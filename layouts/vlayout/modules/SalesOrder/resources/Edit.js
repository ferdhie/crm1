/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

Inventory_Edit_Js("SalesOrder_Edit_Js",{},{
	
	/**
	 * Function which will register event for Reference Fields Selection
	 */
	registerReferenceSelectionEvent : function(container) {
		this._super(container);
		var thisInstance = this;
		
		jQuery('input[name="account_id"]', container).on(Vtiger_Edit_Js.referenceSelectionEvent, function(e, data){
			thisInstance.referenceSelectionEventHandler(data, container);
		});
	},

	/**
	 * Function to get popup params
	 */
	getPopUpParams : function(container) {
		var params = this._super(container);
                var sourceFieldElement = jQuery('input[class="sourceField"]',container);

		if(sourceFieldElement.attr('name') == 'contact_id' || sourceFieldElement.attr('name') == 'potential_id') {
			var form = this.getForm();
			var parentIdElement  = form.find('[name="account_id"]');
			if(parentIdElement.length > 0 && parentIdElement.val().length > 0 && parentIdElement.val() != 0) {
				var closestContainer = parentIdElement.closest('td');
				params['related_parent_id'] = parentIdElement.val();
				params['related_parent_module'] = closestContainer.find('[name="popupReferenceModule"]').val();
			} else if(sourceFieldElement.attr('name') == 'potential_id') {
				parentIdElement  = form.find('[name="contact_id"]');
				if(parentIdElement.length > 0 && parentIdElement.val().length > 0) {
					closestContainer = parentIdElement.closest('td');
					params['related_parent_id'] = parentIdElement.val();
					params['related_parent_module'] = closestContainer.find('[name="popupReferenceModule"]').val();
				}
			}
            }
            return params;
        },

	/**
	 * Function to search module names
	 */
	searchModuleNames : function(params) {
		var aDeferred = jQuery.Deferred();

		if(typeof params.module == 'undefined') {
			params.module = app.getModuleName();
		}
		if(typeof params.action == 'undefined') {
			params.action = 'BasicAjax';
		}

		if (params.search_module == 'Contacts' || params.search_module == 'Potentials') {
			var form = this.getForm();
			var parentIdElement  = form.find('[name="account_id"]');
			if(parentIdElement.length > 0 && parentIdElement.val().length > 0) {
				var closestContainer = parentIdElement.closest('td');
				params.parent_id = parentIdElement.val();
				params.parent_module = closestContainer.find('[name="popupReferenceModule"]').val();
			} else if(params.search_module == 'Potentials') {
				parentIdElement  = form.find('[name="contact_id"]');
				if(parentIdElement.length > 0 && parentIdElement.val().length > 0) {
					closestContainer = parentIdElement.closest('td');
					params.parent_id = parentIdElement.val();
					params.parent_module = closestContainer.find('[name="popupReferenceModule"]').val();
				}
			}
		}

		AppConnector.request(params).then(
			function(data){
				aDeferred.resolve(data);
			},
			function(error){
				aDeferred.reject();
			}
		)
		return aDeferred.promise();
	},
	
	/**
	 * Function to register event for enabling recurrence
	 * When recurrence is enabled some of the fields need
	 * to be check for mandatory validation
	 */
	registerEventForEnablingRecurrence : function(){
		var thisInstance = this;
		var form = this.getForm();
		var enableRecurrenceField = form.find('[name="enable_recurring"]');
		var fieldsForValidation = new Array('recurring_frequency','start_period','end_period','payment_duration','invoicestatus');
		enableRecurrenceField.on('change',function(e){
			var element = jQuery(e.currentTarget);
			var addValidation;
			if(element.is(':checked')){
				addValidation = true;
			}else{
				addValidation = false;
			}
			
			//If validation need to be added for new elements,then we need to detach and attach validation
			//to form
			if(addValidation){
				form.validationEngine('detach');
				thisInstance.AddOrRemoveRequiredValidation(fieldsForValidation,addValidation);
				//For attaching validation back we are using not using attach,because chosen select validation will be missed
				form.validationEngine(app.validationEngineOptions);
				//As detach is used on form for detaching validationEngine,it will remove any actions on form submit,
				//so events that are registered on form submit,need to be registered again after validationengine detach and attach
				thisInstance.registerSubmitEvent();
			}else{
				thisInstance.AddOrRemoveRequiredValidation(fieldsForValidation,addValidation);
			}
		})
		if(!enableRecurrenceField.is(":checked")){
			thisInstance.AddOrRemoveRequiredValidation(fieldsForValidation,false);
		}else if(enableRecurrenceField.is(":checked")){
			thisInstance.AddOrRemoveRequiredValidation(fieldsForValidation,true);
		}
	},
	
	/**
	 * Function to add or remove required validation for dependent fields
	 */
	AddOrRemoveRequiredValidation : function(dependentFieldsForValidation,addValidation){
		var form = this.getForm();
		jQuery(dependentFieldsForValidation).each(function(key,value){
			var relatedField = form.find('[name="'+value+'"]');
			if(addValidation){
				var validationValue = relatedField.attr('data-validation-engine');
				if(validationValue.indexOf('[f') > 0){
					relatedField.attr('data-validation-engine','validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]');
				}
				if(relatedField.is("select")){
					relatedField.attr('disabled',false).trigger("liszt:updated");
				}else{
					relatedField.removeAttr('disabled');
				}
			}else if(!addValidation){
				if(relatedField.is("select")){
					relatedField.attr('disabled',true).trigger("liszt:updated");
				}else{
					relatedField.attr('disabled',"disabled");
				}
				relatedField.validationEngine('hide');
				if(relatedField.is('select') && relatedField.hasClass('chzn-select')){
					var parentTd = relatedField.closest('td');
					parentTd.find('.chzn-container').validationEngine('hide');
				}
			}
		})
	},
        
	pricebooksPopupHandler : function(popupImageElement){
		var thisInstance                    = this;
		var lineItemRow                     = popupImageElement.closest('tr.'+ this.rowClass);
		var lineItemProductOrServiceElement = lineItemRow.find('input.productName').closest('td');
		var params = {};
                //var isSalesOrder = jQuery(popupImageElement).data('caller') == 'SalesOrder';
                
		params.module      = 'PriceBooks';
		params.src_module  = jQuery('img.lineItemPopup',lineItemProductOrServiceElement).data('moduleName');
		params.src_field   = jQuery('img.lineItemPopup',lineItemProductOrServiceElement).data('fieldName');
		params.src_record  = jQuery('input.selectedModuleId',lineItemProductOrServiceElement).val();
                
                //see modules/PriceBooks/models/Record.php for method implementation
                params.get_url     = 'getPricebookInfoURL';
		params.currency_id = jQuery('#currency_id option:selected').val();
                
		this.showPopup(params).then(function(data){
                    var responseData = JSON.parse(data),
                        pb = responseData[0];
                    console.log(pb);
                    
                    thisInstance.setListPriceValue(lineItemRow,parseFloat(pb.list_price));
                    thisInstance.quantityChangeActions(lineItemRow);
                    
                    var nup = parseFloat(pb['CPSH/KPA'].cf_900.fieldvalue), 
                        bookingfee = parseFloat(pb['CPSH/KPA'].cf_902.fieldvalue),
                        jangka_waktu_um = jQuery("select[name=jangka_waktu_um]").val(),
                        kpa_percent = parseFloat(pb['CPSH/KPA'].cf_912.fieldvalue),
                        kpa_nominal = parseFloat(pb['CPSH/KPA'].cf_906.fieldvalue),
                        dp_nominal = parseFloat(pb['CPSH/KPA'].cf_910.fieldvalue),
                        dp_percent = parseFloat(pb['CPSH/KPA'].cf_914.fieldvalue),
                        harga_pengikatan = parseFloat(pb['CPSH/KPA'].cf_916.fieldvalue);

                    window['sonum_changed'] = true;
                    jQuery("input[name=nup]").val( nup );
                    jQuery("input[name=bookingfee]").val( bookingfee );
                    jQuery("input[name=um1]").val( dp_nominal );
                    jQuery("input[name=pinjaman]").val( kpa_nominal );
                    jQuery("input[name=jamsostek]").val( jQuery('#tax_final').text() );
                    jQuery('input[name=pinjaman]').val( kpa_nominal.toFixed(2) );
                    jQuery('input[name=angsuran1]').val( typeof pb["Estimasi Angsuran Perbulan"]['cf_876'] != 'undefined' ? pb["Estimasi Angsuran Perbulan"]['cf_876'].fieldvalue : 0 );
                    jQuery('input[name=angsuran2]').val( typeof pb["Estimasi Angsuran Perbulan"]['cf_878'] != 'undefined' ? pb["Estimasi Angsuran Perbulan"]['cf_878'].fieldvalue : 0 );
                    jQuery('input[name=angsuran3]').val( typeof pb["Estimasi Angsuran Perbulan"]['cf_880'] != 'undefined' ? pb["Estimasi Angsuran Perbulan"]['cf_880'].fieldvalue : 0 );
                    
                    var angsuran_bulanan = 0;
                    if (jangka_waktu_um == 12) { //1th
                        angsuran_bulanan = parseFloat(jQuery('input[name=angsuran1]').val());
                    } else if (jangka_waktu_um == 24) { //2th
                        angsuran_bulanan = parseFloat(jQuery('input[name=angsuran2]').val());
                    } else if (jangka_waktu_um == 36) { //5th
                        angsuran_bulanan = parseFloat(jQuery('input[name=angsuran3]').val());
                    }

                    for(var i=2; i<=jangka_waktu_um; i++) {
                        jQuery("input[name=um"+i+"]").val( isNaN(angsuran_bulanan) ? '0' : angsuran_bulanan.toFixed(2) );
                    }
                    
                    thisInstance.hitungAngsuran();
                    thisInstance.hitungTotal();
                    window['sonum_changed'] = false;
		});
	},
        
        hitungAngsuran: function() {
            var jangka_waktu_um = jQuery("select[name=jangka_waktu_um]").val(),
                angsuran_bulanan = 0;

            if (jangka_waktu_um == 12) { //1th
                angsuran_bulanan = parseFloat(jQuery('input[name=angsuran1]').val());
            } else if (jangka_waktu_um == 24) { //2th
                angsuran_bulanan = parseFloat(jQuery('input[name=angsuran2]').val());
            } else if (jangka_waktu_um == 36) { //5th
                angsuran_bulanan = parseFloat(jQuery('input[name=angsuran3]').val());
            }
            for(var i=2; i<=jangka_waktu_um; i++) {
                jQuery("input[name=um"+i+"]").val( isNaN(angsuran_bulanan) ? '0' : angsuran_bulanan.toFixed(2) );
            }
        },
        
        hitungTotal: function() {
            var nup = parseFloat(jQuery("input[name=nup]").val());
            var bookingfee = parseFloat(jQuery("input[name=bookingfee]").val());
            var dp_nominal = parseFloat(jQuery("input[name=um1]").val());
            var jangka_waktu_um = parseInt(jQuery("select[name=jangka_waktu_um]").val());
            var harga_pengikatan= parseFloat(jQuery("#grandTotal").text());
            var total = 0;
            if (jangka_waktu_um>1) {
                for(var i=2; i<=jangka_waktu_um; i++) {
                    var um = parseFloat( jQuery("input[name=um"+i+"]").val() );
                    if (!isNaN(um)) total+=um;
                }
            }
            total += nup + bookingfee + dp_nominal;
            var pinjaman = parseFloat(jQuery("input[name=pinjaman]").val());
            var jamsostek = parseFloat(jQuery("input[name=jamsostek]").val());
            var totalBayar = total + (isNaN(pinjaman)?0:pinjaman) + (isNaN(jamsostek)?0:jamsostek);
            //var pinjaman = harga_pengikatan - total;
            //jQuery("input[name=pinjaman]").val( isNaN(pinjaman) ? 0 : pinjaman.toFixed(2) );
            jQuery("input[name=totalbayar]").val(isNaN(totalBayar) ? 0 : totalBayar.toFixed(2));
        },
        
        lineItemToTalResultCalculations: function() {
                Inventory_Edit_Js.prototype.lineItemToTalResultCalculations.call(this);
                this.hitungAngsuran();
                this.hitungTotal();
        },

	registerEvents: function(){
		this._super();
		this.registerEventForEnablingRecurrence();
		this.registerForTogglingBillingandShippingAddress();
		this.registerEventForCopyAddress();
                var thisInstance = this;

                jQuery(function(){ 
                    
                    //hitung total
                    jQuery(".sonum").change(function() {
                        if (typeof window['sonum_changed'] != 'undefined' && window['sonum_changed']) 
                            return;
                        window['sonum_changed'] = true;
                        thisInstance.hitungTotal();
                        window['sonum_changed'] = false;
                    });
                    
                    var flagChanged=function() {
                        jQuery(this).data('changed', true);
                    };
                    jQuery(".sonum").keydown(flagChanged).keyup(flagChanged);
                    
                    jQuery("input[name=duedate]").change(function() {
                        var val = jQuery(this).val();
                        jQuery("input[name=nup_due_date]").val(val);
                        jQuery("input[name=bookingfee_due_date]").val(val);
                        jQuery("input[name=um1_due_date]").val(val);
                        jQuery("input[name=jamsostek_due_date]").val(val);
                    });
                    
                    jQuery(".um_date").change(function() {
                        if (typeof window['date_changed'] != 'undefined' && window['date_changed']) 
                            return;
                        
                        window['date_changed'] = true;
                        var $this=jQuery(this);
                        if ($this.prop('id') == "um1_due_date") {
                            var value = $(this).val(),
                                jangka_waktu_um = jQuery("#jangka_waktu_um").val(),
                                arr = value.split(/-/, 3),
                                dt = parseInt(arr[0]),
                                mon = parseInt(arr[1]),
                                yr = parseInt(arr[2]),
                                dateObject = new Date(yr, mon-1, dt);
                            
                            for(var i=2; i<=jangka_waktu_um; i++) {
                                dateObject.setMonth( dateObject.getMonth()+1 );
                                var val = ( dateObject.getDate() > 9 ? dateObject.getDate() : '0' + dateObject.getDate() ) + '-' + ( dateObject.getMonth()+1 > 9 ? dateObject.getMonth()+1 : '0' + (1+dateObject.getMonth()) ) + '-' + dateObject.getFullYear();
                                jQuery("#um"+i+"_due_date").val( val );
                            }
                        }
                        window['date_changed'] = false;
                    });
                    
                    jQuery('select[name=jangka_waktu_um]').change(function() {
                        var val = $(this).val();
                        jQuery('tr.um').hide();
                        jQuery('tr.um:lt('+val+')').show();
                        var dateField=jQuery("#um1_due_date"), dateVal = dateField.val();
                        if (!dateVal) {
                            var dateObject = new Date();
                            var dateVal = ( dateObject.getDate() > 9 ? dateObject.getDate() : '0' + dateObject.getDate() ) + '-' + ( dateObject.getMonth()+1 > 9 ? dateObject.getMonth()+1 : '0' + (1+dateObject.getMonth()) ) + '-' + dateObject.getFullYear();
                            dateField.val(dateVal);
                        }
                        dateField.trigger('change');
                        thisInstance.hitungAngsuran();
                        thisInstance.hitungTotal();
                    });
                    
                    jQuery('select[name=jangka_waktu_um]').trigger('change'); 
                    
                    jQuery('#EditView').submit(function(event) {
                        var totalBayar = parseInt( jQuery("#totalbayar").val() ),
                            grandTotal = parseInt( jQuery("#grandTotal").text() );
                            
                        if (totalBayar != grandTotal) {
                            event.preventDefault();
                            alert("Total pembayaran dan grand total transaksi tidak sama, mohon cek form sekali lagi");
                            return false;
                        }
                        
                        if (!jQuery('input[name=duedate]').val()) {
                            alert("Tanggal jatuh tempo sales order harus diisi");
                            return false;
                        }
                        
                        if (!jQuery('input[name=nup_due_date]').val()) {
                            alert("Tanggal jatuh tempo NUP harus diisi");
                            return false;
                        }
                        
                        if (!jQuery('input[name=bookingfee_due_date]').val()) {
                            alert("Tanggal jatuh tempo Booking Fee harus diisi");
                            return false;
                        }
                        
                        var jangka_waktu_um = jQuery("#jangka_waktu_um").val();
                        for(var i=1; i<=jangka_waktu_um; i++) {
                            if (!jQuery("#um"+i+"_due_date").val()) {
                                alert("Tanggal jatuh tempo Uang Muka ke " + i + " harus diisi");
                                return false;
                            }
                        }
                        
                        if (!jQuery('input[name=pinjaman_due_date]').val()) {
                            alert("Tanggal jatuh tempu pinjaman harus diisi");
                            return false;
                        }
                        
                    });
                    
                });
                
	}
});



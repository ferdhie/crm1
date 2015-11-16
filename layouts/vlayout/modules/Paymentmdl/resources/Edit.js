/* 
 * Copyright (c) Herdian Ferdianto <herdian-at-ferdianto.com>
 * 
 * Everyone is permitted to copy and distribute verbatim or modified 
 * copies of this license document, and changing it is allowed as long 
 * as the name is changed. 
 * 
 */

Vtiger_Edit_Js("Paymentmdl_Edit_Js",{},{
    registerRecordPreSaveEvent : function(form) {
        var thisInstance = this;
        if(typeof form == 'undefined') {
            form = this.getForm();
        }
        
        form.on(Vtiger_Edit_Js.recordPreSave, function(e, data) {
            
            var form = jQuery(this),
                form_state = form.data('form_state');
                
            if (form_state == 2) {
                return true;
            }
            
            form.data('form_state', 1);
            //jalankan validasi disini

            var salesorder_id = jQuery("input[name=salesorder_id]").val(),
                payment_id = jQuery("input[record]").val(),
                termin = jQuery("#termin_select").val(),
                jenis_bayar = jQuery("select[name=paymentmdl_tks_jenispembayaran]").val(),
                jumlah_bayar = jQuery("input[name=paymentmdl_tks_biayauangmuka]").val(),
                total_tagihan = jQuery('input[name=paymentmdl_tks_totaltagihan]').val();
                
            jumlah_bayar = parseInt(jumlah_bayar);
            total_tagihan = parseInt(total_tagihan);
            if ( total_tagihan > 0 && jumlah_bayar < total_tagihan ) {
                alert("Pembayaran kurang");
                e.preventDefault();
                return false;
            }

            AppConnector.request({
                module:'Paymentmdl', 
                action: 'ValidateEdit', 
                record:payment_id, 
                salesorder_id: salesorder_id,
                termin: termin,
                jenis_bayar: jenis_bayar,
                jumlah_bayar: jumlah_bayar 
            }).then(function(resp) {
                var result = typeof resp['result'] != 'undefined' ? resp['result'] : {};

                if (typeof result['success'] != 'undefined') {
                    form.data('form_state', 2);
                    setTimeout(function(){ jQuery("#EditView").submit() }, 300);
                } else if (typeof result['error'] != 'undefined') {
                    form.data('form_state', 0);
                    alert(result['error']);
                } else {
                    form.data('form_state', 0);
                    alert("Error");
                }
            });
            
            e.preventDefault();
            return false;
        });
    },
    
    registerEvents: function() {
        this._super();
        this.registerRecordPreSaveEvent();
        
        var salesOrderId = '', 
                paymentId = '', 
                arr = [], 
                updateTermin = function() {
                    var jenisBayar = jQuery("select[name=paymentmdl_tks_jenispembayaran]").val(),
                        totalTagihan = jQuery("input[name=paymentmdl_tks_totaltagihan]"),
                        jangka_waktu_um = parseInt(jQuery("#jangka_waktu_um_val").text());
                
                    console.log(['update termin', jenisBayar]);
                    
                    if (!/Pembayaran Uang Muka/i.test(jenisBayar)) {
                        
                        var terminSelect = jQuery("#termin_select");
                        terminSelect.prop('disabled', 'disabled');
                        terminSelect.val('1');
                        
                        if (/Pembayaran NUP/i.test(jenisBayar)) {
                            totalTagihan.val( parseFloat(jQuery("#so_nup").text()).toFixed(0) );
                        } else if (/Pembayaran Booking Fee/i.test(jenisBayar)) {
                            totalTagihan.val( parseFloat(jQuery("#so_bookingfee").text()).toFixed(0) );
                        } else if (/Pembayaran BPKKB/i.test(jenisBayar)) {
                            totalTagihan.val( parseFloat(jQuery("#so_jamsostek").text()).toFixed(0) );
                        } else if (/Pembayaran Angsuran/i.test(jenisBayar)) {
                            totalTagihan.val( parseFloat(jQuery("#so_pinjaman").text()).toFixed(0) );
                        }
                        
                    } else {
                        jQuery("#termin_select").removeProp('disabled');
                        
                        //hitung total uang muka terbayar
                        var totalTerbayar=0;
                        for(var i=1; i<=jangka_waktu_um; i++) {
                            var terbayar = parseFloat( jQuery("#so_um"+i).text() );
                            if (isNaN(terbayar) || terbayar == 0)
                                break;
                            else totalTerbayar+=terbayar;
                        }
                        totalTagihan.val(totalTerbayar.toFixed(2));
                        
                    }
                },
                updateForm = function() {
                    var salesOrderId = jQuery("input[name=salesorder_id]").val();
                    if (!salesOrderId) return;
                    
                    //update termin combo
                    var jangka_waktu_um = parseInt(jQuery("#jangka_waktu_um_val").text());
                    var input = jQuery("input[name=paymentmdl_tks_termin]");
                    if (input.length > 0) {
                        input.parent().append('<select id="termin_select" name="paymentmdl_tks_termin"></select>');
                        input.remove();
                    }
                    var select = jQuery("#termin_select")[0];
                    select.options.length=0;
                    for(var i=1; i<=jangka_waktu_um; i++) {
                        var terbayar = parseInt(jQuery("#payment_um"+i).text());
                        if ( isNaN(terbayar) || terbayar == 0 ) {
                            select.options[select.options.length] = new Option( 'Uang Muka Ke ' + i, i );
                        }
                    }
                    
                    jQuery("input[name=paymentmdl_tks_totaltagihan]").val( jQuery("#final_total_tagihan").text() );

                    var terbayar = jQuery("#final_terbayar").val(),
                        totalBayar = jQuery("input[name=paymentmdl_tks_totalbayar]");
                    totalBayar.val( terbayar  );
                    totalBayar.data( 'terbayar', terbayar  );

                    jQuery("#salesorder_id_display").val( jQuery('input[name=salesorder_title]').val()  );
                    
                    updateTermin();
                    
                    location.hash="#salesorderid/"+salesOrderId;
                },
                loadSalesOrder = function(paymentId, recordId) {
                    AppConnector.request({module:'Paymentmdl', view: 'Edit', record:paymentId, salesorder_id: recordId, fromajax:'true'}).then(function(resp) {
                        jQuery("#salesorderDiv").html(resp);
                        jQuery("input[name=salesorder_id]").val( recordId  );
                        updateForm();
                    });
                };
                
        if (location.search.length >=0) {
            var arr1 = location.search.substring(1).split('&');
            for(var i=0, len=arr1.length; i<len; i++) {
                var arr = arr1[i].split('=',2);
                if (arr[0] == 'salesorder_id') {
                    salesOrderId=arr[1];
                } else if (arr[0] == 'record') {
                    paymentId=arr[1];
                }
            }
        }

        if (salesOrderId.length == 0 && location.hash.length >=0) {
            var arr = location.hash.substring(1).split('/');
            for(var i=0, len=arr.length; i<len; i++) {
                if (arr[i] == 'salesorderid' && i+1 < len) {
                    salesOrderId=arr[i+1];
                    if (salesOrderId.length)
                        loadSalesOrder(paymentId, salesOrderId);
                    break;
                }
            }
        }
        
        jQuery('input[name=paymentmdl_tks_totalbayar],input[name=paymentmdl_tks_totaltagihan]').prop('readonly','readonly');
        
        jQuery('input[name=salesorder_id]').on(Vtiger_Edit_Js.postReferenceSelectionEvent, function(ev, response) {
            for(var id in response.data) {
                salesOrderId = response.data[id].info.salesorderid;
                loadSalesOrder(paymentId, salesOrderId);
                break;
            }
        });
        
        var dateval = jQuery('input[name=paymentmdl_tks_tanggalpembayar]').val();
        if (!dateval) {
            var d = new Date(),
                dateStr = ( d.getDate() < 10 ? '0' + d.getDate() : d.getDate() ) + '-' + ( d.getMonth()+1 < 10 ? '0' + (d.getMonth()+1) : (d.getMonth()+1) ) + '-' + d.getFullYear();
            jQuery('input[name=paymentmdl_tks_tanggalpembayar]').val(dateStr);
        }
        
        var hitungTerbayar = function() {
            var $this=jQuery(this),
                val = parseFloat($this.val()),
                salesorderId = jQuery('input[name=salesorder_id]').val(),
                terbayar = parseFloat( jQuery("input[name=paymentmdl_tks_totalbayar]").data( 'terbayar') ),
                terbayar = (isNaN(val)?0:val) + (isNaN(terbayar)?0:terbayar);
                
            if (salesorderId) {
                jQuery("input[name=paymentmdl_tks_totalbayar]").val( terbayar  );
            }
        };
        jQuery('input[name=paymentmdl_tks_biayauangmuka]').keyup(hitungTerbayar).change(hitungTerbayar);
        
        jQuery("select[name=paymentmdl_tks_jenispembayaran]").change(updateTermin);
        
        /*
        jQuery("#EditView").submit(function(event) {
            console.log('submitting form');
            
            
            return false;
        });
        */
        
        updateForm();
    }
});

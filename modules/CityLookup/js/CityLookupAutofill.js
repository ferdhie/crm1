jQuery(function() {

	// Pre-configure list of cities.
	var cities = [
		"New York", "Los Angeles", "Chicago", "Houston", "Philadelphia",
		"Phoenix", "San Diego", "San Antonio", "Dallas", "Detroit", "Other"
	]
	
	// Enable auto-fill editview / detailview (ajaxedit)
	var activeModule = app.getModuleName(), activeView = app.getViewName();
	if (activeView == 'Edit' || activeView == 'Detail') {
		// For target module
		if (activeModule == 'Leads' || activeModule == 'Contacts') {
			// For target field.
			var fieldName = 'city';
			var field = jQuery("#"+activeModule+"_editView_fieldName_"+fieldName);
			field.autocomplete({
				source: cities
			});					
		}
	}
	
});

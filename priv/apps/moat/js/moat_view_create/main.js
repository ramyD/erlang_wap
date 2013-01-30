$(document).ready(function() {
	"use strict";
	$.getJSON("/create/get_template_names", function(data) {
		$("#templates").kendoDropDownList({
			dataTextField: "name",
			dataValueField: "value",
			dataSource: data,
			change: constructForm
		});
		constructForm();
	});
});

// shows the template according to what was picked through the dropdown list
function constructForm() {
	"use strict";
	var templateId = $("#templates").val();
	$.getJSON("/create/get_template_parameters", {template_id: templateId}, function(template) {
		// declare dom elements to manipulate
		var templateForm = $("#template-form");

		// store all the required form field types
		var formFields = {};

		for (var parameter in template) {
			// skip if the parameter is a hidden type
			if ( parameter[0] == '_' ) continue;
			formFields[parameter] = ('form_' + template[parameter]);
		}

		templateForm.load("/html/generate", formFields);
	});
}

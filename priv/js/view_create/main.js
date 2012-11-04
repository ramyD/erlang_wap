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
	console.log("template is: " + templateId);
	$.getJSON("/create/get_template_parameters", {template_id: templateId}, function(template) {
		// declare dom elements to manipulate
		var templateForm = $("#template-form");

		// empty the template-form div
		templateForm.html("");
		for (var parameter in template) {
			// skip if the parameter is a hidden type
			if ( parameter[0] == '_' ) continue;

			// crate an input element based on the parameter type
			var formField;

			// add the label to the form element
			formField = "<div class=\"control-group\">";
			formField += "<label for=\"" + parameter + "\" class=\"control-label\" >" + parameter.replace(/([A-Z])/g, " $1") + "</label>\n";
			formField += "<div class=\"controls\">";

			switch ( template[parameter] ) {
				case "string":
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					break;

				case "associative_array(integer)":
					formField += "<div class=\"form-inline\">\n";
				    formField += "<input type=\"text\" placeholder=\"Email\" class=\"input-small\" required=\"required\" >\n";
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					formField += "</div>";
					break;

				case "integer":
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					break;

				case "date":
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					break;

				case "character":
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					break;

				case "array(attributes)":
					formField += "<input type=\"text\" name=\"" + parameter + "\" id=\"" + parameter + "\" required=\"required\" >\n";
					break;
			}

			// add the element to the template form element
			formField += "</div></div>";
			templateForm.append(formField);
		}
	});
}

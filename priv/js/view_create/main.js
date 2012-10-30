$(document).ready(function() {
	"use strict";
	$.getJSON("/create/get_template_names", function(data) {
		$("#templates").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: data,
			change: constructForm
		});
	});

	constructForm();
});

// shows the template according to what was picked through the dropdown list
function constructForm() {
	"use strict";
	var value = $('#templates').val();
	console.log("template is: " + value);
}

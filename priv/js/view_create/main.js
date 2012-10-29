$(document).ready(function() {
	jQuery.getJSON("/create/get_template_names", function(data) {
		$("#templates").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: data
		});
	});
});

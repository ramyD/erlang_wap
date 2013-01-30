-module(moat_view_html_form_attributes).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(_A, Parameters) -> 
	{parameter, {Parameter, ParameterName}} = lists:keyfind(parameter, 1, Parameters),
	{ehtml, [
		{'div', [{class, "control-group"}], [
			{label, [{for, Parameter}, {class, "control-label"}], [ ParameterName ]},
			{'div', [{class, "controls"}], [
				{input, [{name, Parameter}, {id, Parameter}, {required, "required"}], []},
				{button, [{id, Parameter ++ "_add"}, {form, ""}, {onclick, "add_attribute()"}], ["add"]},
				{script, [{type, "text/javascript"}], [
					"var input_id = '#" ++ Parameter ++ "';
					 (function() { $(input_id).kendoComboBox( { index: 0,
																placeholder: 'Choose Roles',
																dataTextField: 'attribute',
																dataValuefield: 'id',
																filter: 'contains',
																dataSource:{type: 'json',
																			serverFiltering: false,
																			serverPaging: true,
																			pageSize: 20,
																			transport: { read: '/create/get_attribute_names' }}
																}); })();
					 function add_attribute() {
						var attribute_id = $(input_id).data('kendoComboBox').text();
						if ($(input_id + '-forms div#' + attribute_id).length == 0) {
							$.getJSON('/create/get_attribute_parameters', {attribute_id: attribute_id}, function(attribute) {
								// store all the required form field types
								var formFields = {};

								for (var parameter in attribute) {
									// skip if the parameter is a hidden type
									if ( parameter[0] == '_' ) continue;
									formFields[parameter] = ('attribute_' + attribute[parameter]);
								}

								$(input_id + '-forms').append('<div id=' + attribute_id + '></div>');

								// declare dom elements to manipulate
								var attributeForm = $(input_id + '-forms div#' + attribute_id);

								attributeForm.load('/html/generate', formFields);
							});
						}
					 }
					"
				]},
				{'div', [{id, Parameter ++ "-forms"}], [
				]}
			]}
		]}
	]}.

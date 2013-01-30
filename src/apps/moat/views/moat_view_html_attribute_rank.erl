-module(moat_view_html_attribute_rank).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

out(A) -> 
 out(A, []).

out(_A, Parameters) -> 
	{parameter, {Parameter, ParameterName}} = lists:keyfind(parameter, 1, Parameters),
	{ehtml, [
		{'div', [{class, "control-group"}], [
			{label, [{for, Parameter}, {class, "control-label"}], [ ParameterName ]},
			{'div', [{class, "controls"}], [
				{input, [{type, "number"}, {name, Parameter}, {id, Parameter}, {required, "required"}], []},
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
																			transport: { read: '/app_data/get_ranks' }}
																}); })();"
				]}
			]}
		]}
	]}.

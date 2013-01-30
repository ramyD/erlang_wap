-module(moat_view_html_form_gender).
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
				{input, [{id, Parameter}, {type, "text"}, {name, Parameter}, {required, "required"}]},
				{script, [{type, "text/javascript"}], [
					"(function() { $('#" ++ Parameter ++ "').kendoAutoComplete({dataSource: ['Male', 'Female'],
																				filter: 'startswith',
																				placeholder: 'Enter Gender',
																				separator: ''}); })();"
				]}
			]}
		]}
	]}.

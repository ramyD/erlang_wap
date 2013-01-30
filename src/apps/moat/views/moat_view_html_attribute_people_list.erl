-module(moat_view_html_attribute_people_list).
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
				{input, [{type, "text"}, {name, Parameter}, {id, Parameter}, {required, "required"}], []}
			]}
		]}
	]}.

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
				{input, [{type, "radio"}, {name, Parameter}, {required, "required"}, {value, "male"}], []},
				{input, [{type, "radio"}, {name, Parameter}, {required, "required"}, {value, "female"}], []},
				{input, [{type, "radio"}, {name, Parameter}, {required, "required"}, {value, "other"}], []}
			]}
		]}
	]}.

-module(view_html_form_date).
-author("ramy.daghstani@gmail.com").
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
				{input, [{type, "date"}, {name, Parameter}, {id, Parameter}, {required, "required"}], []},
				%% maybe use a DOMNodeInserted event to detect the insertion of a input of type date and 
				%% run the following js on it
				{script, [{type, "text/javascript"}], [
					"(function() { $('#" ++ Parameter ++ "').kendoDatePicker(); })();"
				]}
			]}
		]}
	]}.

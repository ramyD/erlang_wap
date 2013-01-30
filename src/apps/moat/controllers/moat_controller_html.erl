-module(moat_controller_html).
-export([generate/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

generate(Kernel, _ExtraParameters, A) ->
	Query = yaws_api:parse_query(A),
	Post = yaws_api:parse_post(A),

	FormInputs = lists:foldl(fun({Parameter, Type}, HtmlParts) ->
		%% transform camelCase into camel Case
		ParameterName = lists:foldl(fun(C, Str) ->
			if
				C >= $a ->
					Str ++ [C];
				true ->
					Str ++ " " ++ [C]
			end
		end, [], Parameter),

		HtmlPart = apply(list_to_atom("moat_view_html_" ++ Type), out, [A, [{parameter, {Parameter, ParameterName}}]]),

		[HtmlParts, HtmlPart]
	end, [], lists:append(Query, Post)),

	Kernel ! {ok, FormInputs},
	ok.

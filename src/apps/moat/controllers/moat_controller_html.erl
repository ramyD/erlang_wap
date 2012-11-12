-module(moat_controller_html).
-export([generate_form/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

is_loggedin(A) ->
	CD = lib_cookie:getcookiedata(A),
	case CD#cookiedata.permission of
		anonymous -> false;
		_ -> true
	end.

generate_form(Kernel, _ExtraParameters, A) ->
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

		case Type of
			"string" -> 
				HtmlPart = moat_view_html_form_string:out(A, [{parameter, {Parameter, ParameterName}}]);

			"gender" ->
				HtmlPart = moat_view_html_form_gender:out(A, [{parameter, {Parameter, ParameterName}}]);

			"date" ->
				HtmlPart = moat_view_html_form_date:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"attributes" ->
				HtmlPart = moat_view_html_form_attributes:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"telephone" ->
				HtmlPart = moat_view_html_form_telephone:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"email" ->
				HtmlPart = moat_view_html_form_email:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			_ ->
				HtmlPart = {ehtml, []}
		end,
		[HtmlParts, HtmlPart]
	end, [], lists:append(Query, Post)),

	Kernel ! {ok, FormInputs},
	ok.

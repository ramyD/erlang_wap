-module(controller_html).
-author("ramy.daghstani@gmail.com").
-export([init/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

is_loggedin(A) ->
	CD = lib_cookie:getcookiedata(A),
	case CD#cookiedata.permission of
		anonymous -> false;
		_ -> true
	end.

init(Kernel, "", A) ->
	case is_loggedin(A) of
		true ->
			apply(?MODULE, default, [Kernel, "",  A]);

		false ->
			controller_auth:login(Kernel, "login", A)
	end;

init(Kernel, Parameters, A) ->
	case is_loggedin(A) of
		true ->
			try (apply(?MODULE, list_to_atom(Parameters), [Kernel, [],  A])) of
				ok -> ok
			catch
				error:undef -> init(Kernel, "", A)
			end;

		false ->
			controller_auth:login(Kernel, "login", A)
	end.

default(Kernel, _ExtraParameters, _A) ->
	Kernel ! {ok, {content, "application/json", <<"">>}},
	ok.

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
				HtmlPart = view_html_form_string:out(A, [{parameter, {Parameter, ParameterName}}]);

			"gender" ->
				HtmlPart = view_html_form_gender:out(A, [{parameter, {Parameter, ParameterName}}]);

			"date" ->
				HtmlPart = view_html_form_date:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"attributes" ->
				HtmlPart = view_html_form_attributes:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"telephone" ->
				HtmlPart = view_html_form_telephone:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			"email" ->
				HtmlPart = view_html_form_email:out(A, [{parameter, {Parameter, ParameterName}}]);
				
			_ ->
				HtmlPart = {ehtml, []}
		end,
		HtmlParts ++ [HtmlPart]
	end, [], lists:append(Query, Post)),

	Kernel ! {ok, FormInputs},
	ok.

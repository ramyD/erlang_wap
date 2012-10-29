-module(controller_create).
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
		true -> apply(?MODULE, default, [Kernel, "",  A]);
		false -> controller_auth:login(Kernel, "login", A)
	end;

init(Kernel, Parameters, A) ->
	case is_loggedin(A) of
		true -> try (apply(?MODULE, list_to_atom(Parameters), [Kernel, [],  A])) of
					ok -> ok
				catch
					error:undef -> init(Kernel, "", A)
				end;
		false -> controller_auth:login(Kernel, "login", A)
	end.

default(Kernel, _ExtraParameters, A) ->
	Templates = object_templates:get_templates(),
	Attributes = object_templates:get_attributes(),
	Kernel ! {ok, [view_create:out(A, [{templates, Templates}, {attributes, Attributes}])]},
	ok.

get_template_names(Kernel, _ExtraParameters, A) ->
	Templates = object_templates:get_templates(),
	TemplateNames = [ {[{<<"text">>, Name}, {<<"value">>, Name}]} || {Name, _} <- Templates ],
	{ok, TemplateOutput} = json:encode(TemplateNames),
	Kernel ! {ok, {content, "application/json", TemplateOutput}},
	ok.

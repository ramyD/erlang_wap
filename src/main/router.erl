-module(router).
-export([prep_route/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

% routing module

prep_route(Kernel, undefined, A) ->
	prep_route(Kernel, "/default", A);

prep_route(Kernel, Fullroute, A) ->
	[ _ | Route ] = filename:split(Fullroute),
	RequestType = A#arg.req#http_request.method,
	route(Kernel, {RequestType, Route}, A).

route(Kernel, RouteInfo, A) ->
	case RouteInfo of
		{ _, []} ->
			apply(moat_controller_default, default, [Kernel, [], A]);
			
		{'GET', ["css" | Path]} ->
			apply(moat_controller_priv, css, [Kernel, Path, A]);

		{'GET', ["js" | Path]} ->
			apply(moat_controller_priv, js, [Kernel, Path, A]);

		{'GET', ["image" | Path]} ->
			apply(moat_controller_priv, image, [Kernel, Path, A]);

		{'GET', ["login"]} ->
			apply(moat_controller_auth, login, [Kernel, [], A]);

		{'POST', ["login"]} ->
			apply(moat_controller_auth, authenticate, [Kernel, [], A]);

		{ _, [Controller]} ->
			apply(list_to_atom("moat_controller_" ++ Controller), default, [Kernel, [], A]);

		{ _, [Controller, Function]} ->
			apply(list_to_atom("moat_controller_" ++ Controller), list_to_atom(Function), [Kernel, [], A]);

		_ ->
			Kernel ! {ok, moat_view_notfound:out(A)}
	end,
	ok.

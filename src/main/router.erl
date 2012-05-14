-module(router).
-author("ramy.daghstani@gmail.com").
-export([route/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

% routing module

init() -> 
	true.

route(Kernel, "", A) ->
	Route = "default",
	Parameters = "",
	executecontroller(Kernel, Route, Parameters, A);

route(Kernel, Fullroute, A) ->
	case string:chr(Fullroute, $/) of 
		0 ->
			Route = Fullroute,
			Parameters = "";
		_ ->
			Route = string:substr(Fullroute, 1, string:chr(Fullroute, $/)-1),
			Parameters = string:substr(Fullroute, string:chr(Fullroute, $/)+1)
	end,
	executecontroller(Kernel, Route, Parameters, A).

executecontroller(Kernel, Route, Parameters, A) ->
	try (apply(list_to_atom("controller_" ++ Route), init, [Kernel, Parameters,  A])) of
		ok -> ok
	catch
		error:undef -> pagenotfound(Kernel, "",  A)
	end.

pagenotfound(Kernel, _Parameters, A) ->
	Kernel ! {ok, {ehtml, {html, [], [
				{h2, [], "404"}, 
				{p, [], A#arg.appmoddata},
				{p, [], "page not found"}
			]}
	}}, ok.

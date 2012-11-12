-module(wap_kernel).
-export([start/2, stop/0, out/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

% web app module

start(normal, []) ->
	init(),
	io:fwrite("pid: ~p", [erlang:pid_to_list(self())]),
	{ok, self()}.

init() -> 
	inets:start(),
	code:add_pathz("/usr/lib/yaws/ebin/"),
	register(chat, spawn(wap_chat, init, [])),
	config:init(),
	Docroot = "/var/yaws",
	Id = "my_server",
	ServerConfiguration = [{servername, "localhost"}, {listen, {127,0,0,1}}, {port, 8000}, {appmods, [{"/", wap_kernel}]}],
	%% ServerConfiguration = [{servername, "localhost"}, {listen, {10,42,0,1}}, {port, 8000}, {appmods, [{"/", wap_kernel}]}],
	GlobalConfiguration = [{logdir, filename:absname("../log")}, {ebin_dir, [filename:absname("")]}, {id, Id}],
	yaws:start_embedded(Docroot, ServerConfiguration, GlobalConfiguration, Id).

stop() -> 
	inets:stop(),
	yaws:stop().

out(A) ->
	process_flag(trap_exit, true),
	spawn_link(router, prep_route, [self(), A#arg.pathinfo, A]),
	receive
		{ok, Response} ->
			Response;

		{'EXIT', _Pid, Reason} ->
			{ehtml, [{section, [], ["routing dispatch failed, " ++ erlang:atom_to_list(Reason)]}]}

	after 10000 ->
		{ehtml, [{section, [], ["request has taken too long, internal timeout"]}]}
	end.

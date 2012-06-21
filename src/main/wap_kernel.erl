-module(wap_kernel).
-author("ramy.daghstani@gmail.com").
-export([init/0, start/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

% web app module

start(normal, []) ->
	init(),
	io:fwrite("pid: ~p", [erlang:pid_to_list(self())]),
	{ok, self()}.

init() -> 
	inets:start(),
	code:add_pathz("/usr/lib/yaws/ebin/"),
	Docroot = "/var/yaws",
	Id = "my_server",
	ServerConfiguration = [{servername, "localhostserver"}, {listen, {127,0,0,1}}, {port, 8000}, {appmods, [{"/", wap_kernel}]}],
	GlobalConfiguration = [{logdir, filename:absname("../log")}, {ebin_dir, [filename:absname("")]}, {id, Id}],
	yaws:start_embedded(Docroot, ServerConfiguration, GlobalConfiguration, Id).

stop() -> 
	inets:stop(),
	yaws:stop().

out(A) ->
	process_flag(trap_exit, true),
	spawn_link(router, route, [self(), A#arg.appmoddata, A]),
	receive
		{ok, Html} ->
			Html;
		{'EXIT', _Pid, Reason} ->
			{ehtml, [{section, [], ["routing dispatch failed, " ++ erlang:atom_to_list(Reason)]}]}
	after 10000 ->
		{ehtml, [{section, [], ["request has taken too long"]}]}
	end.

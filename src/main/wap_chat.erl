-module(wap_chat).
-author("ramy.daghstani@gmail.com").
-export([init/0, start/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

% chat app module

start(normal, []) ->
	init(),
	{ok, self()}.

init() -> 
  loop([]).

loop(Users) ->
	receive
		{message, {{Handle, Pid}, Text}} ->
			wap_chat:broadcast(Users, Handle, Text),
      loop(Users);
		{drop, {Handle, Pid}} ->
      NewUserList = wap_chat:drop(Users, Pid),
      loop(NewUserList);
    {register, {Handle, Pid}} ->
      NewUserList = wap_chat:register(Users, Pid),
      loop(NewUserList)
	end.

broadcast(Users, Sender, Text) ->
  lists:map(fun(P) -> yaws_api:websocket_send(P, {text, list_to_binary(Text)}) end, Users),
  ok.

drop(Users, Sender) ->
  lists:delete(Sender, Users). 

register(Users, Sender) ->
  [Sender | Users].

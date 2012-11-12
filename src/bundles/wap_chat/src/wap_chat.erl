-module(wap_chat).
-export([start/2, init/0, loop/1, broadcast/2, drop/2, register/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

% chat app module

start(normal, []) ->
	init(),
	{ok, self()}.

init() -> 
  loop([]).

loop(Users) ->
	receive
		{message, Text} ->
			wap_chat:broadcast(Users, Text),
      loop(Users);
		{drop, Pid} ->
      NewUserList = wap_chat:drop(Users, Pid),
      loop(NewUserList);
    {register, Pid} ->
      NewUserList = wap_chat:register(Users, Pid),
      loop(NewUserList)
	end.

broadcast(Users, Text) ->
  lists:foreach(fun(P) -> yaws_api:websocket_send(P, {text, Text}) end, Users),
  ok.

drop(Users, Sender) ->
  lists:delete(Sender, Users). 

register(Users, Sender) ->
  io:format("adding user: ~p \n to chatroom with total users: ~p", [Sender, Users]),
  [Sender | Users].

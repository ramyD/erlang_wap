-module(lib_websocket).
-author("ramy.daghstani@gmail.com").
-export([handle_message/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

handle_message({text, <<"client-connected">>}) ->
  chat ! {register, self()},
  noreply;
handle_message({text, Data}) ->
  chat ! {message, Data},
  noreply;
handle_message({Type, Data}) ->
  noreply.

%%   io:format("sending from pid: ~p", [self()]),
%%   {reply, {Type, Data}}.




%%  case Type of
%%    text -> case Data of
%%              <<"client-connected">> -> chat ! {register, {"user: ", self()}};
%%              %%  _ -> {reply, {Type, Data}}
%%              _ -> chat ! {message, {self(), Data}}
%%            end
%%  end.

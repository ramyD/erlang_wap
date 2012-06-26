-module(lib_websocket).
-author("ramy.daghstani@gmail.com").
-export([handle_message/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

handle_message({Type, Data}) ->
  case Type of
    text -> case Data of
              <<"client-connected">> -> chat ! {register, {"user: ", self()}};
              %%  _ -> {reply, {Type, Data}}
              _ -> chat ! {message, {"user: ", self()}, Data}
            end
  end.

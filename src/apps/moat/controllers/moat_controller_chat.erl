-module(moat_controller_chat).
-export([default/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

default(Kernel, _ExtraParameters, A) ->
  CD = lib_cookie:getcookiedata(A),
  case CD#cookiedata.permission of
    anonymous ->
		Kernel ! {ok, moat_view_login:out(A)};

    _ ->
		Kernel ! {ok, moat_view_chat:out(A)}
  end,
	ok.

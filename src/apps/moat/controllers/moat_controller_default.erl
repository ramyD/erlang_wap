-module(moat_controller_default).
-export([default/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

default(Kernel, ExtraParameters, A) ->
	CD = lib_cookie:getcookiedata(A),
	case CD#cookiedata.permission of
		anonymous ->
			Kernel ! {ok, {ehtml, [{section, [], ["hello default" ++ "default"]}]}};

		_ ->
			Kernel ! {ok, moat_view_loggedin:out(A, [{name, CD#cookiedata.first_name ++ " " ++ CD#cookiedata.last_name}])}
	end,
	ok.

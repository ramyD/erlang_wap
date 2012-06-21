-module(lib_cookie).
-author("ramy.daghstani@gmail.com").
-export([getcookiedata/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

getcookiedata(A) ->
  case yaws_api:find_cookie_val("YAWSSESSID", A#arg.headers#headers.cookie) of
    [] -> CD = #cookiedata{user_id = "",
                           permission = anonymous,
                           first_name = "",
                           middle_name = "",
                           last_name = "",
                           email = "",
                           lastlogin = 0};
    Cookie -> case yaws_api:cookieval_to_opaque(Cookie) of
                {ok, CD} -> CD;
                {error, no_session} -> CD = #cookiedata{user_id = "",
                                                        permission = anonymous,
                                                        first_name = "",
                                                        middle_name = "",
                                                        last_name = "",
                                                        email = "",
                                                        lastlogin = 0}
              end
  end,
	CD.

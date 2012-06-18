-module(controller_auth).
-author("ramy.daghstani@gmail.com").
-export([init/3, default/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

-record(myopaque, {authorization = none,
                   lastlogin = 0}).
init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	try (apply(?MODULE, list_to_atom(Parameters), [Kernel, Parameters,  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, _Parameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

login(Kernel, _Parameters, A) ->
	Kernel ! {ok, view_login:out(A)},
	ok.

register(Kernel, _Parameters, A) ->
  case A#arg.req#http_request.method of
	  'GET' -> Kernel ! {ok, view_register:out(A)};
    'POST' -> A,
              Kernel ! {ok, {}}
  end,
	ok.

authenticate(Kernel, _Parameters, A) ->
  %% verify login credentials check out. If any of this fails, the app crashes
  [{"user", Username}, {"pass", Password}, _] = yaws_api:parse_post(A),
  BPassword = list_to_binary(Password),
  BUsername = list_to_binary(Username),
  {ok, {{"HTTP/1.1",200,"OK"}, _, DbRawRows}} = object_people:get_passwords(),
  DbRowObjects = rfc4627:decode_noauto(DbRawRows),
  {ok, {obj,[{"total_rows",1}, {"offset",0}, {"rows", Rows}]}, []} = DbRowObjects,
  [UserRow | _] = [RowData || {obj, RowData} <- Rows, lists:keyfind(BUsername, 2, RowData) == {"key", BUsername}],
  [{"id", UserId}, {"key", BUsername}, {"value", BPassword}] = UserRow,

  %% store a cookie
  CookieData = #myopaque{},
  %% we should get and store the users's permission inside the CookieData
  Cookie = yaws_api:new_cookie_session(CookieData),
  CookieObject = yaws_api:setcookie("YAWSSESSID", Cookie, "/"),
  io:format("cookie header ~p ~n", [CookieObject]),
  
	Kernel ! {ok, [{ehtml, [{html, [], [{body, [], [{h1, [], ["login successful"]}, {p, [], ["welcome " ++ Username]}]}]}]}, CookieObject]},
	ok.

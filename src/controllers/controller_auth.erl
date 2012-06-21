-module(controller_auth).
-author("ramy.daghstani@gmail.com").
-export([init/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	try (apply(?MODULE, list_to_atom(Parameters), [Kernel, [],  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, _ExtraParameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

login(Kernel, ExtraParameters, A) ->
  case yaws_api:find_cookie_val("YAWSSESSID", A#arg.headers#headers.cookie) of
    [] -> Kernel ! {ok, view_login:out(A)};
    Cookie -> case yaws_api:cookieval_to_opaque(Cookie) of
                {ok, CD} -> Kernel ! {ok, view_loggedin:out(A, [{"name", CD#cookiedata.first_name ++ " " ++ CD#cookiedata.middle_name ++ " " ++ CD#cookiedata.last_name}])};
                {error, no_session} -> Kernel ! {ok, view_login:out(A)}
              end
  end,
	ok.

register(Kernel, _ExtraParameters, A) ->
  case A#arg.req#http_request.method of
	  'GET' -> Kernel ! {ok, view_register:out(A)};
    'POST' -> A,
              Kernel ! {ok, {}}
  end,
	ok.

authenticate(Kernel, _ExtraParameters, A) ->
  %% verify login credentials check out. If any of this fails, the app crashes
  [{"user", Username}, {"pass", Password}, _] = yaws_api:parse_post(A),
  BPassword = list_to_binary(Password),
  BUsername = list_to_binary(Username),
  Rows = object_people:get_passwords(),
  [UserRow | _] = [RowData || {obj, RowData} <- Rows, lists:keyfind(BUsername, 2, RowData) == {"key", BUsername}],
  [{"id", BUserId}, {"key", BUsername}, {"value", BPassword}] = UserRow,
  UserId = binary_to_list(BUserId),

  %% get user document if login is successful
  UserDocument = object_people:get_user(UserId),
  {_, Permission} = lists:keyfind("permissions", 1, UserDocument),
  {_, FirstName} = lists:keyfind("first_name", 1, UserDocument),
  {_, MiddleName} = lists:keyfind("middle_name", 1, UserDocument),
  {_, LastName} = lists:keyfind("last_name", 1, UserDocument),
  {_, Email} = lists:keyfind("email", 1, UserDocument),

  %% create a cookie
  {_, Timestamp, _} = now(),
  CD = #cookiedata{user_id = UserId,
                   permission = Permission,
                   first_name = FirstName,
                   middle_name = MiddleName,
                   last_name = LastName,
                   email = Email,
                   lastlogin = Timestamp},

  %% we should get and store the users's permission inside the CookieData
  Cookie = yaws_api:new_cookie_session(CD),
  CookieObject = yaws_api:setcookie("YAWSSESSID", Cookie, "/"),
  
  %% output a successful message
	Kernel ! {ok, [view_loggedin:out(A, [{"name", FirstName ++ " " ++ MiddleName ++ " " ++ LastName}]), CookieObject]},
	ok.

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

login(Kernel, _ExtraParameters, A) ->
  CD = lib_cookie:getcookiedata(A),
  case CD#cookiedata.permission of
    anonymous -> Kernel ! {ok, view_login:out(A)};
    _ -> Kernel ! {ok, view_loggedin:out(A, [{name, CD#cookiedata.first_name ++ " " ++ CD#cookiedata.last_name}])}
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
	[{"email", Email}, {"pass", Password}, _] = yaws_api:parse_post(A),
	BPassword = list_to_binary(Password),
	BEmail = list_to_binary(Email),
	Row = object_people:get_password_by_email(Email),
	%% todo: encrypt and decrypt here
	[{obj, [{"id", BUserId}, {"key", BEmail}, {"value", BPassword}]}] = Row,
	UserId = binary_to_list(BUserId),

	%% get user document if login is successful
	UserDocument = object_people:get_user_by_id(UserId),
	%%{_, Permission} = lists:keyfind("permissions", 1, UserDocument),
	Permission = <<"Officer">>,
	{_, FirstName} = lists:keyfind("FirstName", 1, UserDocument),
	{_, LastName} = lists:keyfind("Name", 1, UserDocument),
	{_, BEmail} = lists:keyfind("Email", 1, UserDocument),

	%% create a cookie
	{_, Timestamp, _} = now(),
	CD = #cookiedata{user_id = UserId,
					 permission = binary_to_atom(Permission, utf8),
					 first_name = binary_to_list(FirstName),
					 last_name = binary_to_list(LastName),
					 email = Email,
					 lastlogin = Timestamp},

	%% we should get and store the users's permission inside the CookieData
	Cookie = yaws_api:new_cookie_session(CD),
	CookieObject = yaws_api:setcookie("YAWSSESSID", Cookie, "/"),
  
  %% output a successful message
	Kernel ! {ok, [view_loggedin:out(A, [{name, FirstName}]), CookieObject]},
	ok.

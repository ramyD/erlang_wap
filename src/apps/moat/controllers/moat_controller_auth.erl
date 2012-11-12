-module(moat_controller_auth).
-export([login/3, register/3, authenticate/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

login(Kernel, _ExtraParameters, A) ->
	CD = lib_cookie:getcookiedata(A),
	case CD#cookiedata.permission of
	anonymous ->
		Kernel ! {ok, moat_view_login:out(A)};

		_ ->
			Kernel ! {ok, moat_view_loggedin:out(A, [{name, CD#cookiedata.first_name ++ " " ++ CD#cookiedata.last_name}])}
	end,
	ok.

register(Kernel, _ExtraParameters, A) ->
	case A#arg.req#http_request.method of
		'GET' ->
			Kernel ! {ok, moat_view_register:out(A)};

		'POST' ->
			A,
			Kernel ! {ok, {}}
	end,
	ok.

authenticate(Kernel, _ExtraParameters, A) ->
	%% verify login credentials check out. If any of this fails, the app crashes
	[{"email", Email}, {"pass", Password}, _] = yaws_api:parse_post(A),
	BPassword = list_to_binary(Password),
	BEmail = list_to_binary(Email),
	Row = moat_object_people:get_password_by_email(Email),
	%% todo: encrypt and decrypt here
	[{[{<<"id">>, BUserId}, {<<"key">>, BEmail}, {<<"value">>, BPassword}]}] = Row,
	UserId = binary_to_list(BUserId),

	%% get user document if login is successful
	UserDocument = moat_object_people:get_user_by_id(UserId),
	%%{_, Permission} = lists:keyfind("permissions", 1, UserDocument),
	Permission = <<"Officer">>,
	{_, FirstName} = lists:keyfind(<<"FirstName">>, 1, UserDocument),
	{_, LastName} = lists:keyfind(<<"Name">>, 1, UserDocument),
	{_, BEmail} = lists:keyfind(<<"Email">>, 1, UserDocument),

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
	Kernel ! {ok, [moat_view_loggedin:out(A, [{name, FirstName}]), CookieObject]},
	ok.

-module(view_register).
-author("ramy.daghstani@gmail.com").
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(A, Parameters) -> 
	{ehtml, [
		{html, [], [
			{head, [], [
				{title, [], ["Register your account."]},
				{script, [{src, "/priv/js/zepto.min.js"}]}
			]},
			{body, [], [
				{p, [], ["Register your account."]},
				{form, [{method, "post"}, {action, "/auth/register"}], [
					{input, [{type, text}, {width, "50"}, {name, user}, {placeholder, username}] },
					{br},
					{input, [{type, password}, {width, "50"}, {name, pass}, {placeholder, password}] },
					{br},
					{input, [{type, password}, {width, "50"}, {name, pass_confirm}, {placeholder, "confirm password"}] },
					{br},
					{input, [{type, submit}, {name, submit}, {value, "Register your account"}] }
				]}
			]}
		]}
	]}.


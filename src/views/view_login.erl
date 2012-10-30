-module(view_login).
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
				{title, [], ["user login"]},
				{script, [{src, "/priv/js/zepto/zepto.min.js"}]}
			]},
			{body, [], [
				{p, [], ["Login to MOAT framework"]},
				{form, [{method, "post"}, {action, "/auth/authenticate"}], [
					{input, [{type, email}, {width, "50"}, {name, email}, {placeholder, email}] },
					{br},
					{input, [{type, password}, {width, "50"}, {name, pass}, {placeholder, password}] },
					{br},
					{input, [{type, submit}, {name, submit}, {value, "authenticate credentials"}] }
				]}
			]}
		]}
	]}.

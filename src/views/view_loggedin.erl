-module(view_loggedin).
-author("ramy.daghstani@gmail.com").
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(_A, Parameters) -> 
  {_, Name} = lists:keyfind(name, 1, Parameters),
	{ehtml, [
		{html, [], [
			{head, [], [
				{title, [], ["You are logged in"]},
				{script, [{src, "/priv/js/zepto.min.js"}]}
			]},
			{body, [], [
				{h1, [], ["Login successful"]},
				{p, [], ["welcome " ++ Name]}
			]}
		]}
	]}.

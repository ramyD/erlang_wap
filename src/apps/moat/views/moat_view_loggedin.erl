-module(moat_view_loggedin).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

out(A) -> 
 out(A, []).

out(_A, Parameters) -> 
	{_, Name} = lists:keyfind(name, 1, Parameters),
	{ehtml, [
		{html, [], [
			{head, [], [
				{title, [], ["You are logged in"]},
				{script, [{src, "/js/zepto/zepto.min.js"}]}
			]},
			{body, [], [
				{h1, [], ["Login successful"]},
				{p, [], ["welcome " ++ Name]},
				{br},
				{a, [{href, "/chat"}, {alt, "go to chat room"}], ["chat room"]},
				{br},
				{a, [{href, "/create"}, {alt, "create"}], ["create people"]},
				{br},
				{a, [{href, "/moat/create"}, {alt, "get a cadet's documents"}], ["get a cadet's document"]}
			]}
		]}
	]}.

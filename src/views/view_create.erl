-module(view_create).
-author("ramy.daghstani@gmail.com").
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(_A, Parameters) -> 
	%% {template, Templates} = lists:keyfind(template, 1, Parameters),
	%% {attributes, Attributes} = lists:keyfind(attributes, 1, Parameters),
	{ehtml, [
		"<!DOCTYPE html>",
		{html, [], [
			{head, [], [
				{meta, [{charset, "UTF-8"}]},
				{title, [], ["Create"]},

				%% kendo ui css
				{link, [{rel, "stylesheet"}, {href, "/priv/css/kendo/kendo.common.min.css"}]},
				{link, [{rel, "stylesheet"}, {href, "/priv/css/kendo/kendo.default.min.css"}]},

				%% kendo ui js
				{script, [{src, "/priv/js/kendo/jquery.min.js"}]},
				{script, [{src, "/priv/js/kendo/kendo.web.min.js"}]},

				%% page js
				{script, [{src, "/priv/js/" ++ atom_to_list(?MODULE) ++ "/main.js"}]}
			]},
			{body, [], [
				{h1, [], ["Create an entry into the database"]},
				{'div', [{class, "k-content"}],
					%% {'input id="templates"'}
					{input, [{id, templates}]}
				}
			]}
		]}
	]}.

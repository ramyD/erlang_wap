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
				{meta, [{name, "viewport"}, {content, "width=device-width, initial-scale=1.0"}]},
				{meta, [{name, "description"}, {content, ""}]},

				%% bootstrap
				{link, [{rel, "stylesheet"}, {href, "/priv/css/bootstrap/bootstrap.min.css"}]},

				%% kendo ui css
				{link, [{rel, "stylesheet"}, {href, "/priv/css/kendo/kendo.common.min.css"}]},
				{link, [{rel, "stylesheet"}, {href, "/priv/css/kendo/kendo.default.min.css"}]},

				%% IE6-8 support of html5
				"<!--[if lt IE 9]>",
					{script, [{src, "http://html5shim.googlecode.com/svn/trunk/html5.js"}]},
				"<![endif]-->"
			]},
			{body, [{style, "padding-top:60px"}], [
				{'div', [{class, "navbar navbar-inverse navbar-fixed-top"}], [
					{'div', [{class, "navbar-inner"}], [
						{'div', [{class, "container"}], [
							{a, [{class, "btn btn-navbar"}, {'data-toggle', "collapse"}, {'data-target', ".nav-collapse"}], [
								{span, [{class, "icon-bar"}], []},
								{span, [{class, "icon-bar"}], []},
								{span, [{class, "icon-bar"}], []}
							]},
							{a, [{class, "brand"}, {href, "#"}], [
								"Project name"
							]},
							{'div', [{class, "nav-collapse collapse"}], [
								{ul, [{class, "nav"}], [
									{li, [{class, "active"}], [{a, [{href, "#"}], [ "Home" ] }] },
									{li, [], [{a, [{href, "#about"}], [ "About" ] }] },
									{li, [], [{a, [{href, "#contact"}], [ "Contact" ] }] }
								]}
							]}
						]}
					]}
				]},

				{'div', [{class, "container"}], [
					{h1, [], ["Create an entry into the database"]},
					{'div', [{class, "row"}], [
						{'div', [{class, "span4"}], [
							{'div', [{class, "k-content"}], [
								%% {'input id="templates"'}
								{input, [{id, templates}]}
							]}
						]},
						{'div', [{class, "span6"}], [
							{'form', [{class, "form-horizontal"}], [
								{'fieldset', [{id, "template-form"}], []}
							]}
						]}
					]}
				]},

				%% query bootstrap kendo js
				{script, [{src, "/priv/js/jquery/jquery.min.js"}]},
				{script, [{src, "/priv/js/bootstrap/bootstrap.min.js"}]},
				{script, [{src, "/priv/js/kendo/kendo.web.min.js"}]},

				%% page js
				{script, [{src, "/priv/js/" ++ atom_to_list(?MODULE) ++ "/main.js"}]}
			]}
		]}
	]}.

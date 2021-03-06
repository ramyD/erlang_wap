-module(moat_view_create).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

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
				{link, [{rel, "stylesheet"}, {href, "/css/bootstrap/bootstrap.min.css"}]},

				%% kendo ui css
				{link, [{rel, "stylesheet"}, {href, "/css/kendo/kendo.common.min.css"}]},
				{link, [{rel, "stylesheet"}, {href, "/css/kendo/kendo.default.min.css"}]},

				%% compatibility between style changes for kendo and bootstrap
				{link, [{rel, "stylesheet"}, {href, "/css/general/compatibility.css"}]},

				%% general style sheet for this view
				{link, [{rel, "stylesheet"}, {href, "/css/" ++ atom_to_list(?MODULE)  ++ "/main.css"}]},

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
								"Moat Project"
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
								{'fieldset', [{form, "template-form"}], [
									{input, [{id, templates}]}
								]}
							]},
							{button, [{type, "submit"}, {form, "template-form"}, {formaction, "/create/create_entry"}, {formmethod, "post"}], ["Submit"]}
						]},
						{'div', [{class, "span6"}], [
							{'form', [{class, "form-horizontal"}, {id, "template-form"}], [
								{'fieldset', [{form, "template-form"}], []}
							]}
						]}
					]}
				]},

				%% query bootstrap kendo js
				{script, [{src, "/js/jquery/jquery.min.js"}]},
				{script, [{src, "/js/bootstrap/bootstrap.min.js"}]},
				{script, [{src, "/js/kendo/kendo.web.min.js"}]},
				{script, [{src, "/js/modernizr/modernizr.js"}]},

				%% page js
				{script, [{src, "/js/" ++ atom_to_list(?MODULE) ++ "/main.js"}]}
			]}
		]}
	]}.

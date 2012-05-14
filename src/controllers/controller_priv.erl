-module(controller_priv).
-author("ramy.daghstani@gmail.com").
-export([init/3, default/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	Folder = string:substr(Parameters, 1, string:chr(Parameters, $/)-1),
	try (apply(?MODULE, list_to_atom(Folder), [Kernel, Parameters,  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, _Parameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

js(Kernel, Parameters, _A) ->
	case file:read_file(code:priv_dir(web_app2) ++ "/" ++ Parameters) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "application/javascript", Binary}}
	end,
	ok.

css(Kernel, Parameters, _A) ->
	case file:read_file(code:priv_dir(web_app2) ++ "/" ++ Parameters) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "text/css", Binary}}
	end,
	ok.

images(Kernel, Parameters, _A) ->
	case string:substr(Parameters, string:char(Parameters, $.)+1) of
		"jpeg" -> MimeType = "image/jpeg";
		"jpg" -> MimeType = "image/jpeg";
		"gif" -> MimeType = "image/gif";
		"png" -> MimeType = "image/png";
		"svg" -> MimeType = "image/svg+xml";
		"tiff" -> MimeType = "image/tiff"
	end,

	case file:read_file(code:priv_dir(web_app2) ++ "/" ++ Parameters) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, MimeType, Binary}}
	end,
	ok.

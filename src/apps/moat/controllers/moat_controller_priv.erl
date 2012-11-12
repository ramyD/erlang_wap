-module(moat_controller_priv).
-export([js/3, css/3, image/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

js(Kernel, ExtraParameters, _A) ->
	File = filename:join([code:priv_dir(erlang_wap), "apps", "moat", "js"] ++ ExtraParameters),
	case file:read_file(File) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "application/javascript", Binary}}
	end,
	ok.

css(Kernel, ExtraParameters, _A) ->
	File = filename:join([code:priv_dir(erlang_wap), "apps", "moat", "css"] ++ ExtraParameters),
	case file:read_file(File) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "text/css", Binary}}
	end,
	ok.

image(Kernel, ExtraParameters, _A) ->
	File = filename:join([code:priv_dir(erlang_wap), "apps", "moat", "css"] ++ ExtraParameters),
	case string:substr(File, string:char(File, $.)+1) of
		"jpeg" -> MimeType = "image/jpeg";
		"jpg" -> MimeType = "image/jpeg";
		"gif" -> MimeType = "image/gif";
		"png" -> MimeType = "image/png";
		"svg" -> MimeType = "image/svg+xml";
		"tiff" -> MimeType = "image/tiff"
	end,

	case file:read_file(File) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, MimeType, Binary}}
	end,
	ok.

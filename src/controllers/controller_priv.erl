-module(controller_priv).
-author("ramy.daghstani@gmail.com").
-export([init/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	Folder = string:substr(Parameters, 1, string:chr(Parameters, $/)-1),
	try (apply(?MODULE, list_to_atom(Folder), [Kernel, [{file_path, Parameters}],  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, _ExtraParameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

js(Kernel, ExtraParameters, _A) ->
  {_, FilePath} = lists:keyfind(file_path, 1, ExtraParameters),
	case file:read_file(filename:absname("../priv/" ++ FilePath)) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "application/javascript", Binary}}
	end,
	ok.

css(Kernel, ExtraParameters, _A) ->
  {_, FilePath} = lists:keyfind(file_path, 1, ExtraParameters),
	case file:read_file(filename:absname("../priv/" ++ FilePath)) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, "text/css", Binary}}
	end,
	ok.

images(Kernel, ExtraParameters, _A) ->
  {_, FilePath} = lists:keyfind(file_path, 1, ExtraParameters),
	case string:substr(FilePath, string:char(FilePath, $.)+1) of
		"jpeg" -> MimeType = "image/jpeg";
		"jpg" -> MimeType = "image/jpeg";
		"gif" -> MimeType = "image/gif";
		"png" -> MimeType = "image/png";
		"svg" -> MimeType = "image/svg+xml";
		"tiff" -> MimeType = "image/tiff"
	end,

	case file:read_file(filename:absname("../priv/" ++ FilePath)) of
		{error, Reason} ->
			Kernel ! {ok, {html, Reason}};
		{ok, Binary} ->
			Kernel ! {ok, {content, MimeType, Binary}}
	end,
	ok.

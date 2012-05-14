-module(controller_herp).
-author("ramy.daghstani@gmail.com").
-export([init/3, default/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	try (apply(?MODULE, list_to_atom(Parameters), [Kernel, Parameters,  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, Parameters, _A) ->
	Kernel ! {ok, {ehtml, [{section, [], ["hello default!" ++ Parameters]}]}},
	ok.

herp(Kernel, Parameters, _A) ->
	Kernel ! {ok, {ehtml, [{section, [], ["hello herp!" ++ Parameters]}]}},
	ok.

adddb(Kernel, _Parameters, _A) -> 
	Kernel ! {ok, {ehtml, {html, [], [
				{h2, [], "A simple text post page"}, 
				{form, [{method, "post"}, {action, "dbcreate"}], [
					"database name: ", 
					{input, [{type, text}, {width, "50"}, {name, dbname}] }
				]}
			]}
	}},
	ok.

dbcreate(Kernel, _Parameters,  A) -> 
	%%io:fwrite("in dbcreate with post data: ~p", [yaws_api:parse_post(A)]),
	[{"dbname", Data}] = yaws_api:parse_post(A),
	ecouch:db_create(Data),
	Kernel ! {ok, {html, io_lib:format("~p", [ecouch:db_list()])}},
	ok.

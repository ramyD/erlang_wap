-module(controller_moat).
-author("ramy.daghstani@gmail.com").
-export([init/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

init(Kernel, "", A) ->
	apply(?MODULE, default, [Kernel, "",  A]);

init(Kernel, Parameters, A) ->
	try (apply(?MODULE, list_to_atom(Parameters), [Kernel, [],  A])) of
		ok -> ok
	catch
		error:undef -> init(Kernel, "", A)
	end.

default(Kernel, _ExtraParameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

%% This method needs to fetch the tempalates for a person and all attributes. basically all templates
create(Kernel, _extraParameters, A) ->
	Templates = object_templates:get_templates(),

	Kernel ! {ok, [view_loggedin:out(A, [{test, "derp"}])]},
	ok.

%% Submit creation
submit_create(Kernel, _extraParameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

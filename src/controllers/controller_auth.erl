-module(controller_auth).
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

default(Kernel, _Parameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

login(Kernel, _Parameters, A) ->
	Kernel ! {ok, view_login:out(A)},
	ok.

register(Kernel, _Parameters, A) ->
  case A#arg.req#http_request.method of
	  'GET' -> Kernel ! {ok, view_register:out(A)};
    'POST' -> A,
              Kernel ! {ok, {}}
  end,
	ok.

authenticate(Kernel, _Parameters, _A) ->
	Kernel ! {ok, {ehtml, []}},
	ok.

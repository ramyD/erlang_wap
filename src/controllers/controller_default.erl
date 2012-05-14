-module(controller_default).
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
	Kernel ! {ok, {ehtml, [{section, [], ["hello default" ++ Parameters]}]}},
	ok.

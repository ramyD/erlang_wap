-module(config).
-author("ramy.daghstani@gmail.com").
-export([init/0, configuration/0, get_database/1, get/2]).

-include("config.hrl").

configuration() ->
	[ _ | Database ] = tuple_to_list(#database{database_type={database_type, couchdb},
											   port={port, "5984"},
											   username={username, ""},
											   password={password, ""}}),
	[{database, Database}].

init() ->
	ets:new(config, [set,
					 protected,
					 named_table,
					 {keypos, 1},
					 {heir, none},
					 {write_concurrency, false},
					 {read_concurrency, true}]),
	
	ets:insert(config, config:configuration()).

get_database(Parameter) ->
	[{database, Config}] = ets:lookup(config, database),
	lists:keyfind(Parameter, 1, Config).

get(Node, Parameter) ->
	[{Node, Config}] = ets:lookup(config, Node),
	lists:keyfind(Parameter, 1, Config).

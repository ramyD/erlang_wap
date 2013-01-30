-module(couchdb).
-author("ramy.daghstani@gmail.com").
-export([]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

pass_query(Database, Parameters) ->
	Url = "http://localhost:5984/" ++ Database ++ "/" ++ Parameters,
	{ok, {{"HTTP/1.1",200,"OK"}, _Header, DbRawRows}} = httpc:request(get, {Url,[{"Content-Type", "application/json"}]}, [], [{full_result, true}]),
	DbRawRows.

moat_templates_documents(View) ->
	DbRawRows = couchdb:pass_query("moat_templates", View),
	DbRowObjects = json:decode(DbRawRows),
	{ok, {[{<<"total_rows">>, _Rownum}, {<<"offset">>,0}, {<<"rows">>, Rows}]}} = DbRowObjects,
	Rows.

moat_templates(Parameters) ->
	DbRawRows = couchdb:pass_query("moat_templates", Parameters),
	{ok, {Row}} = json:decode(DbRawRows),
	Row.

moat_attributes(Parameters) ->
	DbRawRows = couchdb:pass_query("moat_attributes", Parameters),
	{ok, {Row}} = json:decode(DbRawRows),
	Row.

moat_attributes_documents(View) ->
	DbRawRows = couchdb:pass_query("moat_attributes", View),
	DbRowObjects = json:decode(DbRawRows),
	{ok, {[{<<"total_rows">>, _Rownum}, {<<"offset">>,0}, {<<"rows">>, Rows}]}} = DbRowObjects,
	Rows.

moat_data(Parameters) ->
	DbRawRows = couchdb:pass_query("moat_data", Parameters),
	io:format("request data: ~p~n", [DbRawRows]),
	{ok, {Row}} = json:decode(DbRawRows),
	Row.

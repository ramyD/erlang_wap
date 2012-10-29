-module(couchdb).
-author("ramy.daghstani@gmail.com").
-export([]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

pass_query(Database, Parameters) ->
	Url = "http://localhost:5984/" ++ Database ++ "/" ++ Parameters,
	{ok, {{"HTTP/1.1",200,"OK"}, _Header, DbRawRows}} = httpc:request(get, {Url,[{"Content-Type", rfc4627:mime_type()}]}, [], [{full_result, true}]),
	DbRawRows.

moat_templates_documents(View) ->
	Documents = "_design/documents/_view/",
	DbRawRows = couchdb:pass_query("moat_templates", Documents ++ View),
	DbRowObjects = rfc4627:decode_noauto(DbRawRows),
	{ok, {obj,[{"total_rows", _Rownum}, {"offset",0}, {"rows", Rows}]}, []} = DbRowObjects,
	Rows.

moat_templates(Parameters) ->
	DbRawRows = couchdb:pass_query("moat_templates", Parameters),
	DbRowObjects = rfc4627:decode_noauto(DbRawRows),
	{ok, {obj,[{"total_rows", _Rownum}, {"offset",0}, {"rows", Rows}]}, []} = DbRowObjects,
	Rows.

moat_attributes_documents(View) ->
	Documents = "_design/documents/_view/",
	DbRawRows = couchdb:pass_query("moat_attributes", Documents ++ View),
	DbRowObjects = rfc4627:decode_noauto(DbRawRows),
	{ok, {obj,[{"total_rows", _Rownum}, {"offset",0}, {"rows", Rows}]}, []} = DbRowObjects,
	Rows.

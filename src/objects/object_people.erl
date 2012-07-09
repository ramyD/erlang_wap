-module(object_people).
-author("ramy.daghstani@gmail.com").
-export([get_passwords/0, add/0, update/0]).

-compile(export_all).

get_passwords() ->
  {ok, {{"HTTP/1.1",200,"OK"}, _Header, DbRawRows}} = httpc:request(get, {"http://localhost:5984/cadets/_design/authorization/_view/registration", [{"Content-Type", rfc4627:mime_type()}]}, [], [{full_result, true}]),
  DbRowObjects = rfc4627:decode_noauto(DbRawRows),
  {ok, {obj,[{"total_rows", _Rownum}, {"offset",0}, {"rows", Rows}]}, []} = DbRowObjects,
  Rows.

get_user(UserId) ->
  {ok, {{"HTTP/1.1",200,"OK"}, _, DbRawRows}} = httpc:request(get, {"http://localhost:5984/cadets/" ++ UserId, [{"Content-Type", rfc4627:mime_type()}]}, [], [{full_result, true}]),
  DbRowObjects = rfc4627:decode_noauto(DbRawRows),
  {ok, {obj, Row}, []} = DbRowObjects,
  Row.

add() -> ok.

update() -> ok.

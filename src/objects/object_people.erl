-module(object_people).
-author("ramy.daghstani@gmail.com").
-export([get_passwords/0, add/0, update/0]).

-compile(export_all).

get_passwords() ->
  Response = httpc:request(get, {"http://localhost:5984/cadets/_design/authorization/_view/registration", [{"Content-Type", rfc4627:mime_type()}]}, [], [{full_result, true}]),
  Response.

add() -> ok.

update() -> ok.

-module(moat_object_attributes).
-export([get_attributes/0, get_attribute_by_id/1, get_attribute_by_design/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

get_attributes() ->
	Documents = "_design/documents/_view/",
	{database_type , Database} = config:get_database(database_type),
	Rows = apply(Database, moat_attributes_documents, [Documents ++ "all_docs"]),
	Attributes = [ {AttributeId, Attribute} || {Row} <- Rows, {<<"id">>, AttributeId} <- Row, {<<"value">>, {Attribute}} <- Row ],
	Attributes.

get_attribute_by_id(Id) ->
	{database_type , Database} = config:get_database(database_type),
	Attribute = apply(Database, moat_attributes, [Id]),
	Attribute.

get_attribute_by_design(Design) ->
	Documents = "_design/documents/_view/",
	{database_type , Database} = config:get_database(database_type),
	Attribute = apply(Database, moat_attributes_documents, [Documents ++ Design]),
	Attribute.

-module(object_templates).
-author("ramy.daghstani@gmail.com").
-export([get_templates/0]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

get_templates() ->
	Documents = "_design/documents/_view/",
	{ database_type , Database} = config:get_database(database_type),
	Rows = apply(Database, moat_templates_documents, [Documents ++ "all_docs"]),
	Templates = [ {TemplateId, Template} || {Row} <- Rows, {<<"id">>, TemplateId} <- Row, {<<"value">>, {Template}} <- Row ],
	Templates.

get_template_by_id(Id) ->
	{ database_type , Database} = config:get_database(database_type),
	Template = apply(Database, moat_templates, [Id]),
	Template.

get_templates_by_design(Design) ->
	Documents = "_design/documents/_view/",
	{ database_type , Database} = config:get_database(database_type),
	Templates = apply(Database, moat_templates_documents, [Documents ++ Design]),
	Templates.

get_attributes() ->
	Documents = "_design/documents/_view/",
	{ database_type , Database} = config:get_database(database_type),
	Rows = apply(Database, moat_attributes_documents, [Documents ++ "all_docs"]),
	Attributes = [ {AttributeId, Attribute} || {obj, Row} <- Rows, {"id", AttributeId} <- Row, {"value", {obj, Attribute}} <- Row ],
	Attributes.

get_attribute_by_id(Id) ->
	{ database_type , Database} = config:get_database(database_type),
	Attribute = apply(Database, moat_attributes, [Id]),
	Attribute.

get_attribute_by_design(Design) ->
	Documents = "_design/documents/_view/",
	{ database_type , Database} = config:get_database(database_type),
	Attribute = apply(Database, moat_attributes_documents, [Documents ++ Design]),
	Attribute.

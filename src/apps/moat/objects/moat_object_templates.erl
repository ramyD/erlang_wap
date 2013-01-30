-module(moat_object_templates).
-export([get_templates/0, get_template_by_id/1, get_templates_by_design/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

get_templates() ->
	Documents = "_design/documents/_view/",
	{database_type , Database} = config:get_database(database_type),
	Rows = apply(Database, moat_templates_documents, [Documents ++ "all_docs"]),
	Templates = [ {TemplateId, Template} || {Row} <- Rows, {<<"id">>, TemplateId} <- Row, {<<"value">>, {Template}} <- Row ],
	Templates.

get_template_by_id(Id) ->
	{database_type , Database} = config:get_database(database_type),
	Template = apply(Database, moat_templates, [Id]),
	Template.

get_templates_by_design(Design) ->
	Documents = "_design/documents/_view/",
	{database_type , Database} = config:get_database(database_type),
	Templates = apply(Database, moat_templates_documents, [Documents ++ Design]),
	Templates.

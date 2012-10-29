-module(object_templates).
-author("ramy.daghstani@gmail.com").
-export([get_templates/0]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

get_templates() ->
	Rows = couchdb:moat_templates_documents("all_docs"),
	Templates = [ {TemplateId, Template} || {obj, Row} <- Rows, {"id", TemplateId} <- Row, {"value", {obj, Template}} <- Row ],
	Templates.

get_template_objects(Id) ->
	Rows = couchdb:moat_templates_documents(Id),
	Rows.

get_attributes() ->
	Rows = couchdb:moat_attributes_documents("all_docs"),
	Attributes = [ {AttributeId, Attribute} || {obj, Row} <- Rows, {"id", AttributeId} <- Row, {"value", {obj, Attribute}} <- Row ],
	Attributes.

-module(moat_controller_create).
-export([default/3,
		 create_entry/3,
		 get_template_names/3,
		 get_template_parameters/3,
		 get_attribute_names/3,
		 get_attribute_parameters/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

%% is_loggedin(A) ->
%% 	CD = lib_cookie:getcookiedata(A),
%% 	case CD#cookiedata.permission of
%% 		anonymous -> false;
%% 		_ -> true
%% 	end.

default(Kernel, _ExtraParameters, A) ->
	Templates = moat_object_templates:get_templates(),
	Attributes = moat_object_attributes:get_attributes(),
	Kernel ! {ok, [moat_view_create:out(A, [{templates, Templates},
										    {attributes, Attributes}])]},
	ok.

create_entry(Kernel, _ExtraParameters, A) ->
	Query = yaws_api:parse_query(A),
	Post = yaws_api:parse_post(A),
	io:format("Query: ~p~n, Post: ~p~n", [Query, Post]),
	Kernel ! {ok, {content, "application/json", <<"{}">>}},
	ok.

get_template_names(Kernel, _ExtraParameters, _A) ->
	Templates = moat_object_templates:get_templates(),
	TemplateNames = [ {[{<<"name">>, Name}, {<<"value">>, Value}]} || {Name, Properties} <- Templates,
																      {<<"_id">>, Value} <-Properties ],
	{ok, TemplateOutput} = json:encode(TemplateNames),
	Kernel ! {ok, {content, "application/json", TemplateOutput}},
	ok.

get_template_parameters(Kernel, _ExtraParameters, A) ->
	Query = yaws_api:parse_query(A),
	{"template_id", TemplateId} = lists:keyfind("template_id", 1, Query),
	TemplateDescription = moat_object_templates:get_template_by_id(TemplateId),
	{ok, TemplateOutput} = json:encode({TemplateDescription}),
	Kernel ! {ok, {content, "application/json", TemplateOutput}},
	ok.

get_attribute_names(Kernel, _ExtraParameters, _A) ->
	Attributes = moat_object_attributes:get_attributes(),
	AttributesPrep = [ {[{<<"attribute">>, Id}, {<<"id">>, Id}]} || {Id, _} <- Attributes ],
	{ok, AttributesOutput} = json:encode(AttributesPrep),
	Kernel ! {ok, {content, "application/json", AttributesOutput}},
	ok.

get_attribute_parameters(Kernel, _ExtraParameters, A) ->
	Query = yaws_api:parse_query(A),
	{"attribute_id", AttributeId} = lists:keyfind("attribute_id", 1, Query),
	AttributeDescription = moat_object_attributes:get_attribute_by_id(AttributeId),
	{ok, AttributeOutput} = json:encode({AttributeDescription}),
	Kernel ! {ok, {content, "application/json", AttributeOutput}},
	ok.

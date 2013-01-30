-module(moat_object_data).
-export([get_data/1]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

get_data(Data) ->
	{database_type , Database} = config:get_database(database_type),
	Ranks = apply(Database, moat_data, [Data]),
	Ranks.

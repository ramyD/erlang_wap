-module(moat_controller_app_data).
-export([default/3, get_ranks/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

default(Kernel, _ExtraParameters, A) ->
	Kernel ! {ok, [moat_view_notfound:out(A)]},
	ok.

get_ranks(Kernel, _ExtraParameters, _A) ->
	RawRanks = moat_object_data:get_data("Ranks"),

	Ranks = proplists:delete(<<"_id">>, proplists:delete(<<"_rev">>, RawRanks)),

	FormatedRanks = lists:foldl(fun({Order, RankName}, AllRanks) ->
		if
			Order == <<"_id">> ->
				AllRanks;
			
			Order == <<"_rev">> ->
				AllRanks;
			
			true ->
				AllRanks ++ [{[{<<"order">>, Order}, {<<"rank">>, RankName}]}]
		end
	end, [], Ranks),

	%% decode ranks and sort them into a list of id: 0 rank:somerank etc
	{ok, RanksOutput} = json:encode(FormatedRanks),

	Kernel ! {ok, {content, "application/json", RanksOutput}},
	ok.

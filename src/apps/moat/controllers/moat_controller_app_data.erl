-module(moat_controller_app_data).
-export([get_ranks/3]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").

get_ranks(Kernel, _ExtraParameters, _A) ->
	Ranks = moat_object_data:get_data("Ranks"),
	%% decode ranks and sort them into a list of id: 0 rank:somerank etc
	{ok, RanksOutput} = json:encode(Ranks),
	Kernel ! {ok, {content, "application/json", RanksOutput}},
	ok.

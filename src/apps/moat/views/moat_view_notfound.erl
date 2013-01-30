-module(moat_view_notfound).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(A, _Parameters) -> 
	{ehtml, {html, [], [
					{h2, [], "404"}, 
					{p, [], A#arg.appmoddata},
					{p, [], "page not found"}
			]}
	}.

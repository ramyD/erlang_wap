-module(moat_view_html_attribute_date).
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").

out(A) -> 
 out(A, []).

out(A, Parameters) -> 
	moat_view_html_form_date:out(A, Parameters).

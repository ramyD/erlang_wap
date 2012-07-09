-module(view_chat).
-author("ramy.daghstani@gmail.com").
-export([out/1, out/2]).

-include("/usr/lib/yaws/include/yaws_api.hrl").
-include("wap.hrl").
-compile(export_all).

out(A) -> 
 out(A, []).

out(A, _Parameters) -> 
	{ehtml, [
		{html, [], [
			{head, [], [
				{title, [], ["Chat room"]},
				{script, [{src, "/priv/js/chatwebsocket.js"}]},
        {script, [{type, "text/javascript"}], [" client.websockethost = '" ++ A#arg.headers#headers.host ++ "'; "]},
				{style, [{type, "text/cs"}], ["div.hidden { display: none; }"]}
			]},
			{body, [], [
				{h1, [], ["Chat Room"]},
        {br},
        {'div', [{id, "msgs"}], []},
        {'div', [{id, "connect"}], [
          {input, [{id, "cA"}, {class, "button"}, {type, "submit"}, {value, "Connect"}, {name, "Connect"}], []}
        ]},
        {br},
        {'div', [{id, "connected"}, {class, "hidden"}], [
          "Say Something",
          {input, [{id, "phrase"}, {type, "text"}], []},
          {input, [{id, "sendB"}, {class, "button"}, {type, "submit"}, {value, "Send"}, {name, "connect"}], []}
        ]}
			]}
		]}
	]}.

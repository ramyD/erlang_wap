{application,wap,
	[{description,"generic web app"},
	 {vsn,"0.2"},
	 {modules,[
			%% Main
			wap_kernel,
			wap_chat,
			router,

			%% Main
			config,

			%% Controllers:
			controller_auth,
			controller_chat,
			controller_create,
			controller_default,
			controller_herp,
			controller_priv,
			controller_websocket,

			%% Databases:
			couchdb,

			%% Json
			json,
			json_fuzz,

			%% Libs:
			db_access.erl,
			lib_cookie,
			lib_websocket,

			%% Views:
			view_chat,
			view_create,
			view_loggedin,
			view_login,
			view_register,

			%% Objects:
			object_people,
			object_templates,

			%% rfc4627
			rfc4627,
			rfc4627_jsonrpc_app,
			rfc4627_jsonrpc,
			rfc4627_jsonrpc_http,
			rfc4627_jsonrpc_inets,
			rfc4627_jsonrpc_mochiweb,
			rfc4627_jsonrpc_registry,
			rfc4627_jsonrpc_sup
	      ]
	 },
	 {registered,[wap]},
	 {applications,[kernel, stdlib]},
	 {env, [{environment, "test"}]},
	 {mod,{wap_kernel,[]}}]}.

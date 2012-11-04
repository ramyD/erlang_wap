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
			object_templates
	      ]
	 },
	 {registered,[wap]},
	 {applications,[kernel, stdlib]},
	 {env, [{environment, "test"}]},
	 {mod,{wap_kernel,[]}}]}.

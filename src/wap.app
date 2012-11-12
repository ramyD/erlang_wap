{application,wap,
	[{description,"generic web app"},
	 {vsn,"0.3"},
	 {modules,[
			%% Main
			wap_kernel,
			router,

			%% Bundles
			wap_chat,

			%% Config
			config,

			%% Databases:
			couchdb,

			%% Libraries
			%% Json
			json,
			json_fuzz,
			
			%% Cookies
			lib_cookie,

			%% apps
			%%MOAT
			%% Controllers:
			moat_controller_auth,
			moat_controller_chat,
			moat_controller_create,
			moat_controller_default,
			moat_controller_priv,

			%% Views:
			moat_view_chat,
			moat_view_create,
			moat_view_loggedin,
			moat_view_login,
			moat_view_register,

			%% Objects:
			moat_object_people,
			moat_object_templates
	      ]
	 },
	 {registered,[wap]},
	 {applications,[kernel, stdlib]},
	 {env, [{environment, "test"}]},
	 {mod,{wap_kernel,[]}}]}.

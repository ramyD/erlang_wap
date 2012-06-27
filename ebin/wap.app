{application,wap,
	[{description,"generic web app"},
	 {vsn,"0.1"},
	 {modules,[wap_kernel,
             wap_chat,

	    		   %% Router:
	    		   router,

	    		   %% Controllers:
	    		   controller_default,
	    		   controller_herp,
	    		   controller_priv,
	    		   controller_auth,
	    		   controller_chat,
	    		   controller_websocket,

             %% Views:
             view_chat,
             view_loggedin,
             view_login,
             view_register,


             %% Objects:
             object_people,

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

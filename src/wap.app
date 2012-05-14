{application,wap,
	[{description,"generic web app"},
	 {vsn,"0.1"},
	 {modules,[wap_kernel,
	 		   %% Router:
			   router,

			   %% Controllers:
			   controller_default,
			   controller_herp
			  ]
	},
	{registered,[wap]},
	{applications,[kernel, stdlib]},
	{env, [{environment, "test"}]},
	{mod,{wap_kernel,[]}}]}.

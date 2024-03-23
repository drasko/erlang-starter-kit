%%%-------------------------------------------------------------------
%% @doc erlang-starter-kit public API
%% @end
%%%-------------------------------------------------------------------

-module(esk_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @spec start(StartType, StartArgs) -> {ok, Pid} |
%%                                      {ok, Pid, State} |
%%                                      {error, Reason}
%%      StartType = normal | {takeover, Node} | {failover, Node}
%%      StartArgs = term()
%% @end
%%--------------------------------------------------------------------
start(_StartType, _StartArgs) ->
    %% Retrieve Cowboy host and port from application environment
    {ok, CowboyEnv} = application:get_env(cowboy),
    Host = proplists:get_value(host, CowboyEnv),
    Port = proplists:get_value(port, CowboyEnv),

    % Cowboy
    {ok, _} = application:ensure_all_started(cowboy),

    Routes = [{
        '_',
        [
            {"/status", esk_status, []},
            {"/users", esk_users, []},
            {"/users/:id", esk_users, []},
            {"/users/:id/login", esk_users, []}
        ]
    }],

    error_logger:info_msg("HERE1"),
    Dispatch = cowboy_router:compile(Routes),

    TransOpts = [{ip, Host}, {port, Port}],
	ProtoOpts = #{env => #{dispatch => Dispatch}},

    error_logger:info_msg("HERE2"),

	{ok, _} = cowboy:start_clear(esk_http_listener, TransOpts, ProtoOpts),
    
    error_logger:info_msg("HERE3"),

    esk_sup:start_link().

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @spec stop(State) -> void()
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
	ok = cowboy:stop_listener(esk_http_listener).

%%====================================================================
%% Internal functions
%%====================================================================

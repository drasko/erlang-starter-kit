%%%-------------------------------------------------------------------
%% @doc erlang-starter-kit top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(esk_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
-spec start_link() -> {ok, pid()}.
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    

    {ok, PoolsEnv} = application:get_env(pools),
    [SizeArgs, WorkerArgs] = proplists:get_value(dbpool, PoolsEnv),
    PoolArgs = [{name, {local, dbpool}}, {worker_module, esk_db_worker}],
    PoolSpec = poolboy:child_spec(dbpool, PoolArgs ++ SizeArgs, WorkerArgs),

    error_logger:info_msg("PoolSpec: ~p", [PoolSpec]),

    ChildSpecs = [PoolSpec],
    {ok, {SupFlags, ChildSpecs}}.

%%====================================================================
%% Internal functions
%%====================================================================

%%%-------------------------------------------------------------------
%% @doc erlang-starter-kit public API
%% @end
%%%-------------------------------------------------------------------

-module(esk_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = 'esk_sup':start_link(),
	Routes = [ {
        '_',
        [
            {"/status", esk_status, []},
            {"/user", esk_user, []},
            {"/login", esk_login, []}
        ]
    } ],
    Dispatch = cowboy_router:compile(Routes),

    TransOpts = [ {ip, {0,0,0,0}}, {port, 8089} ],
	ProtoOpts = #{env => #{dispatch => Dispatch}},

	{ok, _} = cowboy:start_clear(esk_cowboy,
		TransOpts, ProtoOpts),

    {ok, Pid}.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

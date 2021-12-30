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
    {ok, Host} = inet:parse_address(os:getenv("ESK_HOST", "0.0.0.0")),
    Port = list_to_integer(os:getenv("ESK_PORT", "8089")),

    Routes = [{
        '_',
        [
            {"/status", esk_status, []},
            {"/users", esk_user, []},
            {"/login", esk_login, []}
        ]
    }],
    Dispatch = cowboy_router:compile(Routes),

    TransOpts = [{ip, Host}, {port, Port}],
	ProtoOpts = #{env => #{dispatch => Dispatch}},

	{ok, _} = cowboy:start_clear(esk_http_listener, TransOpts, ProtoOpts),

    esk_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
	ok = cowboy:stop_listener(esk_http_listener).

%%====================================================================
%% Internal functions
%%====================================================================

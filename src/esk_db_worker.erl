-module(esk_db_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {conn}).

-define(DRIVER, "PostgreSQL ANSI").
-define(PORT, "5432").

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    io:format("Initializing odbc_test_worker~n"),
    process_flag(trap_exit, true),
    Server = proplists:get_value(hostname, Args),
    Database = proplists:get_value(database, Args),
    Uid = proplists:get_value(username, Args),
    Pwd = proplists:get_value(password, Args),
    % Connection string example: "Driver=PostgreSQL ANSI;Server=localhost;Port=5432;Database=test;Uid=allibaba;Pwd=sesame"
    ConnStr = io_lib:format("Driver=~s;Server=~s;Port=~s;Database=~s;Uid=~s;Pwd=~s;", [?DRIVER, Server, ?PORT, Database, Uid, Pwd]),
    {ok, Conn} = odbc:connect(ConnStr, []),
    io:format("Connected to database~n"),
    {ok, #state{conn=Conn}}.

handle_call({squery, Sql}, _From, #state{conn=Conn}=State) ->
    {reply, epgsql:squery(Conn, Sql), State};
handle_call({equery, Stmt, Params}, _From, #state{conn=Conn}=State) ->
    {reply, epgsql:equery(Conn, Stmt, Params), State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{conn=Conn}) ->
    ok = epgsql:close(Conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
-module(esk_db_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {conn}).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    io:format("Initializing odbc_test_worker~n"),
    process_flag(trap_exit, true),
    Driver = proplists:get_value(driver, Args),
    Server = proplists:get_value(hostname, Args),
    Port = proplists:get_value(port, Args),
    Database = proplists:get_value(database, Args),
    Uid = proplists:get_value(username, Args),
    Pwd = proplists:get_value(password, Args),
    % Connection string example: "Driver=PostgreSQL ANSI;Server=localhost;Port=5432;Database=test;Uid=allibaba;Pwd=sesame"
    ConnStr = io_lib:format("Driver=~s;Server=~s;Port=~B;Database=~s;Uid=~s;Pwd=~s;", [Driver, Server, Port, Database, Uid, Pwd]),
    io:format("Connection string: ~s~n", [ConnStr]),
    {ok, Conn} = odbc:connect(ConnStr, []),
    io:format("Connected to database~n"),
    {ok, #state{conn=Conn}}.

handle_call({execute_query, Query}, _From, State) ->
    io:format("Handling execute_query call: ~s~n", [Query]),
    Conn = State#state.conn,
    io:format("Executing SQL query: ~s~n", [Query]),
    {selected, Columns, Rows} = odbc:sql_query(Conn, Query),
    Result = {Columns, Rows},
    io:format("Query result: ~p~n", [Result]),
    {reply, Result, State};

handle_call(_Request, _From, State) ->
    io:format("Handling unknown call~n"),
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    io:format("Handling cast message~n"),
    {noreply, State}.

handle_info(_Info, State) ->
    io:format("Handling info message~n"),
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("Terminating odbc_test_worker~n"),
    odbc:disconnect(State#state.conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    io:format("Code change in odbc_test_worker~n"),
    {ok, State}.
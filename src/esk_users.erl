-module(esk_users).

-export([
    init/2,
    allowed_methods/2,
    content_types_accepted/2,
    content_types_provided/2,
    resource_exists/2,
    read_user/2,
    write_user/2
]).

-include_lib("kernel/include/logger.hrl").

init(Req, State) ->
	{cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>, <<"POST">>, <<"PUT">>, <<"DELETE">>],
    {Methods, Req, State}.

resource_exists(Req, State) ->
    case cowboy_req:method(Req) of
        <<"GET">> -> {true, Req, State};
        <<"POST">> -> {false, Req, State};
        <<"PUT">> -> {true, Req, State};
        <<"DELETE">> -> {true, Req, State}
    end.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, read_user}], Req, State}.

content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, write_user}], Req, State}.

read_user(Req, State) ->
    Resp = jsone:encode([{<<"user">>,<<"1234">>}]),
    {Resp, Req, State}.

write_user(Req, State) ->
    ?LOG_NOTICE(#{req => Req}),
    case cowboy_req:method(Req) of
        <<"POST">> -> create_user(Req, State);
        <<"PUT">> -> update_user(Req, State)
    end.

create_user(Req, State) ->
    ?LOG_NOTICE(#{req => Req}),
    {ok, PostVals, Req1} = cowboy_req:read_urlencoded_body(Req),
    _Username = proplists:get_value(<<"username">>, PostVals),
    _Password = proplists:get_value(<<"password">>, PostVals),
    {{true, <<"UUID">>}, Req1, State}.

update_user(Req, State) ->
    {true, Req, State}.
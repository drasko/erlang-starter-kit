-module(esk_status).

-export([init/2]).

init(Req, Opts) ->
    Resp = cowboy_req:reply(200,
        #{<<"content-type">> => <<"application/json">>},
        jsone:encode([{<<"status">>,<<"running">>}]),
        Req),
    {ok, Resp, Opts}.

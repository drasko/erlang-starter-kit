-module(esk_status).

-export([init/2]).

init(Req, Opts) ->
    lager:warning("~s GET /status~n", [?MODULE_STRING]),
    Resp = cowboy_req:reply(200,
        #{<<"content-type">> => <<"application/json">>},
        jsone:encode([{<<"status">>,<<"running">>}]),
        Req),
    {ok, Resp, Opts}.

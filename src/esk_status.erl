-module(esk_status).

-export([init/2]).

init(Req, Opts) ->
    _ = lager:warning("~s GET /status~n", [?MODULE_STRING]),
    Req2 = cowboy_req:reply(200,
        #{<<"content-type">> => <<"application/json">>},
        jsx:encode([{<<"status">>,<<"running">>}]),
        Req),
    {ok, Req2, Opts}.

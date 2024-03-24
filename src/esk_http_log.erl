-module(esk_http_log).
-behaviour(cowboy_middleware).

-export([execute/2]).

execute(Req, Env) ->
    log_request(Req),
    {ok, Req, Env}.

log_request(Req) ->
    #{
        method := Method,
        path := Path,
        version := Version
    } = Req,
    io:format("Request received: ~s ~s ~s~n", [Method, Path, Version]).

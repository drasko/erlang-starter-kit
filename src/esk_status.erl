-module(esk_status).

-export([
    init/2,
    allowed_methods/2,
    content_types_provided/2,
    read_status/2
]).

-include_lib("kernel/include/logger.hrl").

init(Req, State) ->
	{cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>],
    {Methods, Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, read_status}], Req, State}.

read_status(Req, State) ->
    Resp = jsone:encode([{<<"status">>,<<"running">>}]),
    {Resp, Req, State}.
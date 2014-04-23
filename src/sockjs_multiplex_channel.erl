-compile({parse_transform,sockjs_pmod_pt}).
-module(sockjs_multiplex_channel).

-export([send/2, close/1, close/3, info/1]).

-type channel() :: {?MODULE, sockjs:conn(), topic()}.
-type topic()   :: string().

-spec send(iodata(), channel()) -> ok.
send(Data, {?MODULE, Conn, Topic}) ->
    Conn:send(iolist_to_binary(["msg", ",", Topic, ",", Data])).

-spec close(channel()) -> ok.
close(Channel) ->
    close(1000, "Normal closure", Channel).

-spec close(non_neg_integer(), string(), channel()) -> ok.
close(_Code, _Reason, {?MODULE, Conn, Topic}) ->
    Conn:send(iolist_to_binary(["uns", ",", Topic])).

-spec info(channel()) -> [{atom(), any()}].
info({?MODULE, Conn, Topic}) ->
    Conn:info() ++ [{topic, Topic}].


-module(mongoose_domain_gaps).
-export([init/0]).
-export([new_timestamp/0]).
-export([max_time_to_wait/0]).
-export([gaps_limit_before_restart/0]).
-export([check_for_gaps/2]).

%% These are used in the small tests
-ignore_xref([gaps_limit_before_restart/0, max_time_to_wait/0]).

-include("mongoose_logger.hrl").

-define(TABLE, ?MODULE).

-type time_seconds() :: integer().

init() ->
    ets:new(?TABLE, [set, named_table, public]).

-spec new_timestamp() -> time_seconds().
new_timestamp() ->
    erlang:monotonic_time(seconds).

-spec max_time_to_wait() -> time_seconds().
max_time_to_wait() ->
    30.

-spec gaps_limit_before_restart() -> non_neg_integer().
gaps_limit_before_restart() ->
    10000.

-spec check_for_gaps([mongoose_domain_sql:row()], time_seconds()) -> ok | restart | wait.
check_for_gaps(Rows, Now) ->
    Ids = rows_to_ids(Rows),
    case find_gaps(Ids, gaps_limit_before_restart()) of
        too_many_gaps ->
            ?LOG_ERROR(#{what => domain_check_for_gaps_failed,
                         reason => too_many_gaps,
                         rows => Rows}),
            restart;
        [] -> %% No gaps, good
            ok;
        Gaps ->
            handle_gaps(Gaps, Now)
    end.

rows_to_ids(Rows) ->
    [element(1, Row) || Row <- Rows].

find_gaps(Ids, MaxGaps) ->
    find_gaps(Ids, [], MaxGaps).

find_gaps(_, _Missing, _MaxGaps = 0) ->
    too_many_gaps;
find_gaps([H|T], Missing, MaxGaps) ->
    Expected = H + 1,
    case T of
        [Expected|_] ->
            find_gaps(T, Missing, MaxGaps);
        [_|_] ->
            find_gaps([Expected|T], [Expected|Missing], MaxGaps - 1);
        [] ->
             Missing
     end;
find_gaps([], Missing, _MaxGaps) ->
     Missing.

handle_gaps(Gaps, Now) ->
    remember_gaps(Gaps, Now),
    MaxTimeToWait = max_time_to_wait(), %% seconds
    case [Gap || Gap <- Gaps, not is_expired_gap(Gap, Now, MaxTimeToWait)] of
        [] ->
            ok; %% Skip any gaps checking
        [_|_] = WaitingGaps ->
            ?LOG_WARNING(#{what => wait_for_gaps,
                           gaps => format_gaps(WaitingGaps)}),
            wait
    end.

format_gaps(Gaps) ->
    iolist_to_binary(io_lib:format("~w", [Gaps])).

remember_gaps(Gaps, Now) ->
    [ets:insert_new(?TABLE, {Gap, Now}) || Gap <- Gaps],
    ok.

is_expired_gap(Gap, Now, MaxTimeToWait) ->
    case ets:lookup(?TABLE, Gap) of
        [] ->
            ?LOG_WARNING(#{what => gap_not_found, gap => Gap}),
            true;
        [{Gap, Inserted}] ->
            (Now - Inserted) > MaxTimeToWait
    end.

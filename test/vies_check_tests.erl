-module(vies_check_tests).

-include_lib("eunit/include/eunit.hrl").

run_test_() ->
    {foreach, 
     fun setup/0,
     fun teardown/1,
     [fun request_raw/1,
      fun request_proplist/1,
      fun request_json/1]}.

request_raw(_) ->
    Result = vies_check:request("GB", "12345678", raw),
    ?_assert(Result).

request_proplist(_) ->
    Result = vies_check:request("GB", "12345678", proplist),
    ?_assertEqual(Result, [{country_code, <<"GB">>},
			   {vat_number, <<"12345678">>},
			   {valid, <<"false">>},
			   {name, <<"---">>},
			   {address, <<"---">>}]).

request_json(_) ->
    Result = vies_check:request("GB", "12345678", json),
    io:format("~p~n", [Result]),
    ?_assertEqual(Result, jsx:encode([{country_code, <<"GB">>},
				 {vat_number, <<"12345678">>},
				 {valid, <<"false">>},
				 {name, <<"---">>},
				 {address, <<"---">>}])).

setup() ->
    application:start(inets).

teardown(_) ->
    application:stop(inets).

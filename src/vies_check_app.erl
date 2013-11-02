-module(vies_check_app).

-behaviour(application).

-export([start/2,
	 stop/1]).

-define(APPS, [ranch, crypto, cowboy, inets]).

start(_StartType, _StartArgs) ->
    [application:start(App) || App <- ?APPS],
    vies_check_sup:start_link().

stop(_State) ->
    ok.

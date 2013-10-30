PROJECT = vies_check

DEPS = erlydtl jsx
dep_erlydtl = https://github.com/evanmiller/erlydtl.git
dep_jsx = https://github.com/talentdeficit/jsx.git

include erlang.mk

shell: app
	erl -pa ebin -pa deps/*/ebin

test: app
	rebar eunit

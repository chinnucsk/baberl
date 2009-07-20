#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./ebin -sasl errlog_type error -boot start_sasl

main(_) ->
    etap:plan(6),
    etap:is(application:start(baberl), ok, "Start baberl app"),
    etap:is(baberl:convert("", "UTF-8", <<"foo">>), {ok, <<"foo">>}, "Convert a default-encoded string"),
    etap:is(baberl:convert("UTF-8", "ISO-8859-1", <<"foo">>), {ok, <<"foo">>}, "Convert a UTF-8 encoded string"),
    etap:is(baberl:convert("UTF-8", "ASCII", <<"foo">>), {ok, <<"foo">>}, "Simple conversion works"),
    etap:is(baberl:convert("UTF-8", "ASCII//translit//IGNORE", <<"foo">>), {ok, <<"foo">>}, "Complex conversion works"),
    etap:ok(true =:= check_return(baberl:convert("UTF-8", "ASCII//translit//IGNORE", unicode:characters_to_binary("fooÔ"))), "Transliteration works"),
    etap:end_tests().

check_return({ok, <<"foo~A">>}) ->
    true;
check_return(Other) ->
    false.

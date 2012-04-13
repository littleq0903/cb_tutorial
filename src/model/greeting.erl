-module(greeting, [Id, GreetingText]).
-compile(export_all).


after_create() ->
    boss_mq:push("new-greetings", THIS).


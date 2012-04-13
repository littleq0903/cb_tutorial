-module(cb_tutorial_greeting_controller, [Req]).
-compile(export_all).

hello('GET', []) -> 
    {ok, [{greeting, "Hello, world!"},
            {greeting2, "Hello2"}]}.


list('GET', []) ->
    {ok, [{greetings, boss_db:find(greeting, [])}]}.


create('GET', []) -> 
    ok;
create('POST', []) ->
    NewGreeting = greeting:new(id, Req:post_param("greeting_text")),
    NewGreeting:save(),
    {redirect, [{action, "list"}]}.


send_test_message('GET', []) ->
    TestMessage = "Free~~~~~!", 
    boss_mq:push("test-channel", TestMessage),
    {output, TestMessage}.



pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Greetings} = boss_mq:pull("new-greetings", list_to_integer(LastTimestamp)),
    {json, [ {timestamp, Timestamp} , {greetings, Greetings} ]}.

live('GET', []) ->
    Greetings = boss_db:find(greeting, []),
    Timestamp = boss_mq:now("new-greetings"),
    {ok, [ {greetings, Greetings} , {timestamp, Timestamp} ] }.

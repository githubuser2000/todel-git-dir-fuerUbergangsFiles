:- use_module(library(process)).
:- use_module(library(lists)).
:- use_module(library(date)).
:- use_module(library(readutil)).

log_file('/home/dein_user/clipboard.log').
interval(2). % Sekunden

% --- Hash Funktion: einfache Summierung der Codes
hash_string(String, Hash) :-
    string_codes(String, Codes),
    sum_list(Codes, Hash).

% --- Clipboard auslesen
get_clipboard(Content) :-
    process_create(path(wl-paste), ['-n'], [stdout(pipe(Out))]),
    read_string(Out, _, ContentRaw),
    string_trim(ContentRaw, Content).

string_trim(Str, Trimmed) :-
    string_codes(Str, Codes),
    exclude(is_newline, Codes, TrimmedCodes),
    string_codes(Trimmed, TrimmedCodes).

is_newline(10). % '\n'
is_newline(13). % '\r'

% --- Clipboard loggen
log_clipboard(Content) :-
    get_time(TS),
    stamp_date_time(TS, DateTime, local),
    format_time(atom(TSString), '%Y-%m-%d %H:%M:%S', DateTime),
    log_file(File),
    open(File, append, Stream),
    format(Stream, "[~w]~n", [TSString]),
    format(Stream, "~w~n~n", [Content]),
    close(Stream).

% --- Hauptloop
clipboard_loop(LastHash) :-
    get_clipboard(Content),
    (Content \= "" ->
        hash_string(Content, CurrentHash),
        (CurrentHash \= LastHash ->
            log_clipboard(Content),
            sub_string(Content, 0, 30, _, Preview),
            format("Neuer Clipboard-Inhalt geloggt: ~w...~n", [Preview]),
            true
        ; true),
        sleep(interval(_)),
        clipboard_loop(CurrentHash)
    ; sleep(interval(_)),
      clipboard_loop(LastHash)
    ).

% --- Start
start :-
    clipboard_loop(0).


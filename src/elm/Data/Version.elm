module Data.Version exposing (fromDateString, getRecord)


type Version
    = V0_19_1
    | V0_19
    | V0_18
    | V0_17
    | V0_16
    | V0_15_1
    | V0_15
    | V0_14_1
    | V0_14
    | V0_13
    | V0_12_3
    | V0_12_1
    | V0_12
    | V0_11
    | V0_10_1
    | V0_10
    | V0_9
    | V0_8
    | V0_7_1
    | V0_7
    | V0_6
    | V0_5
    | V0_4
    | V0_3_6
    | V0_3_5
    | V0_3
    | V0_1


fromDateString : String -> Maybe Version
fromDateString date =
    if date >= "2019-10-21" then
        Just V0_19_1

    else if date >= "2018-08-21" then
        Just V0_19

    else if date >= "2016-11-14" then
        Just V0_18

    else if date >= "2016-05-10" then
        Just V0_17

    else if date >= "2015-11-19" then
        Just V0_16

    else if date >= "2015-06-30" then
        Just V0_15_1

    else if date >= "2015-04-20" then
        Just V0_15

    else if date >= "2015-01-10" then
        Just V0_14_1

    else if date >= "2014-12-10" then
        Just V0_14

    else if date >= "2014-09-25" then
        Just V0_13

    else if date >= "2014-05-20" then
        Just V0_12_3

    else if date >= "2014-05-01" then
        Just V0_12_1

    else if date >= "2014-03-24" then
        Just V0_12

    else if date >= "2014-01-21" then
        Just V0_11

    else if date >= "2013-12-30" then
        Just V0_10_1

    else if date >= "2013-10-24" then
        Just V0_10

    else if date >= "2013-08-13" then
        Just V0_9

    else if date >= "2013-05-29" then
        Just V0_8

    else if date >= "2013-01-25" then
        Just V0_7_1

    else if date >= "2013-01-04" then
        Just V0_7

    else if date >= "2012-12-08" then
        Just V0_6

    else if date >= "2012-10-25" then
        Just V0_5

    else if date >= "2012-09-28" then
        Just V0_4

    else if date >= "2012-08-16" then
        Just V0_3_6

    else if date >= "2012-06-29" then
        Just V0_3_5

    else if date >= "2012-06-19" then
        Just V0_3

    else if date >= "2012-03-30" then
        Just V0_1

    else
        Nothing


getRecord : Version -> { version : String, released_at : String, topic : String, url : String }
getRecord version =
    case version of
        V0_19_1 ->
            { version = "0.19.1"
            , released_at = "2019-10-21"
            , topic = "Friendly syntax hints, faster builds"
            , url = "https://elm-lang.org/news/the-syntax-cliff"
            }

        V0_19 ->
            { version = "0.19"
            , released_at = "2018-08-21"
            , topic = "Smaller assets, faster builds"
            , url = "https://elm-lang.org/news/small-assets-without-the-headache"
            }

        V0_18 ->
            { version = "0.18"
            , released_at = "2016-11-14"
            , topic = "New debugger with import/export"
            , url = "https://elm-lang.org/news/the-perfect-bug-report"
            }

        V0_17 ->
            { version = "0.17"
            , released_at = "2016-05-10"
            , topic = "Add subscriptions, remove signals"
            , url = "https://elm-lang.org/news/farewell-to-frp"
            }

        V0_16 ->
            { version = "0.16"
            , released_at = "2015-11-19"
            , topic = "Even better error messages!"
            , url = "https://elm-lang.org/news/compilers-as-assistants"
            }

        V0_15_1 ->
            { version = "0.15.1"
            , released_at = "2015-06-30"
            , topic = "Dramatically improved error messages"
            , url = "https://elm-lang.org/news/compiler-errors-for-humans"
            }

        V0_15 ->
            { version = "0.15"
            , released_at = "2015-04-20"
            , topic = "Tasks, better HTTP library"
            , url = "https://elm-lang.org/news/0.15"
            }

        V0_14_1 ->
            { version = "0.14.1"
            , released_at = "2015-01-10"
            , topic = "HTML through main"
            , url = "https://groups.google.com/forum/#!topic/elm-announce/6zRwjN68Ap0"
            }

        V0_14 ->
            { version = "0.14"
            , released_at = "2014-12-10"
            , topic = "Package manager, parallel builds, JSON"
            , url = "https://elm-lang.org/news/0.14"
            }

        V0_13 ->
            { version = "0.13"
            , released_at = "2014-09-25"
            , topic = "Debugging with elm-reactor"
            , url = "https://elm-lang.org/news/0.13"
            }

        V0_12_3 ->
            { version = "0.12.3"
            , released_at = "2014-05-20"
            , topic = "3D rendering with WebGL"
            , url = "https://elm-lang.org/news/0.12.3"
            }

        V0_12_1 ->
            { version = "0.12.1"
            , released_at = "2014-05-01"
            , topic = "Fast Immutable Arrays"
            , url = "https://elm-lang.org/news/0.12.1"
            }

        V0_12 ->
            { version = "0.12"
            , released_at = "2014-03-24"
            , topic = "Interactive UI Elements"
            , url = "https://elm-lang.org/news/0.12"
            }

        V0_11 ->
            { version = "0.11"
            , released_at = "2014-01-21"
            , topic = "Drastically improved FFI with ports"
            , url = "https://elm-lang.org/news/0.11"
            }

        V0_10_1 ->
            { version = "0.10.1"
            , released_at = "2013-12-30"
            , topic = "Package manager integration"
            , url = "https://elm-lang.org/news/0.10.1"
            }

        V0_10 ->
            { version = "0.10"
            , released_at = "2013-10-24"
            , topic = "Strings, Colors, Operators"
            , url = "https://elm-lang.org/news/0.10"
            }

        V0_9 ->
            { version = "0.9"
            , released_at = "2013-08-13"
            , topic = "Fast and reliable type inference"
            , url = "https://elm-lang.org/news/0.9"
            }

        V0_8 ->
            { version = "0.8"
            , released_at = "2013-05-29"
            , topic = "HTML/JS integration"
            , url = "https://elm-lang.org/news/0.8"
            }

        V0_7_1 ->
            { version = "0.7.1"
            , released_at = "2013-01-25"
            , topic = "Libraries for touch, either, and keyboard"
            , url = "https://elm-lang.org/news/0.7.1"
            }

        V0_7 ->
            { version = "0.7"
            , released_at = "2013-01-04"
            , topic = "Extensible records"
            , url = "https://elm-lang.org/news/0.7"
            }

        V0_6 ->
            { version = "0.6"
            , released_at = "2012-12-08"
            , topic = "Whitespace sensitivity"
            , url = "https://elm-lang.org/news/0.6"
            }

        V0_5 ->
            { version = "0.5"
            , released_at = "2012-10-25"
            , topic = "Libraries for dictionaries, sets, and automata"
            , url = "https://elm-lang.org/news/0.5"
            }

        V0_4 ->
            { version = "0.4"
            , released_at = "2012-09-28"
            , topic = "Markdown"
            , url = "https://elm-lang.org/news/0.4"
            }

        V0_3_6 ->
            { version = "0.3.6"
            , released_at = "2012-08-16"
            , topic = "JSON support"
            , url = "https://web.archive.org/web/20130810052854/http://www.testblogpleaseignore.com/2012/08/16/elm-0-3-6json-support-and-better-error-messages/"
            }

        V0_3_5 ->
            { version = "0.3.5"
            , released_at = "2012-06-29"
            , topic = "JavaScript FFI"
            , url = "https://web.archive.org/web/20131010072233/http://www.testblogpleaseignore.com/2012/06/29/announcing-elm-0-3-5-javascript-integration-signal-filters-and-more/"
            }

        V0_3 ->
            { version = "0.3"
            , released_at = "2012-06-19"
            , topic = "Modules"
            , url = "https://web.archive.org/web/20131010015034/http://www.testblogpleaseignore.com/2012/06/19/announcing-elm-0-3-modules/"
            }

        V0_1 ->
            { version = "0.1"
            , released_at = "2012-03-30"
            , topic = "Initial Release"
            , url = "https://www.reddit.com/r/haskell/comments/rkyoa/my_thesis_is_finally_complete_elm_concurrent_frp/"
            }

module Data.Tag exposing (fromString, toString)

import String.Extra as String
import String.Normalize as Normalize
import Url


type alias Tag =
    { label : String
    , value : String
    }


type alias TagValue =
    String


tags : List Tag
tags =
    List.map (\l -> { label = l, value = Normalize.slug l })
        [ "Custom Types"
        , "Dev Environment"
        , "elm reactor"
        , "Functional Programming"
        , "Hello World"
        , "Opaque Type"
        , "Phantom Type"
        , "Single Page Application"
        , "Static Site Generator"
        , "The Elm Architecture"
        , "To-Do List App"
        , "Type Aliases"
        ]


fromString : String -> TagValue
fromString s =
    case find (.label >> (==) s) tags of
        Just tag ->
            tag.value

        _ ->
            if String.any ((==) '/') s then
                Url.percentEncode s

            else if (String.toLower s |> String.toSentenceCase) == s then
                String.toLower s

            else
                Url.percentEncode s


toString : TagValue -> String
toString s =
    case find (.value >> (==) s) tags of
        Just tag ->
            tag.label

        _ ->
            if String.contains "%2F" s then
                Url.percentDecode s |> Maybe.withDefault s

            else if (String.toSentenceCase s |> String.toLower) == s then
                String.toSentenceCase s

            else
                Url.percentDecode s |> Maybe.withDefault s


find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first

            else
                find predicate rest

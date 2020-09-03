module Data.Article exposing (Article, articleDecoder)

import Json.Decode as Decode exposing (Decoder, string)


type alias Article =
    { title : String
    , author : String
    , siteName : String
    , url : String
    , language : String
    , tags : List String
    , created_at : String
    }


articleDecoder : Decoder Article
articleDecoder =
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "siteName" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.succeed "")

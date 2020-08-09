module Data.Article.Qiita exposing (articleDecoder)

import Data.Article exposing (Article)
import Json.Decode as Decode exposing (Decoder, string)


articleDecoder : Decoder Article
articleDecoder =
    Decode.map6 Article
        (Decode.field "title" Decode.string)
        (Decode.at [ "user", "id" ] Decode.string)
        (Decode.succeed "Qiita")
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))

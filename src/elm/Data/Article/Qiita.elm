module Data.Article.Qiita exposing (articleDecoder)

import Data.Article exposing (Article)
import Json.Decode as Decode exposing (Decoder, string)


articleDecoder : Decoder Article
articleDecoder =
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.at [ "user", "id" ] Decode.string)
        (Decode.succeed "Qiita")
        (Decode.field "url" Decode.string)
        (Decode.succeed "ja")
        (Decode.succeed "-")
        (Decode.field "tags" (Decode.list (Decode.field "name" Decode.string)))

module Data.Article exposing (Article, articleDecoder, qiitaDecoder, zennDecoder)

import Json.Decode as Decode exposing (Decoder, string)
import Url.Builder exposing (crossOrigin)


type alias Article =
    { title : String
    , author : String
    , siteName : String
    , url : String
    , language : String
    , tags : List String
    , createdAt : String
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


qiitaDecoder : Decoder Article
qiitaDecoder =
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.at [ "user", "id" ] Decode.string)
        (Decode.succeed "Qiita")
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "created_at" Decode.string)


zennDecoder : Decoder Article
zennDecoder =
    let
        urlDecoder =
            Decode.map2 (\username slug -> crossOrigin "https://zenn.dev" [ username, "articles", slug ] [])
                (Decode.at [ "user", "username" ] Decode.string)
                (Decode.field "slug" Decode.string)
    in
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.at [ "user", "name" ] Decode.string)
        (Decode.succeed "Zenn")
        urlDecoder
        (Decode.succeed "ja")
        (Decode.succeed [])
        (Decode.field "createdAt" Decode.string)

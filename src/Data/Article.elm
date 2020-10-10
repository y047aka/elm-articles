module Data.Article exposing (Article, articleDecoder, qiitaDecoder, zennDecoder)

import Json.Decode as Decode exposing (Decoder, string, succeed)
import Url.Builder exposing (crossOrigin)


type alias Article =
    { title : String
    , author : Author
    , siteName : String
    , url : String
    , language : String
    , tags : List String
    , createdAt : String
    }


type alias Author =
    { name : String
    , image : Maybe String
    }


articleDecoder : Decoder Article
articleDecoder =
    let
        authorDecoder =
            Decode.map2 Author
                (Decode.field "author" Decode.string)
                (succeed Nothing)
    in
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        authorDecoder
        (Decode.field "siteName" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.succeed "")


qiitaDecoder : Decoder Article
qiitaDecoder =
    let
        authorDecoder =
            Decode.map2 Author
                (Decode.at [ "user", "id" ] Decode.string)
                (Decode.maybe <| Decode.at [ "user", "profile_image_url" ] Decode.string)
    in
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        authorDecoder
        (Decode.succeed "Qiita")
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "created_at" Decode.string)


zennDecoder : Decoder Article
zennDecoder =
    let
        authorDecoder =
            Decode.map2 Author
                (Decode.at [ "user", "name" ] Decode.string)
                (Decode.maybe <| Decode.at [ "user", "avatarUrl" ] Decode.string)

        urlDecoder =
            Decode.map2 (\username slug -> crossOrigin "https://zenn.dev" [ username, "articles", slug ] [])
                (Decode.at [ "user", "username" ] Decode.string)
                (Decode.field "slug" Decode.string)
    in
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        authorDecoder
        (Decode.succeed "Zenn")
        urlDecoder
        (Decode.succeed "ja")
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "createdAt" Decode.string)

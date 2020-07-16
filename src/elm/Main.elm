module Main exposing (main)

import Browser exposing (Document)
import Html exposing (Html, a, h1, i, main_, section, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, rel, target)
import Http
import Json.Decode as Decode exposing (Decoder, string)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { articles : List Article }


type alias Article =
    { title : String
    , author : String
    , siteName : String
    , url : String
    , language : String
    , targetVersion : String
    , tags : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = [] }
    , Http.get
        { url = "articles.json"
        , expect = Http.expectJson Loaded (Decode.list articleDecoder)
        }
    )


articleDecoder : Decoder Article
articleDecoder =
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "siteName" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "targetVersion" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))



-- UPDATE


type Msg
    = Loaded (Result Http.Error (List Article))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        Loaded (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Elm Articles"
    , body =
        [ main_ [ class "ui container" ]
            [ section [ class "ui vertical stripe segment" ]
                [ h1 [] [ text "Elm Articles" ]
                , table [ class "ui table" ]
                    [ thead []
                        [ tr []
                            [ th [] [ text "Target" ]
                            , th [] [ text "Language" ]
                            , th [] [ text "Title" ]
                            , th [] [ text "Website" ]
                            , th [] [ text "Tags" ]
                            ]
                        ]
                    , tbody [] (List.map tableRow model.articles)
                    ]
                ]
            ]
        ]
    }


tableRow : Article -> Html msg
tableRow article =
    tr []
        [ td [] [ text article.targetVersion ]
        , td [] [ text (languageToString article.language) ]
        , td [] [ text article.title ]
        , td []
            [ a [ href article.url, target "_blank", rel "noopener" ]
                [ text article.siteName
                , text " "
                , i [ class "external alternate icon" ] []
                ]
            ]
        , td [] [ text (article.tags |> String.join ", ") ]
        ]


languageToString : String -> String
languageToString language =
    case language of
        "en" ->
            "English"

        "ja" ->
            "日本語"

        _ ->
            ""

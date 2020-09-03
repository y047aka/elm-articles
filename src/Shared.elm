module Shared exposing (Flags, Model, Msg, init, subscriptions, update, view)

import Browser.Navigation exposing (Key)
import Data.Article exposing (Article)
import Data.Language exposing (Language(..), languageToString)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , guideArticles : List Article
    , qiitaArticles : List Article
    , selectedLanguages : Language
    , selectedTag : Maybe String
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { url = url
      , key = key
      , guideArticles = []
      , qiitaArticles = []
      , selectedLanguages = All
      , selectedTag = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetLanguage Language


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLanguage l ->
            ( { model | selectedLanguages = l }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    { title = page.title
    , body =
        [ Html.map toMsg <| siteHeader model
        , main_ [ class "ui main container" ] page.body
        , Html.map toMsg <| siteFooter
        ]
    }


siteHeader : Model -> Html Msg
siteHeader { selectedLanguages } =
    header [ class "ui fixed inverted menu" ]
        [ div [ class "ui container" ]
            [ a [ class "header item", href (Route.toString Route.Top) ] [ text "elm-articles" ]
            , div [ class "right menu" ]
                [ div [ class "ui simple dropdown item" ]
                    [ text ("Language: " ++ languageToString selectedLanguages)
                    , i [ class "dropdown icon" ] []
                    , div [ class "menu" ] <|
                        List.map (\l -> div [ class "item", onClick (SetLanguage l) ] [ text (languageToString l) ])
                            [ All, English, Japanese ]
                    ]
                ]
            ]
        ]


siteFooter : Html Msg
siteFooter =
    let
        column { parent, children } =
            div [ class "three wide column" ]
                [ h1
                    [ class "ui small inverted header"

                    -- , onClick (SelectTag parent)
                    ]
                    [ text (wordToJapanese parent) ]
                , div [ class "ui inverted link list" ] <|
                    List.map
                        (\t ->
                            div
                                [ class "item"

                                -- , onClick (SelectTag t)
                                ]
                                [ text (wordToJapanese t) ]
                        )
                        children
                ]
    in
    footer [ class "ui inverted vertical footer segment" ]
        [ div [ class "ui center aligned container" ]
            [ div [ class "ui inverted divided grid" ] <|
                List.map column
                    [ { parent = "Types", children = [ "Type Aliases", "Custom Types", "Maybe", "Result" ] }
                    , { parent = "Core", children = [ "HTTP", "JSON", "Random", "Time", "Task" ] }
                    , { parent = "Test", children = [ "TDD", "elm-test", "elm-verify-examples" ] }
                    , { parent = "Dev Environment", children = [ "Ellie", "elm reactor", "Parcel", "webpack", "VSCode" ] }
                    ]
                    ++ [ div [ class "four wide column" ]
                            [ h1 [ class "ui small inverted header" ] [ text "elm-articles" ]
                            , p [] [ text "© 2020 y047aka" ]
                            ]
                       ]
            ]
        ]


wordToJapanese : String -> String
wordToJapanese englishWord =
    case englishWord of
        "Algorithm" ->
            "アルゴリズム"

        "Custom Types" ->
            "カスタム型"

        "Dev Environment" ->
            "開発環境"

        "Environment Setup" ->
            "環境構築"

        "Examples" ->
            "作例"

        "Functional Programming" ->
            "関数型プログラミング"

        "Modules" ->
            "モジュール"

        "Pattern Matching" ->
            "パターンマッチ"

        "Personal Log" ->
            "私的記録"

        "Poème" ->
            "ポエム"

        "Static Site Generator" ->
            "静的サイトジェネレーター"

        "Study Log" ->
            "学習記録"

        "Test" ->
            "テスト"

        "To-Do List App" ->
            "ToDoリスト"

        "Types" ->
            "型"

        "Type Aliases" ->
            "型エイリアス"

        _ ->
            englishWord

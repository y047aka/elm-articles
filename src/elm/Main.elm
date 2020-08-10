module Main exposing (main)

import AssocList
import AssocList.Extra
import Browser exposing (Document)
import Data.Article exposing (Article)
import Data.Article.Qiita exposing (articleDecoder)
import Data.Language exposing (Language(..), isSelectedLanguage, languageToString)
import Data.Version as Version
import Html exposing (Html, a, button, div, footer, h1, header, i, main_, p, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, colspan, href, rel, target)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode


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
    { articles : List Article
    , selectedLanguages : Language
    , selectedTag : Maybe String
    }


tagCloud : List (List String)
tagCloud =
    [ [ "The Elm Architecture", "Types", "Type Aliases", "Custom Types", "Maybe", "Result", "HTTP", "JSON", "Random", "Time", "Task" ]
    , [ "Opaque Type", "Phantom Type", "パターンマッチ", "ports", "副作用" ]
    , [ "Test", "TDD", "elm-test", "elm-verify-examples" ]
    , [ "SVG", "GraphQL", "Static Site Generator" ]
    , [ "mdgriffith/elm-ui", "arowM/elm-form-decoder", "arowM/elm-neat-layout" ]
    , [ "CLI" ]
    , [ "VirtualDom", "SPA", "WebComponents", "PWA", "Firebase", "form" ]
    , [ "HTML", "CSS", "JavaScript", "TypeScript" ]
    , [ "関数型プログラミング", "Node.js" ]
    , [ "Dev Environment", "Ellie", "elm reactor", "elm-format", "elm-analyse", "create-elm-app", "elm-live", "Parcel", "webpack", "VSCode", "Docker", "Windows" ]
    , [ "アルゴリズム", "木構造", "初心者" ]
    , [ "Hello World", "FizzBuzz", "To-Do List App" ]
    , [ "Examples", "Poème", "Study Log", "Personal Log" ]
    ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = []
      , selectedLanguages = All
      , selectedTag = Nothing
      }
    , Http.get
        { url = "articles_qiita.json"
        , expect = Http.expectJson Loaded (Decode.list articleDecoder)
        }
    )



-- UPDATE


type Msg
    = Loaded (Result Http.Error (List Article))
    | SetLanguage Language
    | SelectTag String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        Loaded (Err _) ->
            ( model, Cmd.none )

        SetLanguage l ->
            ( { model | selectedLanguages = l }, Cmd.none )

        SelectTag tag ->
            ( { model | selectedTag = Just tag }, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    let
        filteredArticles =
            model.articles
                |> List.filter
                    (\article ->
                        List.all identity
                            [ isSelectedLanguage model.selectedLanguages article.language
                            , model.selectedTag
                                |> Maybe.map (\tag -> List.member tag article.tags)
                                |> Maybe.withDefault True
                            ]
                    )

        articlesByVersion =
            filteredArticles
                |> AssocList.Extra.filterGroupBy (.created_at >> Version.fromDateString >> Maybe.map Version.getRecord)
                |> AssocList.toList
    in
    { title = "elm-articles"
    , body =
        [ siteHeader model
        , main_ [ class "ui main container" ]
            [ div [ class "ui form" ]
                [ div [ class "grouped fields" ] <|
                    List.map
                        (\tag ->
                            button
                                [ class "ui tiny button"
                                , onClick (SelectTag tag)
                                ]
                                [ text (wordToJapanese tag) ]
                        )
                        (List.concat tagCloud)
                ]
            , div [] <| List.map (\( v, a ) -> tableFor v a) articlesByVersion
            ]
        , siteFooter
        ]
    }


siteHeader : Model -> Html Msg
siteHeader { selectedLanguages } =
    header [ class "ui fixed inverted menu" ]
        [ div [ class "ui container" ]
            [ a [ class "header item" ] [ text "elm-articles" ]
            , div [ class "right menu" ]
                [ a [ class "ui simple dropdown item" ]
                    [ text ("Language: " ++ languageToString selectedLanguages)
                    , i [ class "dropdown icon" ] []
                    , div [ class "menu" ] <|
                        List.map (\l -> div [ class "item", onClick (SetLanguage l) ] [ text (languageToString l) ])
                            [ All, English, Japanese ]
                    ]
                ]
            ]
        ]


tableFor : { version : String, released_at : String, topic : String, url : String } -> List Article -> Html Msg
tableFor { version, topic, url } articles =
    table [ class "ui selectable table" ]
        [ thead []
            [ tr []
                [ th [ colspan 3 ]
                    [ a
                        [ href url, target "_blank", rel "noopener" ]
                        [ text (version ++ " - " ++ topic ++ " ")
                        , i [ class "external alternate small icon" ] []
                        ]
                    ]
                ]
            ]
        , tbody [] (List.map tableRow articles)
        ]


tableRow : Article -> Html Msg
tableRow article =
    tr []
        [ td [ class "ten wide" ]
            [ div []
                [ a
                    [ href article.url
                    , target "_blank"
                    , rel "noopener"
                    ]
                    [ text (article.title ++ " "), i [ class "external alternate small icon" ] [] ]
                ]
            , span [ class "ui small grey text" ] [ text (article.author ++ " | " ++ article.siteName) ]
            ]
        , td [ class "six wide" ] <|
            List.map
                (\tag -> span [ class "ui tiny button", onClick (SelectTag tag) ] [ text (wordToJapanese tag) ])
                article.tags
        ]


siteFooter : Html Msg
siteFooter =
    let
        column { parent, children } =
            div [ class "three wide column" ]
                [ h1 [ class "ui small inverted header", onClick (SelectTag parent) ]
                    [ text (wordToJapanese parent) ]
                , div [ class "ui inverted link list" ] <|
                    List.map (\t -> a [ class "item", onClick (SelectTag t) ] [ text (wordToJapanese t) ]) children
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



-- String Converter


wordToJapanese : String -> String
wordToJapanese englishWord =
    case englishWord of
        "Custom Types" ->
            "カスタム型"

        "Dev Environment" ->
            "開発環境"

        "Environment Setup" ->
            "環境構築"

        "Examples" ->
            "作例"

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

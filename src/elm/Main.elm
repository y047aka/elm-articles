module Main exposing (main)

import Browser exposing (Document)
import Data.Article exposing (Article)
import Data.Article.Qiita exposing (articleDecoder)
import Html exposing (Html, a, button, div, h1, header, i, input, label, main_, section, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (checked, class, for, href, id, rel, target, type_, value)
import Html.Events exposing (onCheck, onClick)
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
    , selectedLanguages : List String
    , selectedTag : Maybe String
    , selectedVersions : List String
    }


tagCloud : List (List String)
tagCloud =
    [ [ "Ellie", "The Elm Architecture", "Types", "Type Aliases", "Custom Types", "Maybe", "Result", "HTTP", "JSON", "Random", "Time", "Task" ]
    , [ "Opaque Type", "Phantom Type", "パターンマッチ", "ports", "副作用" ]
    , [ "Test", "Doctest", "TDD", "elm-test", "elm-verify-examples" ]
    , [ "SVG", "GraphQL", "Static Site Generator" ]
    , [ "mdgriffith/elm-ui", "arowM/elm-form-decoder", "arowM/elm-neat-layout" ]
    , [ "CLI" ]
    , [ "VirtualDom", "SPA", "WebComponents", "PWA", "Firebase", "form" ]
    , [ "HTML", "CSS", "JavaScript", "TypeScript" ]
    , [ "関数型プログラミング", "Node.js" ]
    , [ "Dev Environment", "elm reactor", "elm-format", "elm-analyse", "create-elm-app", "elm-live", "Parcel", "webpack", "VSCode", "Docker", "Windows" ]
    , [ "アルゴリズム", "木構造", "初心者" ]
    , [ "Hello World", "FizzBuzz", "To-Do List App" ]
    , [ "Examples", "Poème", "Study Log", "Personal Log" ]
    ]


languages : List { id : String, value : String, label : String }
languages =
    [ { id = "en", value = "en", label = languageToString "en" }
    , { id = "ja", value = "ja", label = languageToString "ja" }
    ]


versions : List { id : String, value : String, label : String }
versions =
    [ { id = "^0.19.0", value = "^0.19.0", label = "0.19.0" }
    , { id = "none", value = "-", label = "-" }
    ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = []
      , selectedLanguages = List.map .value languages
      , selectedTag = Nothing
      , selectedVersions = List.map .value versions
      }
    , Http.get
        { url = "articles_qiita.json"
        , expect = Http.expectJson Loaded (Decode.list articleDecoder)
        }
    )



-- UPDATE


type Msg
    = Loaded (Result Http.Error (List Article))
    | SetLanguages (List String)
    | SelectTag String
    | SelectVersions String Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        Loaded (Err _) ->
            ( model, Cmd.none )

        SetLanguages languages_ ->
            ( { model | selectedLanguages = languages_ }, Cmd.none )

        SelectTag tag ->
            ( { model | selectedTag = Just tag }, Cmd.none )

        SelectVersions l isChecked ->
            ( { model
                | selectedVersions =
                    if isChecked then
                        l :: model.selectedVersions

                    else
                        List.filter ((/=) l) model.selectedVersions
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Document Msg
view model =
    let
        filteredArticles =
            model.articles
                |> List.filter
                    (\article ->
                        List.all identity
                            [ List.member article.language model.selectedLanguages
                            , List.member article.targetVersion model.selectedVersions
                            , model.selectedTag
                                |> Maybe.map (\tag -> List.member tag article.tags)
                                |> Maybe.withDefault True
                            ]
                    )

        listItem msg options opt =
            div [ class "field" ]
                [ div [ class "ui checkbox" ]
                    [ input
                        [ id opt.id
                        , type_ "checkbox"
                        , value opt.value
                        , checked (List.member opt.value options)
                        , onCheck (msg opt.value)
                        ]
                        []
                    , label [ for opt.id ] [ span [ class "ui text" ] [ text opt.label ] ]
                    ]
                ]
    in
    { title = "elm-articles"
    , body =
        [ siteHeader
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
                , div [ class "inline fields" ] <|
                    label [] [ text "Target Versions" ]
                        :: List.map (listItem SelectVersions model.selectedVersions) versions
                ]
            , table [ class "ui selectable table" ]
                [ thead []
                    [ tr []
                        [ th [] [ text "Target" ]
                        , th [] [ text "Tags" ]
                        , th [] [ text "Title /  Author /  Site Name" ]
                        ]
                    ]
                , tbody [] (List.map tableRow filteredArticles)
                ]
            ]
        ]
    }


siteHeader : Html Msg
siteHeader =
    header [ class "ui fixed inverted menu" ]
        [ div [ class "ui container" ]
            [ a [ class "header item" ] [ text "elm-articles" ]
            , div [ class "right menu" ]
                [ a [ class "ui simple dropdown item" ]
                    [ text "Language"
                    , i [ class "dropdown icon" ] []
                    , div [ class "menu" ] <|
                        List.map (\opt -> div [ class "item", onClick opt.msg ] [ text opt.label ])
                            [ { label = "全て", msg = SetLanguages [ "en", "ja" ] }
                            , { label = "English", msg = SetLanguages [ "en" ] }
                            , { label = "日本語", msg = SetLanguages [ "ja" ] }
                            ]
                    ]
                ]
            ]
        ]


tableRow : Article -> Html Msg
tableRow article =
    tr []
        [ td [] [ text article.targetVersion ]
        , td [] <|
            List.map
                (\tag -> span [ class "ui tiny button", onClick (SelectTag tag) ] [ text (wordToJapanese tag) ])
                article.tags
        , td []
            [ div []
                [ a
                    [ href article.url
                    , target "_blank"
                    , rel "noopener"
                    ]
                    [ text article.title ]
                ]
            , span [ class "ui small grey text" ] [ text (article.author ++ " | " ++ article.siteName) ]
            ]
        ]



-- String Converter


languageToString : String -> String
languageToString language =
    case language of
        "en" ->
            "English"

        "ja" ->
            "日本語"

        _ ->
            ""


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

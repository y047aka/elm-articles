module Main exposing (main)

import Browser exposing (Document)
import Data.Article exposing (Article)
import Data.Article.Qiita exposing (articleDecoder)
import Html exposing (Html, a, button, div, h1, i, input, label, main_, section, span, table, tbody, td, text, th, thead, tr)
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
    [ [ "The Elm Architecture", "Custom Types", "Maybe", "Result", "HTTP", "JSON", "Random", "Task" ]
    , [ "型", "OpaqueType", "パターンマッチ", "ports", "副作用" ]
    , [ "Test", "TDD" ]
    , [ "GraphQL" ]
    , [ "elm-format", "elm-test" ]
    , [ "mdgriffith/elm-ui", "arowM/elm-neat-layout" ]
    , [ "Functional Reactive Programming" ]
    , [ "VirtualDom", "SPA", "WebComponents", "PWA", "REST-API", "doctest", "cli", "Firebase", "静的サイトジェネレーター", "form", "バリデーション", "SVG" ]
    , [ "Markdown", "HTML", "CSS", "JavaScript", "TypeScript", "React", "redux", "Vue.js", "hyperapp", "Svelte", "Swift", "Java", "PHP" ]
    , [ "関数型プログラミング", "関数型言語", "Haskell", "purescript", "Go", "Scala", "Elixir", "Rust", "Phoenix", "Node.js" ]
    , [ "Dev Environment", "elm reactor", "elm-analyse", "create-elm-app", "elm-live", "Parcel", "webpack", "VSCode", "Docker", "Windows" ]
    , [ "アルゴリズム", "木構造", "初心者" ]
    , [ "Hello World", "FizzBuzz", "To-Do List App" ]
    , [ "Examples", "Poème", "Study Log", "Personal Log" ]
    ]


languages : List { id : String, value : String, label : String }
languages =
    [ { id = "en", value = "en", label = "English" }
    , { id = "ja", value = "ja", label = "日本語" }
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
    | SelectLanguages String Bool
    | SelectTag String
    | SelectVersions String Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        Loaded (Err _) ->
            ( model, Cmd.none )

        SelectLanguages l isChecked ->
            ( { model
                | selectedLanguages =
                    if isChecked then
                        l :: model.selectedLanguages

                    else
                        List.filter ((/=) l) model.selectedLanguages
              }
            , Cmd.none
            )

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
    { title = "Elm Articles"
    , body =
        [ main_ [ class "ui container" ]
            [ section [ class "ui vertical stripe segment" ]
                [ h1 [] [ text "Elm Articles" ]
                , div [ class "ui form" ]
                    [ div [ class "grouped fields" ] <|
                        List.map
                            (\tag ->
                                button
                                    [ class "ui tiny button"
                                    , onClick (SelectTag tag)
                                    ]
                                    [ text tag ]
                            )
                            (List.concat tagCloud)
                    , div [ class "inline fields" ] <|
                        label [] [ text "Languages" ]
                            :: List.map (listItem SelectLanguages model.selectedLanguages) languages
                    , div [ class "inline fields" ] <|
                        label [] [ text "Target Versions" ]
                            :: List.map (listItem SelectVersions model.selectedVersions) versions
                    ]
                , table [ class "ui table" ]
                    [ thead []
                        [ tr []
                            [ th [] [ text "Target" ]
                            , th [] [ text "Tags" ]
                            , th [] [ text "Title" ]
                            , th [] [ text "Language" ]
                            , th [] [ text "Website" ]
                            ]
                        ]
                    , tbody [] (List.map tableRow filteredArticles)
                    ]
                ]
            ]
        ]
    }


tableRow : Article -> Html Msg
tableRow article =
    tr []
        [ td [] [ text article.targetVersion ]
        , td [] <|
            List.map
                (\tag -> span [ class "ui label", onClick (SelectTag tag) ] [ text (wordToJapanese tag) ])
                article.tags
        , td []
            [ div [] [ text article.title ]
            , span [ class "ui small grey text" ] [ text article.author ]
            ]
        , td [] [ text (languageToString article.language) ]
        , td []
            [ a [ href article.url, target "_blank", rel "noopener" ]
                [ text article.siteName
                , text " "
                , i [ class "external alternate icon" ] []
                ]
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

module Pages.Top exposing (Model, Msg, Params, page)

import AssocList
import AssocList.Extra
import Data.Article exposing (Article)
import Data.Article.Qiita as Qiita exposing (articleDecoder)
import Data.Language exposing (isSelectedLanguage)
import Data.Version as Version
import Html exposing (..)
import Html.Attributes exposing (class, colspan, href, rel, target)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String.Converter exposing (wordToJapanese)


type alias Params =
    ()


type alias Model =
    Shared.Model


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , save = \_ shared -> shared
        , load = \_ model -> ( model, Cmd.none )
        }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared _ =
    ( shared
    , Cmd.batch <|
        [ Http.get
            { url = "static/articles_guide.json"
            , expect = Http.expectJson Loaded_Guide (Decode.list Data.Article.articleDecoder)
            }
        , Http.get
            { url = "static/articles_qiita.json"
            , expect = Http.expectJson Loaded_Qiita (Decode.list Qiita.articleDecoder)
            }
        ]
    )


type Msg
    = Loaded_Qiita (Result Http.Error (List Article))
    | Loaded_Guide (Result Http.Error (List Article))
    | SelectTag String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded_Guide (Ok articles) ->
            ( { model | guideArticles = articles }, Cmd.none )

        Loaded_Guide (Err _) ->
            ( model, Cmd.none )

        Loaded_Qiita (Ok articles) ->
            ( { model | qiitaArticles = articles }, Cmd.none )

        Loaded_Qiita (Err _) ->
            ( model, Cmd.none )

        SelectTag tag ->
            ( { model | selectedTag = Just tag }, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    let
        byLanguageAndTag article =
            List.all identity
                [ isSelectedLanguage model.selectedLanguages article.language
                , model.selectedTag
                    |> Maybe.map (\tag -> List.member tag article.tags)
                    |> Maybe.withDefault True
                ]

        guideArticles =
            model.guideArticles
                |> List.filter byLanguageAndTag

        articlesByVersion =
            model.qiitaArticles
                |> List.filter byLanguageAndTag
                |> AssocList.Extra.filterGroupBy
                    (.created_at
                        >> Version.fromDateString
                        >> Maybe.map Version.getRecord
                        >> Maybe.map
                            (\{ version, topic, url } ->
                                a [ href url, target "_blank", rel "noopener" ]
                                    [ text (version ++ " - " ++ topic ++ " ")
                                    , i [ class "external alternate small icon" ] []
                                    ]
                            )
                    )
                |> AssocList.toList

        articles =
            (case guideArticles of
                [] ->
                    []

                nonEmpty ->
                    [ ( text "An Introduction to Elm（Evan Czaplicki によるガイド）", nonEmpty ) ]
            )
                ++ articlesByVersion
    in
    { title = "elm-articles"
    , body =
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
        , div [] <| List.map (\( h, a ) -> tableFor h a) articles
        ]
    }


tagCloud : List (List String)
tagCloud =
    [ [ "The Elm Architecture", "Types", "Type Aliases", "Custom Types", "Maybe", "Result", "HTTP", "JSON", "Random", "Time", "Task", "Flags", "Ports" ]
    , [ "Opaque Type", "Phantom Type", "Parser", "Functional Programming" ]
    , [ "Test", "TDD", "elm-test", "elm-verify-examples" ]
    , [ "SVG", "Single Page Application", "Firebase", "GraphQL", "Static Site Generator" ]
    , [ "mdgriffith/elm-ui", "arowM/elm-form-decoder" ]
    , [ "CLI" ]
    , [ "VirtualDom", "WebComponents", "form" ]
    , [ "HTML", "CSS", "JavaScript", "TypeScript", "Node.js" ]
    , [ "Dev Environment", "Ellie", "elm reactor", "elm-format", "elm-analyse", "create-elm-app", "elm-live", "Parcel", "webpack", "VSCode", "Docker", "Windows" ]
    , [ "Algorithm", "木構造", "初心者" ]
    , [ "Hello World", "FizzBuzz", "To-Do List App" ]
    , [ "Examples", "Poème", "Study Log", "Personal Log" ]
    ]


tableFor : Html Msg -> List Article -> Html Msg
tableFor heading articles =
    table [ class "ui selectable table" ]
        [ thead []
            [ tr []
                [ th [ colspan 3 ] [ heading ] ]
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
                (\tag ->
                    span
                        [ class "ui tiny button"
                        , onClick (SelectTag tag)
                        ]
                        [ text (wordToJapanese tag) ]
                )
                article.tags
        ]

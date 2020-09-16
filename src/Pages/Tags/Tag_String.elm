module Pages.Tags.Tag_String exposing (Model, Msg, Params, page)

import AssocList
import AssocList.Extra
import Data.Article exposing (Article)
import Data.Language exposing (Language(..), isSelectedLanguage, languageToString)
import Data.Tag as Tag exposing (fromString, toString)
import Data.Version as Version
import Html exposing (..)
import Html.Attributes exposing (class, colspan, href, rel, target)
import Html.Events exposing (onClick)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String.Converter exposing (wordToJapanese)


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        , save = \model _ -> model.shared
        , load = load
        }



-- INIT


type alias Params =
    { tag : String }


type alias Model =
    { shared : Shared.Model
    , selectedTag : String
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { shared = shared
      , selectedTag = Tag.toString params.tag
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetLanguage Language


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        shared =
            model.shared
    in
    case msg of
        SetLanguage l ->
            ( { model | shared = { shared | language = l } }
            , Cmd.none
            )


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    let
        shared_ =
            model.shared
    in
    ( { model
        | shared =
            { shared_
                | guideArticles = shared.guideArticles
                , qiitaArticles = shared.qiitaArticles
            }
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Document Msg
view m =
    let
        byLanguageAndTag article =
            List.all identity
                [ isSelectedLanguage m.shared.language article.language
                , List.member m.selectedTag article.tags
                ]

        filteredGuideArticles =
            m.shared.guideArticles |> List.filter byLanguageAndTag

        filteredQiitaArticles =
            m.shared.qiitaArticles |> List.filter byLanguageAndTag

        filteredArticlesCount =
            List.length filteredGuideArticles + List.length filteredQiitaArticles

        articlesByVersion =
            filteredQiitaArticles
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
            (case filteredGuideArticles of
                [] ->
                    []

                nonEmpty ->
                    [ ( text "An Introduction to Elm（Evan Czaplicki によるガイド）", nonEmpty ) ]
            )
                ++ articlesByVersion
    in
    { title = m.selectedTag ++ " | elm-articles"
    , body =
        [ h3 [] [ text (wordToJapanese m.selectedTag ++ ": " ++ String.fromInt filteredArticlesCount ++ "件の記事が見つかりました") ]
        , div [ class "ui secondary menu" ]
            [ div [ class "right menu" ]
                [ div [ class "ui simple dropdown item" ]
                    [ text ("Language: " ++ languageToString m.shared.language)
                    , i [ class "dropdown icon" ] []
                    , div [ class "menu" ] <|
                        List.map (\l -> div [ class "item", onClick (SetLanguage l) ] [ text (languageToString l) ])
                            [ All, English, Japanese ]
                    ]
                ]
            ]
        , div [ class "ui vertical segment" ] <|
            List.map (\( h, a ) -> tableFor h a) articles
        ]
    }


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
                    a [ href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag }) ]
                        [ span [ class "ui tiny button" ] [ text (wordToJapanese tag) ] ]
                )
                article.tags
        ]

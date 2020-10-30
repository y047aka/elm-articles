module Pages.Tags.Tag_String exposing (Model, Msg, Params, page)

import AssocList
import AssocList.Extra
import Data.Article exposing (Article)
import Data.Language exposing (Language(..), isSelectedLanguage, languageToString)
import Data.Tag as Tag exposing (fromString, toString)
import Data.Version as Version
import Html exposing (..)
import Html.Attributes exposing (class, href, rel, src, target)
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
                | articles = shared.articles
                , guideArticles = shared.guideArticles
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

        hasGuideArticles =
            m.shared.guideArticles
                |> List.filter byLanguageAndTag
                |> (\articles -> List.length articles /= 0)

        filteredArticles =
            m.shared.articles |> List.filter byLanguageAndTag

        articlesByVersion =
            filteredArticles
                |> AssocList.Extra.filterGroupBy (.createdAt >> Version.fromDateString >> Maybe.map Version.getRecord)
                |> AssocList.toList
    in
    { title = m.selectedTag ++ " | elm-articles"
    , body =
        [ h3 []
            [ text (wordToJapanese m.selectedTag)
            , text ": "
            , text (String.fromInt <| List.length filteredArticles)
            , text "件の記事が見つかりました"
            ]
        , if hasGuideArticles then
            a [ class "item", href (Route.toString Route.Guide) ] [ text <| wordToJapanese m.selectedTag ++ " についての公式のガイドがあります" ]

          else
            text ""
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
            List.map (\( h, a ) -> segmentWithCards { heading = h, articles = a }) articlesByVersion
        ]
    }


segmentWithCards :
    { heading : { version : String, releasedAt : String, topic : String, url : String }
    , articles : List Article
    }
    -> Html Msg
segmentWithCards { heading, articles } =
    div [ class "ui vertical padded segment" ]
        [ h1 [ class "ui small grey header" ]
            [ a [ href heading.url, target "_blank", rel "noopener" ]
                [ text (heading.version ++ " - " ++ heading.topic ++ " ")
                , i [ class "external alternate small icon" ] []
                ]
            ]
        , div [ class "ui stackable three cards" ] (List.map card articles)
        ]


card : Article -> Html Msg
card article =
    let
        author { name, image } =
            case image of
                Just image_ ->
                    span []
                        [ img [ class "ui avatar image", src image_ ] []
                        , text (" " ++ name)
                        ]

                Nothing ->
                    text name
    in
    a
        [ class "card"
        , href article.url
        , target "_blank"
        , rel "noopener"
        ]
        [ div [ class "content" ]
            [ div [ class "header" ] [ text (article.title ++ " "), i [ class "external alternate small icon" ] [] ]
            , div [ class "meta" ]
                [ author article.author
                , span [ class "right floated" ] [ text article.siteName ]
                ]
            ]
        , div [ class "extra content" ]
            [ case article.tags of
                [] ->
                    text ""

                nonEmpty ->
                    div [ class "extra content" ] <|
                        List.map
                            (\tag ->
                                a
                                    [ class "ui label"
                                    , href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag })
                                    ]
                                    [ text (wordToJapanese tag) ]
                            )
                            nonEmpty
            ]
        ]

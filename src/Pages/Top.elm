module Pages.Top exposing (Model, Msg, Params, page)

import AssocList
import AssocList.Extra
import Data.Article exposing (Article)
import Data.Language exposing (Language(..), isSelectedLanguage, languageToString)
import Data.Tag as Tag exposing (fromString, toString)
import Data.Version as Version
import Html exposing (..)
import Html.Attributes exposing (class, href, rel, target)
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
    ()


type alias Model =
    { shared : Shared.Model }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared _ =
    ( { shared = shared }, Cmd.none )



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
                | qiitaArticles = shared.qiitaArticles
                , zennArticles = shared.zennArticles
            }
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Document Msg
view m =
    let
        articlesByVersion =
            (m.shared.qiitaArticles ++ m.shared.zennArticles)
                |> List.filter (.language >> isSelectedLanguage m.shared.language)
                |> AssocList.Extra.filterGroupBy (.createdAt >> Version.fromDateString >> Maybe.map Version.getRecord)
                |> AssocList.toList
                |> List.map (Tuple.mapSecond (List.sortBy .createdAt >> List.reverse))
                |> List.sortBy (Tuple.first >> .releasedAt)
                |> List.reverse
    in
    { title = "elm-articles"
    , body =
        [ section [ class "ui vertical padded segment" ]
            [ h3 [] [ text "最新の記事" ]
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
        , div [ class "ui three cards" ] (List.map card articles)
        ]


card : Article -> Html Msg
card article =
    a
        [ class "card"
        , href article.url
        , target "_blank"
        , rel "noopener"
        ]
        [ div [ class "content" ]
            [ div [ class "header" ] [ text article.title ]
            , div [ class "meta" ] [ text (article.author ++ " | " ++ article.siteName) ]
            ]
        , case article.tags of
            [] ->
                text ""

            nonEmpty ->
                div [ class "extra content" ] <|
                    List.map
                        (\tag ->
                            a [ href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag }) ]
                                [ span [ class "ui tiny button" ] [ text (wordToJapanese tag) ] ]
                        )
                        nonEmpty
        ]

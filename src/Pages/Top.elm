module Pages.Top exposing (Model, Msg, Params, page)

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
                |> List.map
                    (\( { version, topic, url }, articles ) ->
                        ( a [ href url, target "_blank", rel "noopener" ]
                            [ text (version ++ " - " ++ topic ++ " ")
                            , i [ class "external alternate small icon" ] []
                            ]
                        , articles
                        )
                    )
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
            , div [] <| List.map (\( h, a ) -> tableFor h a) articlesByVersion
            ]
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

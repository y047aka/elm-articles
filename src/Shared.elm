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
        , siteFooter
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


siteFooter : Html msg
siteFooter =
    footer [ class "ui inverted vertical footer segment" ]
        [ div [ class "ui right aligned container" ]
            [ p [] [ text "© 2020 y047aka" ] ]
        ]

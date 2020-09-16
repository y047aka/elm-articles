module Shared exposing (Flags, Model, Msg, init, subscriptions, update, view)

import Browser.Navigation exposing (Key)
import Data.Article exposing (Article)
import Data.Article.Qiita as Qiita exposing (articleDecoder)
import Data.Language exposing (Language(..))
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , language : Language
    , guideArticles : List Article
    , qiitaArticles : List Article
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { url = url
      , key = key
      , language = All
      , guideArticles = []
      , qiitaArticles = []
      }
    , Cmd.batch <|
        [ Http.get
            { url = "/static/articles_guide.json"
            , expect = Http.expectJson Loaded_Guide (Decode.list Data.Article.articleDecoder)
            }
        , Http.get
            { url = "/static/articles_qiita.json"
            , expect = Http.expectJson Loaded_Qiita (Decode.list Qiita.articleDecoder)
            }
        ]
    )



-- UPDATE


type Msg
    = Loaded_Qiita (Result Http.Error (List Article))
    | Loaded_Guide (Result Http.Error (List Article))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded_Guide (Ok articles) ->
            ( { model | guideArticles = articles }
            , Cmd.none
            )

        Loaded_Guide (Err _) ->
            ( model, Cmd.none )

        Loaded_Qiita (Ok articles) ->
            ( { model | qiitaArticles = articles }
            , Cmd.none
            )

        Loaded_Qiita (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } _ =
    { title = page.title
    , body =
        [ Html.map toMsg <| siteHeader
        , main_ [ class "ui main container" ] page.body
        , siteFooter
        ]
    }


siteHeader : Html Msg
siteHeader =
    header [ class "ui vertical header segment" ]
        [ div [ class "ui container" ]
            [ div [ class "ui secondary menu" ] <|
                a [ class "item", href (Route.toString Route.Top) ] [ span [ class "ui bold text" ] [ text "elm-articles" ] ]
                    :: List.map
                        (\{ label, route } ->
                            a [ class "item", href (Route.toString route) ] [ text label ]
                        )
                        [ { label = "Elmを学ぶ", route = Route.Guide }
                        , { label = "タグから探す", route = Route.Tags }
                        ]
            ]
        ]


siteFooter : Html msg
siteFooter =
    footer [ class "ui vertical padded footer segment" ]
        [ div [ class "ui right aligned container" ]
            [ p [] [ text "© 2020 y047aka" ] ]
        ]

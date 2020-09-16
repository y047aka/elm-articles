module Pages.Tags exposing (Model, Msg, Params, page)

import AssocList
import AssocList.Extra
import Data.Tag as Tag
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Set
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
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { shared : Shared.Model
    , tagsByInitial : List ( Char, List String )
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared _ =
    ( { shared = shared
      , tagsByInitial = gatherAllTagsByInitial shared
      }
    , Cmd.none
    )


gatherAllTagsByInitial : Shared.Model -> List ( Char, List String )
gatherAllTagsByInitial { guideArticles, qiitaArticles } =
    (guideArticles ++ qiitaArticles)
        |> List.map .tags
        |> List.concat
        |> Set.fromList
        |> Set.toList
        |> AssocList.Extra.filterGroupBy (String.uncons >> Maybe.map (Tuple.first >> Char.toUpper))
        |> AssocList.toList
        |> List.sortBy Tuple.first



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save _ shared =
    shared


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
        , tagsByInitial = gatherAllTagsByInitial shared
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Document Msg
view m =
    { title = "elm-articles"
    , body =
        [ h2 [] [ text "タグから探す" ]
        , section [ class "ui basic segments" ] <|
            List.map
                (\( initial, tags ) ->
                    div [ class "ui  padded horizontally fitted segment" ] <|
                        h3 [] [ text (String.fromChar initial) ]
                            :: List.map
                                (\tag ->
                                    a [ href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag }) ]
                                        [ span [ class "ui tiny button" ] [ text (wordToJapanese tag) ] ]
                                )
                                tags
                )
                m.tagsByInitial
        ]
    }

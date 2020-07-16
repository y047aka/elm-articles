module Main exposing (main)

import Browser exposing (Document)
import Html exposing (h1, input, main_, section, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onInput)
import Http
import Json.Decode as Decode exposing (Decoder, string)
import Table


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
    , tableState : Table.State
    , query : String
    }


type alias Article =
    { title : String
    , author : String
    , siteName : String
    , url : String
    , language : String
    , targetVersion : String
    , tags : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = []
      , tableState = Table.initialSort "Year"
      , query = ""
      }
    , Http.get
        { url = "articles.json"
        , expect = Http.expectJson Loaded (Decode.list articleDecoder)
        }
    )


articleDecoder : Decoder Article
articleDecoder =
    Decode.map7 Article
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "siteName" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "language" Decode.string)
        (Decode.field "targetVersion" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))



-- UPDATE


type Msg
    = Loaded (Result Http.Error (List Article))
    | SetQuery String
    | SetTableState Table.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Loaded (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        Loaded (Err _) ->
            ( model, Cmd.none )

        SetQuery newQuery ->
            ( { model | query = newQuery }, Cmd.none )

        SetTableState newState ->
            ( { model | tableState = newState }, Cmd.none )



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Elm Articles"
    , body =
        let
            lowerQuery =
                String.toLower model.query

            acceptablePeople =
                List.filter (String.contains lowerQuery << String.toLower << .title) model.articles
        in
        [ main_ [ class "ui container" ]
            [ section [ class "ui vertical stripe segment" ]
                [ h1 [] [ text "Elm Articles" ]
                , input [ placeholder "Search by Name", onInput SetQuery ] []
                , Table.view config model.tableState acceptablePeople
                ]
            ]
        ]
    }


config : Table.Config Article Msg
config =
    Table.config
        { toId = .title
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Target" .targetVersion
            , Table.stringColumn "Language" .language
            , Table.stringColumn "Title" .title
            , Table.stringColumn "Site" .siteName
            , Table.stringColumn "URL" .url
            , Table.stringColumn "Tags" (.tags >> String.join ", ")
            ]
        }

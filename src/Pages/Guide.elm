module Pages.Guide exposing (Model, Msg, Params, page)

import Data.Tag as Tag exposing (fromString, toString)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)
import String.Converter exposing (wordToJapanese)


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


type alias Model =
    Url Params


type alias Msg =
    Never



-- VIEW


type alias Params =
    ()


view : Url Params -> Document Msg
view _ =
    let
        section_ { heading, tags } =
            div [ class "ui  padded horizontally fitted segment" ] <|
                h3 [] [ text (wordToJapanese heading) ]
                    :: List.map
                        (\tag ->
                            a [ href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag }) ]
                                [ span [ class "ui tiny button" ] [ text (wordToJapanese tag) ] ]
                        )
                        tags
    in
    { title = "elm-articles"
    , body =
        [ h2 [] [ text "Elmを学ぶ" ]
        , section [ class "ui basic segments" ] <|
            List.map section_
                [ { heading = "The Elm Architecture"
                  , tags = [ "The Elm Architecture" ]
                  }
                , { heading = "Types"
                  , tags = [ "Types", "Type Aliases", "Custom Types" ]
                  }
                , { heading = "Error Handling"
                  , tags = [ "Maybe", "Result" ]
                  }
                , { heading = "コマンドとサブスクリプション"
                  , tags = [ "HTTP", "JSON", "Random", "Time", "Task" ]
                  }
                , { heading = "JavaScriptとの相互運用"
                  , tags = [ "Flags", "Ports" ]
                  }
                , { heading = "Test"
                  , tags = [ "Test", "TDD", "elm-test", "elm-verify-examples" ]
                  }
                , { heading = "Dev Environment"
                  , tags = [ "Dev Environment", "Ellie", "elm reactor", "elm-format", "elm-analyse", "create-elm-app", "elm-live", "Parcel", "webpack", "VSCode", "Docker", "Windows" ]
                  }
                , { heading = "タグクラウド"
                  , tags = List.concat tagCloud
                  }
                ]
        ]
    }


tagCloud : List (List String)
tagCloud =
    [ [ "Parser", "Functional Programming" ]
    , [ "SVG", "Single Page Application", "Firebase", "GraphQL", "Static Site Generator" ]
    , [ "mdgriffith/elm-ui", "arowM/elm-form-decoder" ]
    , [ "VirtualDom", "WebComponents", "form" ]
    , [ "HTML", "CSS", "JavaScript", "TypeScript", "Node.js" ]
    , [ "Algorithm", "木構造", "初心者" ]
    , [ "Hello World", "FizzBuzz", "To-Do List App" ]
    ]

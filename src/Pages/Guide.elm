module Pages.Guide exposing (Model, Msg, Params, page)

import Data.Tag as Tag exposing (fromString, toString)
import Html exposing (..)
import Html.Attributes exposing (class, href, rel, target)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


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


type alias Msg =
    Never


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    let
        shared_ =
            model.shared
    in
    ( { model
        | shared = { shared_ | guideArticles = shared.guideArticles }
      }
    , Cmd.none
    )



-- VIEW


view : Model -> Document Msg
view m =
    { title = "elm-articles"
    , body =
        [ h2 [] [ text "Elmを学ぶ" ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "はじめに"
                  , description = ""
                  , url = "https://guide.elm-lang.org/"
                  , url_ja = "https://guide.elm-lang.jp/"
                  , tag = ""
                  }
                , { title = "インストール"
                  , description = ""
                  , url = "https://guide.elm-lang.org/install/"
                  , url_ja = "https://guide.elm-lang.jp/install.html"
                  , tag = "Environment Setup"
                  }
                , { title = "言語の基礎"
                  , description = ""
                  , url = "https://guide.elm-lang.org/core_language.html"
                  , url_ja = "https://guide.elm-lang.jp/core_language.html"
                  , tag = ""
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "The Elm Architecture"
                  , description = ""
                  , url = "https://guide.elm-lang.org/architecture/"
                  , url_ja = "https://guide.elm-lang.jp/architecture/"
                  , tag = "The Elm Architecture"
                  }
                , { title = "ボタン"
                  , description = ""
                  , url = "https://guide.elm-lang.org/architecture/buttons.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/buttons.html"
                  , tag = "The Elm Architecture"
                  }
                , { title = "テキスト入力"
                  , description = ""
                  , url = "https://guide.elm-lang.org/architecture/text_fields.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/text_fields.html"
                  , tag = "The Elm Architecture"
                  }
                , { title = "フォーム"
                  , description = ""
                  , url = "https://guide.elm-lang.org/architecture/forms.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/forms.html"
                  , tag = "The Elm Architecture"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "型について"
                  , description = ""
                  , url = "https://guide.elm-lang.jp/types/"
                  , url_ja = "https://guide.elm-lang.jp/types/"
                  , tag = "Types"
                  }
                , { title = "型を読む"
                  , description = ""
                  , url = "https://guide.elm-lang.jp/types/reading_types.html"
                  , url_ja = "https://guide.elm-lang.jp/types/reading_types.html"
                  , tag = "Types"
                  }
                , { title = "型エイリアス"
                  , description = ""
                  , url = "https://guide.elm-lang.jp/types/type_aliases.html"
                  , url_ja = "https://guide.elm-lang.jp/types/type_aliases.html"
                  , tag = "Type Aliases"
                  }
                , { title = "カスタム型（Custom type）"
                  , description = ""
                  , url = "https://guide.elm-lang.jp/types/custom_types.html"
                  , url_ja = "https://guide.elm-lang.jp/types/custom_types.html"
                  , tag = "Custom Types"
                  }
                , { title = "パターンマッチ"
                  , description = ""
                  , url = "https://guide.elm-lang.jp/types/pattern_matching.html"
                  , url_ja = "https://guide.elm-lang.jp/types/pattern_matching.html"
                  , tag = "Pattern Matching"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "エラーハンドリング"
                  , description = ""
                  , url = "https://guide.elm-lang.org/error_handling/"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/"
                  , tag = "Maybe"
                  }
                , { title = "Maybe"
                  , description = ""
                  , url = "https://guide.elm-lang.org/error_handling/maybe.html"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/maybe.html"
                  , tag = "Maybe"
                  }
                , { title = "Result"
                  , description = ""
                  , url = "https://guide.elm-lang.org/error_handling/result.html"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/result.html"
                  , tag = "Result"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "コマンドとサブスクリプション"
                  , description = ""
                  , url = "https://guide.elm-lang.org/effects/"
                  , url_ja = "https://guide.elm-lang.jp/effects/"
                  , tag = "elm/browser"
                  }
                , { title = "HTTP"
                  , description = ""
                  , url = "https://guide.elm-lang.org/effects/http.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/http.html"
                  , tag = "HTTP"
                  }
                , { title = "JSON"
                  , description = ""
                  , url = "https://guide.elm-lang.org/effects/json.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/json.html"
                  , tag = "JSON"
                  }
                , { title = "Random"
                  , description = ""
                  , url = "https://guide.elm-lang.org/effects/random.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/random.html"
                  , tag = "elm/random"
                  }
                , { title = "Time"
                  , description = ""
                  , url = "https://guide.elm-lang.org/effects/time.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/time.html"
                  , tag = "Task"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "JavaScriptとの相互運用"
                  , description = ""
                  , url = "https://guide.elm-lang.org/interop/"
                  , url_ja = "https://guide.elm-lang.jp/interop/"
                  , tag = ""
                  }
                , { title = "フラグ"
                  , description = ""
                  , url = "https://guide.elm-lang.org/interop/flags.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/flags.html"
                  , tag = "Flags"
                  }
                , { title = "ポート"
                  , description = ""
                  , url = "https://guide.elm-lang.org/interop/ports.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/ports.html"
                  , tag = "Ports"
                  }
                , { title = "Custom Elements"
                  , description = ""
                  , url = "https://guide.elm-lang.org/interop/custom_elements.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/custom_elements.html"
                  , tag = "Custom Elements"
                  }
                , { title = "The Limits of Elm/JS Interop"
                  , description = ""
                  , url = "https://guide.elm-lang.org/interop/limits.html"
                  , url_ja = ""
                  , tag = "Ports"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "Web アプリケーション"
                  , description = ""
                  , url = "https://guide.elm-lang.org/webapps/"
                  , url_ja = "https://guide.elm-lang.jp/webapps/"
                  , tag = "elm/browser"
                  }
                , { title = "ナビゲーション"
                  , description = ""
                  , url = "https://guide.elm-lang.org/webapps/url_parsing.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/navigation.html"
                  , tag = "elm/url"
                  }
                , { title = "URLのパース"
                  , description = ""
                  , url = "https://guide.elm-lang.org/webapps/modules.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/url_parsing.html"
                  , tag = "elm/url"
                  }
                , { title = "モジュール"
                  , description = ""
                  , url = "https://guide.elm-lang.org/webapps/modules.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/modules.html"
                  , tag = "Modules"
                  }
                , { title = "Webアプリケーションの構造化"
                  , description = ""
                  , url = "https://guide.elm-lang.org/webapps/structure.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/structure.html"
                  , tag = "Modules"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "最適化"
                  , description = ""
                  , url = "https://guide.elm-lang.org/optimization/"
                  , url_ja = "https://guide.elm-lang.jp/optimization/"
                  , tag = ""
                  }
                , { title = "Html.Lazy"
                  , description = ""
                  , url = "https://guide.elm-lang.org/optimization/lazy.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/lazy.html"
                  , tag = "Lazy"
                  }
                , { title = "Html.Keyed"
                  , description = ""
                  , url = "https://guide.elm-lang.org/optimization/keyed.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/keyed.html"
                  , tag = "Keyed"
                  }
                , { title = "アセットサイズの縮小"
                  , description = ""
                  , url = "https://guide.elm-lang.org/optimization/asset_size.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/asset_size.html"
                  , tag = ""
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "次への一歩"
                  , description = ""
                  , url = "https://guide.elm-lang.org/next_steps.html"
                  , url_ja = "https://guide.elm-lang.jp/next_steps.html"
                  , tag = ""
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "集合としての型"
                  , description = ""
                  , url = "https://guide.elm-lang.org/appendix/types_as_sets.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/types_as_sets.html"
                  , tag = "Types"
                  }
                , { title = "型のビット表現"
                  , description = ""
                  , url = "https://guide.elm-lang.org/appendix/types_as_bits.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/types_as_bits.html"
                  , tag = "Types"
                  }
                , { title = "関数の型"
                  , description = ""
                  , url = "https://guide.elm-lang.org/appendix/function_types.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/function_types.html"
                  , tag = "Types"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "翻訳について"
                  , description = ""
                  , url = ""
                  , url_ja = "https://guide.elm-lang.jp/about_translation.html"
                  , tag = ""
                  }
                ]
        ]
    }


listItem :
    { title : String
    , description : String
    , url : String
    , url_ja : String
    , tag : String
    }
    -> Html msg
listItem { title, description, url, url_ja, tag } =
    div [ class "ui basic horizontally fitted segment" ]
        [ div [ class "ui header" ] [ text (title ++ " ") ]
        , p [] [ text description ]
        , div []
            [ externalLink { label = "邦訳版", url = url_ja }
            , externalLink { label = "原文", url = url }
            , a
                [ class "ui right labeled icon tiny button"
                , href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag })
                ]
                [ i [ class "search icon" ] []
                , span [ class "meta" ] [ text (tag ++ " を検索") ]
                ]
            ]
        ]


externalLink : { label : String, url : String } -> Html msg
externalLink { label, url } =
    a
        [ class "ui right labeled icon tiny button"
        , href url
        , target "_blank"
        , rel "noopener"
        ]
        [ i [ class "external alternate icon" ] []
        , span [ class "meta" ] [ text label ]
        ]

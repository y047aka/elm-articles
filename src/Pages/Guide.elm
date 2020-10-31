module Pages.Guide exposing (Model, Msg, Params, page)

import Data.Tag as Tag exposing (fromString, toString)
import Html exposing (..)
import Html.Attributes exposing (class, href, rel, target)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


type alias Model =
    Url Params


type alias Params =
    ()


type alias Msg =
    Never



-- VIEW


view : Url Params -> Document Msg
view _ =
    { title = "elm-articles"
    , body =
        [ h2 [] [ text "Elmを学ぶ" ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "はじめに"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/"
                  , url_ja = "https://guide.elm-lang.jp/"
                  , tag = Nothing
                  }
                , { title = "インストール"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/install/"
                  , url_ja = "https://guide.elm-lang.jp/install.html"
                  , tag = Just "Environment Setup"
                  }
                , { title = "言語の基礎"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/core_language.html"
                  , url_ja = "https://guide.elm-lang.jp/core_language.html"
                  , tag = Nothing
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "The Elm Architecture"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/architecture/"
                  , url_ja = "https://guide.elm-lang.jp/architecture/"
                  , tag = Just "The Elm Architecture"
                  }
                , { title = "ボタン"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/architecture/buttons.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/buttons.html"
                  , tag = Just "The Elm Architecture"
                  }
                , { title = "テキスト入力"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/architecture/text_fields.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/text_fields.html"
                  , tag = Just "The Elm Architecture"
                  }
                , { title = "フォーム"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/architecture/forms.html"
                  , url_ja = "https://guide.elm-lang.jp/architecture/forms.html"
                  , tag = Just "The Elm Architecture"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "型について"
                  , description = ""
                  , url = Just "https://guide.elm-lang.jp/types/"
                  , url_ja = "https://guide.elm-lang.jp/types/"
                  , tag = Just "Types"
                  }
                , { title = "型を読む"
                  , description = ""
                  , url = Just "https://guide.elm-lang.jp/types/reading_types.html"
                  , url_ja = "https://guide.elm-lang.jp/types/reading_types.html"
                  , tag = Just "Types"
                  }
                , { title = "型エイリアス"
                  , description = ""
                  , url = Just "https://guide.elm-lang.jp/types/type_aliases.html"
                  , url_ja = "https://guide.elm-lang.jp/types/type_aliases.html"
                  , tag = Just "Type Aliases"
                  }
                , { title = "カスタム型（Custom type）"
                  , description = ""
                  , url = Just "https://guide.elm-lang.jp/types/custom_types.html"
                  , url_ja = "https://guide.elm-lang.jp/types/custom_types.html"
                  , tag = Just "Custom Types"
                  }
                , { title = "パターンマッチ"
                  , description = ""
                  , url = Just "https://guide.elm-lang.jp/types/pattern_matching.html"
                  , url_ja = "https://guide.elm-lang.jp/types/pattern_matching.html"
                  , tag = Just "Pattern Matching"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "エラーハンドリング"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/error_handling/"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/"
                  , tag = Just "Maybe"
                  }
                , { title = "Maybe"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/error_handling/maybe.html"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/maybe.html"
                  , tag = Just "Maybe"
                  }
                , { title = "Result"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/error_handling/result.html"
                  , url_ja = "https://guide.elm-lang.jp/error_handling/result.html"
                  , tag = Just "Result"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "コマンドとサブスクリプション"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/effects/"
                  , url_ja = "https://guide.elm-lang.jp/effects/"
                  , tag = Just "elm/browser"
                  }
                , { title = "HTTP"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/effects/http.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/http.html"
                  , tag = Just "HTTP"
                  }
                , { title = "JSON"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/effects/json.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/json.html"
                  , tag = Just "JSON"
                  }
                , { title = "Random"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/effects/random.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/random.html"
                  , tag = Just "elm/random"
                  }
                , { title = "Time"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/effects/time.html"
                  , url_ja = "https://guide.elm-lang.jp/effects/time.html"
                  , tag = Just "Task"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "JavaScriptとの相互運用"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/interop/"
                  , url_ja = "https://guide.elm-lang.jp/interop/"
                  , tag = Nothing
                  }
                , { title = "フラグ"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/interop/flags.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/flags.html"
                  , tag = Just "Flags"
                  }
                , { title = "ポート"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/interop/ports.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/ports.html"
                  , tag = Just "Ports"
                  }
                , { title = "Custom Elements"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/interop/custom_elements.html"
                  , url_ja = "https://guide.elm-lang.jp/interop/custom_elements.html"
                  , tag = Just "Custom Elements"
                  }
                , { title = "The Limits of Elm/JS Interop"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/interop/limits.html"
                  , url_ja = ""
                  , tag = Just "Ports"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "Web アプリケーション"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/webapps/"
                  , url_ja = "https://guide.elm-lang.jp/webapps/"
                  , tag = Just "elm/browser"
                  }
                , { title = "ナビゲーション"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/webapps/url_parsing.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/navigation.html"
                  , tag = Just "elm/url"
                  }
                , { title = "URLのパース"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/webapps/modules.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/url_parsing.html"
                  , tag = Just "elm/url"
                  }
                , { title = "モジュール"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/webapps/modules.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/modules.html"
                  , tag = Just "Modules"
                  }
                , { title = "Webアプリケーションの構造化"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/webapps/structure.html"
                  , url_ja = "https://guide.elm-lang.jp/webapps/structure.html"
                  , tag = Just "Modules"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "最適化"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/optimization/"
                  , url_ja = "https://guide.elm-lang.jp/optimization/"
                  , tag = Nothing
                  }
                , { title = "Html.Lazy"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/optimization/lazy.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/lazy.html"
                  , tag = Just "Lazy"
                  }
                , { title = "Html.Keyed"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/optimization/keyed.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/keyed.html"
                  , tag = Just "Keyed"
                  }
                , { title = "アセットサイズの縮小"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/optimization/asset_size.html"
                  , url_ja = "https://guide.elm-lang.jp/optimization/asset_size.html"
                  , tag = Nothing
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "次への一歩"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/next_steps.html"
                  , url_ja = "https://guide.elm-lang.jp/next_steps.html"
                  , tag = Nothing
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "集合としての型"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/appendix/types_as_sets.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/types_as_sets.html"
                  , tag = Just "Types"
                  }
                , { title = "型のビット表現"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/appendix/types_as_bits.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/types_as_bits.html"
                  , tag = Just "Types"
                  }
                , { title = "関数の型"
                  , description = ""
                  , url = Just "https://guide.elm-lang.org/appendix/function_types.html"
                  , url_ja = "https://guide.elm-lang.jp/appendix/function_types.html"
                  , tag = Just "Types"
                  }
                ]
        , section [ class "ui vertical segment" ] <|
            List.map listItem
                [ { title = "翻訳について"
                  , description = ""
                  , url = Nothing
                  , url_ja = "https://guide.elm-lang.jp/about_translation.html"
                  , tag = Nothing
                  }
                ]
        ]
    }


listItem :
    { title : String
    , description : String
    , url : Maybe String
    , url_ja : String
    , tag : Maybe String
    }
    -> Html msg
listItem { title, description, url, url_ja, tag } =
    let
        searchLink tag_ =
            a
                [ class "ui right labeled icon tiny button"
                , href (Route.toString <| Route.Tags__Tag_String { tag = Tag.fromString tag_ })
                ]
                [ i [ class "search icon" ] []
                , span [ class "meta" ] [ text (tag_ ++ " を検索") ]
                ]
    in
    div [ class "ui basic horizontally fitted segment" ]
        [ div [ class "ui header" ] [ text (title ++ " ") ]
        , p [] [ text description ]
        , div []
            [ externalLink { label = "邦訳版", url = url_ja }
            , Maybe.withDefault (text "") <| Maybe.map (\url_ -> externalLink { label = "原文", url = url_ }) url
            , Maybe.withDefault (text "") <| Maybe.map searchLink tag
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

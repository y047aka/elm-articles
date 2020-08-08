module Data.Language exposing (Language(..), isSelectedLanguage, languageToString)


type Language
    = All
    | English
    | Japanese


isSelectedLanguage : Language -> String -> Bool
isSelectedLanguage setting articleLanguage =
    case ( setting, articleLanguage ) of
        ( All, _ ) ->
            True

        ( English, "en" ) ->
            True

        ( Japanese, "ja" ) ->
            True

        _ ->
            False


languageToString : Language -> String
languageToString language =
    case language of
        All ->
            "すべて"

        English ->
            "English"

        Japanese ->
            "日本語"

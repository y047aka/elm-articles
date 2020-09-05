module String.Converter exposing (wordToJapanese)


wordToJapanese : String -> String
wordToJapanese englishWord =
    case englishWord of
        "Algorithm" ->
            "アルゴリズム"

        "Custom Types" ->
            "カスタム型"

        "Dev Environment" ->
            "開発環境"

        "Environment Setup" ->
            "環境構築"

        "Error Handling" ->
            "エラーハンドリング"

        "Examples" ->
            "作例"

        "Functional Programming" ->
            "関数型プログラミング"

        "Modules" ->
            "モジュール"

        "Pattern Matching" ->
            "パターンマッチ"

        "Personal Log" ->
            "私的記録"

        "Poème" ->
            "ポエム"

        "Static Site Generator" ->
            "静的サイトジェネレーター"

        "Study Log" ->
            "学習記録"

        "Test" ->
            "テスト"

        "To-Do List App" ->
            "ToDoリスト"

        "Types" ->
            "型"

        "Type Aliases" ->
            "型エイリアス"

        _ ->
            englishWord

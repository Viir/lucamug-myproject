# Elm hands-on

# Part 1

* Elm introduction
* Omni code base introduction

# Part 2

* Building an Elm app from scratch
* Writing HTML in Elm
* Moving to elm-go
* Introduction to the Elm Architecture
* Building a counter

# Part 3

* Stepping up, building a TODO list
* Introduction to elm-ui

# Part 4

* Subscriptions, responsiveness
* Ports
* Saving the state to the local storage

# Part 5

* Q&A
* Going deeper in Omni (does it look more familiar now?)

# Prerequisites

Node.js and NPM https://nodejs.org/en/download/

npm install -g elm
npm install -g elm-go
npm install -g elm-formatter

You can use your favorite IDE with an Elm plugin:

* VSCode: https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode
* IntelliJ: https://plugins.jetbrains.com/plugin/10268-elm
* Atom: https://atom.io/packages/elmjutsu

Alternative packages repository: https://elm.dmy.fr/
Ellie: https://ellie-app.com/

# To start elm-go:

Basic

```
elm-go src/Main.elm
```

With debugger

```
elm-go src/Main.elm -- --debug
```

With debugger, hot reload and index.html

```
elm-go src/Main.elm --dir=docs --hot -- --output=docs/elm.js --debug
```

# Useful snippets

## Remove at

From https://github.com/elm-community/list-extra/blob/8.4.0/src/List/Extra.elm#L920

```
removeAt : Int -> List a -> List a
removeAt index l =
    if index < 0 then
        l

    else
        case List.drop index l of
            [] ->
                l

            _ :: rest ->
                List.take index l ++ rest
```

## On enter

https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element-Input#form-elements
https://ellie-app.com/5X6jBKtxzdpa1

```
onEnter : msg -> Element.Attribute msg
onEnter msg =
    htmlAttribute
        (Html.Events.on "keyup"
            (Json.Decode.field "key" Json.Decode.string
                |> Json.Decode.andThen
                    (\key ->
                        if key == "Enter" then
                            Json.Decode.succeed msg

                        else
                            Json.Decode.fail "Not the enter key"
                    )
            )
        )
```

## HTML template

```
<!DOCTYPE html>
<html>

<head>
    <meta name='viewport' content='width=device-width,initial-scale=1,shrink-to-fit=no'>
    <title>My Project</title>
</head>

<body>
    <div id='elm'></div>
    <script src='elm.js'></script>
    <script>
        var storedState = localStorage.getItem('elm');
        var startingState = storedState ? JSON.parse(storedState) : null;
        var app = Elm.Main.init({
            node: document.getElementById('elm'),
            flags: startingState
        })
        app.ports.setStorage.subscribe(function(state) {
            localStorage.setItem('elm', JSON.stringify(state));
        });
    </script>
</body>

</html>
```

using

```
type alias Flags =
    Maybe Model


port setStorage : Model -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Maybe.withDefault
        { counter = 0
        , todos = [ "Todo 1", "Todo 2" ]
        , inputFieldValue = ""
        , viewport = 800
        }
        flags
    , Cmd.none
    )
```

## JavaScript with Codec

```
var storedState = localStorage.getItem('elm');
var startingState = storedState ? JSON.parse(storedState) : null;
var app = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: String(startingState)
})
app.ports.setStorage.subscribe(function(state) {
    localStorage.setItem('elm', JSON.stringify(state));
});
window.onstorage = function(event) {
    if (event.key === 'elm') {
        app.ports.getStorage.send(String(JSON.parse(event.newValue)));
    }
};
```

using

```
type alias Flags =
    String


port setStorage : String -> Cmd msg


port getStorage : (String -> msg) -> Sub msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Result.withDefault
        { counter = 0
        , todos = [ "Todo 1", "Todo 2" ]
        , inputFieldValue = ""
        , viewport = 800
        }
        (Codec.decodeString codecModel flags)
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ...
    case msg of
        GetStorage string ->
            ( newModel, cmds )

        _ ->
            ( newModel
            , Cmd.batch
                [ cmds
                , setStorage (Codec.encodeToString 0 codecModel newModel)
                ]
            )
```
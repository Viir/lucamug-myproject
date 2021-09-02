# Elm hands-on

# Part 1

* Building an Elm app from scratch
* Writing HTML in Elm
* Moving to elm-go
* Introduction to the Elm Architecture
* Building a counter

# Part 2

* Stepping up, building a TODO list
* Introduction to elm-ui
* Subscriptions, responsiveness
* Ports
* Saving the state to the local storage

# Prerequisites

Node.js and NPM https://nodejs.org/en/download/

npm install -g elm
npm install -g elm-go
npm install -g elm-formatter

You can use your favorite IDE with an Elm plugin:

VSCode: https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode
IntelliJ: https://plugins.jetbrains.com/plugin/10268-elm
Atom: https://atom.io/packages/elmjutsu

Alternative packages repository: https://elm.dmy.fr/
Ellie: https://ellie-app.com/

# To start elm-go:

```
elm-go src/Main.elm
```

With debugger

```
elm-go src/Main.elm -- --debug
```


# On enter

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

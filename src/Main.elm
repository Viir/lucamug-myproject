module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html
import Html.Events
import Json.Decode


main : Program () Model Msg
main =
    Browser.sandbox
        { init = { counter = 0, todos = [ "Todo 1", "Todo 2" ], inputFieldValue = "" }
        , view = view
        , update = update
        }


type alias Model =
    { counter : Int
    , todos : List String
    , inputFieldValue : String
    }


type Msg
    = Increase Int
    | Decrease
    | OnChange String
    | Add
    | Delete Int


type Maybe2 a
    = Just2 a
    | Nothing2


email : String
email =
    "a@a.com"


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase value ->
            { model | counter = model.counter + value }

        Decrease ->
            { model | counter = model.counter - 1 }

        OnChange string ->
            { model | inputFieldValue = string }

        Add ->
            { model
                | todos = model.inputFieldValue :: model.todos
                , inputFieldValue = ""
            }

        Delete position ->
            { model | todos = removeAt position model.todos }


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


buttonStyle : List (Attribute msg)
buttonStyle =
    [ Border.width 1
    , Border.rounded 5
    , Background.color <| rgba 1 1 0 0.2
    , padding 5
    ]


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


view : Model -> Html.Html Msg
view model =
    layout [] <|
        column
            [ centerX, centerY, spacing 20 ]
            [ row [ spacing 10 ]
                [ Input.text [ onEnter <| Add ]
                    { label = Input.labelLeft [] <| text "Todo"
                    , onChange = OnChange
                    , placeholder = Nothing
                    , text = model.inputFieldValue
                    }
                , Input.button buttonStyle
                    { label = text "Add", onPress = Just Add }
                ]
            , column [ spacing 10 ]
                (List.indexedMap
                    (\index todo ->
                        row [ spacing 10 ]
                            [ Input.button buttonStyle
                                { label = text "Delete", onPress = Just (Delete index) }
                            , text todo
                            ]
                    )
                    model.todos
                )
            , row [ spacing 10 ]
                [ Input.button buttonStyle { label = text "+10", onPress = Just (Increase 10) }
                , Input.button buttonStyle
                    { label = text "+3", onPress = Just (Increase 3) }
                , el [] (text <| String.fromInt model.counter)
                , Input.button buttonStyle { label = text "-1", onPress = Just Decrease }
                ]
            ]



-- div [ class "content" ]
--     [ input [] []
--     , node "style" [] [ text ".content {margin: 40px}" ]
--     , button [ Html.Events.onClick (Increase 20) ] [ text "Increase" ]
--     , p [] [ text (String.fromInt model.counter) ]
--     , button [ Html.Events.onClick Decrease ] [ text "Decrease" ]
--     ]

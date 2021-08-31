module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes
import Html.Events


main : Program () Int Msg
main =
    Browser.sandbox
        { init = 0
        , view = view
        , update = update
        }


type Msg
    = Increase Int
    | Decrease


update : Msg -> Int -> Int
update msg model =
    case msg of
        Increase value ->
            model + value

        Decrease ->
            model - 1


view : Int -> Html Msg
view model =
    div []
        [ button [ Html.Events.onClick (Increase 20) ] [ text "Increase" ]
        , p [] [ text (String.fromInt model) ]
        , button [ Html.Events.onClick Decrease ] [ text "Decrease" ]
        ]

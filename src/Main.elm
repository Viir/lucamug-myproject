module Main exposing (..)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html
import Html.Events
import Json.Decode



-- sandbox :
--     { init : model
--     , view : model -> Html msg
--     , update : msg -> model -> model
--     }
--
-- element :
--     { init : flags -> ( model, Cmd msg )
--     , view : model -> Html msg
--     , update : msg -> model -> ( model, Cmd msg )
--     , subscriptions : model -> Sub msg
--     }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update

        -- (Int -> Int -> msg)
        , subscriptions = \model -> Browser.Events.onResize OnResize
        }


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { counter = 0
      , todos = [ "Todo 1", "Todo 2" ]
      , inputFieldValue = ""
      , width = flags.initialWidth
      }
    , Cmd.none
    )


type alias Flags =
    { initialWidth : Int }


type alias Model =
    { counter : Int
    , todos : List String
    , inputFieldValue : String
    , width : Int
    }


type Msg
    = Increase Int
    | Decrease
    | OnChange String
    | Add
    | Delete Int
    | OnResize Int Int


type Maybe2 a
    = Just2 a
    | Nothing2


email : String
email =
    "a@a.com"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increase value ->
            ( { model | counter = model.counter + value }, Cmd.none )

        Decrease ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        OnChange string ->
            ( { model | inputFieldValue = string }, Cmd.none )

        Add ->
            ( { model
                | todos = model.inputFieldValue :: model.todos
                , inputFieldValue = ""
              }
            , Cmd.none
            )

        Delete position ->
            ( { model | todos = removeAt position model.todos }, Cmd.none )

        OnResize width height ->
            ( { model | width = width }, Cmd.none )


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


buttonStyle : List (Attribute msg)
buttonStyle =
    [ Border.width 1
    , Border.rounded 5
    , Background.color <| rgba 1 1 0 0.2
    , padding 5
    ]


view : Model -> Html.Html Msg
view model =
    layout [] <|
        column
            [ centerX, centerY, spacing 20 ]
            [ text <| String.fromInt model.width
            , Input.text [ onEnter Add ]
                { label = Input.labelLeft [] <| text "Todo"
                , onChange = OnChange
                , placeholder = Nothing
                , text = model.inputFieldValue
                }
            , column [ spacing 10 ]
                (List.indexedMap
                    (\index todo ->
                        row [ spacing 10 ]
                            [ text todo
                            , Input.button buttonStyle
                                { label = text "Delete", onPress = Just (Delete index) }
                            ]
                    )
                    model.todos
                )
            , (if model.width < 600 then
                column

               else
                row
              )
                [ spacing 10 ]
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

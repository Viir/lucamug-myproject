port module Main exposing (..)

import Browser
import Browser.Events
import Codec
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html
import Html.Events
import Json.Decode


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    String


subscriptions : a -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onResize OnResize
        , getStorage GetStorage
        ]


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


type alias Model =
    { counter : Int
    , todos : List String
    , inputFieldValue : String
    , viewport : Int
    }


codecModel : Codec.Codec Model
codecModel =
    Codec.object Model
        |> Codec.field "counter" .counter Codec.int
        |> Codec.field "todos" .todos (Codec.list Codec.string)
        |> Codec.field "inputFieldValue" .inputFieldValue Codec.string
        |> Codec.field "viewport" .viewport Codec.int
        |> Codec.buildObject


type Msg
    = Increase Int
    | Decrease
    | OnChange String
    | Add
    | Delete Int
    | OnResize Int Int
    | GetStorage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds ) =
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

                OnResize x y ->
                    ( { model | viewport = x }, Cmd.none )

                GetStorage storage ->
                    ( Result.withDefault model (Codec.decodeString codecModel storage)
                    , Cmd.none
                    )
    in
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
            [ text <| String.fromInt <| model.viewport
            , (if model.viewport < 400 then
                column

               else
                row
              )
                [ spacing 10 ]
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


port setStorage : String -> Cmd msg


port getStorage : (String -> msg) -> Sub msg

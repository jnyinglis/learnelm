module TrySVG exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode
import Mouse exposing (Position)
import Svg
import Svg.Attributes


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { position : Position
    , drag : Maybe Drag
    }


type alias Drag =
    { start : Position
    , current : Position
    }


init : ( Model, Cmd Msg )
init =
    ( Model (Position 200 200) Nothing, Cmd.none )



-- UPDATE


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg ({ position, drag } as model) =
    case msg of
        DragStart xy ->
            Model position (Just (Drag xy xy))

        DragAt xy ->
            Model position (Maybe.map (\{ start } -> Drag start xy) drag)

        DragEnd _ ->
            Model (getPosition model) Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


view : Model -> Html Msg
view model =
    let
        realPosition =
            getPosition model
    in
        div
            [ onMouseDown
            , style
                [ ("background-color", "#3C8D2F")
                , "cursor" => "move"
                , "width" => "100px"
                , "height" => "100px"
                , "border-radius" => "4px"
                , "position" => "absolute"
                , "left" => px realPosition.x
                , "top" => px realPosition.y

                --
                --          , "color" => "white"
                , "display" => "flex"
                , "align-items" => "center"
                , "justify-content" => "center"
                ]
            ]
            --      [ text "Drag Me!"
            --      ]
            [ Svg.svg
                [ width 80
                , height 80
                , Svg.Attributes.viewBox "0 0 60 60"
                ]
                [ Svg.g [ Svg.Attributes.transform "translate(0, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "10", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(8, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "20", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(16, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "40", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(24, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "60", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(32, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "40", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(40, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "20", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                , Svg.g [ Svg.Attributes.transform "translate(48, 0)" ]
                    [ Svg.rect [ Svg.Attributes.height "10", Svg.Attributes.y "0", Svg.Attributes.width "5" ] [] ]
                ]
            ]


px : Int -> String
px number =
    toString number ++ "px"


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)


onMouseDown : Attribute Msg
onMouseDown =
    on "mousedown" (Decode.map DragStart Mouse.position)

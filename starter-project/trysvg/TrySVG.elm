module TrySVG exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Widgets exposing (..)


type Msg
    = Msg1
    | Msg2


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias PropertyType =
    Int


type alias Model =
    { property : PropertyType
    }

type alias Myvalue =
    { one : Int
    , two : Int
    , three : Int
    , four : Int
    }

type alias Myvalues = List Myvalue

modelInitialValue : Model
modelInitialValue =
    { property = 1
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
            ( model, Cmd.none )

        Msg2 ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        x = [ Myvalue 1 2 3 4
            , Myvalue 2 4 6 8
            , Myvalue 3 6 9 12
            , Myvalue 4 8 12 16
            , Myvalue 5 10 15 20
            , Myvalue 4 8 12 16
            , Myvalue 3 6 9 12
            , Myvalue 2 4 6 8
            , Myvalue 1 2 3 4
        ]
    in
        
    div []
        [ div []
            [ text "New Html Program"
            ]
        , div []
            [ text "More text"
            ]
        , div []
            [ text "Even more text"
            ]
        , div []
            [ sparkChart 40 40 [ 10, 20, 30, 40, 50, 60, 70, 0, -10, -20 ]
            ]
        , div []
            [ List.range 40 100
                |> sparkChart 80 80
            ]
        , div []
            [ sparkChart 100 100 (List.range 40 100)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( modelInitialValue, Cmd.none )

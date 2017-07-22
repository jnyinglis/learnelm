module Website exposing (..)

import Html exposing (..)
import Html.Attributes exposing(style)
import HandBakedSite
import BootstrapSite


-- MODEL


type alias Model =
    {displayHandBaked : Bool }


initialModel : Model
initialModel =
    {displayHandBaked = False }



-- UPDATE


type Msg
        = DisplayHandBaked
        | DisplayBootstrap


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ( model, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    let
        handBakedStyle =
            case model.displayHandBaked of
                    True -> ("display", "none")
                    False -> ("display", "none")
    in
        div []
            [ div [ style [ handBakedStyle ] ] [ HandBakedSite.view HandBakedSite.initialModel ]
            , div [ style [ ("display", "none") ] ] [ BootstrapSite.view BootstrapSite.initialModel ]
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

module Website exposing (..)

import Html exposing (..)
import HandBakedSite
import BootstrapSite


-- MODEL


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg = WhichWebsite


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ( model, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    div []
        [ HandBakedSite.view HandBakedSite.initialModel
        , BootstrapSite.view BootstrapSite.initialModel
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

module BootstrapSite exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Card as Card
import Bootstrap.Button as Button


-- MODEL


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = BootstrapSite


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html msg
view model =
    node "bootstrap-site"
        [ attribute "data-bootstrap" "" ]
        [ Grid.container []
            [ h1 [] [ text "Home" ]
            , Grid.row []
                [ Grid.col []
                    [ Card.config [ Card.outlinePrimary ]
                        |> Card.headerH4 [] [ text "Getting started" ]
                        |> Card.block []
                            [ Card.text [] [ text "Getting stared should be easy. Just need to practice." ]
                            , Card.custom <|
                                Button.linkButton
                                    [ Button.primary, Button.attrs [ href "#getting-started" ] ]
                                    [ text "Start" ]
                            ]
                        |> Card.view
                    ]
                , Grid.col []
                    [ Card.config [ Card.outlineDanger ]
                        |> Card.headerH4 [] [ text "Modules" ]
                        |> Card.block []
                            [ Card.text [] [ text "Check out the modules overview." ]
                            , Card.custom <|
                                Button.linkButton
                                    [ Button.primary, Button.attrs [ href "#modules" ] ]
                                    [ text "Module" ]
                            ]
                        |> Card.view
                    ]
                ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

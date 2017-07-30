module MaterialDesignSite exposing (..)

import Html exposing (div, text, Html, h1)
import Html.Attributes exposing (href, class, style)
import Material.Layout as Layout
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options
import Material.Color as Color


-- MODEL


type alias Model =
    { count : Int
    , mdl : Material.Model -- Boilerplate
    , selectedTab : Int
    }



-- Material.model provides the initial model


model : Model
model =
    { count = 0
    , mdl = Material.model -- Boilerplate: Always use this inital Mdl model store.
    , selectedTab = 0
    }



-- ACTION, UPDATE
-- You need to tage 'Msg' that are coming from 'Mdl' so you can dispatch them
-- appropriately.


type Msg
    = Increase
    | Reset
    | Mdl (Material.Msg Msg) -- Boilerplate
    | SelectTab Int



-- Boilerplate: Msg clause for internal Mdl messages.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increase ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Reset ->
            ( { model | count = 0 }
            , Cmd.none
            )

        -- When the 'Mdl' messages come through, update appropriately.
        Mdl msg ->
            Material.update Mdl msg model

        SelectTab num ->
            { model | selectedTab = num } ! []



--  VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = [ h1 [ style [ ( "padding", "2rem" ) ] ] [ text "Counter" ] ]
            , drawer = []
            , tabs = ( [ text "Milk", text "Oranges" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    case model.selectedTab of
        0 ->
            viewCounter model

        1 ->
            text "something else"

        _ ->
            text "404"


viewCounter : Model -> Html Msg
viewCounter model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Current count: " ++ toString model.count)
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick Increase
            , Options.css "margin" "0 24px"
            ]
            [ text "Increase " ]
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Reset ]
            [ text "Reset" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }

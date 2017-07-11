module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Random
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode

-- MODEL

type GameState = EnteringName | Playing

type alias Model =
    { name : String
    , gameNumber : Int
    , entries : List Entry
    , alertMessage : Maybe String
    , nameInput : String
    , gameState : GameState
    }

type alias Entry = 
    { id : Int
    , phrase : String
    , points : Int
    , marked : Bool
    }

type alias Score =
    { id : Int
    , name : String
    , score : Int
    }

initialModel : Model
initialModel =
    { name = "Anonymous"
    , gameNumber = 1
    , entries = []
    , alertMessage = Maybe.Nothing
    , nameInput = ""
    , gameState = EnteringName
--    , entries = initialEntries
    }

--initialEntries : List Entry
--initialEntries =
--    [ Entry 1 "Future-Proof" 100 False -- { id = 1, phrase = "Future-proof", points = 100, marked = False }
--    , Entry 2 "Doing Agile" 200 False -- { id = 2, phrase = "Doing Agile", points = 200, marked = False } 
--    , Entry 3 "In The Cloud" 300 False
--    , Entry 4 "Rock-Star Ninja" 400 False
--    ]

-- UPDATE

type Msg
    = NewGame
    | Mark Int
    | NewRandom Int
    | NewEntries (Result Http.Error (List Entry))
    | CloseAlert
    | ShareScore
    | NewScore (Result Http.Error Score)
    | SetNameInput String
    | SaveName
    | CancelName
    | ChangeGameState GameState

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        sortByDesc a list = List.reverse (List.sortBy a list)
    in
        case msg of
            ChangeGameState state ->
                ( { model | gameState = state }, Cmd.none )

            SaveName ->
                ( { model | name = model.nameInput,
                            nameInput = "",
                            gameState = Playing}, Cmd.none )

            CancelName ->
                ( { model | nameInput = "", gameState = Playing }, Cmd.none )

            SetNameInput value ->
                ( { model | nameInput = value }, Cmd.none )

            NewRandom randomNumber ->
                ( { model | gameNumber = randomNumber }, Cmd.none )
    
            ShareScore ->
                ( model, postScore model )

            NewScore (Ok score) ->
                let
                    message =
                        "Your score of " 
                            ++ (toString score.score)
                            ++ " was successfully shared!"
                in
                    ( { model | alertMessage = Just message }, Cmd.none )
                    
            NewScore (Err error) ->
                let
                    message =
                        "Error posting your score: " 
                            ++ (toString error)
                in
                    ( { model | alertMessage = Just message }, Cmd.none )

            NewGame ->
                ( { model | gameNumber = model.gameNumber + 1 }, getEntries)
    
            NewEntries (Ok randomEntries) ->
                ( { model | entries = sortByDesc .points randomEntries }, Cmd.none )
    
            NewEntries (Err error) ->
                let
                    errorMessage =
                        case error of
                            Http.NetworkError ->
                                "Is the server running?"

                            Http.BadStatus response ->
                                (toString response.status)

                            Http.BadPayload message _ ->
                                "Decoding Failed: " ++ message

                            _ ->
                                (toString error)
                in
                    ( { model | alertMessage = Just errorMessage }, Cmd.none)
    
            CloseAlert ->
                ( { model | alertMessage = Maybe.Nothing }, Cmd.none )
            Mark id ->
                let
                    markEntry e =
                        if e.id == id then
                            { e | marked = (not e.marked) }
                        else
                            e
                in
                ( { model | entries = List.map markEntry model.entries }, Cmd.none )

-- DECODERS/ENCODERS

entryDecoder : Decoder Entry
entryDecoder =
    Decode.map4 Entry
        (field "id" Decode.int)
        (field "phrase" Decode.string)
        (field "points" Decode.int)
        (succeed False)

scoreDecoder : Decoder Score
scoreDecoder =
    Decode.map3 Score
        (field "id" Decode.int)
        (field "name" Decode.string)
        (field "score" Decode.int)

encodeScore : Model -> Encode.Value
encodeScore model =
            Encode.object
                [ ("name", Encode.string model.name)
                , ("score", Encode.int (sumMarkedPoints model.entries))
                ]

-- COMMANDS

generateRandomNumber : Cmd Msg
generateRandomNumber =
--    Random.generate (\num -> NewRandom num) (Random.int 1 100)
    Random.generate NewRandom (Random.int 1 100)

apiUrlPrefix : String
apiUrlPrefix =
    "http://localhost:3000"

entriesUrl : String
entriesUrl =
    apiUrlPrefix ++ "/random-entries"

postScoresUrl : String
postScoresUrl =
    apiUrlPrefix ++ "/scores"

postScore : Model -> Cmd Msg
postScore model =
    let
        url =
            postScoresUrl

        body =
            encodeScore model
                |> Http.jsonBody

        request =
            Http.post url body scoreDecoder
    in
        Http.send NewScore request

getEntries : Cmd Msg
getEntries =
--    Http.send NewEntries (Http.getString entriesUrl)
    (Decode.list entryDecoder)
        |> Http.get entriesUrl
        |> Http.send NewEntries

    -- send : (Result Http.Error String -> Msg) -> Request String -> Cmd Msg

-- VIEW

hasZeroScore : Model -> Bool
hasZeroScore model =
    (sumMarkedPoints model.entries) == 0

view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ viewHeader "BUZZWORD BINGO"
        , viewPlayer model.name model.gameNumber
        , viewAlertMessage model.alertMessage
        , viewNameInput model
        , viewEntryList model.entries
        , viewScore (sumMarkedPoints model.entries)
        , div [ class "button-group" ]
              [ button [ onClick NewGame ] [ text "New Game" ]
              , button [ onClick ShareScore, disabled (hasZeroScore model) ] [ text "Share Score"]
              ]
        , div [ class "debug" ] [ text (toString model) ]
        , viewFooter
        ]

viewNameInput : Model -> Html Msg
viewNameInput model =
    case model.gameState of
        EnteringName ->
            div [ class "name-input" ]
                [ input
                    [ type_ "text"
                    , placeholder "Who's playing?"
                    , autofocus True
                    , value model.nameInput
                    , onInput SetNameInput
                    ]
                    []
                , button [ onClick SaveName ] [ text "Save" ]
                , button [ onClick CancelName ] [ text "Cancel" ]
                ]
            
        Playing ->
            text ""

viewAlertMessage : Maybe String -> Html Msg
viewAlertMessage alertMessage =
    case alertMessage of
        Just message ->
            div [ class "alert" ]
                [ span [ class "close", onClick CloseAlert ] [ text "X" ]
                , text message
                ]
        
        Maybe.Nothing ->
            text ""

viewPlayer : String -> Int -> Html Msg
viewPlayer name gameNumber =
    h2 [ id "info", class "classy" ]
        [ a [ href "", onClick (ChangeGameState EnteringName)]
            [ text name ]
        , text (" - Game #" ++ (toString gameNumber)) 
        ]

viewHeader : String -> Html Msg
viewHeader title =
    header []
        [ h1 [] [ text title ] ]

viewFooter : Html Msg
viewFooter =
    footer []
        [ a [ href "http://elm-lang.org" ]
            [ text "Powered by Elm" ]
        ]
viewEntryItem : Entry -> Html Msg
viewEntryItem entry =
    li [ classList [ ("marked", entry.marked) ], onClick (Mark entry.id) ]
        [ span [ class "phrase" ] [ text entry.phrase ]
        , span [ class "points" ] [ text (toString entry.points) ]
        ]

viewEntryList : List Entry -> Html Msg
viewEntryList entries =
    let
        listOfEntries =
            List.map viewEntryItem entries
    in
        ul [ ] listOfEntries

sumMarkedPoints : List Entry -> Int
sumMarkedPoints entries =
--  let
--      markedEntries =
--          List.filter .marked entries
--      pointValues =
--          List.map .points markedEntries
--  in
--      List.sum pointValues
    entries
        |> List.filter .marked
        |> List.map .points
        |> List.sum

viewScore : Int -> Html Msg
viewScore sum =
    div
        [ class "score" ]
        [ span [ class "label" ] [ text "Score" ]
        , span [ class "value" ] [ text (toString sum) ]
        ]

main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getEntries )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none )
        }
                    
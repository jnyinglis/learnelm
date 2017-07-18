module HandBakedSite exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = HandBakedSite


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW

navigationEntry : String -> Html msg
navigationEntry string =
    li []
        [ a [ href "" ]
            [ text string ]
        ]

view : Model -> Html msg
view model =
    node "handbaked-site"
        [ attribute "data-handbaked" "" ]
        [ header []
            [ div []
                [ nav []
                    [ ul []
                        [ navigationEntry "Home"
                        , navigationEntry "About"
                        , navigationEntry "Contact"
                        , navigationEntry "Login"
                        ]
                    ]
]
            ]
        , div []
            [ text "Hello, World!"
            ]
        , footer []
            []
        ]



{-
   <header>
       <div>
           <nav>
               <ul>
                   <li>
                       <a href="">Home</a>
                   </li>
                   <li>
                       <a href="">About</a>
                   </li>
                   <li>
                       <a href="">Contact</a>
                   </li>
                   <li>
                       <a href="">Login</a>
                   </li>
               </ul>
           </nav>
       </div>
   </header>
   <div>
       <text>Hello, World!</text>
   </div>
   <footer>
   </footer>
-}

main : Program Never Model Msg
main =
    Html.program
        { init = (initialModel, Cmd.none)
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
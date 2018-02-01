module App exposing (main)

import Element exposing (..)
import Html
import Keyboard
import Layout exposing (..)
import Time


type alias Model =
    { height : Int
    , player : Player
    , width : Int
    , zombies :
        List Zombie
    }


type alias Player =
    { health : Int, x : Int, y : Int, state : SpriteState }


type alias Zombie =
    { speed : Int, state : SpriteState, x : Int, y : Int }


type SpriteState
    = First
    | Second
    | Collided


initModel : Model
initModel =
    { width = 1000
    , height = 1000
    , zombies =
        [ { x = 0, y = 0, speed = 4, state = First }
        , { x = 100, y = 0, speed = 5, state = Second }
        , { x = 200, y = 0, speed = 8, state = First }
        , { x = 300, y = 0, speed = 3, state = Second }
        , { x = 400, y = 0, speed = 10, state = First }
        ]
    , player = { x = 0, y = 550, health = 100, state = First }
    }


type Msg
    = Noop
    | Tick Time.Time
    | KeyPressed Keyboard.KeyCode


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : a -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (Time.millisecond * 200) Tick
        , Keyboard.presses KeyPressed
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        Tick time ->
            let
                newZombies =
                    List.map (tickZombie model.player) model.zombies
            in
            ( { model | zombies = newZombies }, Cmd.none )

        KeyPressed 106 ->
            let
                player =
                    model.player

                player_ =
                    { player | x = model.player.x - 10 }
            in
            ( { model | player = player_ }, Cmd.none )

        KeyPressed 107 ->
            let
                player =
                    model.player

                player_ =
                    { player | x = model.player.x + 10 }
            in
            ( { model | player = player_ }, Cmd.none )

        KeyPressed x ->
            let
                blah =
                    Debug.log "keycode" x
            in
            ( model, Cmd.none )


tickZombie : Player -> Zombie -> Zombie
tickZombie player zombie =
    let
        collision =
            if zombie.y + 50 >= player.y && zombie.y <= player.y + 50 then
                if zombie.x + 50 >= player.x && zombie.x <= player.x + 50 then
                    Collided
                else
                    -- no collision
                    zombie.state
            else
                -- no collision
                zombie.state
    in
    { zombie
        | y =
            if collision == Collided then
                zombie.y
            else
                zombie.y + zombie.speed
        , state =
            if collision == Collided then
                Collided
            else
                flipNormalState zombie.state
    }


flipNormalState : SpriteState -> SpriteState
flipNormalState state =
    case state of
        First ->
            Second

        Second ->
            First

        _ ->
            First


view : Model -> Html.Html Msg
view model =
    column [] [ gameBoard model, introText ]
        |> layout [ width fill, height fill, bgGrey ]


introText : Element msg
introText =
    el [ fontWhite ] <| text "Press j/k to move left/right and catch all the vegan zombies!"


viewPlayer : Model -> Element msg
viewPlayer model =
    el
        [ height <| px 50
        , width <| px 50
        , alignLeft
        , absolute
        , moveRight <| toFloat model.player.x
        , moveDown <| toFloat model.player.y
        ]
    <|
        image [ 50 / 110 |> scale ]
            { src =
                case model.player.state of
                    First ->
                        "/public/sprites/player_walk1.png"

                    Second ->
                        "/public/sprites/player_walk2.png"

                    Collided ->
                        "/public/sprites/player_fall.png"
            , description = ""
            }


viewZombie : Zombie -> Element msg
viewZombie zombie =
    el [ absolute, height <| px 50, width <| px 50, moveRight <| toFloat zombie.x, moveDown <| toFloat zombie.y, alignLeft ] <|
        image [ 50 / 110 |> scale ]
            { src =
                case zombie.state of
                    First ->
                        "/public/sprites/zombie_action1.png"

                    Second ->
                        "/public/sprites/zombie_action2.png"

                    Collided ->
                        "/public/sprites/zombie_cheer1.png"
            , description = ""
            }


gameBoard : Model -> Element msg
gameBoard model =
    column [ center, width (px 600), height (px 600), bgPurple, inFront True (viewStuff model) ] []


viewStuff : Model -> Element msg
viewStuff model =
    column [ width (px 600), height (px 600) ]
        ([ viewPlayer model
         ]
            ++ List.map viewZombie model.zombies
        )

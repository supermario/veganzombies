module Layout exposing (..)

import Color exposing (..)
import Color.Convert exposing (hexToColor)
import Element as E exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes


fromHex : String -> Color
fromHex str =
    case hexToColor str of
        Ok col ->
            col

        Err _ ->
            red


h3 =
    hx 40


h4 =
    hx 30


hx fontSize element =
    E.el [ fontWhite, Font.size fontSize ] element


bgGrey =
    Background.color <| fromHex "#222"


bgOrange =
    Background.color <| fromHex "#ffab40"


bgPurple =
    Background.color <| fromHex "#7c4dff"


fontWhite =
    Font.color <| fromHex "#fff"


bgGreen =
    Background.color green


bgStriped =
    attribute <|
        Html.Attributes.style
            [ ( "background", "repeating-linear-gradient(45deg,#222,#222 60px,#333 60px,#333 120px)" ) ]


absolute =
    attribute <|
        Html.Attributes.style
            [ ( "position", "absolute" ) ]


green =
    fromHex "#159587"

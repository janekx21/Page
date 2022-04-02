module Util exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


infoBox =
    el box <| text "Thank you"


box =
    [ centerX, centerY, Border.color white, Border.width 1, padding 32 ]


black =
    rgb 0 0 0


white =
    rgb 1 1 1


focusColor =
    rgb255 255 99 99


hoverColor =
    rgb255 255 165 109


note : String -> Element msg
note txt =
    el [ moveLeft 16, moveDown 32, inFront <| image [ alignRight, width (px 16) ] { src = "assets/corner.svg", description = "corner" }, onLeft <| image [ alignBottom, moveRight 2 ] { src = "assets/indicator.svg", description = "indicator" } ] <|
        column [ padding 16, Border.color white, Border.width 1, spacing 6 ]
            (txt |> String.split "\n" |> List.map text)


inputStyle : List (Element.Attribute msg)
inputStyle =
    [ Background.color black
    , Border.color white
    , Border.width 1
    , Border.rounded 0
    , spacing 12
    , mouseOver [ Border.color hoverColor ]
    ]


buttonStyle : List (Element.Attribute msg)
buttonStyle =
    [ width (fill |> minimum 120)
    , padding 12
    , Font.center
    , Background.color black
    , Border.color white
    , Border.width 1
    , mouseOver [ Border.color hoverColor ]
    , mouseDown [ Background.color focusColor ]
    ]

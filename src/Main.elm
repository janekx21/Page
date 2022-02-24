module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, div)
import Html.Attributes exposing (href, rel)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }


type alias Model =
    { username : String, password : String }


init : Model
init =
    { username = "", password = "" }


type Msg
    = SetUsername String
    | SetPassword String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetUsername username ->
            { model | username = username }

        SetPassword password ->
            { model | password = password }


view : Model -> Html Msg
view model =
    layoutWith
        options
        [ width fill
        , height fill
        , Font.size 16
        , Background.color black
        , Font.color white
        , Font.light
        , Font.family
            [ Font.external { url = "https://fonts.googleapis.com/css2?family=Raleway:wght@300&display=swap", name = "Raleway" }
            , Font.sansSerif
            ]
        , behindContent <| html styleLink
        ]
    <|
        box model


styleLink =
    Html.node "link" [ rel "stylesheet", href "/assets/style.css" ] []


options =
    { options =
        [ focusStyle
            { backgroundColor = Nothing
            , borderColor = Just focusColor
            , shadow = Nothing
            }
        ]
    }


box : Model -> Element Msg
box model =
    column [ centerX, centerY, Border.color white, Border.width 1, padding 32, spacing 16 ]
        [ Input.username (inputStyle ++ [ Input.focusedOnLoad ])
            { onChange = SetUsername
            , text = model.username
            , placeholder = Nothing
            , label = Input.labelLeft [ width (px 80) ] <| text "Username"
            }
        , Input.currentPassword inputStyle
            { onChange = SetPassword
            , text = model.password
            , placeholder = Nothing
            , label = Input.labelLeft [ width (px 80) ] <| text "Password"
            , show = False
            }
        , el [ alignRight ] <| Input.button buttonStyle { onPress = Nothing, label = text "Login" }
        ]


inputStyle : List (Element.Attribute msg)
inputStyle =
    [ Background.color black
    , Border.color white
    , Border.width 1
    , Border.rounded 0
    , mouseOver [ Border.color hoverColor ]
    , spacing 12
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
    ]


black =
    rgb 0 0 0


white =
    rgb 1 1 1


focusColor =
    rgb255 255 99 99


hoverColor =
    rgb255 255 165 109

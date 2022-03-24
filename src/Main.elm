module Main exposing (..)

import Animation
import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (href, rel)
import LoginDialog
import Util exposing (..)


main : Program () Model Msg
main =
    Browser.element { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.user of
        Just user ->
            Animation.subscription (LoginDialogMsg << LoginDialog.Animate) [ user.style ]

        Nothing ->
            Sub.none


type alias Model =
    { user : Maybe (LoginDialog.LoginDialog Msg)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { user = Just LoginDialog.init }
    , Cmd.none
    )


type Msg
    = LoginDialogMsg LoginDialog.Msg
    | ShowInfo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginDialogMsg userMsg ->
            model.user
                |> Maybe.map (LoginDialog.update userMsg ShowInfo)
                |> Maybe.map (\( user, cmd ) -> ( { model | user = Just user }, cmd ))
                |> Maybe.withDefault ( model, Cmd.none )

        ShowInfo ->
            ( { model | user = Nothing }, Cmd.none )


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
        case model.user of
            Just user ->
                LoginDialog.view user |> Element.map LoginDialogMsg

            Nothing ->
                infoBox


options =
    { options =
        [ focusStyle
            { backgroundColor = Nothing
            , borderColor = Just focusColor
            , shadow = Nothing
            }
        ]
    }


styleLink =
    Html.node "link" [ rel "stylesheet", href "/assets/style.css" ] []

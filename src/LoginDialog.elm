module LoginDialog exposing (..)

import Animation
import Animation.Messenger exposing (State)
import Element exposing (..)
import Element.Input as Input
import Util exposing (..)


type alias LoginDialog onLogin =
    { username : String
    , password : String
    , style : State onLogin
    }


init : LoginDialog onLogin
init =
    { username = "", password = "", style = Animation.style [ Animation.scale3d 1 1 1, Animation.blur (Animation.px 0) ] }


type Msg
    = SetUsername String
    | SetPassword String
    | Login
    | Animate Animation.Msg


update : Msg -> onLogin -> LoginDialog onLogin -> ( LoginDialog onLogin, Cmd onLogin )
update msg onLogin user =
    case msg of
        SetUsername username ->
            { user | username = username } |> noCmd

        SetPassword password ->
            { user | password = password } |> noCmd

        Login ->
            let
                newStyle =
                    Animation.interrupt
                        [ Animation.toWith linear [ Animation.scale3d 1.1 0.1 1, Animation.blur (Animation.px 4) ]
                        , Animation.toWith linear [ Animation.scale3d 0 0 1 ]
                        , Animation.Messenger.send onLogin
                        ]
                        user.style
            in
            { user | style = newStyle } |> noCmd

        Animate animMsg ->
            let
                ( style, cmd ) =
                    Animation.Messenger.update animMsg user.style
            in
            ( { user | style = style }, cmd )


view : LoginDialog onLogin -> Element Msg
view user =
    let
        st =
            user.style
                |> Animation.render
                |> List.map Element.htmlAttribute
    in
    column (box ++ st ++ [ spacing 16, onRight <| el [ moveRight 32, above <| note noteText ] none ])
        [ Input.username (inputStyle ++ [ Input.focusedOnLoad ])
            { onChange = SetUsername
            , text = user.username
            , placeholder = Nothing
            , label = Input.labelLeft [ width (px 80) ] <| text "Username"
            }
        , Input.currentPassword inputStyle
            { onChange = SetPassword
            , text = user.password
            , placeholder = Nothing
            , label = Input.labelLeft [ width (px 80) ] <| text "Password"
            , show = False
            }
        , el [ alignRight ] <| Input.button buttonStyle { onPress = Just <| Login, label = text "Login" }
        ]


noCmd : model -> ( model, Cmd msg )
noCmd model =
    ( model, Cmd.none )


linear =
    Animation.easing { duration = 100, ease = \t -> t }


noteText =
    "This is not a real login.\nThis is just a mock up."

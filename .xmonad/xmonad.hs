import XMonad
import XMonad.Util.EZConfig(additionalKeysP)

main = do
    -- xmproc <- spawnPipe "/path/to/xmobar"
    xmonad $ defaultConfig
        { modMask = mod4Mask
        , terminal = "urxvt"
        } `additionalKeysP`
        [ ("<XF86ScreenSaver>", spawn "xscreensaver-command -lock")
        ]

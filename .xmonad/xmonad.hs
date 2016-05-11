import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Run(spawnPipe)

main = do
    xmproc <- spawnPipe "/run/current-system/sw/bin/xmobar /home/dance/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , modMask = mod4Mask
        , terminal = "urxvt"
        } `additionalKeysP`
        [ ("<XF86ScreenSaver>", spawn "xscreensaver-command -lock")
        ]

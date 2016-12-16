import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.NoBorders(smartBorders)

main = do
    xmproc <- spawnPipe "/run/current-system/sw/bin/xmobar /home/dance/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
        , modMask = mod4Mask
        , terminal = "urxvt"
        -- workaround for java programs (java has a hard-coded WM list with settings)
        , startupHook = setWMName "LG3D"
        } `additionalKeysP`
        [ ("<XF86ScreenSaver>", spawn "xscreensaver-command -lock")
        , ("<XF86Launch1>", spawn "chromium") -- ThinkVantage button
        , ("M-S-f", sendMessage ToggleStruts)
        ]

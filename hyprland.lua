-- ========================================================
--  HYPRLAND+ CONFIG
-- ========================================================
--  Modified by Viv
--
--  A clean, optimized Hyprland configuration
--  focused on smooth animations and usability.
--  oh yeah and from now on you will never question your life, this is a better version
-- ========================================================


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------

hl.exec_cmd("sh -c 'pgrep -x hyprpaper >/dev/null || hyprpaper'")
hl.exec_cmd("sh -c 'pgrep -x waybar >/dev/null || waybar'")


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
          inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },

    misc = {
        force_default_wallpaper = -1,
            disable_hyprland_logo   = false,
    },
})


-- Animations (curves + leaves)

hl.curve("smooth", {
    type   = "bezier",
    points = {
        {0.23, 1},
        {0.32, 1},
    },
})

hl.curve("spring", {
    type      = "spring",
    mass      = 1,
    stiffness = 80,
    dampening = 12,
})

hl.animation({ leaf = "global",  enabled = true, speed = 8, bezier = "smooth" })
hl.animation({ leaf = "border",  enabled = true, speed = 5, bezier = "smooth" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "spring" })

hl.animation({
    leaf    = "windowsIn",
    enabled = true,
    speed   = 4,
    spring  = "spring",
    style   = "popin 85%",
})

hl.animation({
    leaf    = "windowsOut",
    enabled = true,
    speed   = 3,
    bezier  = "smooth",
    style   = "popin 85%",
})

hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "smooth" })

hl.animation({
    leaf    = "workspaces",
    enabled = true,
    speed   = 4,
    bezier  = "smooth",
    style   = "fade",
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDS ----
---------------------

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Window control
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Power menu
-- NOTE: the fallback branch must use the raw hyprctl dispatcher name ("exit"),
-- not the Lua API call syntax (hl.dsp.exit()) — that syntax only exists inside
-- this config file, hyprctl itself has no idea what to do with it.
hl.bind(
    mainMod .. " + M",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
    )
)

-- Window focus
local directions = {
    left  = "left",
    right = "right",
    up    = "up",
    down  = "down",
}

for key, direction in pairs(directions) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    end

    -- Workspaces
    for i = 1, 10 do
        local key = i % 10

        -- Switch workspace
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

        -- Move window to workspace
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Scratchpad
        hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
        hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

        -- Mouse window control
        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Audio controls
        local audio = {
            volume_up   = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
            volume_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
            mute        = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        }

        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(audio.volume_up),   { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(audio.volume_down), { locked = true, repeating = true })
        hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(audio.mute),        { locked = true, repeating = true })

        -- Brightness
        hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

        -- Media
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),        { locked = true })
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),    { locked = true })


        --------------------------------
        ---- WINDOWS AND WORKSPACES ----
        --------------------------------

        -- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
        -- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

        -- Ignore maximize requests from all apps. You'll probably like this.
        local suppressMaximizeRule = hl.window_rule({
            name  = "suppress-maximize-events",
            match = { class = ".*" },

            suppress_event = "maximize",
        })
        -- suppressMaximizeRule:set_enabled(false)

        -- Fix some dragging issues with XWayland
        hl.window_rule({
            name  = "fix-xwayland-drags",
            match = {
                class      = "^$",
                title      = "^$",
                xwayland   = true,
                float      = true,
                fullscreen = false,
                pin        = false,
            },

            no_focus = true,
        })

        -- Layer rules also return a handle.
        -- local overlayLayerRule = hl.layer_rule({
        --     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

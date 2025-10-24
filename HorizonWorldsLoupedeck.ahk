#Requires AutoHotkey v2
ReleaseLag := 250          ; ms after LAST dial tick before releasing keys
EscDelay   :=  90          ; ms after RMB-up before Esc (kills pop-up)

RmbHeld  := false
KeyHeld  := ""             ; "" | "e" | "q"

HoldKey(letter) {
    global RmbHeld, KeyHeld, ReleaseLag
    if (KeyHeld = letter) {           ; already holding correct key
        SetTimer ReleaseAll, -ReleaseLag
        return
    }
    if (KeyHeld)                      ; release wrong key first
        Send "{" KeyHeld " up}"
    if (!RmbHeld) {
        Click "Right","Down"          ; hold RMB once
        RmbHeld := true
    }
    Send "{" letter " down}"          ; hold new key
    KeyHeld := letter
    SetTimer ReleaseAll, -ReleaseLag
}

F13::HoldKey("e")    ; dial-CW → crane UP   (hold E)
F14::HoldKey("q")    ; dial-CCW → crane DOWN (hold Q)

ReleaseAll() {
    global RmbHeld, KeyHeld, EscDelay
    if (KeyHeld) {
        Send "{" KeyHeld " up}"
        KeyHeld := ""
    }
    if (RmbHeld) {
        Click "Right","Up"
        Sleep EscDelay           ; let menu appear, then dismiss
        Send "{Esc}"
        RmbHeld := false
    }
}

; ─── horizontal spin ───
SpinStep  :=  30    ; pixels per tick  (↑ faster spin)
SpinLag   := 200   ; ms after LAST tick before releasing RMB
EscDelayS :=  90   ; menu-clear delay

RmbSpinHeld := false

SpinStepDir(dx){                 ; dx = +SpinStep or -SpinStep
    global RmbSpinHeld, SpinLag
    if !RmbSpinHeld {
        Click "Right","Down"
        RmbSpinHeld := true
    }
    MouseMove dx,0,0,"R"         ; drag horizontally
    SetTimer EndSpin, -SpinLag
}

F15:: SpinStepDir(  SpinStep)    ; dial-CW  → spin right
F16:: SpinStepDir( -SpinStep)    ; dial-CCW → spin left

; ─── vertical spin (face-first) ───
SpinStepV :=  30                    ; pixels per tick  (↑ faster tilt)

SpinStepDirV(dy) {                  ; dy = +SpinStepV or -SpinStepV
    global RmbSpinHeld, SpinLag
    if !RmbSpinHeld {
        Click "Right","Down"
        RmbSpinHeld := true
    }
    MouseMove 0,dy,0,"R"            ; drag vertically
    SetTimer EndSpin, -SpinLag
}

F17:: SpinStepDirV( -SpinStepV)     ; dial-CW  → tilt forward  (mouse up)
F18:: SpinStepDirV(  SpinStepV)     ; dial-CCW → tilt back     (mouse down)

; ─── single EndSpin ───
EndSpin() {
    global RmbSpinHeld, EscDelayS
    Click "Right","Up"
    Sleep EscDelayS
    Send "{Esc}"
    RmbSpinHeld := false
}

; ── camera-speed dial ───────────────────────────
SpeedLag   := 200   ; ms after LAST tick before RMB-up
EscDelaySp :=  90   ; menu-clear delay (same idea as spin)

RmbSpeedHeld := false

SpeedStep(dir){                 ; dir = +1 (wheel up)  or  -1 (wheel down)
    global RmbSpeedHeld, SpeedLag
    if !RmbSpeedHeld {
        Click "Right","Down"    ; hold RMB once
        RmbSpeedHeld := true
    }
    if (dir=1)
        Click "WheelUp"         ; speed up
    else
        Click "WheelDown"       ; slow down
    SetTimer EndSpeed, -SpeedLag
}

F19:: SpeedStep( 1)             ; dial-CW  → faster
F20:: SpeedStep(-1)             ; dial-CCW → slower

EndSpeed() {
    global RmbSpeedHeld, EscDelaySp
    Click "Right","Up"
    Sleep EscDelaySp
    Send "{Esc}"
    RmbSpeedHeld := false
}
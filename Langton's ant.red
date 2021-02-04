Red [
   Title: "Langton's ant"
   Author: "Galen Ivanov"
   Date: 04-02-2021
   Needs 'view
]

img-ant: load %Ant_32.png
cell-size: 32
n-cells: 20
color1: beige
color2: aqua
pos: 1x1 * ( n-cells / 2 + 1 ) + 1
rot: 180
speed: 5
steps: 0
run: true
instr: "Turn the mouse wheel over the yellow square to change the animation speed"

make-id: function [ pair ][ to set-word! rejoin ["c" pair] ]

board: collect [
    keep [ pen white ]
    repeat y n-cells [
        repeat x n-cells [
            keep compose [
                ( make-id as-pair x y )
                fill-pen ( color1 )
                box ( as-pair x - 1 * cell-size y - 1 * cell-size )
                    ( as-pair     x * cell-size     y * cell-size )
            ]
        ]
    ]
    keep compose [
        ant: translate ( pos * cell-size )
        rotate 180 16x16 [ image img-ant ]
    ]
]

update-ant: does [
    steps: steps + 1
    steps-txt/text: rejoin [ "Steps: " steps ]
    id-series: find board make-id pos
    col: pick id-series 3

    set [ col sign ] reduce pick [ [ color2 1 ] [ color1 -1 ] ] col = color1
    pos: ( pick [ 0x1 -1x0 0x-1 1x0 ] rot / 90 + 1 ) * sign + pos
    rot: modulo sign * 90 + rot 360

    if any [
        pos/x < 1
        pos/y < 1
        pos/x > n-cells
        pos/y > n-cells
    ][    
        status/text: "The ant left the area. You can press Reset"
        run: false
    ]
    
    change at id-series 3 col
    change at ant 2 pos - 1 * cell-size
    change at ant 4 rot
]

reset: does [
    pos: 1x1 * ( n-cells / 2 + 1 ) + 1
    rot: 180
    speed: 5
    steps: 0
    parse board [ any [ thru quote 'fill-pen change skip ( beige ) ] to end ]
    grid/draw:  board
    status/text: instr
    grid/rate: speed
    spd/text: to "" speed
    run: true
]

view compose/deep [
    title "Langton's ant"
    
    below

    grid: base (1x1 * cell-size * n-cells) #9FAFFF 
    draw board
    rate (speed) on-time [ if run [ update-ant ] ]
    
    status: text 500x16 ( instr )
    
    return
    below
    
    spd: base 64x64 yello ( to "" speed )
    on-wheel [
        speed: min 30 max 1 speed + to 1 event/picked 
        spd/text: form speed
        grid/rate: speed
    ]

    steps-txt: text "0"
    reset-btn: button "Reset" [ reset ]
]

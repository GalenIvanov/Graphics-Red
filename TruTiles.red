Red [
    Title: "Pattern generator based on plane tesselations and Truchet tiles"
    Author: "Galen Ivanov"
    Needs: 'View
]

cells: make block! 2000
cell-size: 0

; tesselation rules
r3:      [tri: [60 tri 60 tri 60 tri]]
r4:      [square: [90 square 90 square 90 square 90 square]]
r6:      [hex: [120 hex 120 hex 120 hex 120 hex 120 hex 120 hex]]        
r6-3:    [hex: [120 tri 120 tri 120 tri 120 tri 120 tri 120 tri]
          tri: [60 hex 60 hex 60 hex]]
r6-3-3:  [hex:  [120 tri1 120 tri1 120 tri1 120 tri1 120 tri1 120 tri1]
          tri1: [60 hex 60 tri2 60 tri1]
          tri2: [60 tri1 60 tri1 60 tri1]]         
r6-4-3:  [hex: [120 square 120 square 120 square 120 square 120 square 120 square]
          square: [90 tri 90 hex 90 tri 90 hex]
          tri: [60 square 60 square 60 square]]       
r8-4:    [octa: [135 octa 135 square 135 octa 135 square 135 octa 135 square 135 octa 135 square]
          square: [90 octa 90 octa 90 octa 90 octa]]
r12-3:   [p12: [150 tri 150 p12 150 tri 150 p12 150 tri 150 p12 150 tri 150 p12 150 tri 150 p12 150 tri 150 p12]
          tri: [60 p12 60 p12 60 p12]]
r12-6-4: [p12: [150 hex 150 sq 150 hex 150 sq 150 hex 150 sq 150 hex 150 sq 150 hex 150 sq 150 hex 150 sq]
          hex: [120 p12 120 sq 120 p12 120 sq 120 p12 120 sq]
          sq: [90 p12 90 hex 90 p12 90 hex]]
r4-3:    [sq1: [90 t1 90 t2 90 t3 90 t4]
          sq2: [90 t4 90 t1 90 t2 90 t3]
          t1:  [60 sq1 60 sq2 60 t3]
          t2:  [60 sq1 60 sq2 60 t4]
          t3:  [60 sq1 60 sq2 60 t1]
          t4:  [60 sq1 60 sq2 60 t2]]
r4-3a:   [sq1: [90 td1 90 sq2 90 tu1 90 sq2]
          sq2: [90 td2 90 sq1 90 tu2 90 sq1]  
          td1: [60 sq1 60 tu1 60 tu2]
          tu1: [60 sq1 60 td1 60 td2] 
          td2: [60 sq2 60 tu2 60 tu1] 
          tu2: [60 sq2 60 td2 60 td1]]
         
;all-rules: [r3 20 r4 15 r6 10 r6-3 10 r6-3-3 10 r6-4-3 8 r8-4 8 r12-3 7 r12-6-4 7 r4-3 12 r4-3a 12]
all-rules: [r3 25 r4 20 r6 15 r6-3 15 r6-3-3 15 r6-4-3 12 r8-4 12 r12-3 10 r12-6-4 10 r4-3 15 r4-3a 15]
rules: make block! 100
;conds: make block! 100
conds-thumbs: [x > 0 x < 100 y > 0 y < 100] 
conds-screen: [x > 0 x < 800 y > 0 y < 645]
conds-big: [x > 0 x < 1920 y > 0 y < 1080]
cells-to-check: make block! 10000
grid: make block! 10000
coords: make block! 10000

;initial settings
cur-rule: 'r3
prop: copy [100 0 0 0 0]
cell-sz: 40
rotation: 0
cell-width: 3
line-color: white
bgcolor: aqua
shadow?: off
shadowcolor: white
shadowsz: 9
shadowoffs: 0x0
r-tile: 100
r-dual: r-diam: r-truchet: r-diag: 0
rndseed: 0
bg: on
prog-c: [r3 7.8 r4 4 r6 2.2 r6-3 3.5 r6-3-3 3.5 r6-4-3 4 r8-4 1.9 r12-3 1.5 r12-6-4 2.0 r4-3 5.8 r4-3a 5.8]


grid-header: [
    line-cap round
    line-join round
    pen aqua
    thick: line-width 5
    fill-pen aqua
    box 0x0 1920x1080
    fill-pen 0.0.0.255
    color: pen white
]

grid-front: [
    thick: line-width 3
    fill-pen transparent
    color: pen snow
]

frame: [line-width 5 pen yellow box 0x0 100x100]

calc-center: function [
    coords [block!] {a block with coordinates [x1 y1 x2 y2 ... xn yn]}
    factor [integer!] {scale factor}
][
    x: to integer! average extract coords 2
    y: to integer! average extract next coords 2
    as-pair round/to x factor round/to y factor
]

render-cell: function [
    cell [block!]
    freq [block!]
][
    grd: copy [scale 0.1 0.1]
    grid: copy []

    len: (length? cell) / 2
    stretch: len - 2 * 180 / len + 1
    
    set [orig dual diam truchet diag] freq
        
    dual: orig + dual
    diam: dual + diam
    truchet: truchet + diam
    diag: truchet + diag
    
    skp: random 3
    move/part cell tail cell 2 * skp
    
    sel: random 99
    cx: to-integer average extract cell 2
    cy: to-integer average extract next cell 2
    
    offs: either bg [shadowoffs][0x0]
    
    case [
        sel <= orig [
            append grid 'polygon
            foreach [x y] cell [
                append grid offs + as-pair to-integer x to-integer y
            ]           
        ]
        sel <= dual [
            i: 1
            loop (len: length? cell) / 2  [
                x: to-integer cell/:i + cell/(i + 1 % len + 1) / 2
                y: to-integer cell/(i + 1) + cell/(i + 2 % len + 1) / 2
                append grid reduce ['line offs + as-pair x y offs + as-pair cx cy]
                i: i + 2
            ]
        ]
        sel <= diam [
            i: 1
            loop (len: length? cell) / 2  [
                x1: to-integer cell/:i + cell/(i + 1 % len + 1) / 2
                y1: to-integer cell/(i + 1) + cell/(i + 2 % len + 1) / 2
                x2: to-integer cell/(i + 1 % len + 1) + cell/(i + 3 % len + 1) / 2
                y2: to-integer cell/(i + 2 % len + 1) + cell/(i + 4 % len + 1) / 2
                append grid reduce ['line offs + as-pair x1 y1 offs + as-pair x2 y2]
                i: i + 2
            ]
        ]
        
        sel <= truchet [
            foreach [x1 y1 x2 y2] cell [
                x2: any [x2 cell/1]
                y2: any [y2 cell/2]
                cntr: offs + as-pair to-integer x2 to-integer y2
                bgn: 179 + modulo to integer!(arctangent2 y2 - y1 x2 - x1) 360
                append grid reduce ['arc cntr 10x10 * cell-size / 2 bgn stretch]
            ]
        ]    
        sel > truchet [
            foreach [x y] cell [
                append grid reduce ['line offs + as-pair x y offs + as-pair cx cy]
            ]    
        ]
    ]
    move/part at tail cell -2 * skp cell 2 * skp
    append/only grd grid
    grd
]

calc-cell-points: func[
    size      [integer!] 
    x         [number!]  
    y         [number!]
    angle     [number!]
    cell-type [string!]
    /local
    cell poly rot ang
    
][
    cell: make block! 20
    poly: extract select rules to set-word! cell-type 2
    ang: angle
    foreach rot poly [
        append cell reduce[x y]
        x: (size * cosine ang) + x
        y: y - (size * sine ang)
        ang: ang + 180 - rot 
    ]
    cell
]

get-new-cell-edges: func [
    cell [block!]
    cell-type [string!]
    rules-offs [integer!]
    /local 
    n cell2 cell-rules
][
        cell2: copy cell
        move/part cell2 tail cell2 2
    
        cell-rules: select rules to-set-word cell-type 
        move/part cell-rules tail cell-rules rules-offs - 2

        collect/into [
            repeat n to 1 (length? cell) / 2[
                keep/only collect [
                    keep reduce [
                        cell/(n * 2 - 1)
                        cell/(n * 2)
                        cell2/(n * 2 - 1)
                        cell2/(n * 2)
                        to-string cell-rules/(n * 2) "_"
                    ]
                ]
            ]
            keep cell-type
        ] make block! 4 * length? cell
]

check-boundaries: none  ; will be a function

n-to-go: func[c-id][
    c-cell: copy select cells c-id
    remove-each e c-cell [e/6 <> "_"]
    length? c-cell
]

same-edge?: function [
     e1 [block!]
     e2 [block!]
][
    res: true
    repeat n 4 [
        res: res and (1 > absolute e2/:n - e1/:n )
    ]
]

make-id: function[coord][to-set-word rejoin ["C" coord]]

make-cells: has [
    cell cell-id cell-type edge n ang
    new-cell-id new-cell new-cell-edges new-center
    common-edge caller offs existing?
][  
    cell-id: pick cells-to-check random length? cells-to-check
    cell: select cells cell-id
    caller: last cell

    edge: cell
    n: length? edge
    while [all[n > 0 edge/1/6 <> "_"]][
        edge: next edge
        n: n - 1
    ]
    either zero? n [    ; selected cell has all edges processed
        remove find cells-to-check cell-id
    ][
        edge: edge/1
        ang: 180 - arctangent2 edge/4 - edge/2 edge/3 - edge/1
        new-cell: calc-cell-points 10 * cell-size edge/3 edge/4 ang edge/5
        new-center: calc-center new-cell 2
        cell-type: edge/5
        
        either check-boundaries new-center [
            new-cell-id: make-id new-center
            edge/6: new-cell-id
            if zero? n-to-go cell-id [remove find cells-to-check cell-id]
            existing?: false
            
            either find cells new-cell-id [
                existing?: true
            ][
                append cells-to-check new-cell-id
                append cells new-cell-id
                offs: index? find rules/(to set-word! cell-type) to set-word! caller 
                append/only cells get-new-cell-edges new-cell cell-type offs
            ]
            
            new-cell-edges: select cells new-cell-id
            common-edge: reduce[edge/3 edge/4 edge/1 edge/2]
            while [not same-edge? copy/part new-cell-edges/1 4 common-edge][ 
                new-cell-edges: next new-cell-edges
            ]
            new-cell-edges/1/6: cell-id
            
            if existing? [if zero? n-to-go new-cell-id [remove find cells-to-check new-cell-id]]
        ][
               edge/6: "Border"
               if zero? n-to-go cell-id [remove find cells-to-check cell-id]
        ]
    ]
]

draw-cells: has [
    cell edge
][
    collect [
        foreach [_ cell] head cells [
            keep/only collect [
                foreach edge copy/part cell back tail cell [keep edge/1 keep edge/2]
            ]
        ]
    ]    
]

init-cells: func [
    new-rules [block!]
    new-conds [block!]
    size      [integer!]
    posX      [number!]
    posY      [number!]
    rot       [integer!]
    /local cell cell-center n edges cell-name cell-type cond-out 
][
    random/seed rndseed
    clear head cells
    rules: copy new-rules
    conds: copy new-conds
    
    cond-out: to integer! size * (length? rules/2) / 4 * 10 

    conds/3: 0 - cond-out
    conds/6: conds/6 * 10 + cond-out
    conds/9: 0 - cond-out
    conds/12: conds/12 * 10 + cond-out
    
    ; make a function to check either the cell is in the boundaries set by cond 
    check-boundaries: func [p] [x: p/x y: p/y to-logic all conds]
    
    cell-size: size
    cell-type: to-string new-rules/1
    
    cell: calc-cell-points 10 * size posX posY rot cell-type
    cell-center: calc-center cell 2
    
    if check-boundaries cell-center [
        cell-name: make-id cell-center
        append cells cell-name
        append/only cells get-new-cell-edges cell cell-type 0
        append cells-to-check cell-name
    ]    
]

make-thumbs: does [
    foreach [rule size] all-rules [
        init-cells get rule conds-thumbs size 40 40 0
        while [not empty? cells-to-check][make-cells]
        img: to-word rejoin [rule "-img"]
        set img make image! [100x100 0.0.0.255]
        grid: copy grid-header
        foreach c draw-cells [append grid render-cell c prop]
        draw get img grid
    ]
]

select-thumb: func [
    rule
    /local old-face face img
][
    old-face: get to-word rejoin ["b-" cur-rule]
    img: to-word rejoin [cur-rule "-img"]
    append clear old-face/draw compose [image (img)]
    face: get to-word rejoin ["b-" rule]
    img: to-word rejoin [rule "-img"]
    append clear face/draw compose [image (img) (frame)]
    cur-rule: rule
]
;init-cells rules conds 50 150 150 0 "tri"

render-grid: func [
    img? [logic!]   ; render to screen or file?
    /local sp count n t1 t2 cond
][
    t1: now/time/precise
    rndseed: either empty? rs: f-rand/text [0][to-integer rs]
    
    count: 2000 / cell-sz * (1000 / cell-sz)  
    n: 0
    prog/data: 0
       
    count: count * (select prog-c cur-rule)   ; ; progress etimate   !!! - I need to update them
    unless shadow? [count: to-integer count * 0.66]
        
    prop: reduce [r-tile r-dual r-diam r-truchet r-diag]
    either zero? sp: sum prop [
        prop: [20 20 20 20 20]
        norm: 1
    ][
        norm: 100.0 / sp
    ]
    forall prop [prop/1: to-integer norm * prop/1]
    
    big-img: make image! [1920x1080 0.0.0.255]
    
    ;probe conds
    ;probe conds-screen
    
    cond: either img? [conds-big][conds-screen]
    ;init-cells get cur-rule conds-big cell-sz 5000 5000 rotation
    init-cells get cur-rule cond cell-sz 5000 5000 rotation
    while [not empty? cells-to-check][
        make-cells
        n: n + 1
        prog/data: n / count
    ]
    
    random/seed rndseed
    coords: draw-cells
    clear grid
    append clear grid compose [fill-pen (bgcolor) box 0x0 1920x1080 line-cap round line-join round]
    bg: on
    if shadow? [
        append grid compose [line-width (10 * shadowsz) pen (shadowcolor)]
        foreach c coords [
            append grid render-cell c prop
            n: n + 1
            prog/data: n / count
        ]
    ]
    bg: off
    change at find grid-front 'color 3 line-color
    change at find grid-front 'thick 3 10 * cell-width
    append grid grid-front
    ;---------
    append grid [scale-factor: scale 1 1]
    ;
    random/seed rndseed
    foreach c coords [
        append grid render-cell c prop
        n: n + 1
        prog/data: n / count
    ]
    t2: now/time/precise
    ;print ["Image generated for" t2 - t1 "seconds"]
    draw big-img grid
]

update-clr: function [
    r g b
][
    as-color to-integer 255 * r
             to-integer 255 * g
             to-integer 255 * b
]

get-color: func [
    caller
    color
    /local clr r g b
][
    changed: false
    caller/enabled?: false
    
    col: get color
    r: 100% * col/1 / 255
    g: 100% * col/2 / 255
    b: 100% * col/3 / 255
    view/flags compose [
        title "Pick a color" 
        across
        b-red: base 25x25 red
        sl-red: slider 256x25 (r) [
            f-red/data: to-integer 255 * sl-red/data
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        f-red: field 32x25 (to-string col/1) on-key-up [
            sl-red/data: (any [f-red/data 0]) / 255
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        return
        b-green: base 25x25 green
        sl-green: slider 256x25 (g) [
            f-green/data: to-integer 255 * sl-green/data
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        f-green: field 32x25 (to-string col/2) on-key-up [
            sl-green/data: (any [f-green/data 0]) / 255
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        return
        b-blue: base 25x25 blue
        sl-blue: slider 256x25 (b) [
            f-blue/data: to-integer 255 * sl-blue/data
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        f-blue: field 32x25 (to-string col/3) on-key-up [
            sl-blue/data: (any [f-blue/data 0]) / 255
            clr/color: update-clr sl-red/data sl-green/data sl-blue/data
        ]
        return
        clr: base 260x60 (col)
        below 
        button 60x25 "Cancel" [unview]
        button 60x25 "OK"      [changed: true unview]
    ][modal no-min no-max]
    
    caller/enabled?: true
    either changed [set color clr/color clr/color][col]
]

;initial screen
make-thumbs
cur-rule: 'r4
line-color: 42.120.150

base-c: 0.1

view compose/deep [
    title "TruTiles"
    
    space 5x5
    presets: drop-list 245x20
    button 45x23 "Load"
    return
    preset: field 245x23
    button 45x23 "Save"
    return
    
    group-box [
        across middle
        text "Cell Size" sl-size: slider 132x20 17.5%
        [t-size/data: cell-sz: round/to to-integer 200 * sl-size/data + 15 1]
        t-size: text (form cell-sz) 40x20 return
        text "Rotation" sl-rotation: slider 132x20 0%
        [t-rot/data: rotation: to-integer 120 * sl-rotation/data]
        t-rot: text (form rotation) 30x20 return
        text "Line Width" sl-thick: slider 132x20 5%
        [t-line/data: cell-width: to-integer 50 * sl-thick/data + 1]
        t-line: text (form cell-width) 32x20 return
        text "Line Color" b-linecolor: base 25x25 42.120.150
        on-up [
            b-linecolor/color: get-color b-linecolor 'line-color
            t-linecolor/data: line-color
        ]
        t-linecolor: text (form line-color) 60x20 return
        text "Background" b-bgcolor: base 25x25 aqua
        on-up [
            b-bgcolor/color: get-color b-bgcolor 'bgcolor
            t-bgcolor/data: bgcolor
        ]
        t-bgcolor: text (form bgcolor) 60x20
    ] return
    group-box [
        tshadow: check "Shadow" 65x20 off [shadow?: tshadow/data]
        text "Shadow Color" b-shadowcolor: base 25x25 white
        on-up [
            b-shadowcolor/color: get-color b-shadowcolor 'shadowcolor
            t-shadowcolor/data: shadowcolor
        ]
        t-shadowcolor: text (form shadowcolor) 60x20
        return
        text "Shadow Width" sl-shadsz: slider 132x20 18%
        [t-shadowsz/data:  shadowsz: to-integer 50 * sl-shadsz/data + 1]
        t-shadowsz: text (form shadowsz) 30x20 return
        text "Shadow Offset" sl-shadoffs: slider 132x20 50%
        [shadowoffs: 500x500 * sl-shadoffs/data - 250x250
        t-shadowoffs/data: to-integer shadowoffs/x / 10]
        t-shadowoffs: text "0" 40x20 return
    ] return
    group-box [
        text "Tile" sl-tile: slider 132x20 100%
        [t-tile/data:  r-tile: to-integer 100 * sl-tile/data]
        t-tile: text (form r-tile) 40x20 return
        text "Dual" sl-dual: slider 132x20
        [t-dual/data: r-dual: to-integer 100 * sl-dual/data]
        t-dual: text (form r-dual) 30x20 return
        text "Diamond" sl-diam: slider 132x20
        [t-diam/data: r-diam: to-integer 100 * sl-diam/data]
        t-diam: text (form r-diam) 30x20 return
        text "Truchet" sl-truchet: slider 132x20
        [t-truchet/data: r-truchet: to-integer 100 * sl-truchet/data]
        t-truchet: text (form r-truchet) 30x20 return
        text "Diagonal" sl-diag: slider 132x20
        [t-diag/data: r-diag: to-integer 100 * sl-diag/data]
        t-diag: text (form r-diag) 30x20
    ] return

    f-rand: field 95x25 hint "Random seed"
    button 95x25 "Render" [render-grid false]
    button 95x25 "Save .png"
    [render-grid true save/as request-file/save/file/filter %TruTiles.png [%png] big-img 'png]
    return
    prog: progress 300x5 0%
    
    space 5x5
    below return
    b-r4:      base 100x100 draw [image (r4-img)(frame)] [select-thumb 'r4]
    b-r3:      base 100x100 draw [image (r3-img)]        [select-thumb 'r3]
    b-r6:      base 100x100 draw [image (r6-img)]        [select-thumb 'r6] 
    b-r6-3:    base 100x100 draw [image (r6-3-img)]      [select-thumb 'r6-3]
    b-r6-3-3:  base 100x100 draw [image (r6-3-3-img)]    [select-thumb 'r6-3-3]
    b-r6-4-3:  base 100x100 draw [image (r6-4-3-img)]    [select-thumb 'r6-4-3]
    return              
    b-r8-4:    base 100x100 draw [image (r8-4-img)]      [select-thumb 'r8-4]  
    b-r12-3:   base 100x100 draw [image (r12-3-img)]     [select-thumb 'r12-3]
    b-r12-6-4: base 100x100 draw [image (r12-6-4-img)]   [select-thumb 'r12-6-4]
    b-r4-3:    base 100x100 draw [image (r4-3-img)]      [select-thumb 'r4-3]
    b-r4-3a:   base 100x100 draw [image (r4-3a-img)]     [select-thumb 'r4-3a]
	radio "Side" on
	radio "Line"
	radio "Shadow"
	
    space 8x5
    return
    scr: base 800x645  ;rate 30
    draw grid
    on-create [render-grid false]
    ;on-time [base-c: base-c * 1.1 % 3 scale-factor/2: base-c scale-factor/3: base-c]
]

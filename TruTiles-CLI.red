Red [
    Title: "Pattern generator - CLI version"
    Author: "Galen Ivanov"
    CLI:   "by @hiimboris" 
    Needs: 'View
]

#include %cli.red

cells: make block! 2000
cell-size: 40

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
         

all-rules: [r3 25 r4 20 r6 15 r6-3 15 r6-3-3 15 r6-4-3 12 r8-4 12 r12-3 10 r12-6-4 10 r4-3 15 r4-3a 15]
rules: make block! 100
conds-thumbs: [x > 0 x < 100 y > 0 y < 100] 
conds-screen: [x > 0 x < 800 y > 0 y < 645]
conds-big: [x > 0 x < 1920 y > 0 y < 1080]
cells-to-check: make block! 10000
grid: make block! 10000
coords: make block! 10000

;initial settings
cur-rule: 'r6-3-3 ;'r4
prop: copy [100 0 0 0 0]
cell-sz: 40
rot: 0
cell-width: 3
line-color: 42.120.150
bgcolor: aqua
shadow?: off
shadowcolor: white
shadowsz: 9
shadowoffs: 0x0
r-tile: 100
r-dual: r-diam: r-truchet: r-diag: 0
rndseed: 0
out-file: %TruTiles.png
bg: on

;prog-c: [r3 7.8 r4 4 r6 2.2 r6-3 3.5 r6-3-3 3.5 r6-4-3 4 r8-4 1.9 r12-3 1.5 r12-6-4 2.0 r4-3 5.8 r4-3a 5.8]
prog-c: [r3 1 r4 1 r6 1 r6-3 1 r6-3-3 1 r6-4-3 1 r8-4 1 r12-3 1 r12-6-4 1 r4-3 1 r4-3a 1]

;r3:      
;r4:      
;r6:      
;r6-3:    
;r6-3-3:  
;r6-4-3:  
;r8-4:    
;r12-3:   
;r12-6-4: 
;r4-3:    
;r4-3a:   

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

render-grid: func [
    img? [logic!]   ; render to screen or file?
    /local sp count n t1 t2 cond
][
    t1: now/time/precise
    rndseed: 0 ; !!! option !!!
    
    count: 2000 / cell-sz * (1000 / cell-sz)  
    n: 0
       
    count: count * (select prog-c cur-rule)   ; ; progress etimate   !!! - I need to update them
    print count
    ;unless shadow? [count: to-integer count * 0.66]
        
    prop: reduce [r-tile r-dual r-diam r-truchet r-diag]
    either zero? sp: sum prop [
        prop: [20 20 20 20 20]
        norm: 1
    ][
        norm: 100.0 / sp
    ]
    forall prop [prop/1: to-integer norm * prop/1]
    
    
    big-img: make image! [1920x1080 0.0.0.255]
  
    cond: either img? [conds-big][conds-screen]

    init-cells get cur-rule cond cell-sz 5000 5000 rot
    while [not empty? cells-to-check][
        make-cells
        ;n: n + 1
        ;prog/data: n / count
        ;prin dot
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
            ;n: n + 1
            ;prin dot
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
        ;n: n + 1
        ;prog/data: n / count
    ]
    t2: now/time/precise
    ;print ["Image generated for" t2 - t1 "seconds"]
    draw big-img grid
]

[
    cur-rule: 'r6-3-3 ;'r4
    cell-sz: 40
    rot: 0
    cell-width: 3
    line-color: 42.120.150
    bgcolor: aqua
    shadow?: on
    shadowcolor: white
    shadowsz: 9
    shadowoffs: 0x0
    r-tile: 100
    r-dual: r-diam: r-truchet: r-diag: 0
    prop: copy [100 0 0 0 0]
    rndseed: 0
    out-file: %TruTiles.png
]   


program: func [
    rule {Type of tiling to be used}
    /size 
        cell-size [integer!]  {Size of the cell, between 15 and 200. Default 40}
    /rotate
        rotation  [number! float!] {Rotation angle. Default 0 degrees}
    /thickness
        cell-line [integer!]  {Line thickness. Default 3 pixels}
    /color
        edge-color   {Cell edge color.Default 42.120.150}
    ;line-color: 42.120.150
    ;bgcolor: aqua
    /shadow   {Turn on shadow. Turned off by default}
    ;shadowcolor: white
    ;shadowsz: 9
    ;shadowoffs: 0x0
    ;r-tile: 100
    ;r-dual: r-diam: r-truchet: r-diag: 0
    ;prop: copy [100 0 0 0 0]
    ;rndseed: 0
][
    cur-rule: to-lit-word rule
    if size [cell-sz: cell-size] 
    if rotate [rot: rotation]
    if thickness [cell-width: cell-line]
    if color [line-color: load edge-color]
    if shadow [shadow?: on]
    
    prin "Working"
    render-grid true
    ;save/as request-file/save/file/filter out-file [%png] big-img 'png
    save/as out-file big-img 'png
]

cli/process-into program
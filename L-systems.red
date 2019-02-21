Red [
   Title: "L-systems"
   Author: "Galen Ivanov"
   Needs: 'View
]

expand-axiom: function [
    axiom [ string! ]
    iterations [ integer! ]
    rules [ block! ]
] [
    loop iterations [
        tmp: make string! 100000
        forall axiom [ 
            either axiom/1 = #"(" [ axiom: find axiom ")" ] [
                append tmp switch/default form axiom/1 rules [ axiom/1 ] 
            ]
        ]
        axiom: tmp
    ]
]

calc-line: function [
    x [ number! ]
    y [ number! ]
    angle [ number! ]
] [
    x: x + cos ( pi * angle / 180 )
    y: y - sin ( pi * angle / 180 )
    reduce [ x y ]
]

normalize-coords: function [
    raw-coords [ block! ]
    width [ integer! ]
] [
    set [ minx maxx miny maxy ] raw-coords/1

    dx: maxx - minx
    dy: maxy - miny
    coef: ( 0.9 * width) / ( max dx dy ) 
    offsx: width - ( dx * coef ) / 2 
    offsy: width - ( dy * coef ) / 2 
    
    draw-block: make block! 100000
    
    collect/into [ 
        keep [ pen gray box 0x0 799x799 pen black ]
        foreach item next raw-coords [
            t: type? item
            if t = block! [ keep to pair! reduce [ item/1 - minx * coef + offsx
                                                   item/2 - miny * coef + offsy ] ]
            if t = word! [ keep item ]
        ]
    ] draw-block 
]

parse-expanded: function [
    expr [ string! ] 
    used [ string! ]
    phi [ number! ]
    angle [ number! ]    
] [
    x: y: 0
    minx: maxx: miny: maxy: 0
    
    raw-block: make block! 100000
    coord-stack: make block! 100000
    
    u: charset used
    
    collect/into [
        parse expr [
            any [
                [ "(" copy c to ")" skip ] ( keep 'pen keep to word! c )
                | u ( keep 'line
                      keep/only reduce [ x y ]
                      set [ x y ] calc-line x y angle 
                      keep/only reduce [ x y ]
                      minx: min x minx
                      maxx: max x maxx
                      miny: min y miny
                      maxy: max y maxy )
                | "+" ( angle: angle + phi )
                | "-"  ( angle: angle - phi )
                | "[" ( append/only coord-stack reduce [ x y angle ] )
                | "]" ( set [ x y angle ] take/last coord-stack )
                | skip
            ]
        ]
    ] raw-block
    
    insert/only raw-block reduce [ minx maxx miny maxy ]
    raw-block
]

load-params: does [
    rules: collect [
        repeat idx 5 [
           name: do rejoin ["c" idx "/text" ]
           rule: do rejoin ["r" idx "/text" ]
           if name <> none [ keep name keep/only to-block mold rule ]
        ]
   ]
   f: expand-axiom axiom-field/text to integer! iter-field/text rules
   p: parse-expanded f use-field/text to float! angle-field/text to float! rotate-field/text
   normalize-coords p 800
]

samples: [
    ; angle orientation iterations axiom use rules
    [ "60" "0" "5" "YF" "F" [ "X" [ "(teal)YF+XF+Y" ] "Y" [ "(cyan)XF-YF-X" ] ] ]             ; Sierpinski arrowhead
    [ "60" "0" "4" "F+F+F+F" "F" [ "F" [ "(pink)F+F-F+F+F" ] ] ]                              ; Koch
    [ "90" "0" "2" "XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX" "XY" [ "X" [ "(orange)X+X+XY-Y-" ]       ; joined cross curves
                                                            "Y" [ "+X+XY-Y-Y" ] ] ]    
    [ "90" "0" "12" "FL" "F" [ "L" [ "L+RF+" ] "R" [ "-FL-R" ] ] ]                            ; dragon curve                          
    [ "25" "90" "4" "F" "F" [ "F" [ "(brown)FF+[(green)+F-F-F]-[(leaf)-F+F+F]" ] ] ]          ; plant
    [ "60" "30" "10" "X" "F" [ "X" [ "[-F+F[Y]+F][+F-F[X]-F]" ]                               ; hexagonal grif
                               "Y"  [ "[-F+F[Y]+F][+F-F-F]" ] ] ]
    [ "90" "0" "4" "X" "F" [ "X" [ "(water)-YF+XFX+FY-" ] "Y" [ "(water)+XF-YFY-FX+" ] ] ]    ; Hilbert curve 
    [ "60" "0" "3" "XF" "F" [ "X" [ "(olive)X+YF++YF-FX--FXFX-YF+" ]                          ; Hexagonal Gosper curve 
                                    "Y" [ "-FX+YFYF++YF+FX--FX-Y" ] ] ] 
    [ "90" "0" "3" "F+XF+F+XF" "F" [ "X" [ "(teal)XF-F+F-XF+F+XF-F+F-X" ] ] ]                 ; square-grid approximation of Sierpinsky curev
    [ "30" "0" "6" "W" "F" [ "W" [ "(red)+++X--F--ZFX+" ]                                     ; lace  
                             "X" [ "(red)---W++F++YFW-" ] 
                             "Y" [ "+ZFX--F--Z+++" ]
                             "Z" [ "-YFW++F++Y---" ] ] ]    
    [ "15" "0" "4" "AAAA" "F" [ "A" [ "X+X+X+X+X+X+" ]                                        ; concentric rings
                                "X" [ "[(water)F+F+F+F[---X-Y]+++++F++++++++F-F-F-F]" ]
                                "Y" [ "[F+F+F+F[---Y]+++++F++++++++F-F-F-F]"] ] ]                         
    [ "36" "0" "3" "[7]++[7]++[7]++[7]++[7]" "1" [ "6" [ " 81++91----71[-81----61]++" ]       ; Penrose tiling
                                                   "7" [ "+81--91[---61--71]+" ] 
                                                   "8" [ "-(tanned)61++71[+++81++91]-" ] 
                                                   "9" [ "--81++++61[+91++++71]--71" ] 
                                                   "1" [ "" ] ] ]                               

]

load-sample: func [ n ] [
    sample: copy samples/:n
    
    angle-field/text: copy sample/1 
    rotate-field/text: copy sample/2 
    iter-field/text: form 1 + do copy sample/3
    axiom-field/text: copy sample/4
    use-field/text: copy sample/5

    sp: " "    
    repeat idx 5 [
        do rejoin ["c" idx "/text:  sp"]
        do rejoin ["r" idx "/text:  sp"]
    ]
    
    idx: 1
    foreach [name rule] sample/6 [
        do rejoin ["c" idx "/text: name"]
        do rejoin ["r" idx "/text: form rule"]
        idx: idx + 1
    ]
    clear canvas/draw
    append canvas/draw load-params

]

draw-samples: does [
    idx: 1
    foreach sample samples [
        f: expand-axiom sample/4 to integer! sample/3 sample/6
        p: parse-expanded f sample/5 to float! sample/1 to float! sample/2
        do rejoin ["append canvas" idx "/draw normalize-coords p 110"]
        idx: idx + 1
    ]
]

frame: [ pen gray box 0x0 109x109 pen black ]

view [
   title "L-systems / Red :: Galen Ivanov"
   on-create [ draw-samples ]
   
   across
   text 35 "Angle" angle-field: field 50 "60"
   text 60 "Orientation" rotate-field: field 50 "0"
   text 50 "Iterations" iter-field: field 50 "3" return 
   
   text 35 "Axiom" axiom-field: field 200 "F--F--F"
   text 30 "Use" use-field: field 50 "F" return
      
   text 35 "Rule 1" c1: field 20 "F" r1: field 270 "F+F--F+F" return
   text 35 "Rule 2" c2: field 20 r2: field 270 return
   text 35 "Rule 3" c3: field 20 r3: field 270 return
   text 35 "Rule 4" c4: field 20 r4: field 270 return
   text 35 "Rule 5" c5: field 20 r5: field 270 return

   start: button 345x40 font-size 16 "Start" [ clear canvas/draw append canvas/draw load-params ] return
   text font-size 16 "Examples" return
   
   style thumb: base white 110x110  
   canvas1:  thumb draw copy frame [ load-sample  1 ]
   canvas2:  thumb draw copy frame [ load-sample  2 ]
   canvas3:  thumb draw copy frame [ load-sample  3 ] return 
   canvas4:  thumb draw copy frame [ load-sample  4 ]
   canvas5:  thumb draw copy frame [ load-sample  5 ]
   canvas6:  thumb draw copy frame [ load-sample  6 ] return
   canvas7:  thumb draw copy frame [ load-sample  7 ]
   canvas8:  thumb draw copy frame [ load-sample  8 ]
   canvas9:  thumb draw copy frame [ load-sample  9 ] return
   canvas10: thumb draw copy frame [ load-sample 10 ]
   canvas11: thumb draw copy frame [ load-sample 11 ]
   canvas12: thumb draw copy frame [ load-sample 12 ] return
   below return 
  
   canvas: base white 800x800 
   draw [ pen gray box 0x0 799x799 pen black ]
] 

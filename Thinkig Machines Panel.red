Red [
    Title: "Thinking Machines Panel simulation"
    Author: "Galen Ivanov" 
]

random/seed now

light-rows: collect [ 
    loop 32 [ 
        keep/only collect [loop 32 [keep pick [red black] (random 9) < 4]]    
    ]
]

move-lights: does [
    ; rows in groups of 4 slide alternatingly to the left or to the right          
    forall light-rows [            
        size: (to-integer (index? light-rows) - 1 / 4) // 2 * 30 + 1
        move/part light-rows/1 tail light-rows/1 size
    ]
    
    pos: at led-panel 4
    repeat y 32 [
        repeat x 16 [
            pos/1: light-rows/:y/:x
            pos: skip pos 5
        ]
    ] 
]

led-panel: collect [
    keep [pen transparent] 
    repeat y 32 [
        repeat x 16 [                                                 
            keep 'fill-pen                                                                                                    
            keep light-rows/:y/:x    ; these will be updated               
            keep 'box                                                     
            keep make point2D! compose [(x - 1 * 16) (y - 1 * 16)]                
            keep make point2D! compose [(x * 16) (y * 16)]            
        ]    
    ] 
]

view [
    title "Connection Machines Display"
    base (256, 512) draw led-panel rate 8
    on-time [move-lights]
]

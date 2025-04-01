Red [
    Title: "Axe - Truchet"
    Author: "Galen Ivanov"
    Date: 31-03-2025
]

S: 128
 
shape1: draw 1x1 * S compose [
    pen transparent
    line-width 0
    fill-pen water
    circle (1x1 * S / 2) (S / 2) 
    fill-pen white
    circle 0x0 (S / 2)
    circle (1x1 * S) (S / 2) 
]
    
shape2: draw 1x1 * S compose [
    pen transparent
    line-width 0
    fill-pen water
    circle (1x1 * S / 2) (S / 2)
    fill-pen white
    circle (1x0 * S) (S / 2)
    circle (0x1 * S) (S / 2)
] 

tiles: collect [
    repeat y 1024 / S [
        repeat x 1024 / S [
            ;keep reduce ['image shape1 as-pair x - 1 * S y - 1 * s] ; simple
            ;keep reduce ['image to-word pick [shape1 shape2] x % 2 + 1 as-pair x - 1 * S y - 1 * s] ; horizontal waves
            ;keep reduce ['image to-word pick [shape1 shape2] x + y % 2 + 1 as-pair x - 1 * S y - 1 * s] ; diagonal
            keep reduce ['image to-word pick [shape1 shape2] ((to 1 x / 2 % 2) + (to 1 y / 2 % 2)) % 2 + 1 as-pair x - 1 * S y - 1 * s] ; flowers
        ]
    ]
]

save/as %Axe-truchet.png draw 1024x1024 tiles 'png

view [base 1024x1024 draw compose [(tiles)]]
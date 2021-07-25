Red [
    Title: "Stick figures tests"
    Author: "Galen Ivanov"
    Needs: view
]

stickman: function [
    pos   [pair!]
    size  [integer!]
    color [tuple!]     
][
    c: size / 20
    r-head: to-integer c * 20
    r-hand: to-integer c * 10
    r-gap:  to-integer c * 3
    l-hand: to-integer c * 80
    c-head: c * 50x25 + pos
    c-neck: c * 50x50 + pos
    width:  to-integer c * 20
    
    collect [
        keep compose/deep [
            fill-pen (color)
            circle (c-head) (r-head)
            shape [
                move (c-neck)
                'hline (0 - width - (3 * r-gap))
                'arc (-1x1 * r-head) (r-head) (r-head) 0
                'vline (l-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - l-hand + r-hand)
                'arc (2x0 * r-gap) (r-gap) (r-gap) 0 sweep
                'vline (2 * l-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - l-hand - r-hand)
                'arc (2x0 * r-gap) (r-gap) (r-gap) 0 sweep
                'vline (l-hand + r-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - 2 * l-hand)
                'arc (2x0 * r-gap) (r-gap) (r-gap) 0 sweep
                'vline (l-hand -  r-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - l-hand)
                'arc (-1x-1 * r-head) (r-head) (r-head) 0
                'hline (0 - width - (4 * r-gap))
            ] 
        ]
    ]
]

stickwoman: function [
    pos   [pair!]
    size  [integer!]
    color [tuple!]     
][
    c: size / 20
    r-head: to-integer c * 20
    r-hand: to-integer c * 9
    r-gap:  to-integer c * 3
    l-hand: to-integer c * 70
    c-head: c * 50x25 + pos
    c-neck: c * 50x50 + pos
    width:  to-integer c * 15
    
    collect [
        keep compose/deep [
            fill-pen (color)
            circle (c-head) (r-head)
            shape [
                move (c-neck)
                'hline (0 - width - (3 * r-gap))
                'arc (-1x1 * r-head) (r-head) (r-head + 10) 0
                'line (as-pair 0 - r-hand * 2 l-hand)
                'arc (2x1 * r-hand) (r-hand) (r-hand) 0
                'line (as-pair r-hand * 2 0 - l-hand)
                'arc (2x1 * r-gap) (r-gap) (r-gap) 0 sweep
                'line (as-pair 0 - r-hand * 3 l-hand + (3 * r-hand))
                'hline (3 * r-hand)
                'vline (l-hand - r-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - l-hand + r-hand)
                'hline (2 * r-gap)
                'vline (l-hand - r-hand)
                'arc (2x0 * r-hand) (r-hand) (r-hand) 0
                'vline (0 - l-hand + r-hand)
                'hline (3 * r-hand)
                'line (as-pair 0 - r-hand * 3 0 - l-hand - (3 * r-hand))
                'arc (2x-1 * r-gap) (r-gap) (r-gap) 0 sweep
                'line (as-pair r-hand * 2 l-hand)
                'arc (2x-1 * r-hand) (r-hand) (r-hand) 0
                'line (as-pair 0 - r-hand * 2 0 - l-hand)
                'arc (-1x-1 * r-head) (r-head) (r-head + 10) 0
                'hline (0 - width - (4 * r-gap))
            ] 
        ]
    ]
]
view compose/deep [
	title "Stickman tests" 
	base 250x300 beige
    draw [
       (stickman 20x20 16 black)
       (stickwoman 140x20 16 pink)
    ]
]
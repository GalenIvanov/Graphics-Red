Red[
   Title: "Animated Truchet tiles"
   Author: "Galen Ivanov"
   Date: 21-02-2020
   Needs: view
]
random/seed now

board: make block! 64
bg: [64x64 196.228.255]
frame: 0
phase: 0.0
step: 90 / 4.0

img11: make image! bg

big-img: make image! [512x512 255.255.255]

collect/into [
    repeat n 64 [ keep random 2 ]
] board

repeat i 2 [
    set [add1 add2] pick [[0x0 64x64] [64x0 0x64]] i
	phase: 0
    repeat n 10 [
	    img: to word! rejoin ['img i n - 1] 
		set img make image! bg
	    draw-block: copy [ line-width 5 pen white line-cap round]
		angle: phase
		collect/into[
			until [
			    ang: either i = 2 [angle][90 - angle]
				x1: 24 * cosine ang
				y1: -24 * sine ang
				x2: 40 * cosine ang
				y2: -40 * sine ang

				keep compose [line (add1 + as-pair x1 y1) (add1 + as-pair x2 y2)]
				keep compose [line (add2 + as-pair x1 y1) (add2 + as-pair x2 y2)] 
				(step / 9.0 + 360) < angle: angle + step
			] 
		] draw-block
	    draw get img draw-block
		phase: step / 9.0 + phase
	]
	
]	

update-board: does [
    frame: frame + 1 % 9
	draw big-img collect [
		repeat y 8 [
			repeat x 8 [
			    fr: either odd? x + y [frame][9 - frame ]
				nn: board/(y - 1 * 8 + x)
				
				keep compose [
					image 
					(to word! rejoin['img nn fr])
					(as-pair x - 1 * 64 y - 1 * 64)]
			]
		]
	]
]

update-board
;save/as %truchet.jpg big-img 'jpeg

view [ canvas: base 512x512 draw [ image big-img ] rate 30
     on-time [update-board append clear canvas/draw [image big-img]]
] 

Red[
   Title: "Extended Filled Truchet tiles"
   Author: "Galen Ivanov"
   Date: 20-02-2020
   Needs: view
]
random/seed now

img11: make image! bg: [32x32 255.255.255]
img12: make image! bg
img31: make image! bg
img21: make image! bg: [32x32 164.200.255]
img22: make image! bg
img32: make image! bg

big-img: make image! [512x512 255.255.255]

t: [line-width 3 pen navy fill-pen]
draw img11 compose [(t) sky circle 0x0 16 circle 32x32 16]
draw img12 compose [(t) sky circle 32x0 16 circle 0x32 16]
draw img31 compose [(t) sky box -2x-2 16x16 box 16x16 33x33]
draw img21 compose [(t) white circle 32x0 16 circle 0x32 16]
draw img22 compose [(t) white circle 0x0 16 circle 32x32 16]
draw img32 compose [(t) white box -2x-2 16x16 box 16x16 33x33]

draw big-img collect [
    repeat y 16 [
	    repeat x 16 [
			keep compose [
			    image 
				(to word! rejoin['img random 3 x + y % 2 + 1])
				(as-pair x - 1 * 32 y - 1 * 32)]
		]
	]
]
save/as %truchet.jpg big-img 'jpeg

view [ base 512x512 draw [ image big-img ] ] 
Red [
   title: "Leaf-shaped Truchet tiles"
   author: "Galen Ivanov"
   date: 14-07-2021
   needs: view
]

W: 800
H: 600
d: 50

random/seed now

tile1: make image! compose [(as-pair d d) (sky)]
tile2: copy tile1

draw tile1 compose/deep[
    fill-pen white pen sky
    shape [arc (as-pair d d) (d) (d) 90 arc 0x0 (d) (d) 90]
]

draw tile2 compose/deep[
    fill-pen white pen sky
    shape [move (as-pair d 0) arc (as-pair 0 d) (d) (d) 90 arc (as-pair d 0) (d) (d) 90]
]

truchet: collect [
    repeat y H / d [
	    repeat x W / d [
		    t: rejoin ['tile random 2]
		    keep compose [image (to-word t) (as-pair x - 1 * d y - 1 * d)]
		]
	]
]

view compose [title "Leaf Truchet" base (as-pair W H) sky draw truchet]
Red [
   Title: "Langton's ant"
   Author: "Galen Ivanov"
   Date: 03-02-2021
   Needs 'view
]

img-ant: load %Ant_32.png
cell-size: 32
n-cells: 15
color1: beige
color2: aqua
pos: 8x8
rot: 180
speed: 1

make-word: function [pair][
    to set-word! rejoin ["c" pair]
]

board: collect [
    keep [pen white]
    repeat y n-cells [
	    repeat x n-cells [
		    keep compose [
				(make-word as-pair x y)
                fill-pen (color1)
				box ( as-pair x - 1 * cell-size y - 1 * cell-size )
			        ( as-pair     x * cell-size     y * cell-size )
			]
		]
	]
	
	keep [ant: translate 224x224 rotate 180 16x16 [image img-ant]]
]

get-cell-color: func [wrd][
    pick find board wrd 3 
]

update-ant: does [
    wrd: make-word pos
    col: get-cell-color wrd
;	print [color1 color2 col]
	either col = color1 [
	    pos: pos + pick [0x1 -1x0 0x-1 1x0] rot / 90 + 1
	    rot: modulo rot + 90 360
		col: color2
	][
	    pos: pos + pick [0x-1 1x0 0x1 -1x0] rot / 90 + 1
	    rot: modulo rot - 90 360
		col: color1
	]

	change at find board wrd 3 col
	change at find board ant 2 pos - 1 * cell-size
	change at find board ant 4 rot
	
]

view compose [
    title "Langton's ant"
	below
    grid: base (1x1 * cell-size * n-cells) #9FAFFF 
	draw board
	rate 1 on-time [update-ant]
	status: text 400x16 ""
	return
	below
	spd: base 64x64 yello "1" all-over
	on-wheel [
	    speed: min 30 max 1 speed + to integer! event/picked 
		spd/text: form speed
		grid/rate: speed
	]
	on-over [
	    either status/text = ""[
		    status/text: "Turn the mouse wheel to change the animation speed"
		][
		    ""
		]
	] 
	reset: button "Reset"

] 
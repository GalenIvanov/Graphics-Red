Red[
    Title: "Optical Illusion Clock"  
	Author: "Galen Ivanov"
	Date: 24-02-2020
	Needs: 'View 
]

digits: [
	[ ;0
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 0 0 0]
	][ ;1 
		[0 0 0 0]
		[0 0 0 1]
		[0 0 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 0]
	][ ;2
		[0 0 0 0]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 1 1 1]
		[0 1 0 0]
		[0 1 0 0]
		[0 1 1 1]
		[0 0 0 0]
	][ ;3
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 1]
		[0 0 0 1]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 1 1 1]
		[0 0 0 0]
	][ ;4
		[0 0 0 0]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 0]
	][ ;5
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 0]
		[0 1 0 0]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 1 1 1]
		[0 0 0 0]
	][ ;6
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 0]
		[0 1 0 0]
		[0 1 1 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 0 0 0]
	][ ;7
		[0 0 0 0]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 0 0 0]
	][ ;8
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 0 0 0]
	][ ;9
		[0 0 0 0]
		[0 1 1 1]
		[0 1 0 1]
		[0 1 0 1]
		[0 1 1 1]
		[0 0 0 1]
		[0 0 0 1]
		[0 1 1 1]
		[0 0 0 0]
	]
]

offs: [0x0 80x0 200x0 280x0]
draw-blk: make block! 200
img1: make image! [20x20 255.255.240]
draw img1 [line-width 2 line-cap round pen papaya line 0x5 5x0
			line 0x15 15x0 line 5x20 20x5 line 15x20 20x15]
img2: make image! [20x20 255.255.240]
draw img2 [line-width 2 line-cap round pen papaya line 15x0 20x5
			line 5x0 20x15 line 0x5 15x20 line 0x15 5x20]

sep1: make image! [20x180 255.255.240]
draw sep1 collect [
    repeat n 9[
	    keep reduce ['image 'img1 as-pair 0 n - 1 * 20]
	]
]

sep2: make image! [20x180 255.255.240]
draw sep2 collect [
    repeat n 9[
	    keep reduce ['image 'img1 as-pair 0 n - 1 * 20]
	]
	keep [image img2 0x60 image img2 0x100]
]
 
repeat n 10 [
    img: to word! rejoin ['digit n - 1]
    set img make image! [80x180 255.255.255]
	draw get img collect [
	    repeat r 9 [
			repeat c 4 [  
				keep 'image
				keep to word! rejoin ['img either zero? digits/:n/:r/:c[1][2]]
				keep as-pair c - 1 * 20 r - 1 * 20
			]
		]
	]
]	

collect/into [
	repeat n 4 [
			keep reduce ['image to word! rejoin ['digit n] offs/:n]
		]
] draw-blk

update-time: has[
    t c p i sec 
][	
    t: now/time
	i: 0
	collect/into [
		foreach c rejoin [pad/left/with t/1 2 #"0" pad/left/with t/2 2 #"0"][
			p: -48 + to integer! c
			i: i + 1
		
			keep reduce ['image to word! rejoin ['digit p ] offs/:i]
		]
		sep:  either zero? t/3 % 2 ['sep1]['sep2]
        keep reduce['image 'sep1 160x0 'image sep 180x0 'image 'sep1 360x0]
         		
	] clear draw-blk
	append clear canvas/draw draw-blk	
]
	
view [
    title "Optical Illusion Clock"
    canvas: base 380x180 draw []
    rate 5 on-time [update-time]
]

Red [
	Title: "Thinking Machines Panel simulation"
	Author: "Galen Ivanov" 
]

light-rows: collect [ 
	loop 32 [ 
		keep/only collect [loop 32 [keep pick [red black] (random 9) < 4]]	
	]
]

move-lights: does [
	repeat row 32 [
		either zero? (to-integer row - 1 / 4) // 2 [
			move light-rows/:row tail light-rows/:row
		][
			move back tail light-rows/:row light-rows/:row
		]	
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
	    	keep 'fill-pen                                            	; 1	    												
	    	keep light-rows/:y/:x                                     	; 2 - these will be updated	           
	    	keep 'box													; 3 	
	    	keep make point2D! compose [(x - 1 * 16) (y - 1 * 16)]		; 4			
	    	keep make point2D! compose [(x * 16) (y * 16)] 				; 5		
	    ]	
	] 
]

view [
	title "Thinking Machines Display"
	base (256, 512) draw led-panel rate 8
	on-time [move-lights]
]

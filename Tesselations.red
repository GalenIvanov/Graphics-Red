Red [
    Title: "Plane tesselations"
	Author: "Galen Ivanov"
	Needs: 'View
]

{
The Grid is a set of Cells
The set is generated using Rules
}
{ 
  Rules: 
  [
     Square:	; type
	[ 
	     90 Square	; turning angle; the type of the neighbor sharing the same edge
	     90 Square
	     90 Square
	     90 Square 
	]
  ]
}

{
Cell [
    id: s1         ; the average of the coords of all edges? - a pair a x b 
	type: square   ; [ triangle square rhombus hexagon octagon ... ]
	color: 
	data:
	edges: [
	    edge1 id-neighbor1 or BORDER
		edge2 id-neighbor2 or BORDER
		...
		edge-n id-neighbor-n or BORDER
	]
]
}

cells: make block! 1000
cell-size: 0

;rules: [square: [90 square 90 square 90 square 90 square]] 
;rules: [hex: [120 hex 120 hex 120 hex 120 hex 120 hex 120 hex]]
;rules: [tri: [60 tri 60 tri 60 tri]]
;rules: [hex: [120 tri 120 tri 120 tri 120 tri 120 tri 120 tri]
;        tri: [60 hex 60 hex 60 hex]]
;rules: [octa: [135 octa 135 square 135 octa 135 square 135 octa 135 square 135 octa 135 square]
;        square: [90 octa 90 octa 90 octa 90 octa] ]
;rules: [square: [90 tri 90 tri 90 tri 90 tri]
;        tri: [60 tri 60 square 60 square]]

rules: [hex: [120 square 120 square 120 square 120 square 120 square 120 square]
        square: [90 tri 90 hex 90 tri 90 hex]
		tri: [60 square 60 square 60 square]]
;conds: [x > 40 x < 460 y > 40 y < 460]
conds: [200 > sqrt (x - 250 * (x - 250) + (y - 250 * ( y - 250)))]	
;conds: [ x + y > 250 x + y < 650 x - y > -150 x - y < 250 ]
cells-to-check: make block! 1000

num: 0

grid: [
    pen yello
	box 0x0 500x500
	line-width 2
	fill-pen papaya
	;box 40x40 460x460
	circle 250x250 200
	fill-pen beige
	pen orange
	polygon
]

calc-center: function [
    coords [block!] {a block with coordinates [x1 y1 x2 y2 ... xn yn]}
	factor [integer!] {scale factor}
][
    x: to integer! average extract coords 2
	y: to integer! average extract next coords 2
	as-pair round/to x factor round/to y factor
]

pair-cell-coords: function [
	cell [block!]
][
    grid: copy []
	foreach [x y] cell [
	    append grid as-pair to-integer x to-integer y
	]
	grid
]

calc-cell-points: func[
    size      [integer!] 
	x         [number!]  
	y         [number!]
    angle     [number!]
	cell-type [string!]
    /local
    cell poly rot ang
	
][
    cell: make block! 20
	poly: extract select rules to set-word! cell-type 2
	ang: angle
    foreach rot poly [
	    append cell reduce[x y]
		x: (size * cosine ang) + x
		y: y - (size * sine ang)
		ang: ang + 180 - rot  ; need to round it to the starting angle + possible steps!
	]
	cell
]

get-new-cell-edges: func [
    cell [block!]
	cell-type [string!]
	rules-offs [integer!]
	/local 
	n cell2 cell-rules
][
   		cell2: copy cell
		move/part cell2 tail cell2 2
	
		cell-rules: select rules to-set-word cell-type  ; needs anchor !
		move/part cell-rules tail cell-rules rules-offs - 2 

		collect/into [
		    repeat n to 1 (length? cell) / 2[
			    keep/only collect [
		            keep reduce [
					    cell/(n * 2 - 1)
						cell/(n * 2)
						cell2/(n * 2 - 1)
						cell2/(n * 2)
						to-string cell-rules/(n * 2) "_"
					]
		        ]
			]
			keep cell-type
		] make block! 4 * length? cell
]

within-area?: function [
    cell-center  [pair!]
	conds [block!]
][
	cell-xy: make object! [
	    x: cell-center/x
	    y: cell-center/y
	]	
	bind conds cell-xy        ; isn't it slow to bind it each time?
	either all conds [ yes ] [ no ]
] 

n-to-go: func[c-id][
    c-cell: copy select cells c-id
	remove-each e c-cell [e/6 <> "_"]
	length? c-cell
]

same-edge?: function [
     e1 [block!]
	 e2 [block!]
][
    either all [
	    1 > absolute e2/1 - e1/1
		1 > absolute e2/2 - e1/2
		1 > absolute e2/3 - e1/3
		1 > absolute e2/4 - e1/4
	][on][off]
]

make-id: function[coord][to-set-word rejoin ["C" coord]]

make-cells: has [
    cell-id
	cell
	cell-type
	edge
	n
	ang
	new-cell-id
	new-cell
	new-cell-edges
	new-center
	common-edge
	caller   ; type of the mother cell
	offs
][  

	;if not empty? cells-to-check [
	;	if num > 260 [return 1]
	;    num: num + 1
		cell-id: pick cells-to-check random length? cells-to-check
		cell: select cells cell-id
		caller: last cell

		edge: cell
		n: length? edge
		while [all[n > 0 edge/1/6 <> "_"]][
		    edge: next edge
		    n: n - 1
		]
		either zero? n [    ; selected cell has all edges processed
		    remove find cells-to-check cell-id

		][
		    edge: edge/1
			ang: 180 - arctangent2 edge/4 - edge/2 edge/3 - edge/1
		    
            new-cell: calc-cell-points cell-size edge/3 edge/4 ang edge/5
		    new-center: calc-center new-cell 2;cell-size
			
		    either within-area? new-center conds [
				new-cell-id: make-id new-center
            
		        either find cells new-cell-id [
		    	    ;if cell-id = new-cell-id [print ["Boom!" cell-id]]
		    		edge/6: new-cell-id
		    		if zero? n-to-go cell-id [remove find cells-to-check cell-id]
                    common-edge: reduce[edge/3 edge/4 edge/1 edge/2]
                    new-cell-edges: select cells new-cell-id
            
 		    		while [not same-edge? copy/part new-cell-edges/1 4 common-edge][ 
 		                new-cell-edges: next new-cell-edges
 		            ]
		    		new-cell-edges/1/6: cell-id
		    		if zero? n-to-go new-cell-id [remove find cells-to-check new-cell-id]
                ][
		    	    append cells-to-check new-cell-id
		    	    append cells new-cell-id

		    		edge/6: new-cell-id
		    		if zero? n-to-go cell-id [remove find cells-to-check cell-id]
		    		
					cell-type: edge/5
					
					offs: index? find rules/(to set-word! cell-type) to set-word! caller 
					append/only cells get-new-cell-edges new-cell cell-type offs 
					
					new-cell-edges: select cells new-cell-id
                    common-edge: reduce[edge/3 edge/4 edge/1 edge/2]
 		    		while [not same-edge? copy/part new-cell-edges/1 4 common-edge][ 
 		                new-cell-edges: next new-cell-edges
 		            ]
		    		new-cell-edges/1/6: cell-id
				
		    	    append grid 'polygon
                    append grid pair-cell-coords copy new-cell
		    	]
				
		    ][
                edge/6: "Border"
                if zero? n-to-go cell-id [remove find cells-to-check cell-id]
		    ]
        ]
		;make-cells
	;]
]

init-cells: func [
    new-rules [block!]
    new-conds [block!]
   	size      [integer!]
	posX      [number!]
	posY      [number!]
	rot       [integer!]
	cell-type [string!]
	/local cell cell-center n edges cell-name cell2
][
    random/seed now
    clear head cells
	rules: new-rules
	conds: new-conds
	cell-size: size
	
	cell: calc-cell-points size posX posY rot cell-type
	cell-center: calc-center cell 2; cell-size
	
	if within-area? cell-center conds [
	    cell-name: make-id cell-center
	    append cells cell-name
		append grid pair-cell-coords copy cell

        append/only cells get-new-cell-edges cell cell-type 0
		
		;append/only cells get-new-cell-edges cell 0
		append cells-to-check cell-name
    ]	
]


;init-cells rules conds 40 200 200 15 "square"
;init-cells rules conds 34 250 250 15 "hex"
init-cells rules conds 20 250 250 30 "tri"
;init-cells rules conds 20 200 200 30 "octa"

while [not empty? cells-to-check][make-cells]
;loop 20[make-cells]

;print calc-center [6.0 60.0 100.0 60.0 100.0 20.0 60.0 20.0] cell-size / 2

view [
   title "Tilings"
   base 500x500 teal
   draw grid
]

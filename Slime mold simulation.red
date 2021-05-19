Red [
    Title:  "Slime mold simulation, inspired by the work of Sebastian Lague"
    Author: "Galen Ivanov" 
	Note:   "Needs compilation!"
    needs:  view
]

random/seed now
W: 600
H: 400
N: 600
delta: 22

slime: make block! N * 4

tbuf: #{}
loop W * H * 3 [append tbuf 0]
bin: copy #{}
loop W * H * 3 [append bin 0]

init-slime: func [n] [
    collect [
        repeat i n [
            keep reduce [
                random W   ; pos X
                random H   ; pos Y
                random 360 ; angle
                3 + random 3    ; speed
            ]
        ]
    ]
]

#system[
    rsblur: func[
        buf  [red-binary!]
        w    [integer!]
        h    [integer!]
        tbuf [red-binary!]
        /local s src d dst offs offs- offs+ idx w3 x y
    ][
        s: GET_BUFFER(buf)
        src: (as byte-ptr! s/offset)
        d: GET_BUFFER(tbuf)
        dst: (as byte-ptr! d/offset)
        w3: w * 3
        loop h [
            idx: 1
            loop w3[
                offs-: idx - 3 // w3
                offs+: idx + 3 // w3
                dst/1: as byte!((as integer! src/idx)+(as integer! src/offs-)+(as integer! src/offs+) / 3)
                idx: idx + 1
                dst: dst + 1
            ]
            src: src + (3 * w)
        ]
        src: (as byte-ptr! s/offset)
        dst: (as byte-ptr! d/offset)
        y: 0
        offs: 1
        loop h [
            x: 1
            loop w3[
                offs-: y - 1 // h * w3 + x
                offs+: y + 1 // h * w3 + x
                src/1: as byte!((as integer! dst/offs)+(as integer! dst/offs-)+(as integer! dst/offs+) / 3)
                x: x + 1
                offs: offs + 1
                src: src + 1
            ]
            y: y + 1
        ]
    ]
]

blur: routine[
    buf    [binary!]
    width  [integer!]
    height [integer!]
    tbuf   [binary!]
][
    rsblur buf width height tbuf
]

update-slime: func[
    /local pix offs lines xl xc xr yl yc yr cl cc cr rnd
][
    offs: 1
    lines: collect [
        keep [line-width 2 pen orange]
        foreach [x y a s] slime [
            keep 'line
            keep as-pair to 1 x to 1 y

            a: a + 2 - random 4
            
            xc: x + (s * cosine a)
            yc: y - (s * sine a)
            cc: img/(as-pair xc yc)
            
            xl: x + (s * (cosine (a - delta)))
            yl: y - (s * (sine (a - delta)))
            cl: img/(as-pair xl yl)
            
            xr: x + (s * (cosine (a + delta)))
            yr: y - (s * (sine (a + delta)))
            cr: img/(as-pair xr yr)
            
            set [x y a] copy/part sort/reverse/skip/compare reduce [
                xl yl a - delta cl
                xc yc a cc
                xr yr a + delta cr
            ] 4 4 3
            
            slime/(offs + 2): a
            
        case [
                x < 1 [x: 1 slime/(offs + 2): 540 - a]
                x > W [x: W slime/(offs + 2): 180 - a]
                y < 1 [y: 1 slime/(offs + 2): 360 - a]
                y > H [y: H slime/(offs + 2): 360 - a]
            ]
            keep as-pair to 1 x to 1 y
            slime/:offs: x
            slime/(offs + 1): y
            offs: offs + 4
        ]
    ]

    draw img lines
    bin: img/rgb
    blur bin img/size/x img/size/y tbuf
    img/rgb: bin
    append clear canvas/draw [image img]
]

img: make image! compose[(as-pair W H) 0.0.0]
slime: init-slime N

view compose/deep [
    title "Slime simulation"
    canvas: base (as-pair W H) 
    draw [image (img)] rate 30 
    on-time [update-slime]
]
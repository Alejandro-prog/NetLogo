;;[0 170 204] Agua (Azul)
;;[230 27 27] Rojo (Russia)
;;[23 164 192] Agua 2 (Azul 2)
;;[96 0 128] Morado (Alemania)
;;[56 72 160] Morado 2
;;[104 106 124]rojo 2
;;[213 45 45] rojo 3
;;[49 83 165] morado 3
;;[6 160 200] rojo 3

breed [hitlers hitler]
breed [stalins stalin]
breed [tanquesnazis tanquenazi]
breed [tanquesovieticos tanquesovietico]
breed [soldadonazis soldadonazi]
breed [soldadosovieticos soldadosovietico]
breed [banderasnazis banderanazi]
breed [banderasovieticas banderasovietica]
breed [fires fire]


soldadonazis-own [vida target]
tanquesnazis-own [vida target]
soldadosovieticos-own [vida target]
tanquesovieticos-own [vida target]
hitlers-own [vida]
stalins-own [vida]

to go

  if not any? hitlers [ stop ]   ;; Para la ejecucion si muere hitler
  if not any? stalins [ stop ]   ;; Para si ejecucion si muere stalin
  iniciar_ticks                  ;; Metodo que inica los ticks
  mata_a_nazis_en_nieve          ;; Metodo que baja la vida de los nazis en la nieve
  matar_2                        ;; Metodo que mata los soldados y tanques que tengan vida igual o menor que 0
  pelear                         ;; Metodo que baja la vida de los soldados tanques y lideres si hay cerca enemigos
  mover_soldados_nazis           ;; Metodo que mueve a una posicion los soldados nazis
  mover_soldados_sovieticos      ;; Metodo que mueve a una posicion los soldados sovieticos
  ganar_sovieticos               ;; Metodo que valida si la vida del lider nazi es menor o igual a 0 y de ser así elimina a tanques y soldados nazis
  ganar_nazis                    ;; Metodo que valida si la vida del lider sovietico es menor o igual a 0 y de ser así elimina a tanques y soldados sovietico

end

to cargar_mapa

  clear-all
  reset-ticks

  import-pcolors-rgb "MapaSinNieve.png"

  ask patch -36 1[set plabel "ALEMANIA"]
  ask patch 30 17[set plabel "URSS"]

  set-default-shape banderasovieticas "banderasovietica"
  create-banderasovieticas 1;;initial-number-susceptibles
  [
   set size 2.8
   setxy 20 17
  ]

  set-default-shape banderasnazis "banderanazi"
  create-banderasnazis 1;;initial-number-susceptibles
  [
   set size 2.8
   setxy -36 7
  ]


  set-default-shape hitlers "hitler"
  create-hitlers 1;;initial-number-susceptibles
  [
   set size 2.8
   setxy -36 5
   set vida 150
  ]

  set-default-shape stalins "stalin"
  create-stalins 1
  [
   set size 2.5
   setxy 20 15
   set vida 150
  ]

  set-default-shape tanquesnazis "tanquenazi"
  create-tanquesnazis 20
  [
   set size 2.5
   setxy random-xcor random-ycor
   set vida 130
   set target one-of stalins
   face target
  ]

  set-default-shape tanquesovieticos "tanquesovietico"
  create-tanquesovieticos 20
  [
   set size 2.5
   setxy random-xcor random-ycor
   set vida 130
   set target one-of hitlers
   face target
  ]

  set-default-shape soldadonazis "soldadonazi"
  create-soldadonazis 100
  [
   set size 2.5
   set vida 100
   setxy random-xcor random-ycor
   set target one-of stalins
   face target
  ]

  set-default-shape soldadosovieticos "soldadosovietico"
  create-soldadosovieticos 100
  [
   set size 2.5
   setxy random-xcor random-ycor
   set vida 100
   set target one-of hitlers
   face target
  ]

  ask patches with [pcolor = [0 170 204] or pcolor = [23 164 192]] [
    ask soldadonazis-here [ setxy random-xcor random-ycor]
  ]

  ask patches with [pcolor = [0 170 204] or pcolor = [23 164 192]] [
    ask soldadosovieticos-here [setxy random-xcor random-ycor]
  ]

  ask patches with [pcolor = [0 170 204]  or pcolor = [23 164 192]] [
    ask tanquesovieticos-here [setxy random-xcor random-ycor]
  ]

  ask patches with [pcolor = [0 170 204]  or pcolor = [23 164 192]] [
    ask tanquesnazis-here [setxy random-xcor random-ycor]
  ]

  repeat 30 [ organizar_por_bandos ]

end

to iniciar_ticks

  if ticks >= 125 [
    import-pcolors-rgb "MapaConNieve.png"
    ask patches [set plabel-color black]
  ]
  tick

end

to pelear

  ask soldadosovieticos [ask soldadonazis in-radius 2.5 ;;Baja la vida de los soldadonazis si hay soldadosovieticos cerca
    [set vida vida - 13]]

  ask soldadosovieticos [ask tanquesnazis in-radius 2.5 ;;Baja la vida de los tanquesnazi si hay soldadosovieticos cerca
    [set vida vida - 9]]

  ask tanquesovieticos [ask soldadonazis in-radius 2.5 ;;Baja la vida de los soldadonazis si hay tanquesovieticos cerca
    [set vida vida - 30]]

  ask tanquesovieticos [ask tanquesnazis in-radius 2.5 ;;Baja la vida de los tanquesnazi si hay tanquesovieticos cerca
    [set vida vida - 20]]

  ask soldadonazis [ask soldadosovieticos in-radius 2.5 ;;Baja la vida de los soldadosovieticos si hay soldadonazis cerca
    [set vida vida - 13]]

  ask soldadonazis [ask tanquesovieticos in-radius 2.5 ;;Baja la vida de los tanquesovietico si hay soldadonazis cerca
    [set vida vida - 9]]

  ask tanquesnazis [ask soldadosovieticos in-radius 2.5 ;;Baja la vida de los soldadosovieticos si hay tanquesnazis cerca
    [set vida vida - 30]]

  ask tanquesnazis [ask tanquesovieticos in-radius 2.5 ;;Baja la vida de los tanquesovietico si hay tanquesnazis cerca
    [set vida vida - 20]]

  ask hitlers [ask soldadosovieticos in-radius 3 ;;Baja la vida de los soldadosovieticos si hay hitlers cerca
    [set vida vida - 2]]

  ask hitlers [ask tanquesovieticos in-radius 3 ;;Baja la vida de los tanquesovieticos si hay hitlers cerca
    [set vida vida - 1]]

    ask stalins [ask soldadonazis in-radius 3 ;;Baja la vida de los soldadonazis si hay stalins cerca
    [set vida vida - 2]]

  ask stalins [ask tanquesnazis in-radius 3 ;;Baja la vida de los tanquesnazis si hay stalins cerca
    [set vida vida - 1]]

   ask soldadosovieticos [ask hitlers in-radius 2.5 ;;Baja la vida de los hitlers si hay tanquesnazis cerca
    [set vida vida - 10]]

 ask tanquesovieticos [ask hitlers in-radius 2.5 ;;Baja la vida de los hitlers si hay tanquesnazis cerca
    [set vida vida - 10]]

   ask soldadonazis [ask stalins in-radius 2.5 ;;Baja la vida de los stalins si hay soldadonazis cerca
    [set vida vida - 10]]

 ask tanquesnazis [ask stalins in-radius 2.5 ;;Baja la vida de los stalins si hay tanquesnazis cerca
    [set vida vida - 10]]

end


to organizar_por_bandos ;;Metodo que organiza a los soldados y tanques en su respectuvo pais

  ask patches with [pcolor = [0 170 204] or pcolor = [230 27 27] or pcolor = [23 164 192] or pcolor = [104 106 124] or pcolor = [213 45 45] or pcolor = [6 160 200] or pcolor = [149 85 95]] [
    ask soldadonazis-here [ setxy random-xcor random-ycor]
  ]

  ask patches with [pcolor = [0 170 204] or pcolor = [230 27 27] or pcolor = [23 164 192] or pcolor = [104 106 124] or pcolor = [213 45 45] or pcolor = [6 160 200] or pcolor = [149 85 95]] [
    ask tanquesnazis-here [setxy random-xcor random-ycor]
  ]

   ask patches with [pcolor = [0 170 204] or pcolor =[96 0 128] or pcolor = [23 164 192] or pcolor = [56 72 160] or pcolor = [49 83 165] or pcolor = [6 160 200] or pcolor = [48 86 166] or pcolor = [57 69 159] or pcolor = [221 25 33]] [
    ask soldadosovieticos-here [setxy random-xcor random-ycor]
  ]

   ask patches with [pcolor = [0 170 204] or pcolor = [96 0 128] or pcolor = [23 164 192] or pcolor = [56 72 160] or pcolor = [49 83 165] or pcolor = [6 160 200] or pcolor = [48 86 166] or pcolor = [57 69 159]  or pcolor = [221 25 33]] [
    ask tanquesovieticos-here [setxy random-xcor random-ycor]
  ]


end


to mata_a_nazis_en_nieve

  ask patches with [pcolor = [0 170 204] or pcolor = [255 255 255] or pcolor = [23 164 192]] [
    ask tanquesnazis-here [ set vida vida - 7 ]
  ]

  ask patches with [pcolor = [0 170 204] or pcolor = [255 255 255] or pcolor = [23 164 192]] [
    ask soldadonazis-here [ set vida vida - 7 ]
  ]
end

to matar_2

 ask soldadonazis [
  if vida <= 0 [
   ask soldadonazis-here [ die ]
  ]
 ]

 ask tanquesnazis [
  if vida <= 0 [
   ask tanquesnazis-here [ die ]
  ]
 ]

 ask soldadosovieticos [
  if vida <= 0 [
   ask soldadosovieticos-here [ die ]
  ]
 ]

 ask tanquesovieticos [
  if vida <= 0 [
   ask tanquesovieticos-here [ die ]
  ]
 ]

end

to banderaNaziGanador
  import-pcolors-rgb "banderaNazi.jpg"
end

to banderaSovieticaGanador
  import-pcolors-rgb "banderaSovietica.jpg"
end

to mapa1
  import-pcolors-rgb "MapaSinNieve.png"
end


to mapa2
  import-pcolors-rgb "MapaConNieve.png"
end

to ganar_sovieticos

 ask hitlers [
  if vida <= 0 [
   ask patch 0 0[set plabel "GAME OVER NAZI"]
   ask soldadonazis [ die ]
   ask tanquesnazis [ die ]
   ask hitlers [die]
  ]
 ]

end

to ganar_nazis

 ask stalins [
  if vida <= 0 [
   ask patch 0 0[set plabel "GAME OVER SOVIETICOS"]
   ask soldadosovieticos [ die ]
   ask tanquesovieticos[ die ]
   ask stalins [ die ]
  ]
 ]

end

to mover_soldados_nazis

 ask stalins [
  if vida > 0 [
      ask soldadonazis [
        ifelse distance target < 2
        []
        [fd 1]
      ]

      ask tanquesnazis [
        ifelse distance target < 2
        []
        [fd 1]
       ]
    ]
 ]

  ask patches with [pcolor = [23 164 192] or pcolor = [0 170 204]] [
    ask soldadonazis-here [setxy random-xcor random-ycor ]
  ]

  ask patches with [pcolor = [23 164 192] or pcolor = [0 170 204]] [
    ask tanquesnazis-here [setxy random-xcor random-ycor ]
  ]
 tick

end

to mover_soldados_sovieticos

  ask hitlers [
    if vida > 0 [
      ask soldadosovieticos [
        ifelse distance target < 2
        [ ]
        [fd 1]
      ]

      ask tanquesovieticos [
        ifelse distance target < 2
        [  ]
        [fd 1]
      ]
    ]
  ]

  ask patches with [pcolor = [23 164 192] or pcolor = [0 170 204]] [
    ask tanquesovieticos-here [setxy random-xcor random-ycor ]
  ]
  ask patches with [pcolor = [23 164 192] or pcolor = [0 170 204]] [
    ask soldadosovieticos-here [setxy random-xcor random-ycor ]
  ]
 tick

end
@#$#@#$#@
GRAPHICS-WINDOW
249
10
1247
489
-1
-1
10.0
1
20
1
1
1
0
0
0
1
-49
49
-23
23
0
0
1
ticks
100.0

BUTTON
8
17
238
90
Cargar Mapa
cargar_mapa
NIL
1
T
OBSERVER
NIL
+
NIL
NIL
1

BUTTON
31
282
197
351
Gana Alemania
banderaNaziGanador
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
31
203
196
274
Gana URSS
banderaSovieticaGanador\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
94
237
174
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

banderanazi
false
0
Rectangle -2674135 true false 0 0 300 180
Rectangle -16777216 true false 0 0 30 300
Circle -1 true false 75 0 180
Rectangle -16777216 true false 120 75 210 90
Rectangle -16777216 true false 105 15 120 90
Rectangle -16777216 true false 195 75 210 150
Rectangle -16777216 true false 150 15 165 90
Rectangle -16777216 true false 150 75 165 150
Rectangle -16777216 true false 105 135 165 150
Rectangle -16777216 true false 150 15 210 30
Rectangle -1 false false 30 0 300 180

banderasovietica
false
0
Rectangle -2674135 true false 0 0 300 195
Rectangle -16777216 true false 0 0 30 300
Polygon -1184463 false false 225 60 210 90 240 60 270 90 255 60 285 45 255 45 240 15 225 45 195 45 225 60
Rectangle -1 false false 30 -15 315 195

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -1184463 true false 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hitler
false
4
Rectangle -7500403 false false 105 30 195 105
Rectangle -7500403 false false 135 105 165 120
Rectangle -2064490 true false 90 30 210 135
Rectangle -16777216 true false 135 75 135 90
Rectangle -16777216 true false 135 75 165 90
Rectangle -16777216 true false 120 45 150 45
Rectangle -16777216 true false 120 45 135 60
Rectangle -16777216 true false 165 45 180 60
Rectangle -6459832 true false 90 120 225 180
Rectangle -16777216 true false 120 15 210 30
Rectangle -2674135 true false 135 150 165 165
Rectangle -6459832 true false 105 195 135 285
Rectangle -6459832 true false 165 165 195 285
Rectangle -6459832 true false 90 135 135 150
Rectangle -6459832 true false 60 135 90 165
Rectangle -6459832 true false 45 105 75 135
Rectangle -2064490 true false 75 60 105 90
Rectangle -6459832 true false 105 195 195 225
Rectangle -2674135 true false 210 150 225 165
Rectangle -2674135 true false 150 135 165 150
Rectangle -6459832 true false 135 135 195 165
Rectangle -2674135 false false 120 90 180 105
Rectangle -2674135 true false 120 90 180 105
Rectangle -16777216 true false 75 30 90 105
Rectangle -6459832 true false 60 105 90 135
Rectangle -6459832 true false 60 75 90 105
Rectangle -2674135 true false 195 150 210 165
Line -16777216 false 195 135 195 210
Rectangle -16777216 false false 90 30 210 120
Rectangle -6459832 true false 105 165 195 210
Rectangle -2064490 true false 75 45 105 75
Rectangle -2064490 true false 75 45 105 75
Rectangle -16777216 false false 75 45 105 75
Rectangle -16777216 false false 105 120 195 195
Rectangle -16777216 true false 105 270 135 285
Rectangle -16777216 true false 165 270 195 285
Rectangle -7500403 false false 105 270 135 285
Rectangle -7500403 false false 165 270 195 285

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

soldadonazi
false
4
Rectangle -2064490 true false 105 45 210 135
Rectangle -16777216 true false 120 135 195 255
Rectangle -16777216 true false 90 135 120 210
Rectangle -16777216 true false 195 135 225 210
Rectangle -2674135 true false 90 150 120 165
Rectangle -16777216 false false 120 135 195 225
Rectangle -16777216 true false 165 75 180 90
Rectangle -16777216 true false 135 75 150 90
Rectangle -16777216 true false 120 45 195 60
Rectangle -16777216 true false 105 15 210 45
Rectangle -2674135 true false 135 105 180 120
Rectangle -16777216 false false 195 135 225 210
Rectangle -16777216 false false 90 135 120 210
Rectangle -16777216 true false 165 240 195 300
Rectangle -16777216 true false 120 240 150 300
Rectangle -2674135 true false 120 210 195 225
Rectangle -16777216 false false 165 225 195 300
Rectangle -16777216 false false 120 225 150 300
Rectangle -10899396 true false 105 180 255 195
Rectangle -6459832 true false 195 180 195 180
Rectangle -10899396 true false 135 165 210 180
Rectangle -10899396 false false 135 180 210 195
Rectangle -10899396 false false 90 180 255 195
Rectangle -10899396 true false 90 180 120 225
Rectangle -13840069 false false 90 180 120 225
Rectangle -16777216 true false 165 285 195 300
Rectangle -16777216 true false 120 285 150 300

soldadosovietico
false
4
Rectangle -2064490 true false 90 45 195 135
Rectangle -6459832 true false 105 135 180 255
Rectangle -6459832 true false 180 135 210 210
Rectangle -6459832 true false 75 135 105 210
Rectangle -6459832 false false 105 135 180 225
Rectangle -16777216 true false 120 75 135 90
Rectangle -16777216 true false 150 75 165 90
Rectangle -7500403 true false 75 30 210 60
Rectangle -7500403 true false 90 15 195 45
Rectangle -2674135 true false 120 105 165 120
Rectangle -6459832 false false 75 135 105 210
Rectangle -6459832 false false 180 135 210 210
Rectangle -6459832 true false 105 240 135 300
Rectangle -6459832 true false 150 240 180 300
Rectangle -7500403 true false 105 210 180 225
Rectangle -6459832 false false 105 225 135 300
Rectangle -6459832 false false 150 225 180 300
Rectangle -16777216 true false 45 180 195 195
Rectangle -6459832 true false 105 180 105 180
Rectangle -16777216 true false 90 165 165 180
Rectangle -16777216 false false 90 165 165 180
Rectangle -16777216 false false 45 180 210 195
Rectangle -16777216 true false 180 180 210 225
Rectangle -16777216 false false 180 180 210 225
Rectangle -6459832 true false 105 285 135 300
Rectangle -6459832 true false 150 285 180 300

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

stalin
false
4
Rectangle -7500403 false false 90 30 195 120
Rectangle -2064490 true false 90 30 210 135
Rectangle -7500403 true false 105 135 195 210
Rectangle -6459832 true false 120 90 180 105
Rectangle -6459832 true false 150 105 165 120
Rectangle -6459832 true false 105 105 120 120
Rectangle -16777216 true false 120 60 135 75
Rectangle -16777216 true false 165 60 180 75
Rectangle -6459832 true false 90 15 195 45
Rectangle -2674135 true false 120 105 180 120
Rectangle -6459832 true false 195 15 210 90
Rectangle -6459832 true false 180 105 195 120
Rectangle -7500403 true false 105 210 135 285
Rectangle -7500403 true false 165 210 195 285
Rectangle -7500403 true false 120 210 180 240
Rectangle -16777216 false false 105 135 195 210
Rectangle -2674135 true false 75 135 120 150
Rectangle -2674135 true false 180 135 225 150
Rectangle -7500403 true false 75 150 105 180
Rectangle -7500403 true false 195 150 225 180
Rectangle -7500403 true false 75 180 135 195
Rectangle -16777216 false false 75 180 135 195
Rectangle -16777216 false false 165 180 225 195
Rectangle -7500403 true false 165 180 225 195
Rectangle -16777216 false false 195 180 225 195
Rectangle -16777216 true false 105 270 135 285
Rectangle -7500403 false false 105 270 135 285
Rectangle -16777216 true false 165 270 195 285
Rectangle -7500403 false false 165 270 195 285
Polygon -7500403 false false 135 165

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

tanquenazi
false
0
Rectangle -16777216 false false 135 90 180 210
Rectangle -13840069 true false 30 75 195 210
Circle -16777216 true false 30 225 60
Circle -16777216 true false 60 225 60
Circle -16777216 true false 90 225 60
Circle -16777216 true false 120 225 60
Circle -16777216 true false 30 15 60
Circle -16777216 true false 60 15 60
Circle -16777216 true false 90 15 60
Circle -16777216 true false 135 15 60
Rectangle -13840069 true false 15 210 240 255
Rectangle -13840069 true false 15 45 240 90
Rectangle -10899396 true false 90 135 285 165
Rectangle -16777216 false false 120 135 285 165
Rectangle -10899396 true false 120 90 180 210
Rectangle -16777216 false false 285 135 300 165
Rectangle -13840069 true false 285 135 300 165
Rectangle -16777216 false false 285 135 300 165
Rectangle -16777216 false false 15 210 240 255
Rectangle -16777216 false false 15 45 240 90
Circle -10899396 true false 15 77 148
Circle -16777216 false false 15 75 150
Rectangle -16777216 true false 105 150 120 165
Rectangle -16777216 true false 105 165 120 180
Rectangle -16777216 true false 105 135 120 150
Rectangle -16777216 true false 90 135 105 150
Rectangle -16777216 true false 75 135 90 150
Rectangle -16777216 true false 75 150 90 165
Rectangle -16777216 true false 75 165 90 180
Rectangle -16777216 true false 60 165 75 180
Rectangle -16777216 true false 45 165 60 180
Rectangle -16777216 true false 60 135 75 150
Rectangle -16777216 true false 45 135 60 150
Rectangle -16777216 true false 45 120 60 135
Rectangle -16777216 true false 45 105 60 120
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 75 105 90 120
Rectangle -16777216 true false 90 105 105 120
Rectangle -16777216 true false 105 105 120 120

tanquesovietico
false
0
Rectangle -16777216 false false 120 90 165 210
Rectangle -13840069 true false 105 90 270 225
Circle -16777216 true false 210 15 60
Circle -16777216 true false 180 15 60
Circle -16777216 true false 150 15 60
Circle -16777216 true false 120 15 60
Circle -16777216 true false 210 225 60
Circle -16777216 true false 180 225 60
Circle -16777216 true false 150 225 60
Circle -16777216 true false 105 225 60
Rectangle -13840069 true false 60 45 285 90
Rectangle -13840069 true false 60 210 285 255
Rectangle -10899396 true false 15 135 210 165
Rectangle -16777216 false false 15 135 180 165
Rectangle -10899396 true false 120 90 180 210
Rectangle -16777216 false false 0 135 15 165
Rectangle -13840069 true false 0 135 15 165
Rectangle -16777216 false false 0 135 15 165
Rectangle -16777216 false false 60 45 285 90
Rectangle -16777216 false false 60 210 285 255
Circle -10899396 true false 137 75 148
Circle -16777216 false false 135 75 150
Polygon -2674135 true false 210 120 150 105 195 150 150 195 210 180 240 225 240 165 285 150 240 135 240 75 210 120 210 120
Circle -1184463 true false 210 135 30

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

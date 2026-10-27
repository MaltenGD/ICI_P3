# **Diario de la Práctica 3**

## **MS PACMAN**
### Versiones

#### **1) MsPacMan_test** – Sábado 24 de octubre del 2026 (línea test)

Contenido/Cambios:
Este controlador parte del controlador anterior del grupo GRIM_LC con el objetivo de reutilizar el mapa de costes.

Dentro de lo planeado se necesita los siguientes archivos java para las accones:
* CazaAction
* ComerAction
* HuirAction
* IrPPillAction
* PerseguirAction
* MapaCostes

La relación sería el siguiente: Dependiendo de lo que se cumpla dentro de las reglas este accede a los archivos de las acciones y estas devuelven la fase que se las da al MapaCostes, de aquí se calcula el peso de los nodos y devuelve el siguiente movimiento para el pacman que sería el mejor.

Apoyo de IA: Si, pero al final no se realizo dicha versión ya que resulta que no se diferencia de una maquina de estados y preferimos optar por una base nueva que parte del ejemplo dado en la practica 3.

#### **2) MsPacMan_Version0** – Sábado 25 de octubre del 2026 (línea base)

Contenido/Cambios: Dentro de este controlador hemos añadido AcecharAction que tiene el objetivo de hacer que el pacman vaya a un cruce de aproximadamente 25 nodos más cercanos a un fantasma no comestible para cortarle el paso. Si el fantasma no es comestible y esta a menos de 6 nodos de él, el pacman intentará huir.

También se editó las acciones Comer,Huir,IrAPPill y Perseguir.

Partida MsPacMan:

== puntos: v1 frente a v0 (más es mejor) ==
rival                        v0               v1         D   2·ET_D
Random                1991 ± 74        2139 ± 87      +148      228  ruido
Aggressive           1598 ± 118        1442 ± 92      -156      299  ruido
Basico                1275 ± 61        1156 ± 54      -119      164  ruido
Intermedio            1236 ± 71        1419 ± 93      +183      233  ruido
Avanzado              1127 ± 55        1252 ± 57      +125      159  ruido
------------------------------------------------------------------------
MEDIA (5)             1445 ± 35        1482 ± 35       +36      100  ruido
v1 es mejor contra 0 rivales, peor contra 0 y no se distingue contra 5.

== turnos por vida: v1 frente a v0 (más es mejor) ==
rival                        v0               v1         D   2·ET_D
Random                 536 ± 24         632 ± 47       +96      105  ruido
Aggressive            890 ± 139        576 ± 108      -314      352  ruido
Basico                 254 ± 14         232 ± 10       -22       34  ruido
Intermedio             240 ± 39          198 ± 8       -42       79  ruido
Avanzado               224 ± 20         255 ± 26       +30       66  ruido
------------------------------------------------------------------------
MEDIA (5)              429 ± 30         379 ± 24       -50       77  ruido
v1 es mejor contra 0 rivales, peor contra 0 y no se distingue contra 5.

== fantasmas comidos: v1 frente a v0 (más es mejor) ==
rival                        v0               v1         D   2·ET_D
Random              1,43 ± 0,13      1,84 ± 0,17     +0,41     0,43  ruido
Aggressive          1,50 ± 0,18      1,13 ± 0,15     -0,37     0,46  ruido
Basico              0,67 ± 0,11      0,50 ± 0,09     -0,17     0,28  ruido
Intermedio          0,79 ± 0,12      1,07 ± 0,13     +0,28     0,36  ruido
Avanzado            0,54 ± 0,09      0,72 ± 0,09     +0,18     0,26  ruido
------------------------------------------------------------------------
MEDIA (5)           0,99 ± 0,06      1,05 ± 0,06     +0,07     0,16  ruido
v1 es mejor contra 0 rivales, peor contra 0 y no se distingue contra 5.


Comparación:

D      = 3150,4 − 2797,8 = +352,6

ET_D   = √(196,67² + 149,33²) ≈ 246,9

2·ET_D = 493,9

|D| = 352,6 < 493,9 → no se distingue de ruido

#### **2) MsPacMan_Version0.1** – Sábado 26 de octubre del 2026

Contenido/Cambios: Se descarta el uso e AcecharAction porque reduce la duración media de las partidas de 1074 a 744. El codigo se conserva en el repositorio como referencia.


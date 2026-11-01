# Diario - Práctica 3: Fantasmas

**Integrantes:** Óliver García Aguado y Guillermo Isaac Ramos Medina
**Grupo:** OGA_GIRM  
**Controlador:** Fantasmas

---

## Sesión 1 · Primer contacto con Jess y port de la Pracitca 2 a reglas (version v0)

Empezamos la práctica leyendo la wiki de la asignatura y mirando qué traía el zip de partida. Al principio el tema de las reglas con Jess nos chocó un poco, sobre todo al ver cómo se integraba Java con CLIPS: las clases RuleEngine, RulesInput y RulesAction, cómo funciona la agenda de Rete y cómo se resuelve qué acción ejecutar con el campo "priority" del hecho "ACTION".

Estuvimos un buen rato decidiendo qué estrategia seguir. Vimos claro que ponernos a inventar una lógica de cero en un lenguaje nuevo era una mala idea e iba a ser complicado. Como el controlador de la práctica anterior (GhostsV0Me) funciona bien, decidimos que la "v0" de esta práctica fuera un port directo de la máquina de estados a reglas.

Antes de programar tuvimos en cuenta que:
- CLIPS tiene que usarse para evaluar condiciones y decidir prioridades, sin meter logica pesada ahí dentro.
- Toda la matemática pesada la dejariamos en metodos estáticos en alguna clase auxiliar (esta terminó siendo LogicaFantasma.java.)
- Las acciones de la FSM anterior las adaptamos a clases que heredan de "RulesAction": "PerseguirAction", "HuirAction", "EmboscarAction", "GuardarPPillAction" y "DispersarAction".
- En "GhostsInput.java" preparamos los hechos que necesita leer el motor: el hecho "FANTASMA" con las distancias calculadas y si está en la cárcel o comestible, el hecho "MSPACMAN" con la distancia a la píldora de poder más cercana, y el hecho "GRUPO" con el booleano "apretado" para saber si hay compañeros a menos de 5 nodos.

Al principio dudamos si crear cuatro archivos ".clp" separados (uno para cada fantasma), pero era una locura mantener cuatro ficheros casi iguales. Lo solucionamos metiendo el hecho "(YO (nombre ?yo))" que se aserta antes de cada turno en Java, y así usamos un único archivo "ghosts-v0.clp" para los cuatro.

Tuvimos un par de problemas al arrancar con Jess (por ejemplo, recordar que los booleanos en los templates van como símbolos en minúsculas tipo "true"/"false", y ajustar los tipos de los slots numéricos para que no diera error de parseo). Una vez resuelto, dejamos montadas las **6 reglas** de partida:

- "huirComestible" (prioridad 90): si somos comestibles y estamos libres, huir.
- "dispersar" (prioridad 40): si el grupo está apretado y Ms. Pac-Man no está encima, abrirse en las intersecciones.
- "emboscarPinky" (prioridad 20): solo para Pinky, prediciendo casillas por delante de Pac-Man.
- "guardarPPillInky" (prioridad 20): solo para Inky, si llega a una píldora de poder con ventaja frente a Pac-Man.
- "perseguir" (prioridad 10): regla base por defecto para Blinky y Sue, o cuando los otros no tienen rol activo.
- "pacmanCerca" (salience 10): regla intermedia. Si Pac-Man está a 10 o menos pasos, mete el hecho "(PACMAN_CERCA)" para que la regla de dispersión no se dispare y los fantasmas no se abran cuando están a punto de cazarla.

## diario - practica 3, fantasmas v1
## 30 de octubre de 2026 - v1

Se ha creado una primera version de las reglas de los fantasmas a partir de la plantilla GhostsInput. Definimos quince reglas para controlar el comportamiento de BLINKY, PINKY, INKY y SUE. Usamos la estrategia de la práctica 2 de estrategias con diferentes prioridades para decidir las acciones: Huir tiene prioridad 100, dispersarse 50, guardar una pildora de poder 40, emboscar 30 y perseguir 10.

Detectaremos si el pacMan está cerca cuando la distancia es de diez pasos o menos. tambien se comprueba si el grupo esta demasiado junto para permitir que los fantasmas se distribuyan por el mapa. Se han añadido reglas para huir cuando el fantasma es comestible. tambien se permite perseguir cuando no es comestible, y se asignan comportamientos diferentes segun el fantasma: PINKY puede emboscar, INKY puede guardar una pildora de poder y el resto puede mantener la persecucion.
Por ultimo, se han añadido reglas para dispersar al grupo cuando los fantasmas estan demasiado juntos y pacman se encuentra lejos.

Ayuda de ia en esta version:
se ha utilizado la ia para revisar la estrategia inicial, ampliar las reglas de comportamiento y preparar las condiciones de huida, persecucion, emboscada, control de pildoras de poder y dispersion.

Analiza las quince reglas iniciales de fantasmas y busca problemas en las prioridades, las condiciones y las acciones que pueden activarse al mismo tiempo. Además, quiero mejorar el comportamiento para que pacman consiga la menor puntuacion posible. Revisa las reglas de huida. Cuando un fantasma sea comestible debe evitar perseguir a pacman y elegir huir. Comprueba tambien la distancia a pacman y la situacion de las pildoras de poder.
Mejora el comportamiento de PINKY para que pueda emboscar cuando pacman este lejos y perseguir directamente cuando este cerca.
Mejora el comportamiento de INKY para que controle las pildoras de poder cuando tenga ventaja para llegar antes que pacman. si no tiene ventaja, debe mantener la persecucion. Revisa la coordinacion de los cuatro fantasmas. cuando el grupo este demasiado junto y pacman se encuentre lejos, deben dispersarse para cubrir mas zonas del mapa.

### resultados de v1 frente a v0

#### Turnos por vida
| rival | v1 ± error tipico | v0 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Basico | 440 ± 38 | 487 ± 42 | +47 | 113 | ruido |
| Intermedio | 2939 ± 82 | 2910 ± 83 | -29 | 234 | ruido |
| Avanzado | 2034 ± 72 | 2171 ± 78 | +138 | 213 | ruido |
| MEDIA (3) | 1804 ± 39 | 1856 ± 41 | +52 | 112 | ruido |

La media de turnos por vida pasa de 1856 a 1804. v1 reduce los turnos por vida, aunque ninguna diferencia supera el umbral estadistico. esta metrica es secundaria, ya que el objetivo principal es reducir los puntos de pacman.

#### Fantasmas comidos
| rival | v1 ± error tipico | v0 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Basico | 2,01 ± 0,09 | 2,05 ± 0,09 | +0,04 | 0,26 | ruido |
| Intermedio | 3,66 ± 0,18 | 3,31 ± 0,18 | -0,34 | 0,52 | ruido |
| Avanzado | 11,97 ± 0,21 | 12,14 ± 0,22 | +0,17 | 0,61 | ruido |
| MEDIA (3) | 5,88 ± 0,10 | 5,83 ± 0,10 | -0,04 | 0,28 | ruido |

### Puntos frente a v0
| rival | v1 ± error tipico | v0 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Basico | 2221 ± 54 | 2230 ± 57 | +10 | 157 | ruido |
| Intermedio | 3661 ± 136 | 3446 ± 131 | -214 | 378 | ruido |
| Avanzado | 8926 ± 152 | 9079 ± 156 | +152 | 436 | ruido |
| MEDIA (3) | 4936 ± 70 | 4918 ± 71 | -17 | 199 | ruido |

La media de puntos baja de 4918 a 4936? la diferencia real es de 17 puntos a favor de v0. por tanto, v1 obtiene una puntuacion ligeramente mayor y no supone una mejora. las diferencias contra los tres rivales estan dentro del margen de ruido estadistico.


## Valoracion de los cambios

v1 presenta resultados muy parecidos a v0. la media de puntos aumenta ligeramente, por lo que no se ha conseguido mejorar el objetivo principal.
se observa una mejora en algunos resultados contra el rival Avanzado, pero empeora contra Intermedio. ninguna diferencia es estadisticamente significativa.
el problema principal es que las reglas pueden generar varias acciones simultaneas para un mismo fantasma. ademas, algunas condiciones son demasiado generales: por ejemplo, la regla de huida se activa siempre que el fantasma es comestible, sin valorar suficientemente las distancias y las oportunidades de escapar.
tambien es necesario mejorar la coordinacion entre fantasmas para evitar que todos persigan al mismo objetivo o que dejen zonas importantes sin cubrir.

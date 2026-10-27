# diario - practica 3, pacman

## 25 de octubre de 2026 - v2

se ha ampliado la plantilla de siete reglas para que pacman pueda decidir mejor cuando huir, buscar poder o perseguir a un fantasma. en esta version se tienen nueve reglas.

primero se ha revisado la informacion que reciben las reglas. en MsPacManInput.java se recogen los datos del juego y se preparan las distancias, las salidas disponibles y los objetivos de comida y poder. tambien se calcula un margen para estimar si un fantasma puede alcanzar a pacman durante el recorrido.

para huir se comparan las salidas que puede utilizar segun su ultima direccion, sin proponer un giro de 180 grados. para cazar se comprueba que quede tiempo suficiente antes de que el fantasma deje de ser comestible y que el camino tenga margen frente a los otros fantasmas.

se han añadido dos reglas para cuando lo persiguen varios fantasmas. una comprueba si hay al menos dos fantasmas peligrosos a menos de treinta pasos y crea el hecho ACOSO. la otra utiliza ese hecho para ir a por una pildora de poder a ochenta pasos o menos, siempre que el camino tenga margen suficiente. asi no se descarta el poder solo porque los perseguidores esten mas cerca que la pildora.

el codigo se ha separado en varios archivos:

- MsPacMan.java: crea el motor de reglas, registra las acciones y pide el movimiento de cada turno. las reglas se cargan una sola vez al crear el controlador.

- MsPacManInput.java: recoge los datos del juego y los convierte en hechos para que las reglas puedan consultarlos.

- Caminos.java: agrupa los calculos de caminos, distancias y margenes de seguridad.

- UltimaAccion.java: recuerda la accion que ha ganado, el objetivo y el fantasma elegido.

- IrObjetivoAction.java: ejecuta el movimiento indicado por la accion ganadora. se utiliza con distintos identificadores para comer, huir, buscar poder y cazar.

- mspacman-v2.clp: contiene las nueve reglas de esta version.

las decisiones se dejan en el archivo de reglas. Java prepara los datos y ejecuta el movimiento que se ha elegido. en cada turno se actualizan los hechos y RuleEngine devuelve la accion con mayor prioridad.

### ayuda de ia en esta version

se ha pedido ayuda a la ia para ampliar las siete reglas de la plantilla y programar en Java los calculos de caminos, los hechos y las acciones. tambien ha ayudado a separar el codigo en archivos y preparar las pruebas y las partidas de comparacion.

### prompts de ejemplo

1. amplia MsPacManInput para preparar la informacion que necesitan las reglas. recorre los fantasmas y descarta los que siguen en la carcel. guarda la distancia, si son comestibles y cuanto tiempo les queda. prepara tambien las pildoras disponibles y las salidas permitidas segun la ultima direccion de pacman.

2. crea Caminos.java para reunir los calculos que se van a repetir. necesito buscar rutas con los metodos del motor y comprobar si un fantasma puede alcanzar a pacman durante el recorrido. ten en cuenta la distancia de contacto del juego y el tiempo que le queda comestible. limita la comprobacion a cuarenta nodos y no permitas girar 180 grados.

3. modifica la accion de huir para comparar las salidas disponibles. calcula el margen frente a los fantasmas en cada recorrido y pasa esa informacion como hechos SALIDA. deja que la regla de huida elija la salida con mayor margen y que la accion ejecute el movimiento indicado.

4.  añade una regla para detectar cuando lo persiguen varios fantasmas. comprueba que haya dos fantasmas distintos, peligrosos y a menos de treinta pasos. cuando se cumpla, crea el hecho ACOSO. añade otra regla que use ese hecho para buscar una pildora de poder a ochenta pasos o menos si su camino tiene margen suficiente.

5. revisa las reglas de perseguir y rematar. no basta con que el fantasma sea comestible: comprueba que su tiempo restante supere el doble de la distancia mas ocho pasos y que la ruta tenga margen frente a los otros fantasmas. guarda la accion ganadora y sus parametros en UltimaAccion para consultarlos en el siguiente turno.

### resultados de v2 frente a v1

se ha probado v2 frente a la plantilla v1 con trescientas partidas por rival y version, semillas del 1 al 300 y el mismo limite de cuatro mil turnos. para v1 se utiliza MsPacManEjemplo con sus hechos y acciones originales; para v2, MsPacMan con los calculos ampliados.

esta es una tanda distinta de la comparacion de v2 frente a v2.1 del siguiente apartado. las cifras de v2 pueden variar entre tandas, por lo que cada version se compara con la otra dentro de su propia ejecucion. todos los valores despues de ± son errores tipicos, no desviaciones tipicas.

#### puntos

| rival | v1 ± error tipico | v2 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 4342 ± 128 | 5929 ± 165 | +1587 | 418 | mejor |
| Aggressive | 3639 ± 142 | 4155 ± 154 | +516 | 419 | mejor |
| basico | 2349 ± 80 | 4250 ± 119 | +1901 | 287 | mejor |
| intermedio | 2374 ± 92 | 3371 ± 113 | +997 | 292 | mejor |
| avanzado | 1829 ± 51 | 2551 ± 57 | +722 | 153 | mejor |
| media de los cinco rivales | 2907 ± 47 | 4051 ± 57 | +1144 | 147 | mejor |

la media de puntos sube de 2907 a 4051, aproximadamente un 39.4 %. la v2 mejora frente a los cinco rivales y en todos los casos la diferencia supera el limite que utiliza el comparador para distinguirla del ruido.

#### turnos por vida

| rival | v1 ± error tipico | v2 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 551 ± 22 | 936 ± 47 | +385 | 105 | mejor |
| Aggressive | 722 ± 70 | 2521 ± 95 | +1799 | 235 | mejor |
| basico | 264 ± 7 | 605 ± 29 | +341 | 59 | mejor |
| intermedio | 254 ± 18 | 426 ± 34 | +172 | 77 | mejor |
| avanzado | 375 ± 40 | 350 ± 14 | -25 | 86 | ruido |
| media de los cinco rivales | 433 ± 17 | 967 ± 23 | +534 | 58 | mejor |

la media de turnos por vida pasa de 433 a 967, aproximadamente un 123.3 % mas. mejora frente a cuatro rivales. frente al avanzado baja la media, pero la diferencia queda dentro del ruido y no se puede afirmar que empeore con esta prueba.

#### fantasmas comidos

| rival | v1 ± error tipico | v2 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 5.60 ± 0.19 | 7.14 ± 0.22 | +1.53 | 0.57 | mejor |
| Aggressive | 4.04 ± 0.18 | 5.01 ± 0.21 | +0.97 | 0.55 | mejor |
| basico | 2.76 ± 0.13 | 5.31 ± 0.17 | +2.55 | 0.43 | mejor |
| intermedio | 2.58 ± 0.13 | 4.01 ± 0.16 | +1.44 | 0.42 | mejor |
| avanzado | 2.04 ± 0.10 | 3.16 ± 0.11 | +1.12 | 0.29 | mejor |
| media de los cinco rivales | 3.40 ± 0.07 | 4.92 ± 0.08 | +1.52 | 0.21 | mejor |

la media de fantasmas comidos pasa de 3.40 a 4.92 por partida, aproximadamente un 44.7 % mas. mejora frente a los cinco rivales.

#### valoracion de los cambios

en esta prueba, v2 mejora las medias generales de puntos, turnos por vida y fantasmas comidos respecto a v1. no hay ningun empeoramiento que se distinga del ruido en las comparaciones por rival. estos resultados apoyan mantener los cambios de seguridad y de busqueda de poder, aunque no permiten saber cuanto aporta cada cambio por separado.

esta version ya puede buscar poder cuando hay varios perseguidores, pero todavia no tiene reglas para mantener ese objetivo, aprovechar zonas con comida o salir de recorridos repetidos. estas situaciones se han dejado para la siguiente version.

## 27 de octubre de 2026 - v2.1

esta version parte de la anterior y añade seis reglas, hasta llegar a quince. se mantienen los calculos de caminos y las comprobaciones de seguridad, y se amplian las decisiones del archivo de reglas.

se ha añadido una regla para mantener la pildora de poder elegida mientras siga activa y el camino tenga margen suficiente. asi pacman no cambia de objetivo sin motivo en cada turno.

tambien se da prioridad a recoger comida cuando quedan diez pildoras normales o menos. cuando hay fantasmas comestibles pero ninguno se puede alcanzar a tiempo, sigue buscando comida en vez de perseguir una presa que queda demasiado lejos.

se ha añadido la posibilidad de interceptar a un fantasma. se calcula el siguiente cruce al que se dirige y se compara con la persecucion directa. la regla elige interceptar si supone ahorrar al menos cuatro pasos, queda tiempo comestible suficiente y el recorrido tiene margen.

para recoger comida se permite buscar una zona con al menos tres pildoras cuando la comida mas cercana queda a mas de diez pasos. de esta forma puede dirigirse hacia una zona con mas comida en vez de centrarse siempre en una pildora aislada.

por ultimo, se ha añadido una regla para cuando lleva ciento veinte turnos sin comer. se ha utilizado Memoria.java para guardar las visitas a los nodos y el tiempo sin recoger comida. entre las salidas con margen suficiente, se elige la menos visitada y, si empatan, la que deje la comida mas cerca.

estos datos se borran cuando recoge una pildora normal o de poder, al morir, cambiar de nivel o empezar otra partida. los cambios de esta version estan en mspacman-v2.1.clp, junto con la preparacion de datos de MsPacManInput.java y Memoria.java.

### ayuda de ia en esta version

se ha usado la ia para programar las reglas de mantener poder, terminar de recoger comida, interceptar, comer cuando no hay una presa alcanzable, buscar zonas y evitar recorridos sin comida. tambien ha ayudado con la memoria, las comprobaciones y la comparacion de resultados.

se ha pedido resumir el material y mantener la estructura de la plantilla para ejecutarlo desde Visual Studio Code. las versiones se llaman v2 y v2.1 tanto en el diario como en los archivos del proyecto.

### prompts de ejemplo

1. añade una regla para mantener la pildora de poder elegida. utiliza el objetivo guardado en UltimaAccion y comprueba que siga activo, este a noventa pasos o menos y conserve un margen mayor que tres. dale prioridad sobre la busqueda normal de poder para que no cambie de objetivo sin motivo.

2. añade una regla para terminar de recoger comida cuando queden diez pildoras normales o menos. utiliza un objetivo de comida con camino seguro y dale prioridad sobre una persecucion normal. si ya no quedan pildoras normales, permite que ese objetivo sea una de poder.

3. prepara un objetivo de intercepcion para cada fantasma comestible. sigue su direccion hasta el siguiente cruce y calcula cuanto tarda pacman en llegar. añade una regla que elija interceptar cuando ahorre al menos cuatro pasos frente a perseguir directamente, quede tiempo comestible suficiente y el camino tenga margen.

4. añade una regla para seguir comiendo cuando haya fantasmas comestibles pero ninguno sea alcanzable a tiempo. comprueba que no haya peligro y que exista un objetivo de comida con margen suficiente. no quiero que pierda turnos persiguiendo a un fantasma al que no puede llegar.

5. añade una regla para buscar una zona con varias pildoras. en MsPacManInput revisa los cruces cercanos y cuenta la comida que tienen alrededor. si la comida mas cercana esta a mas de diez pasos, no hay peligro y existe una zona segura con al menos tres pildoras, permite elegirla como objetivo.

6. amplia Memoria para contar las visitas a los nodos y los turnos sin comer. cuenta una visita solo cuando cambie de nodo y borra los datos cuando recoja comida. añade una regla que, despues de ciento veinte turnos sin comer, elija una salida con margen mayor que tres y menos visitas. si empatan, prefiere la que deje la comida mas cerca. reinicia tambien la memoria al morir, cambiar de nivel o empezar otra partida.

### resultados de v2.1 frente a v2

se han comparado las dos versiones con trescientas partidas contra cada uno de los cinco rivales, usando semillas del 1 al 300. en total son tres mil partidas. todos los datos de este apartado son de la tanda v2-v2.1, que es independiente de la prueba v1-v2 mostrada antes. se conservan sus propios valores de v2 para que la comparacion corresponda a esa ejecucion.

los valores despues de ± son errores tipicos, no desviaciones tipicas. el comparador utiliza D = media de v2.1 - media de v2. si abs(D) supera 2 · ET_D, considera que la diferencia se distingue del ruido.

#### puntos

| rival | v2 ± error tipico | v2.1 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 5764 ± 162 | 6031 ± 160 | +267 | 456 | ruido |
| Aggressive | 4629 ± 169 | 7969 ± 312 | +3341 | 710 | mejor |
| basico | 4170 ± 130 | 4992 ± 155 | +822 | 404 | mejor |
| intermedio | 3415 ± 118 | 3770 ± 132 | +356 | 353 | mejor |
| avanzado | 2507 ± 62 | 2538 ± 61 | +31 | 174 | ruido |
| media de los cinco rivales | 4097 ± 60 | 5060 ± 82 | +963 | 203 | mejor |

la media de puntos sube de 4097 a 5060, aproximadamente un 23.5 %. mejora frente a Aggressive, basico e intermedio. frente a Random y avanzado no se distingue del ruido. la mejora frente al intermedio supera el limite por poco, por lo que conviene repetir esa comparacion para comprobar si se mantiene.

#### turnos por vida

| rival | v2 ± error tipico | v2.1 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 876 ± 39 | 983 ± 48 | +107 | 124 | ruido |
| Aggressive | 2534 ± 94 | 1931 ± 89 | -603 | 259 | peor |
| basico | 562 ± 23 | 596 ± 22 | +34 | 65 | ruido |
| intermedio | 383 ± 27 | 437 ± 31 | +55 | 82 | ruido |
| avanzado | 376 ± 22 | 345 ± 14 | -30 | 53 | ruido |
| media de los cinco rivales | 946 ± 22 | 859 ± 22 | -87 | 62 | peor |

la media de turnos por vida baja de 946 a 859, aproximadamente un 9.2 %. empeora frente a Aggressive y en la media general. frente a los otros cuatro rivales las diferencias quedan dentro del ruido. por tanto, los cambios no mejoran esta metrica aunque aumente la puntuacion.

#### fantasmas comidos

| rival | v2 ± error tipico | v2.1 ± error tipico | D | 2 · ET_D | resultado |
| --- | ---: | ---: | ---: | ---: | --- |
| Random | 6.97 ± 0.23 | 7.40 ± 0.22 | +0.43 | 0.63 | ruido |
| Aggressive | 5.65 ± 0.22 | 9.37 ± 0.37 | +3.72 | 0.87 | mejor |
| basico | 5.28 ± 0.19 | 6.38 ± 0.21 | +1.11 | 0.56 | mejor |
| intermedio | 4.04 ± 0.17 | 4.65 ± 0.18 | +0.61 | 0.49 | mejor |
| avanzado | 2.99 ± 0.11 | 3.18 ± 0.12 | +0.19 | 0.32 | ruido |
| media de los cinco rivales | 4.99 ± 0.08 | 6.20 ± 0.10 | +1.21 | 0.27 | mejor |

la media de fantasmas comidos pasa de 4.99 a 6.20 por partida, aproximadamente un 24.2 % mas. mejora frente a Aggressive, basico e intermedio. frente a Random y avanzado, la diferencia queda dentro del ruido. no empeora de forma distinguible frente a ningun rival en esta metrica.

#### valoracion de los cambios

la v2.1 consigue mas puntos y come mas fantasmas, pero baja en turnos por vida. si se prioriza la puntuacion, esta prueba favorece a v2.1. aun asi, no se puede decir que mejore en todo: queda revisar que ocurre frente a Aggressive para entender por que consigue mas puntos mientras baja el tiempo por vida.

los datos por si solos no permiten atribuir esa bajada a una regla concreta. para comprobarlo habria que revisar partidas y probar las reglas por separado.

los valores se han copiado tal como aparecen en consola. por el redondeo, algunas diferencias D no coinciden exactamente con la resta de las medias mostradas.

las mismas semillas no garantizan repetir exactamente una partida, porque el motor y el rival Random usan tambien otros generadores aleatorios.

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


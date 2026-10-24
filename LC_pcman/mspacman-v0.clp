;;; Ms. Pac-Man V0Me: las 4 fases de la máquina de estados original como 4 reglas.
;;; (Las plantillas son las mismas que en v1, para que el Input sirva a las dos.)

(deftemplate MSPACMAN
   (slot distFantasma    (type NUMBER))  ; al peligroso más cercano; 1000 si no hay
   (slot distPPill       (type NUMBER))  ; a la píldora de poder más cercana; 1000 si no quedan
   (slot numPPills       (type NUMBER))  ; píldoras de poder que quedan
   (slot numPildoras     (type NUMBER))  ; píldoras normales que quedan
   (slot peligrososCerca (type NUMBER))  ; peligrosos a 20 pasos o menos
   (slot vidas           (type NUMBER))  ; vidas que le quedan
   (slot todosEnCarcel   (type SYMBOL))) ; true si los 4 fantasmas siguen en la cárcel

(deftemplate FANTASMA                    ; uno por cada fantasma fuera de la cárcel
   (slot nombre     (type SYMBOL))       ; BLINKY, INKY, PINKY, SUE
   (slot comestible (type SYMBOL))       ; true o false (minúsculas, como Java)
   (slot distancia  (type NUMBER))       ; camino más corto desde Ms Pac-Man
   (slot tiempo     (type NUMBER))       ; turnos que le quedan de comestible
   (slot cazable    (type SYMBOL)))      ; true si es comestible y llego antes de que se le pase

(deftemplate ACTION
   (slot id) (slot info (default "")) (slot priority (type NUMBER)))

;; NORMAL
(defrule comer
   (MSPACMAN)
   =>
   (assert (ACTION (id comer) (info "NORMAL: comer píldoras") (priority 10))))

;; POWER
(defrule power
   (MSPACMAN (numPPills ?n&:(> ?n 0)) (todosEnCarcel true))
   =>
   (assert (ACTION (id irAPPill) (info "POWER: ir a por la píldora de poder") (priority 50))))

;; HUIDA
(defrule huir
   (exists (FANTASMA (comestible false) (distancia ?d&:(and (>= ?d 0) (<= ?d 6)))))
   =>
   (assert (ACTION (id huir) (info "HUIDA: fantasma peligroso pegado") (priority 70))))

;; CAZA
(defrule cazar
   (exists (FANTASMA (comestible true) (distancia ?d&:(and (>= ?d 0) (<= ?d 30)))))
   =>
   (assert (ACTION (id cazar) (info "CAZA: hay comestibles cerca") (priority 80))))

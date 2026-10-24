;;; Ms. Pac-Man v1: 22 reglas. Las 9 primeras concluyen hechos intermedios
;;; (salience 10) y las 13 últimas proponen un ACTION; gana la de más priority.

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

;; ---- Hechos intermedios ------------------------------------------------
(deftemplate PELIGRO      (slot nivel (type SYMBOL)))  ; medio, alto, critico, acorralado
(deftemplate OPORTUNIDAD  (slot tipo  (type SYMBOL)))  ; caza, remate, ppillCerca
(deftemplate CONTEXTO     (slot tipo  (type SYMBOL)))  ; finNivel, ultimaVida

;; =================== PELIGRO ===================
;; 1 · peligroso a 6 o menos
(defrule peligroCritico (declare (salience 10))
   (FANTASMA (comestible false) (distancia ?d&:(and (>= ?d 0) (<= ?d 6))))
   => (assert (PELIGRO (nivel critico))))

;; 2 · peligroso entre 7 y 14
(defrule peligroAlto (declare (salience 10))
   (FANTASMA (comestible false) (distancia ?d&:(and (>= ?d 7) (<= ?d 14))))
   => (assert (PELIGRO (nivel alto))))

;; 3 · peligroso entre 15 y 30
(defrule peligroMedio (declare (salience 10))
   (FANTASMA (comestible false) (distancia ?d&:(and (>= ?d 15) (<= ?d 30))))
   => (assert (PELIGRO (nivel medio))))

;; 4 · dos o más peligrosos a 20 o menos
(defrule acorralada (declare (salience 10))
   (MSPACMAN (peligrososCerca ?n&:(>= ?n 2)))
   => (assert (PELIGRO (nivel acorralado))))

;; =================== OPORTUNIDADES Y CONTEXTO ===================
;; 5 · comestible alcanzable a 30 o menos
(defrule oportunidadCaza (declare (salience 10))
   (FANTASMA (comestible true) (cazable true) (distancia ?d&:(and (>= ?d 0) (<= ?d 30))))
   => (assert (OPORTUNIDAD (tipo caza))))

;; 6 · comestible alcanzable a 5 o menos
(defrule oportunidadRemate (declare (salience 10))
   (FANTASMA (comestible true) (cazable true) (distancia ?d&:(and (>= ?d 0) (<= ?d 5))))
   => (assert (OPORTUNIDAD (tipo remate))))

;; 7 · píldora de poder a 25 o menos
(defrule oportunidadPPill (declare (salience 10))
   (MSPACMAN (numPPills ?n&:(> ?n 0)) (distPPill ?p&:(<= ?p 25)))
   => (assert (OPORTUNIDAD (tipo ppillCerca))))

;; 8 · quedan 80 píldoras o menos: se acaba el nivel
(defrule finDeNivel (declare (salience 10))
   (MSPACMAN (numPildoras ?n&:(and (> ?n 0) (<= ?n 80))))
   => (assert (CONTEXTO (tipo finNivel))))

;; 9 · última vida
(defrule ultimaVida (declare (salience 10))
   (MSPACMAN (vidas ?v&:(<= ?v 1)))
   => (assert (CONTEXTO (tipo ultimaVida))))

;; =================== COMER ===================
;; 10 · por defecto
(defrule comer
   (MSPACMAN)
   => (assert (ACTION (id comer) (info "comer: no pasa nada") (priority 10))))

;; 11 · sin ningún peligro
(defrule comerTranquila
   (not (PELIGRO))
   (MSPACMAN)
   => (assert (ACTION (id comer) (info "comer: sin peligro") (priority 20))))

;; 12 · peligro lejano: sigue comiendo
(defrule comerVigilando
   (PELIGRO (nivel medio))
   => (assert (ACTION (id comer) (info "comer: peligro lejano") (priority 40))))

;; 13 · queda poco nivel y nada pegado: termínalo
(defrule terminarNivel
   (CONTEXTO (tipo finNivel))
   (not (PELIGRO (nivel critico)))
   => (assert (ACTION (id comer) (info "comer: acabar el nivel") (priority 45))))

;; =================== PÍLDORA DE PODER ===================
;; 14 · todos en la cárcel: aprovecha para ir a por ella
(defrule pPillAlEmpezar
   (MSPACMAN (numPPills ?n&:(> ?n 0)) (todosEnCarcel true))
   => (assert (ACTION (id irAPPill) (info "pPill: fantasmas en la cárcel") (priority 50))))

;; 15 · peligro lejano o medio y la píldora cerca
(defrule pPillOportuna
   (OPORTUNIDAD (tipo ppillCerca))
   (PELIGRO (nivel medio|alto))
   => (assert (ACTION (id irAPPill) (info "pPill: cerca y hay peligro") (priority 65))))

;; 16 · peligro serio y la píldora está más cerca que el fantasma
(defrule pPillAntesQueEl
   (PELIGRO (nivel alto|critico))
   (MSPACMAN (numPPills ?n&:(> ?n 0)) (distFantasma ?f) (distPPill ?p&:(< ?p ?f)))
   => (assert (ACTION (id irAPPill) (info "pPill: llego antes que él") (priority 90))))

;; =================== HUIR ===================
;; 17 · peligro alto
(defrule huirAlto
   (PELIGRO (nivel alto))
   => (assert (ACTION (id huir) (info "huir: peligro alto") (priority 75))))

;; 18 · peligro alto en la última vida: más prudente
(defrule huirUltimaVida
   (PELIGRO (nivel alto))
   (CONTEXTO (tipo ultimaVida))
   => (assert (ACTION (id huir) (info "huir: última vida") (priority 78))))

;; 19 · peligro crítico
(defrule huirCritico
   (PELIGRO (nivel critico))
   => (assert (ACTION (id huir) (info "huir: peligro crítico") (priority 85))))

;; 20 · acorralada por dos o más
(defrule huirAcorralada
   (PELIGRO (nivel acorralado))
   => (assert (ACTION (id huir) (info "huir: acorralada") (priority 88))))

;; =================== CAZAR ===================
;; 21 · comestible alcanzable y nada crítico
(defrule cazar
   (OPORTUNIDAD (tipo caza))
   (not (PELIGRO (nivel critico)))
   => (assert (ACTION (id cazar) (info "cazar: comestible alcanzable") (priority 80))))

;; 22 · comestible a punto: se remata aunque haya peligro (salvo acorralada)
(defrule rematar
   (OPORTUNIDAD (tipo remate))
   => (assert (ACTION (id cazar) (info "cazar: rematar") (priority 87))))

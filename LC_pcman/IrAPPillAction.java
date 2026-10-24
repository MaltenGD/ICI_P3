package es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions;

import es.ucm.fdi.ici.rules.RulesAction;
import jess.Fact;
import pacman.game.Constants.MOVE;
import pacman.game.Game;

/** Mapa de costes en fase POWER (peligro x1.2). */
public class IrAPPillAction implements RulesAction {

    private final MapaCostes mapa = new MapaCostes();

    @Override
    public MOVE execute(Game game) {
        return mapa.decidir(game, MapaCostes.Fase.POWER);
    }

    @Override
    public void parseFact(Fact actionFact) { }

    @Override
    public String getActionId() { return "irAPPill"; }
}

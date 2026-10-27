package es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions;

import es.ucm.fdi.ici.rules.RulesAction;
import jess.Fact;
import pacman.game.Constants.DM;
import pacman.game.Constants.MOVE;
import pacman.game.Game;

/** Hacia la píldora de poder más cercana. */
public class IrAPPillAction implements RulesAction {

    @Override
    public MOVE execute(Game game) {
        int pacman = game.getPacmanCurrentNodeIndex();
        if (pacman < 0) return MOVE.NEUTRAL;

        int[] ppills = game.getActivePowerPillsIndices();
        if (ppills == null || ppills.length == 0) return MOVE.NEUTRAL;

        // Elegir la PPill más cercana respetando que PacMan no puede
        // dar media vuelta salvo en cruces.
        MOVE last = game.getPacmanLastMoveMade();
        int objetivo = -1;
        int mejor = Integer.MAX_VALUE;
        for (int p : ppills) {
            int d = game.getShortestPathDistance(pacman, p, last);
            if (d >= 0 && d < mejor) { mejor = d; objetivo = p; }
        }
        if (objetivo < 0) {
            // Fallback: si no hay camino legal, usar el más cercano geométrico
            objetivo = game.getClosestNodeIndexFromNodeIndex(pacman, ppills, DM.PATH);
        }
        if (objetivo < 0) return MOVE.NEUTRAL;

        // ¡OJO! lastMove para no devolver un movimiento ilegal en pasillos
        return game.getNextMoveTowardsTarget(pacman, objetivo, last, DM.PATH);
    }

    @Override
    public void parseFact(Fact actionFact) { }

    @Override
    public String getActionId() { return "irAPPill"; }
}
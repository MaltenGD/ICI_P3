package es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import es.ucm.fdi.ici.rules.RulesInput;
import pacman.game.Constants.GHOST;
import pacman.game.Game;

public class MsPacManInput extends RulesInput {

    private static final int LEJOS = 1000;      // "no hay": ningún fantasma, ninguna píldora
    private static final int CERCA_PELIGRO = 20;

    // Sin inicializar aquí: parseInput() se ejecuta desde el constructor de la superclase
    private List<String> fantasmas;
    private int distFantasma, distPPill, numPPills, numPildoras, peligrososCerca, vidas;
    private boolean todosEnCarcel;

    public MsPacManInput(Game game) {
        super(game);                            // llama a parseInput()
    }

    @Override
    public void parseInput() {
        int pacman = game.getPacmanCurrentNodeIndex();
        fantasmas = new ArrayList<>();
        distFantasma = LEJOS;
        peligrososCerca = 0;
        int enCarcel = 0;

        for (GHOST g : GHOST.values()) {
            if (game.getGhostLairTime(g) > 0) { enCarcel++; continue; }
            int nodo = game.getGhostCurrentNodeIndex(g);
            if (nodo == -1) continue;

            boolean comestible = game.isGhostEdible(g);
            int d = game.getShortestPathDistance(pacman, nodo);
            int tiempo = comestible ? game.getGhostEdibleTime(g) : 0;
            boolean cazable = comestible && tiempo > d;

            if (!comestible && d >= 0) {
                distFantasma = Math.min(distFantasma, d);
                if (d <= CERCA_PELIGRO) peligrososCerca++;
            }
            fantasmas.add(String.format(
                    "(FANTASMA (nombre %s) (comestible %s) (distancia %d) (tiempo %d) (cazable %s))",
                    g, comestible, d, tiempo, cazable));
        }
        todosEnCarcel = enCarcel >= GHOST.values().length;

        int[] ppills = game.getActivePowerPillsIndices();
        numPPills = ppills.length;
        distPPill = LEJOS;
        for (int p : ppills)
            distPPill = Math.min(distPPill, game.getShortestPathDistance(pacman, p));

        numPildoras = game.getActivePillsIndices().length;
        vidas = game.getPacmanNumberOfLivesRemaining();
    }

    @Override
    public Collection<String> getFacts() {
        List<String> facts = new ArrayList<>(fantasmas);
        facts.add(String.format(
                "(MSPACMAN (distFantasma %d) (distPPill %d) (numPPills %d) (numPildoras %d)"
                + " (peligrososCerca %d) (vidas %d) (todosEnCarcel %s))",
                distFantasma, distPPill, numPPills, numPildoras, peligrososCerca, vidas, todosEnCarcel));
        return facts;
    }
}

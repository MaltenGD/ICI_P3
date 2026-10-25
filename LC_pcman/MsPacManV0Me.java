package es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman;

import java.util.HashMap;

import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions.CazarAction;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions.ComerAction;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions.HuirAction;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions.IrAPPillAction;
import es.ucm.fdi.ici.rules.RuleEngine;
import es.ucm.fdi.ici.rules.RulesAction;
import pacman.controllers.PacmanController;
import pacman.game.Constants.MOVE;
import pacman.game.Game;

public class MsPacManV0Me extends PacmanController {

    private static final String RULES_FILE =
            "es/ucm/fdi/ici/c2627/practica3/grupoYY/mspacman/mspacman-v0.clp";

    private final RuleEngine engine;

    public MsPacManV0Me() {
        setName("MsPacMan");
        HashMap<String, RulesAction> acciones = new HashMap<>();
        for (RulesAction a : new RulesAction[] { new CazarAction(), new HuirAction(), new IrAPPillAction(), new ComerAction() })
            acciones.put(a.getActionId(), a);
        engine = new RuleEngine("MsPacManRules", RULES_FILE, acciones);
    }

    @Override
    public void preCompute(String opponent) { engine.reset(); }

    @Override
    public MOVE getMove(Game game, long timeDue) {
        engine.reset();
        engine.assertFacts(new MsPacManInput(game).getFacts());
        return engine.run(game);
    }
}

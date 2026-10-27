package es.ucm.fdi.ici.c2627.practica3.grupoYY;

import java.util.HashMap;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.fusion.AccionFusion;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.companera.actions.MapaCostes;
import es.ucm.fdi.ici.rules.*;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.*;
import es.ucm.fdi.ici.c2627.practica3.grupoYY.mspacman.actions.IrObjetivoAction;
import pacman.controllers.PacmanController;
import pacman.game.Constants.MOVE;
import pacman.game.Game;

public class MsPacMan extends PacmanController {
    // cambiar esta ruta junto al paquete cuando se confirme la letra del grupo
    public static final String RULES_PATH = "es/ucm/fdi/ici/c2627/practica3/grupoYY/";
    // candidata seleccionada despues de comparar; cambiar solo si otra tanda lo justifica
    public static final String VERSION_CONCURSO = "v4";
    private final RuleEngine motor;
    private final boolean fusion;
    private final UltimaAccion ultima = new UltimaAccion();
    private final Memoria memoria = new Memoria();
    private int laberinto = -1, tiempo = -1;

    public MsPacMan() { this("mspacman-" + VERSION_CONCURSO + ".clp"); }

    public MsPacMan(String reglas) {
        fusion = reglas.startsWith("mspacman-v4");
        setName("Pacman YY reglas");
        setTeam("grupo YY");
        HashMap<String, RulesAction> acciones = new HashMap<String, RulesAction>();
        MapaCostes mapa = fusion ? new MapaCostes() : null;
        for (String id : new String[] {"comer", "huir", "irAPPill", "perseguir", "interceptar", "irZona"})
           acciones.put(id, fusion
        ? new AccionFusion(id, mapa)
        : new IrObjetivoAction(id));
        // solo se construye aqui, nunca dentro de getMove o preCompute
        motor = new RuleEngine("MSPACMAN", RULES_PATH + reglas, acciones);
        motor.addObserver(ultima);
    }

    public RuleEngine getMotor() { return motor; }

    @Override
    public void preCompute(String rival) {
        ultima.olvidar(); memoria.olvidar(); laberinto = -1; tiempo = -1;
    }

    @Override
    public MOVE getMove(Game game, long timeDue) {
        if (game.getPacmanCurrentNodeIndex() < 0) return MOVE.NEUTRAL;
        if (game.wasPacManEaten() || (laberinto >= 0 && laberinto != game.getMazeIndex())
                || (tiempo >= 0 && game.getCurrentLevelTime() < tiempo)) {
            ultima.olvidar(); memoria.olvidar();
        }
        memoria.actualizar(game);
        MsPacManInput input = new MsPacManInput(game, ultima, memoria);
        motor.reset(); motor.assertFacts(input.getFacts());
        MOVE movimiento = motor.run(game);
        laberinto = game.getMazeIndex(); tiempo = game.getCurrentLevelTime();
        return movimiento;
    }
}

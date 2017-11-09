
import controlP5.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


int timer = (int)millis()/1000;


private static final long serialVersionUID = 1L;

// Drawing, animation and colours
final static int ANT = 255 << 24 | 128 << 16;
final static int VISITED = 64 << 24 | 32 << 16;
Map<Integer, Integer> stateToColour = new HashMap<Integer, Integer>();
boolean pause, toggle;
int windowWidth = 512;

ControlP5 cp5;

//Initialise objects 
Env env;
Strategy strategy;
Location food, nest, falseFood;
Random random; //single random object for all pseudorandom numbers

// Cells
Cell[][] cells;
int numRows, numCols;
float cellWidth, cellHeight;

// Ants
int numAnts;
ArrayList<Ant> ants;


public void setup() {

  size(812, 512);
  colorMode(HSB, 100);
  smooth();
  
  pause = true;
  toggle = true; //toggle obstacle/background when dragging mouse
  frameRate(12);
  
  initWorld();

  //Colours for cell state
  stateToColour.put(Cell.UNDEFINED, -1);
  stateToColour.put(Cell.BACKGROUND, 255 << 24 | 255 << 16 | 255 << 8 | 255);
  stateToColour.put(Cell.FOOD, 255 << 24 | 128);
  stateToColour.put(Cell.NEST, 255 << 24 | 128 << 8);
  stateToColour.put(Cell.OBSTACLE, 255 << 24);
  stateToColour.put(Cell.FALSEFOOD, 64 << 24 | 128);
}


public void draw() {
  
  background(stateToColour.get(Cell.BACKGROUND));

  drawCells();
  drawAnts();
  drawGrid();
  drawGui();
  if (!pause) updateAnts();
}


void updateAnts() {
  for (int i = 0; i < ants.size(); i++) {

    Ant ant = ants.get(i);
    
    timer = millis()/1000;
    
    switch (strategy) {

    /* Uninformed */
    // Tree search
    default:
    case BFS_TREE:
      ant.simpleTreeSearch(this, Ant.BREADTH_FIRST);
      break;
    case DFS_TREE:
      ant.simpleTreeSearch(this, Ant.DEPTH_FIRST);
      break;
    case DLS_TREE:
      ant.simpleTreeSearch(this, Ant.DEPTH_LIMITED);
      break;
    case UCS_TREE:
      ant.simpleTreeSearch(this, Ant.UNIFORM_COST);
      break;
      
    // Graph search
    case BFS_GRAPH:
      ant.simpleGraphSearch(this, Ant.BREADTH_FIRST);
      break;
    case DFS_GRAPH:
      ant.simpleGraphSearch(this, Ant.DEPTH_FIRST);
      break;
    case UCS_GRAPH:
      ant.simpleGraphSearch(this, Ant.UNIFORM_COST);
      break;
      
    /* Informed */
    case RANDOM:
      ant.randomSearch(this);
      break;
    case GREEDY:
      ant.greedySearch(this);
      break;
    case SWARM:
      ant.swarmSearch(this);
      break;
    }
    
    //print(timer + " seconds\n");
  
  }
}

//Maths functions
double updateEnv(Location loc) {
  switch (env) {
  case DISTANCE:
    return distance(loc, food);
  case NOISE:
    return noisy(loc);
  case DECEPTION:
    return deceptive(loc);
  default:
  case UNINFORMED:
    return 0;
  }
}

private double noisy(Location loc) {
  double variance = 0.1 * width;
  double noise = variance * random.nextGaussian();

  return distance(loc, food) + noise;
}

double distance(Location locA, Location locB) {
  double xA = (locA.col + 0.5) * cellWidth;
  double yA = (locA.row + 0.5) * cellHeight;

  double xB = (locB.col + 0.5) * cellWidth;
  double yB = (locB.row + 0.5) * cellHeight;

  double delX = xA - xB;
  double delY = yA - yB;

  return Math.sqrt(delX * delX + delY * delY);
}

private double deceptive(Location loc) {
  return Math.min(distance(loc, food), 2 * distance(loc, falseFood));
}

boolean inWorld(Ant ant) {
  return inWorld(ant.pos.row, ant.pos.col);
}

boolean inWorld(Location pos) {
  return inWorld(pos.row, pos.col);
}

boolean inWorld(int row, int col) {
  if (row > -1 && row < numRows && col > -1 && col < numCols)
    return true;
  else
    return false;
}

int getCellState(int row, int col) {
  if (inWorld(row, col))
    return cells[row][col].state;
  else
    return Cell.UNDEFINED;
}

int getCellState(Location pos) {
  return getCellState(pos.row, pos.col);
}

void setCellState(int row, int col, int state) {
  if (inWorld(row, col))
    cells[row][col].state = state;
}
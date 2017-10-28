
// ADD GUI HERE


//Initialise the world

public void initWorld() {
  
  fill(0);
  text("Press SPACE to Start", width/2, height/2);
  
  //The world
  numRows = 16;
  numCols = 16;
  cellWidth = width / numCols;
  cellHeight = width / numCols;
  cells = new Cell[numRows][numCols];
  for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
          cells[row][col] = new Cell(new Location(row, col), Cell.BACKGROUND);
    }
  }

  random = new Random(); //Pseudorandom number generator (PRNG)
  
  //Set environment and strategies here!!!!
  env = Env.UNINFORMED;
  strategy = Strategy.DFS_TREE;
  
  if (env == Env.DECEPTION) {
    falseFood = new Location(2, numCols - 3);
    cells[falseFood.row][falseFood.col].state = Cell.FALSEFOOD;
  }
  
  // number of searchers
  if (strategy == Strategy.SWARM)
    numAnts = 5;
  else
    numAnts = 1;

  //Nest
  nest = new Location(2, 2);
  cells[nest.row][nest.col].state = Cell.NEST;
  
  //Food
  food = new Location(numRows - 3, numCols - 3);
  cells[food.row][food.col].state = Cell.FOOD;

  //Ants
  ants = new ArrayList<Ant>();
  for (int i = 0; i < numAnts; i++)
    ants.add(new Ant(nest, this));

  //Obstacles
  //cells[numRows / 2][numCols / 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 - 1][numCols / 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 + 1][numCols / 2 - 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 + 2][numCols / 2 - 2].state = Cell.OBSTACLE;
}
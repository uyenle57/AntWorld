
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
  
  env = Env.UNINFORMED;
  strategy = Strategy.UCS_TREE;
  
  // Add False food in the Deception environment
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



// Draw Ants, Cells and Grid

void drawAnts() {
  rectMode(CORNER);
  noStroke();

  for (int i = 0; i < ants.size(); i++) {

    Ant ant = ants.get(i);

    for (Location l : ant.explored) {
      fill(VISITED);
      rect(l.col * cellWidth, l.row * cellHeight, cellWidth, cellHeight);
    }

    if (inWorld(ant)) {
      fill(ANT);
      rect(ant.pos.col * cellWidth, ant.pos.row * cellHeight, cellWidth, cellHeight);
    }
  }
}

void drawCells() {
  noStroke();
  rectMode(CORNER);

  for (int col = 0; col < numCols; col++) {
    for (int row = 0; row < numRows; row++) {

      if (cells[row][col].state != Cell.BACKGROUND) {

        fill(stateToColour.get(cells[row][col].state));
        rect(col * cellWidth, row * cellHeight, cellWidth, cellHeight);
      }
    }
  }
}

void drawGrid() {
  stroke(128);

  for (int col = 1; col <= numCols; col++) {
    line(col * cellWidth, 0, col * cellWidth, height);
  }

  for (int row = 1; row <= numRows; row++) {
    line(0, row * cellHeight, width, row * cellHeight);
  }
}



// User Interactions

public void keyPressed() {
  
  if (key == ' ')
    pause = !pause;
  else if (key == 't')
    toggle = !toggle;
}

public void mouseClicked() {
  
  int row = (int) (mouseY / cellWidth);
  int col = (int) (mouseX / cellHeight);
  Location loc = new Location(row, col);
  if (!loc.equals(food) && !loc.equals(nest))
    setCellState(row, col, toggle ? Cell.BACKGROUND : Cell.OBSTACLE);

  println(updateEnv(loc));
}

public void mouseDragged() {
  
  int row = (int) (mouseY / cellWidth);
  int col = (int) (mouseX / cellHeight);
  Location loc = new Location(row, col);
  if (!loc.equals(food) && !loc.equals(nest))
    setCellState(row, col, toggle ? Cell.OBSTACLE : Cell.BACKGROUND);
}
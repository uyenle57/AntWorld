
//Initialise the world

boolean Obstacles;

public void initWorld() {
    
  //The world
  numRows = 16;
  numCols = 16;
  cellWidth = windowWidth / numCols;
  cellHeight = windowWidth / numCols;
  cells = new Cell[numRows][numCols];
  for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
          cells[row][col] = new Cell(new Location(row, col), Cell.BACKGROUND);
    }
  }

  random = new Random(); //Pseudorandom number generator (PRNG)
  
  env = Env.UNINFORMED;
  
  Obstacles = true;
  
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
}


// Draw Ants, Cells, Grid and GUI

void drawAnts() {
  rectMode(CORNER);
  noStroke();
  
  float col = 0; 
  
  for (int i = 0; i < ants.size(); i++) {

    Ant ant = ants.get(i);

    for (Location l : ant.explored) {
      col++;
      col %= 255;
      fill(col, 255, 255, 60); //rainbow colors
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
  stroke(0, 40);

  for (int col = 1; col <= numCols; col++) {
    line(col * cellWidth, 0, col * cellWidth, height);
  }

  for (int row = 1; row <= numRows; row++) {
    line(0, row * cellHeight, windowWidth, row * cellHeight);
  }
}


public void drawGui() {
  
  fill(0);
  textSize(40);
  text("Ant World", width-270, 100);
  textSize(14);
  text("Select a strategy below to start", width-270, 150);
  
  cp5 = new ControlP5(this);

  text("Tree Search:", width-270, 190);
  cp5.addToggle("BFS", width-270, 200, 30, 20).setColorLabel(color(0));
  cp5.addToggle("DFS", width-220, 200, 30, 20).setColorLabel(color(0));
  cp5.addToggle("DLS", width-170, 200, 30, 20).setColorLabel(color(0));
  cp5.addToggle("UCS", width-120, 200, 30, 20).setColorLabel(color(0));
  
  text("Graph Search:", width-270, 270);
  cp5.addToggle("BFS_", width-270, 280, 30, 20).setColorLabel(color(0));
  cp5.addToggle("DFS_", width-220, 280, 30, 20).setColorLabel(color(0));
  cp5.addToggle("UCS_", width-170, 280, 30, 20).setColorLabel(color(0));
  
  cp5.addToggle("Obstacles", width-270, 350, 30, 20).setMode(ControlP5.SWITCH).setColorLabel(color(0));
  
  cp5.addButton("restart").setLabel("Start Again")
      .setPosition(width-270, 400).setSize(80, 20)
      .setColorBackground(color(60)).setColorActive(color(255, 128));
  
  //Draw Obstacles
  if (Obstacles==true) {
    cells[numRows / 2][numCols / 2].state = Cell.OBSTACLE;
    cells[numRows / 2 - 1][numCols / 2].state = Cell.OBSTACLE;
    cells[numRows / 2 + 1][numCols / 2 - 2].state = Cell.OBSTACLE;
    cells[numRows / 2 + 2][numCols / 2 - 2].state = Cell.OBSTACLE;
    println("\n Obstacles: ON");
  }
  else println("\n Obstacles: OFF");
}

public void restart() {
  setup();
  println("AntWorld restarted.");
}


/* User Interactions */

public void mousePressed() {

  //Obstacles
  if(mouseX>width-270 && mouseX<572 && mouseY>350 && mouseY<370) {
    Obstacles = !Obstacles;
  }
  
  //Tree Search
  if(mouseX>width-270 && mouseX<572 && mouseY>200 && mouseY<220) {
    restart();
    strategy = Strategy.BFS_TREE;
    pause = false;
    println("\n Running strategy " + strategy + "\n");
  }
  else if (mouseX>width-220 && mouseX<622 && mouseY>200 && mouseY<220) {
    restart();
    strategy = Strategy.DFS_TREE;
    pause = false;
    println("\n Running strategy " + strategy + "\n");  
  }
  else if (mouseX>width-170 && mouseX<672 && mouseY>200 && mouseY<220) {
    restart();
    strategy = Strategy.DLS_TREE;
    pause = false;
    println("\n Running strategy " + strategy + "\n");  
  }
  else if (mouseX>width-120 && mouseX<772 && mouseY>200 && mouseY<220) {
    restart();
    strategy = Strategy.UCS_TREE;
    pause = false;
    println("\n Running strategy " + strategy + "\n");  
  }
  
  //Graph Search
  else if (mouseX>width-270 && mouseX<572 && mouseY>280 && mouseY<300) {
    restart();
    strategy = Strategy.BFS_GRAPH;
    pause = false;
    println("\n Running strategy " + strategy + "\n");  
  }
  else if (mouseX>width-220 && mouseX<622 && mouseY>280 && mouseY<300) {   
    restart();
    strategy = Strategy.DFS_GRAPH;
    pause = false;
    println("\n Running strategy " + strategy + "\n");
  }
  else if (mouseX>width-170 && mouseX<672 && mouseY>280 && mouseY<300) {    
    restart();
    strategy = Strategy.UCS_GRAPH;
    pause = false;
    println("\n Running strategy " + strategy + "\n");
  }
}


public void keyPressed() {
  if (key == ' ') {
    //check that a strategy has been chosen
    if(strategy != null) pause = !pause;
    else println("\n ERROR: Please choose a strategy first! \n");
  } 
  else if (key == 't') {
    toggle = !toggle;
  }
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
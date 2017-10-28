
// Queue Search Strategies, including Breadth First Search and Uniform Cost Search

import java.util.ArrayList;
import java.util.Random;
import java.util.Stack;
import java.util.Queue;
import java.util.PriorityQueue;


public abstract class QueueSearch(Location pos, Location goalTest) {

  ArrayList<Location> explored; // Cells already expanded

  QueueSearch(Location pos, Location goalTest) {
    explored = new ArrayList<Location>();
  }

  //if the frontier is empty then return failure
  public void isEmpty() {
    if (frontier.isEmpty()) {
      System.out.println("failure");
      return;
    }
  }

  public void goalTest() {
    if (goalTest.equals(pos)) {
      stop(antWorld);
      return;
    }
  }

  public abstract void removeElement();
  public abstract void addNode();
}

//Breadth First Search
public class BreadthFirstSearch(Location pos, Location goalTest) extends QueueSearch(Location pos, Location goalTest) {
   
  Queue<Location> frontier;

  BreadthFirstSearch(Location pos, Location goalTest) {

    frontier = new Queue<Location>();
    frontier.add(new Location(pos));
  }

  public void removeElement() {
    pos = frontier.remove(0);
  }

  public void addNode() {
    explored.add(new Location(pos));

    ArrayList<Location> expanded = availableCells(antWorld, pos);
    for (int i = 0; i < expanded.size(); i++) {
      frontier.add(expanded.get(i));
    }
  }

}
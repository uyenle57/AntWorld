
import java.util.ArrayList;
import java.util.Queue;


public class BreadthFirstSearch {
   
  Queue<Location> frontier;
  ArrayList<Location> explored; // Cells already expanded

  BreadthFirstSearch(Location pos, Location goalTest) {
    explored = new ArrayList<Location>();
    frontier.add(new Location(pos));
  }

  public void isFrontierEmpty() {
    if (frontier.isEmpty()) {
      System.out.println("failure");
      return;
    }
  }

  public void removeNode(Location loc) {
    loc = frontier.remove(0);
  }

  public void goalTest() {
    if (goalTest.equals(pos)) {
      stop(antWorld);
      return;
    }
  }

  public void addNode() {
    explored.add(new Location(pos));

    ArrayList<Location> expanded = availableCells(antWorld, pos);
    for (int i = 0; i < expanded.size(); i++) {
      frontier.add(expanded.get(i));
    }
  }
}
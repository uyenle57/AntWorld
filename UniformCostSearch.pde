
import java.util.PriorityQueue;

/*
public class UniformCostSearch extends BreadthFirstSearch {

  PriorityQueue<Location> frontier; //Overrides parent's frontier

  UniformCostSearch(Location pos, Location goalTest) {
    frontier.add(new Location(pos));
  }

  @Override
  public void addNode() {
    //state = frontier.deleteMin() //pick the lowest path cost
    explored.add(new Location(pos));

    ArrayList<Location> expanded = availableCells(antWorld, pos);

    for (int i = 0; i < expanded.size(); i++) {
      Location l = expanded.get(i);

      if (!inList(frontier, l) && !inList(explored, l)) {
        frontier.add(l);
      }
      else if (inList(frontier, l)) {
        //frontier.decreaseKey(l); //TO DO: ADD A COMPARATOR HERE
      }
    }
  }
}
*/
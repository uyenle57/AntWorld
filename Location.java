public class Location {

  int row, col;
  double cost;

  Location(int r, int c) {
    row = r;
    col = c;
  }

  Location(Location rc) {
    row = rc.row;
    col = rc.col;
  }
  
  Location(Location rc, double cost) {
    row = rc.row;
    col = rc.col;
    this.cost = cost;
  }
  
  public double getCost(){
   return this.cost; 
  }

  public String toString() {
    return "[" + row + ", " + col + ", " + cost + "]";
  }

  public boolean equals(Location rc) {
    return row == rc.row && col == rc.col;
  }
}
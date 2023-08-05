package MonteCarloMini;

import java.util.concurrent.RecursiveTask;
import java.util.Random;
/*
 * SearchParallel class that uses ForkJoinPool to search for the lowest point in the terrain
 * by splitting the search into smaller tasks and then joining the results.
 * author: Travimadox Webb
 * date: 10/05/2021
 * version: 1.0
 * 
 */
public class SearchParallel extends RecursiveTask<Result> {
    private static final int SEARCH_THRESHOLD = 1000;
    private int numsearches;
    private int i = 0;
    private int rows;
    private int columns;
    private TerrainArea terrain;
    Random rand = new Random();

    //constructor
	/*
	 * SearchParallel constructor that takes in the number of searches, rows, columns and terrain
	 * @param numsearches - number of searches
	 * @param rows - number of rows
	 * @param columns - number of columns
	 * @param terrain - terrain
	 */
	public SearchParallel(int numsearches,int rows,int columns,TerrainArea terrain){
        this.numsearches = numsearches;
        this.rows = rows;
        this.columns = columns;
        this.terrain = terrain;
    }

	/*
	 * compute method that splits the search into smaller tasks and then joins the results
	 * @return Result - the result of the search
	 */
    @Override
    protected Result compute(){
        if(numsearches <= SEARCH_THRESHOLD){
            Search search = new Search(i++,rand.nextInt(rows),rand.nextInt(columns),terrain);
            int minHeight = search.find_valleys();
            return new Result(minHeight, search.getPos_row(), search.getPos_col());
        }else{
            int mid = numsearches / 2;
            SearchParallel left = new SearchParallel(mid, rows, columns, terrain);
            SearchParallel right = new SearchParallel(numsearches - mid, rows, columns, terrain);
            left.fork();
            Result rightResult = right.compute();
            Result leftResult = left.join();
            if(leftResult.minHeight <= rightResult.minHeight){
                return leftResult;
            }else{
                return rightResult;
            }
        }
    }
}


/* M. Kuttel 2023
 * Searcher class that lands somewhere random on the surfaces and 
 * then moves downhill, stopping at the local minimum.
 * 
 * The search is stopped when the searcher hits a previous trail.
 * 
 * The search is also stopped when the searcher hits the edge of the terrain.
 * 
 */

class Search {
	private int id;				// Searcher identifier
	private int pos_row, pos_col;		// Position in the grid
	private int steps; //number of steps to end of search
	private boolean stopped;			// Did the search hit a previous trail?
	
	private TerrainArea terrain;

	// Directions of movement
	/*
	 * enum class that defines the directions of movement
	 * author: M. Kuttel
	 * date: 2023
	 */
	enum Direction {
		STAY_HERE,
	    LEFT,
	    RIGHT,
	    UP,
	    DOWN
	  }

	// Constructor
	/*
	 * Search constructor that takes in the id, position row, position column and terrain
	 * @param id - id of the search
	 * @param pos_row - position row
	 * @param pos_col - position column
	 * @param terrain - terrain
	 */
	public Search(int id, int pos_row, int pos_col, TerrainArea terrain) {
		this.id = id;
		this.pos_row = pos_row; //randomly allocated
		this.pos_col = pos_col; //randomly allocated
		this.terrain = terrain;
		this.stopped = false;
	}
	

	/*
	 * find_valleys method that finds the lowest point in the terrain
	 * @return int - the lowest point in the terrain
	 */
	public int find_valleys() {	
		int height=Integer.MAX_VALUE;
		Direction next = Direction.STAY_HERE;
		while(terrain.visited(pos_row, pos_col)==0) { // stop when hit existing path
			height=terrain.get_height(pos_row, pos_col);
			terrain.mark_visited(pos_row, pos_col, id); //mark current position as visited
			steps++;
			next = terrain.next_step(pos_row, pos_col);
			switch(next) {
				case STAY_HERE: return height; //found local valley
				case LEFT: 
					pos_row--;
					break;
				case RIGHT:
					pos_row=pos_row+1;
					break;
				case UP: 
					pos_col=pos_col-1;
					break;
				case DOWN: 
					pos_col=pos_col+1;
					break;
			}
		}
		stopped=true;
		return height;
	}


	// Getters
	/*
	 * getID method that returns the id
	 * @return int - the id
	 */
	public int getID() {
		return id;
	}


	/*
	 * getPos_row method that returns the position row
	 * @return int - the position row
	 */
	public int getPos_row() {
		return pos_row;
	}


	/*
	 * getPos_col method that returns the position column
	 * @return int - the position column
	 */
	public int getPos_col() {
		return pos_col;
	}


	/*
	 * getSteps method that returns the number of steps
	 * @return int - the number of steps
	 */
	public int getSteps() {
		return steps;
	}
	public boolean isStopped() {
		return stopped;
	}

}


/*
 * Result class that stores the minimum height, x position and y position
 * author: Travimadox Webb
 * date: 10/05/2021
 * version: 1.0
 * 
 */
class Result {

    int minHeight;
    int xPos;
    int yPos;


    //constructor
	/*
	 * Result constructor that takes in the minimum height, x position and y position
	 * @param minHeight - minimum height
	 * @param xPos - x position
	 * @param yPos - y position
	 * 
	 */
	public Result(int minHeight, int xPos, int yPos) {
        this.minHeight = minHeight;
        this.xPos = xPos;
        this.yPos = yPos;
    }
    
}

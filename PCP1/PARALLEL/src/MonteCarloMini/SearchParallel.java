package MonteCarloMini;

import java.util.concurrent.RecursiveTask;
import java.util.Random;

public class SearchParallel extends RecursiveTask<Result> {
    private static final int SEARCH_THRESHOLD = 1000;
    private int numsearches;
    private int i = 0;
    private int rows;
    private int columns;
    private TerrainArea terrain;
    Random rand = new Random();

    public SearchParallel(int numsearches,int rows,int columns,TerrainArea terrain){
        this.numsearches = numsearches;
        this.rows = rows;
        this.columns = columns;
        this.terrain = terrain;
    }

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
 */

class Search {
	private int id;				// Searcher identifier
	private int pos_row, pos_col;		// Position in the grid
	private int steps; //number of steps to end of search
	private boolean stopped;			// Did the search hit a previous trail?
	
	private TerrainArea terrain;
	enum Direction {
		STAY_HERE,
	    LEFT,
	    RIGHT,
	    UP,
	    DOWN
	  }

	public Search(int id, int pos_row, int pos_col, TerrainArea terrain) {
		this.id = id;
		this.pos_row = pos_row; //randomly allocated
		this.pos_col = pos_col; //randomly allocated
		this.terrain = terrain;
		this.stopped = false;
	}
	
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

	public int getID() {
		return id;
	}

	public int getPos_row() {
		return pos_row;
	}

	public int getPos_col() {
		return pos_col;
	}

	public int getSteps() {
		return steps;
	}
	public boolean isStopped() {
		return stopped;
	}

}


class Result {

    int minHeight;
    int xPos;
    int yPos;

    public Result(int minHeight, int xPos, int yPos) {
        this.minHeight = minHeight;
        this.xPos = xPos;
        this.yPos = yPos;
    }
    
}

package MonteCarloMini;

import java.lang.Math.*;

import MonteCarloMini.Search.Direction;

/*
 * TerrainArea class that creates the terrain and calculates the height of the terrain
 * 
 */
public class TerrainArea {
	
	public static final int PRECISION = 10000;

	private int rows, columns; //grid size
	private double xmin, xmax, ymin, ymax; //x and y terrain limits
	private int [][] heights;
	private int [][] visit;
	private int grid_points_visited;
	private int grid_points_evaluated;
    
	/*
	 * Constructor for the TerrainArea class
	 * 
	 * @param rows - number of rows in the grid
	 * @param columns - number of columns in the grid
	 * @param xmin - minimum x value of the terrain
	 * @param xmax - maximum x value of the terrain
	 * @param ymin - minimum y value of the terrain
	 * @param ymax - maximum y value of the terrain
	 * 
	 */
	public TerrainArea(int rows, int columns, double xmin, double xmax, double ymin, double ymax) {
		super();
		this.rows = rows;
		this.columns = columns;
		this.xmin = xmin;
		this.xmax = xmax;
		this.ymin = ymin;
		this.ymax = ymax;
		heights = new int[rows][columns];
		visit = new int[rows][columns];
		grid_points_visited=0;
		grid_points_evaluated=0;

		/* Terrain initialization */
		for(int i=0; i<rows; i++ ) {
			for( int j=0; j<columns; j++ ) {
				heights[i][j] = Integer.MAX_VALUE;
				visit[i][j] = 0;
			}
		}
	}

	// has this site been visited before?
	/*
	 * Checks if a grid point has been visited before
	 * 
	 * @param x - x coordinate of the grid point
	 * @param y - y coordinate of the grid point
	 * 
	 * @return 0 if not visited, otherwise the id of the searcher that visited it
	 */
	 int visited( int x, int y) {return visit[x][y];}
	 

	 //mark a grid point as visited by a particular searcher
	 /*
	  * Marks a grid point as visited by a particular searcher
	  *	
	  * @param x - x coordinate of the grid point
	  * @param y - y coordinate of the grid point
	  * @param searcherID - id of the searcher

	  */
	 void mark_visited(int x, int y, int searcherID) { 
		 visit[x][y]=searcherID;
		 grid_points_visited++;}
	
	 //evaluate function at a grid point

	 /*
	  * Evaluates the function at a grid point
	  * 
	  * @param x - x coordinate of the grid point
	  * @param y - y coordinate of the grid point
	  * 
	  * @return the value of the function at the grid point
	  */
	int get_height( int x, int y) {
		if (heights[x][y]!=Integer.MAX_VALUE) {
			return heights[x][y]; //don't recalculate if done before
		}
		/* Calculate the coordinates of the point in the ranges */
		double x_coord = xmin + ( (xmax - xmin) / rows ) * x;
		double y_coord = ymin + ( (ymax - ymin) / columns ) * y;
		/* Compute function value */
		double value = -2 * Math.sin(x_coord) * Math.cos(y_coord/2.0) + Math.log( Math.abs(y_coord - Math.PI*2) );
		
		// **** NB  Rosenbrock function below can be used instead for validation ****
		/*double tmp = y_coord-Math.pow(x_coord,2);
		tmp=100.0*Math.pow(tmp,2);
		double tmp2=Math.pow(1-x_coord,2);
		double value = tmp2+tmp; */
	
		/* Transform to fixed point precision */
		int fixed_point = (int)( PRECISION * value );
		heights[x][y]=fixed_point;
		grid_points_evaluated++;//keep count
		return fixed_point;
	}

	//work out where to go next - move downhill
	/*
	 * Calculates the next step to take
	 * 
	 * @param x - x coordinate of the grid point
	 * @param y - y coordinate of the grid point
	 * 
	 * @return the direction to move in
	 */
	Direction next_step( int x, int y) {
		Direction climb_direction =Direction.STAY_HERE;
		int height;
		int local_min= get_height(x, y);
		if ( x > 0 ) {
			height=get_height(x-1, y);
			if (height<local_min) {
				local_min=height;
				climb_direction = Direction.LEFT;
			}
		}
		if ( x < (rows-1) ) {
			height=get_height(x+1, y);
			if (height<local_min) {
				local_min=height;
				climb_direction = Direction.RIGHT;
			}
		}
		if ( y > 0 ) {
			height=get_height(x, y-1);
			if (height<local_min) {
				local_min=height;
				climb_direction = Direction.UP;
			}
		}
		if ( y < (columns-1) ) {
			height=get_height(x, y+1);
			if (height<local_min) {
				local_min=height;
				climb_direction = Direction.DOWN;
			}
		}
		return climb_direction;
	}
	
	//display the heights in text format
	/*
	 * Prints the heights of the grid points
	 */
	void print_heights( ) {
		int i,j;
		System.out.printf("Heights:\n");
		System.out.printf("+");
		for( j=0; j<columns; j++ ) System.out.printf("-------");
		System.out.printf("+\n");
		for( i=0; i<rows; i++ ) {
			System.out.printf("|");
			for( j=0; j<columns; j++ ) {
				if ( heights[i][j] != Integer.MAX_VALUE ) 
					System.out.printf(" %6d", heights[i][j] );
				else
					System.out.printf("       ");
			}
			System.out.printf("|\n");
		}
		System.out.printf("+");
		for( j=0; j<columns; j++ ) System.out.printf("-------");
		System.out.printf("+\n\n");
	}
	
	//display the "visited" array in test format - this shows who went where
	/*
	 * Prints the visited array
	 */
	void print_visited( ) {
		int i,j;
		System.out.printf("Visited:\n");
		System.out.printf("+");
		for( j=0; j<columns; j++ ) System.out.printf("-------");
		System.out.printf("+\n");
		for( i=0; i<rows; i++ ) {
			System.out.printf("|");
			for( j=0; j<columns; j++ ) {
				System.out.printf(" %6d",visit[i][j] );
			}
			System.out.printf("|\n");
		}
		System.out.printf("+");
		for( j=0; j<columns; j++ ) System.out.printf("-------");
		System.out.printf("+\n\n");
	}

	
	/*
	 * Returns the number of grid points visited
	 * 
	 * @return the number of grid points visited
	 */
	public int getGrid_points_visited() {
		return grid_points_visited;
	}


	//getters and setters
	/*
	 * Returns the number of grid points evaluated
	 * 
	 * @return the number of grid points evaluated
	 */
	public int getGrid_points_evaluated() {
		return grid_points_evaluated;
	}
	

	/*
	 * Returns the number of rows in the grid
	 * 
	 * @return the number of rows in the grid
	 */
	public double getXcoord(int x) {
		return xmin + ( (xmax - xmin) / rows ) * x;
	}


	/*
	 * Returns the number of columns in the grid
	 * 
	 * @return the number of columns in the grid
	 */
	public double getYcoord(int y) {
		return ymin + ( (ymax - ymin) / columns ) * y;
	}


}

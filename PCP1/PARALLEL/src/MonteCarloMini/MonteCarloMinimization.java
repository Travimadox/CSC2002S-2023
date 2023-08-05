package MonteCarloMini;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.ExecutionException;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;


/*
 * MonteCarloMinimization class that takes in the command line arguments and runs the program
 * author: Travimadox Webb
 * date: 10/05/2021
 * version: 1.0
 * 
 * 
 */
class MonteCarloMinimization {
    static final boolean DEBUG=false;
    static long startTime = 0;
    static long endTime = 0;

    /*
     * tick method that sets the start time
     */
     
    private static void tick(){
        startTime = System.currentTimeMillis();
    }

    /*
     * tock method that sets the end time
     */
    private static void tock(){
        endTime=System.currentTimeMillis();
    }


    /*
     * Main method that takes in the command line arguments and runs the program
     * 
     * @param args - command line arguments
     * 
     */
    public static void main(String[] args)  {
        if (args.length != 7) {
            System.out.println("Incorrect number of command line arguments provided.");
            System.exit(0);
        }

        int rows =Integer.parseInt( args[0] );
        int columns = Integer.parseInt( args[1] );
        double xmin = Double.parseDouble(args[2] );
        double xmax = Double.parseDouble(args[3] );
        double ymin = Double.parseDouble(args[4] );
        double ymax = Double.parseDouble(args[5] );
        double searches_density = Double.parseDouble(args[6] );

        
        TerrainArea terrain = new TerrainArea(rows, columns, xmin, xmax, ymin, ymax);
        int num_searches = (int)( rows * columns * searches_density );
        
        

        

       

        tick();
        ForkJoinPool pool = new ForkJoinPool(Runtime.getRuntime().availableProcessors());
        SearchParallel task = new SearchParallel(num_searches,rows,columns,terrain);
        Result result = pool.invoke(task);
        int min = result.minHeight;

        tock();

        System.out.printf("Run parameters\n");
        System.out.printf("\t Rows: %d, Columns: %d\n", rows, columns);
        System.out.printf("\t x: [%f, %f], y: [%f, %f]\n", xmin, xmax, ymin, ymax );
        System.out.printf("\t Search density: %f (%d searches)\n", searches_density, num_searches );
        System.out.printf("Time: %d ms\n",endTime - startTime );
        int tmp=terrain.getGrid_points_visited();
        System.out.printf("Grid points visited: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
        tmp=terrain.getGrid_points_evaluated();
        System.out.printf("Grid points evaluated: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
        //System.out.printf("Global minimum: %d", min );
        System.out.printf("Global minimum: %d at x=%.1f y=%.1f\n\n", min, terrain.getXcoord(result.xPos), terrain.getYcoord(result.yPos));
    }
}

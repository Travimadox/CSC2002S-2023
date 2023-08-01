package MonteCarloMini;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.ExecutionException;
import java.util.List;
import java.util.ArrayList;
import java.util.Random;

class MonteCarloMinimization {
    static final boolean DEBUG=false;
    static long startTime = 0;
    static long endTime = 0;

    private static void tick(){
        startTime = System.currentTimeMillis();
    }
    private static void tock(){
        endTime=System.currentTimeMillis();
    }

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

        ForkJoinPool pool = new ForkJoinPool(Runtime.getRuntime().availableProcessors());
        TerrainArea terrain = new TerrainArea(rows, columns, xmin, xmax, ymin, ymax);
        int num_searches = (int)( rows * columns * searches_density );
        List<SearchTask> tasks = new ArrayList<>();
        Random rand = new Random();

        for (int i = 0; i < num_searches; i++) {
            Search search = new Search(i+1, rand.nextInt(rows), rand.nextInt(columns), terrain);
            SearchTask task = new SearchTask(search);
            tasks.add(task);
            pool.execute(task);
        }

        pool.shutdown();

        tick();
        int min = Integer.MAX_VALUE;
        int local_min;
        int finder = -1;

        for (SearchTask task : tasks) {
            try {
                local_min = task.get();
                Search search = task.getSearch();
                if (!search.isStopped() && local_min < min) {
                    min = local_min;
                    finder = search.getID() - 1;
                }
                if(DEBUG) System.out.println("Search "+search.getID()+" finished at "+local_min+" in "+search.getSteps());
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }

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
        System.out.printf("Global minimum: %d at x=%.1f y=%.1f\n\n", min, terrain.getXcoord(tasks.get(finder).getSearch().getPos_row()), terrain.getYcoord(tasks.get(finder).getSearch().getPos_col()) );
    }
}

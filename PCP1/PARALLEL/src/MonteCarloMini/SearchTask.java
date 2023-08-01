package MonteCarloMini;

import java.util.concurrent.RecursiveTask;

public class SearchTask extends RecursiveTask<Integer>{

    private Search search;

    public SearchTask(Search search) {
        this.search = search;
    }

    @Override
    protected Integer compute() {
        return search.find_valleys();
    }

    public Search getSearch() {
        return search;
    }

    
}

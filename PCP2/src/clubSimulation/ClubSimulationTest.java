package clubSimulation;

public class ClubSimulationTest {

    public static void testMaxNumberofPatrons() throws InterruptedException {
        // Set a high number of patrons
        String[] args = {"1000", "10", "10", "5"};
        ClubSimulation.main(args);

        // Allow simulation to run for a short duration
        Thread.sleep(10000);  // 10 seconds for demonstration; you can adjust.

        // Check that inside patrons do not exceed max limit
        if(ClubSimulation.tallys.getInside() > ClubSimulation.max) {
            System.out.println("Test failed: More patrons inside than the specified max limit.");
        } else {
            System.out.println("Test passed: Club respects max limit.");
        }
    }

    // ... other tests ...

    public static void main(String[] args) throws InterruptedException {
        testMaxNumberofPatrons();
        // ... call other tests ...
    }
    
}

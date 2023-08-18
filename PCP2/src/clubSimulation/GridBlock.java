package clubSimulation;

import java.util.concurrent.atomic.AtomicInteger;

// GridBlock class to represent a block in the club.
// only one thread at a time "owns" a GridBlock

public class GridBlock {
	//private int isOccupied;
	private AtomicInteger isOccupied; 
	private final boolean isExit;  //is tthis the exit door?
	private final boolean isBar; //is it a bar block?
	private final boolean isDance; //is it the dance area?
	private int [] coords; // the coordinate of the block.
	
	GridBlock(boolean exitBlock, boolean barBlock, boolean danceBlock) throws InterruptedException {
		isExit=exitBlock;
		isBar=barBlock;
		isDance=danceBlock;
		isOccupied = new AtomicInteger(-1);
	}
	
	GridBlock(int x, int y, boolean exitBlock, boolean refreshBlock, boolean danceBlock) throws InterruptedException {
		this(exitBlock,refreshBlock,danceBlock);
		coords = new int [] {x,y};
	}
	
	public  int getX() {return coords[0];}  
	
	public  int getY() {return coords[1];}
	
	public synchronized boolean get(int threadID) {
        if (isOccupied.get() == threadID) return true;
        if (isOccupied.get() >= 0) return false;
        
        // Here, compareAndSet ensures that the value is updated atomically.
        if (isOccupied.compareAndSet(-1, threadID)) {
            return true;
        }
        return false;
    }

		
	public synchronized void release() {
		isOccupied.set(-1);
	}
	
	public  synchronized boolean occupied() {
		return isOccupied.get() != -1;
	}
	

	//Immutable variables
	public boolean isExit() {
		return isExit;	
	}

	public   boolean isBar() {
		return isBar;
	}
	public   boolean isDanceFloor() {
		return isDance;
	}

}

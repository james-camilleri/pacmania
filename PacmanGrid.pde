import peasy.*;
import java.net.URL;
import java.net.URISyntaxException;

final int WIDTH = 1920;
final int HEIGHT = 1080;
final int GRID_SIZE = 4;
final int GRID_SCALE = 100;
final boolean GRID_FLAT = true;

PeasyCam camera;
Grid grid = new Grid(GRID_SIZE, GRID_SCALE, GRID_FLAT);
Pacman pacman;
Ghost[] ghosts = new Ghost[int(pow(GRID_SIZE, GRID_FLAT ? 2 : 3)) / 10];

boolean drawGhosts = true;
boolean drawFill = true;
boolean drawWalls = true;
boolean pause = true;
boolean record = false;
int recordingNumber = getStartFolder();

void settings() {
  size(WIDTH, HEIGHT, P3D);
}

CellIndex randomLocation() {
  int x = int(random(0, GRID_SIZE));
  int y = int(random(0, GRID_SIZE));
  int z = GRID_FLAT ? 0 : int(random(0, GRID_SIZE));
  
  return new CellIndex(x, y, z);
}

void setup() {
  float centre = (GRID_SCALE * GRID_SIZE) / 2;
  camera = new PeasyCam(this, centre, centre, GRID_FLAT ? 0 : centre, 1000);
  
  for (int i = 0; i < ghosts.length; i++) {
    ghosts[i] = new Ghost(grid, randomLocation());
  }
  
  pacman = new Pacman(grid, randomLocation(), ghosts);
}

void keyPressed() {
  if (key == 'g') {
    drawGhosts = !drawGhosts;
  }
  
  if (key == 'w') {
    drawWalls = !drawWalls;
  }
  
  if (key == 'f') {
    drawFill = !drawFill;
  }
  
  if (key == 'p' || key == ' ') {
    pause = !pause;
  }
  
  if (key == 'r') {
    record = !record;
    if (!record) {
      recordingNumber++;
    }
  }
}

int getStartFolder() {
  int recordingNumber = 1;
  
  try {
    URL url = getClass().getResource("PacmanGrid.class");
    String[] pathSegments = url.toURI().getPath().split("/");
    //....../out/PacmanGrid.class
    String path = String.join("\\", Arrays.copyOfRange(pathSegments, 1, pathSegments.length - 2));
    File file = new File(path + "\\render\\" + Integer.toString(recordingNumber));
    
    while(file.exists()) {
      recordingNumber++;
      file = new File(path + "\\render\\" + Integer.toString(recordingNumber));
    }
  } catch(URISyntaxException exception) {}
  
  return recordingNumber;
}

void draw() {
  background(0, 0, 0, 1);
  
  grid.draw(drawWalls, drawFill);
  
  for (int i = 0; i < ghosts.length; i++) {
    if (!pause) {
      ghosts[i].move();
    }
    
    if (drawGhosts) {
      ghosts[i].draw();
    }
  }
  
  if (!pause) {
    pacman.move();
  }
  
  pacman.draw();
  
  if (record) {
    saveFrame("render\\" + recordingNumber + "\\pacman-####.png");
  }
}

import peasy.*;

final int WIDTH = 1920;
final int HEIGHT = 1080;
final int GRID_SIZE = 5;
final int GRID_SCALE = 100;
final boolean GRID_FLAT = false;

PeasyCam camera;
Grid grid = new Grid(GRID_SIZE, GRID_SCALE, GRID_FLAT);
Pacman pacman;
Ghost[] ghosts = new Ghost[int(pow(GRID_SIZE, GRID_FLAT ? 2 : 3)) / 10];

boolean drawGhosts = true;
boolean drawFill = true;
boolean drawWalls = true;
boolean record = false;
int recordingNumber = 0;

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
  
  if (key == 'r') {
    record = !record;
    if (record) {
      recordingNumber++;
    }
  }
}

void draw() {
  background(0, 0, 0, 1);
  
  grid.draw(drawWalls, drawFill);
  
  for (int i = 0; i < ghosts.length; i++) {
    ghosts[i].move();
    
    if (drawGhosts) {
      ghosts[i].draw();
    }
  }
  
  pacman.move();
  pacman.draw();
  
  if (record) {
    saveFrame("render\\" + recordingNumber + "\\pacman-####.png");
  }
}

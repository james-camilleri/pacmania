import peasy.*;

final int WIDTH = 1920;
final int HEIGHT = 1080;
final int GRID_SIZE = 5;
final int GRID_SCALE = 100;

PeasyCam camera;
Grid grid = new Grid(GRID_SIZE, GRID_SCALE);
Pacman pacman;
Ghost[] ghosts = new Ghost[int(pow(GRID_SIZE, 3)) / 10];

void settings() {
  size(WIDTH, HEIGHT, P3D);
}

void setup() {
  float centre = (GRID_SCALE * GRID_SIZE) / 2;
  camera = new PeasyCam(this, centre, centre, centre, 1000);
  
  for (int i = 0; i < ghosts.length; i++) {
    ghosts[i] = new Ghost(grid, new CellIndex(GRID_SIZE - 1, GRID_SIZE - 1, 0));
  }
  
  pacman = new Pacman(grid, new CellIndex(0, 0, 0), ghosts);
}

void draw() {
  background(0, 0, 0, 1);
  grid.draw();
  
  for (int i = 0; i < ghosts.length; i++) {
    ghosts[i].move();
    ghosts[i].draw();
  }
  
  pacman.move();
  pacman.draw();
}

import peasy.*;

final int WIDTH = 1920;
final int HEIGHT = 1080;
// final int[] CENTRE = { WIDTH / 2, HEIGHT / 2 };
final int GRID_SIZE = 5;
final int GRID_SCALE = 100;

PeasyCam camera;
Grid grid = new Grid(GRID_SIZE, GRID_SCALE);

void settings() {
  size(WIDTH, HEIGHT, P3D);
}

void setup() {
  float centre = (GRID_SCALE * GRID_SIZE) / 2;
  camera = new PeasyCam(this, centre, centre, centre, 1000);
}

void draw() {
  background(0, 0, 0, 1);
  grid.draw();
}

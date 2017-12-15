import java.util.List;

// uwnd stores the 'u' component of the wind.
// The 'u' component is the east-west component of the wind.
// Positive values indicate eastward wind, and negative
// values indicate westward wind.  This is measured
// in meters per second.
Table uwnd;

// vwnd stores the 'v' component of the wind, which measures the
// north-south component of the wind.  Positive values indicate
// northward wind, and negative values indicate southward wind.
Table vwnd;

// An image to use for the background.  The image I provide is a
// modified version of this wikipedia image:
//https://commons.wikimedia.org/wiki/File:Equirectangular_projection_SW.jpg
// If you want to use your own image, you should take an equirectangular
// map and pick out the subset that corresponds to the range from
// 135W to 65W, and from 55N to 25N
PImage img;
float step = 0.1;

int NUM_PARTICLES = 3000;
int MAX_LIFETIME = 200;
List<PVector> particles = new ArrayList();

void setup() {
  // If this doesn't work on your computer, you can remove the 'P3D'
  // parameter.  On many computers, having P3D should make it run faster
  size(700, 400, P3D);
  pixelDensity(displayDensity());
  
  img = loadImage("background.png");
  uwnd = loadTable("uwnd.csv");
  vwnd = loadTable("vwnd.csv");
  
  for(int i = 0; i < NUM_PARTICLES; i++){
    particles.add(new PVector(random(width), random(height), random(MAX_LIFETIME))); 
  }
  
}

void draw() {
  background(255);
  image(img, 0, 0, width, height);
  drawMouseLine();
  
  strokeWeight(3);
  beginShape(POINTS);
  for(PVector v: particles){
    float pos_x, pos_y;
    //Euler method
    //pos_x = v.x + step*readInterp(uwnd, v.x* uwnd.getColumnCount() / width, v.y* uwnd.getRowCount() / height);
    //moving up in this context correlates to decreasing the y-position
    //pos_y = v.y - step*readInterp(vwnd, v.x* vwnd.getColumnCount() / width, v.y* vwnd.getRowCount() / height);
    
    //RK4
    float[]  k = computeRK4Values(uwnd, v);
    pos_x = v.x + (step/6)*(k[0]+(2*k[1])+(2*k[2])+k[3]);
    k = computeRK4Values(vwnd, v);
    pos_y = v.y - (step/6)*(k[0]+(2*k[1])+(2*k[2])+k[3]);
    vertex(pos_x, pos_y);
    v.set(pos_x,pos_y, v.z - 1);
    if(v.z <= 0){
      v.set(random(width), random(height), random(MAX_LIFETIME));
    }
  }
  endShape();
}

void drawMouseLine() {
  // Convert from pixel coordinates into coordinates
  // corresponding to the data.
  float a = mouseX * uwnd.getColumnCount() / width;
  float b = mouseY * uwnd.getRowCount() / height;
  
  // Since a positive 'v' value indicates north, we need to
  // negate it so that it works in the same coordinates as Processing
  // does.
  float dx = readInterp(uwnd, a, b) * 10;
  float dy = -readInterp(vwnd, a, b) * 10;
  line(mouseX, mouseY, mouseX + dx, mouseY + dy);
}

// Reads a bilinearly-interpolated value at the given a and b
// coordinates.  Both a and b should be in data coordinates.
float readInterp(Table tab, float a, float b) {
  int x1 = int(a);
  int y1 = int(b);
  int x2 = x1 + 1;
  int y2 = y1 + 1;
  // bilinear interpolation
  float Q11 = readRaw(tab, x1, y1);
  float Q12 = readRaw(tab, x1, y2);
  float Q21 = readRaw(tab, x2, y1);
  float Q22 = readRaw(tab, x2, y2);
  
  //interpolation in x dir
  float fXY1 = (x2 - a)*Q11 + (a - x1)*Q21;
  float fXY2 = (x2 - a)*Q12 + (a - x1)*Q22;
  //interpolation in y dir
  float fXY =  (y2 - b)*fXY1 + (b - y1)*fXY2;
  
  return fXY;
}

// Reads a raw value 
float readRaw(Table tab, int x, int y) {
  if (x < 0) {
    x = 0;
  }
  if (x >= tab.getColumnCount()) {
    x = tab.getColumnCount() - 1;
  }
  if (y < 0) {
    y = 0;
  }
  if (y >= tab.getRowCount()) {
    y = tab.getRowCount() - 1;
  }
  return tab.getFloat(y,x);
}

float[] computeRK4Values(Table tab, PVector v) {
  float[] k = new float[4];
  k[0] = readInterp(tab, v.x* tab.getColumnCount() / width, v.y* tab.getRowCount() / height);
  k[1] = readInterp(tab, (v.x+(step/2))* tab.getColumnCount() / width , (v.y + (step*(k[0]/2))) * tab.getRowCount() / height);
  k[2] = readInterp(tab, (v.x + (step/2))* tab.getColumnCount() / width, (v.y + (step*(k[1]/2)))* tab.getRowCount() / height);
  k[3] = readInterp(tab, (v.x+step)* tab.getColumnCount() / width, (v.y +step*k[2]) * tab.getRowCount() / height);
  return k;
}
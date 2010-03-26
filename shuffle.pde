/*
 * This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */

//how fast should the triangles be spawned
int interval = 60;
//distance to the newly generated vector of the triangle (size of triangles)
int distance = 1;
//size of the area at distance where the new point gets randomly generated in
int s = 20;
//just take every [counterStep] point from the points array from the svg
int counterStep = 10;


Triangles[] myTriangles;
int NUM;
long previousMillis = 0;
boolean test = false;
boolean flip = true;

//stuff for the svg
import geomerative.*;
RShape shp;
RPoint[] pnts;

//my counter
int a = 0;
int frameCounter = 0;
int pntCounter = 0;

//my key bools
boolean update = false;
boolean debug = true;
boolean capture = false;

void setup() {
  size(1280, 720, P2D);
  frameRate(10);
  textMode(SCREEN);
  smooth();
  
  //load the svg and make points from it
  RG.init(this);
  shp = RG.loadShape("shuffle.svg");
  shp = RG.centerIn(shp, g);
  pnts = shp.getPoints();
  
  //calculate the size of the array
  NUM = floor(pnts.length/counterStep);
  myTriangles = new Triangles[NUM];
  
  for ( int i = 1; i < pnts.length; i++ )
  {
    println(i + ": " + pnts[i].x + ", " + pnts[i].y);
  }
}
void update() {
  if (millis() - previousMillis > interval )//&& millis() > 5000)
  {
    previousMillis = millis();

    if (a < 1 && !test) {
      //this happens just for the first creation
      myTriangles[a] = new Triangles();
    }
    else {
      //if there is one or more object, create one as successor
      myTriangles[a] = new Triangles(myTriangles[getAncestor(a)].getVectors());
    }
    
    //counter through the triangle array
    a++; 
    if(a == NUM) { 
      a = 0; 
      test = true;
    }
    
    //my variable for flipping
    if(flip) {
      flip = false;
    } 
    else {
      flip = true;
    }
  }
}

void draw() {

  //just update everything
  if(update) {
    update();
  }

  background(0);
  
  if(debug) {
    stroke(255);
    
    line(0,360,1280,360);
    line(640,0,640,720);
    text((int)frameRate + " fps",10,20);
  }
  noStroke();

  // **** Draw *************************************
  pushMatrix();
  //translate(0,0,-1000);
  translate(width/2, height/2+50);
  //translate(mouseX * 1.5, mouseY * 1.5);
  //translate(width/2, height/2);

  if(!test) {
    for (int i = 0; i < a; i++) {
      myTriangles[i].drawtri();
    }
  }
  else {
    for (int i = 0; i < NUM; i++) {
      myTriangles[i].drawtri();
    }
  }

  if(debug) {
    fill(255);
    ellipse(pnts[0].x, pnts[0].y, 5, 5);
    for ( int i = 1; i < pnts.length; i++ )
    {
      line( pnts[i-1].x, pnts[i-1].y, pnts[i].x, pnts[i].y );
      ellipse(pnts[i].x, pnts[i].y, 5, 5);
    }
  }
  popMatrix();

  // **** Capture ****************************************
  if(capture) {
    saveFrame("screen-" + nf(frameCounter,6) + ".tif");
    frameCounter++;
  }
}


class Triangles {

  PVector v1 = new PVector(pnts[0].x, pnts[0].y);
  PVector v2 = new PVector(pnts[0].x + s,pnts[0].y + s);
  PVector v3 = new PVector(v1.x - distance + random(-s,s),v1.y - distance - random(s));
  PVector c = new PVector(random(255),random(255),random(255));

  Triangles () {
  }

  Triangles (PVector[] ancestor) {

    //just for looping
    if(pntCounter >= pnts.length) {
      pntCounter = 0;
    }

    v1 = ancestor[0];
    v2 = ancestor[1];

    //if the pntCounter is zero, don't use the vector of ancestor, use the first point of the svg
    if(pntCounter == 0) {
      v1 = new PVector(pnts[0].x, pnts[0].y);
      v2 = new PVector(pnts[0].x + s,pnts[0].y + s);
    }

    //create the vector with the variance of dx so the triangles move in that direction
    if(flip) {
      //take the coords from the actual point of the svg path, add the distance and a random value
      v3 = new PVector(pnts[pntCounter].x + distance + random(s), pnts[pntCounter].y + distance + random(s));
    } 
    else {
      v3 = new PVector(pnts[pntCounter].x - distance - random(s), pnts[pntCounter].y - distance - random(s));
    }

    //if the pntCounter is at the end v3 should use a point from the ancestor 
    if(pntCounter >= pnts.length) {
      v3 = new PVector(pnts[pntCounter-1].x + random(-s,s), pnts[pntCounter-1].y + random(-s,s));
    }

    //increasing the counter for the next point from the svg
    pntCounter = pntCounter + counterStep;
  }

  PVector getLastVector() {
    return v3;
  }

  PVector[] getVectors() {
    PVector[] returnVector = new PVector[2]; 

    //return alternating vector pairs
    if(flip) {
      returnVector[1] = v2;
      returnVector[0] = v3;
    } 
    else {
      returnVector[0] = v1;
      returnVector[1] = v3;
    }

    return returnVector;
  }

  void drawtri() {  
    beginShape(TRIANGLES);
    fill(c.x, c.y, c.z);
    vertex(v1.x, v1.y);
    vertex(v2.x, v2.y);
    vertex(v3.x, v3.y);
    endShape();

    if(debug) {
      fill(255,255,255);
      ellipse(v1.x,v1.y,10,10);
      fill(0,255,0);
      ellipse(v2.x,v2.y,10,10);
    }
  }
}

void keyPressed() {
  if(key == ' '){
    if(update) {
      update = false; 
    } 
    else {
      update = true;
    }
  }

  if(key == 'd'){
    if(debug) {
      debug = false; 
    } 
    else {
      debug = true;
    }
  }

  if(key == 'c'){
    if(capture) {
      capture = false; 
    } 
    else {
      capture = true;
    }
  }

  if(key == 'k'){
    myTriangles = new Triangles[NUM];
    a = 0;
    pntCounter = 0;
    update = false;
  }
}

int getAncestor(int i) {
  if(i == 0) {
    return NUM - 1;
  }
  else {
    return i - 1;
  }
}

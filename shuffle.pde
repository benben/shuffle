/*
 * This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */

//how fast should the triangles be spawned
int interval = 1;
//distance to the newly generated vector of the triangle (size of triangles)
int distance = 1;
//size of the area at distance where the new point gets randomly generated in
int s = 20;
//just take every [counterStep] point from the points array from the svg
int counterStep = 6;
int moveStep = 2;

int count = 0;


int move = 0;
int zoom = 0;

Triangle[] myTriangles;
int NUM;
long previousMillis = 0;
long prevFrames = 0;
boolean test = false;
boolean flip = true;

//stuff for the svg
import geomerative.*;
RShape shp, shp2;
RPoint[] pnts, cam;

//my counter
int a = 0;
int frameCounter = 0;
//first value is for first triangle so increase it and take the second step
int pntCounter = counterStep;

//my key bools
boolean update = false;
boolean debug = true;
boolean capture = false;
boolean moving = false;
boolean finished = false;

float dx, dy, dz, x, y, z;

void setup() {
  size(1280, 720, P3D);
  frameRate(25);
  textMode(SCREEN);
  smooth();
  
  //load the svg and make points from it
  RG.init(this);
  shp = RG.loadShape("shuffle.svg");
  shp2 = RG.loadShape("camera.svg");
  shp.translate(-width/2,-height/2);
  shp.scale(0.8);
  shp2.translate(-width/2,-height/2);
  shp2.scale(0.8);
  pnts = shp.getPoints();
  cam = shp2.getPoints();
  
  //calculate the size of the array
  NUM = ceil(pnts.length/counterStep)+1;
  myTriangles = new Triangle[NUM];
  
  for ( int i = 1; i < pnts.length; i++ )
  {
    println(i + ": " + pnts[i].x + ", " + pnts[i].y);
  }
}
void update() {

  
  if (frameCount % interval == 0)
  {   
    //my variable for flipping
    if(flip) {
      flip = false;
    } 
    else {
      flip = true;
    }
    
    //just for looping
    if(pntCounter >= pnts.length) {
      pntCounter = 0;
      update = false;
      return;
    }
    
    if (count == 0) {
      //this happens just for the first creation
      myTriangles[0] = new Triangle();
      println("generating triangle 0");
    }
    else if(!finished) {
      //if there is one or more object, create one as successor
      myTriangles[count%NUM] = new Triangle(myTriangles[(count-1)%NUM].getVectors());
      println("generating triangle " + count%NUM);
    }
  
  //increasing the counter for the next point from the svg
  pntCounter = pntCounter + counterStep;
  count++;
  }
}

void draw() {
  //just update everything
  if(update) {
    update(); 
  }

  if(moving) {
    
        if (frameCount % interval == 0)
  { 
    move = move + moveStep;
  }
    
    if(move >= cam.length) {
      println("finished!");
      move = 0; 
      finished = true;
      update = false;
      moving = false;
    }
  } 
    
  background(0);
  
  if(debug) {
    stroke(255);
    
    line(0,360,1280,360);
    line(640,0,640,720);
    text((int)frameRate + " fps",10,20);
    text("count: " + count + " / " + (NUM-1),10,35);
    text("pntCounter: " + pntCounter + " / " + pnts.length,10,50);
    text("move: " + move + " / " + cam.length,10,65);
    text("update: " + update,10,80);
    text("moving: " + moving,10,95);
  }
  noStroke();

  // **** Draw *************************************
  pushMatrix();
 
 if(!debug) {
   if(!finished) {
     translate(width/2 - cam[move].x, height/2 - cam[move].y,580);
     dx = width/2 - cam[move].x;
     dy = height/2 - cam[move].y;
     dz = 580;
   } else {
     x = map(zoom,0,20,dx,width/2-40);
     y = map(zoom,0,20,dy,height/2- 20);
     z = map(zoom,0,20,dz,0);
     if(zoom <= 20) {
       zoom++;
     }
     translate(x, y,z);   
     //rotateY(map(mouseX, 0, width, 0, PI));
   }
 } else {
   translate(width/2, height/2);
  }

  if(!test) {
    for (int i = 0; i < count; i++) {
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
    
    fill(100,255,0);
    ellipse(cam[0].x, cam[0].y, 3, 3);
    for ( int i = 1; i < cam.length; i++ )
    {
      line( cam[i-1].x, cam[i-1].y, cam[i].x, cam[i].y );
      ellipse(cam[i].x, cam[i].y, 3, 3);
    }    
  }
  popMatrix();

  // **** Capture ****************************************
  if(capture) {
    println("capturing frame " + frameCounter);
    saveFrame("screen-" + nf(frameCounter,6) + ".tif");
    frameCounter++;
  }
}

void keyPressed() {
  if(key == ' '){
    if(update) {
      update = false; 
      capture = false;
      moving = false;
    } 
    else {
      update = true;
      moving = true;
      finished = false;
      count = 0;
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

//  if(key == 'k'){
//    for (int i = 0; i < NUM; i++) {
//      myTriangles[i].finalize();
//    }
//    a = 0;
//    pntCounter = 0;
//    update = false;
//  }
}

int getAncestor(int i) {
  if(i == 0) {
    return NUM - 1;
  }
  else {
    return i - 1;
  }
}

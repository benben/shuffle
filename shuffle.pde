/*
 * This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */

//how fast should the triangles be spawned
int interval = 60;
//the amount of triangles
int NUM = 30;
//the amount of values which are used for the avergae of speed
int speedNum = 10;
//distance to the newly generated vector of the triangle (size of triangles)
int distance = 100;
//size of the area at distance where the new point gets randomly generated in
int s = 15;
//how strong heading the triangles to the mouseposition
int magnet = 8;

long previousMillis = 0;
Triangles[] myTriangles = new Triangles[NUM];
float x,y,dx,dy;
boolean test = false;
float[] speedArray = new float[speedNum];
int a = 0;
int b = 0;
boolean update = true;
boolean debug = false;

void setup() {
  size(1280, 720, P2D);
  frameRate(30);
  textMode(SCREEN);
  smooth();
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

    //fill the speedArray with the last values
    speedArray[b] = y + myTriangles[a].getLastVector().y;

    a++; 
    if(a == NUM) { 
      a = 0; 
      test = true;
    }
    
    b++;
    if(b == speedNum) { 
      b = 0; 
    }
  }

  //sum up the speedArray
  for(int i = 0; i < speedNum;i++){
    dy = dy + speedArray[i]; 
  }
  //divide the speed to get the average speed
  dy = dy / speedNum;
  //map the speed from the pixel positions of y to a difference pixel value
  dy = map(dy,0,720,1800/interval,0.1);
  
  //set the variance of x with mouseX
  dx = width / 2 - mouseX;
}

void draw() {
  if(update) {
  update();
  }
  
  background(0);
  fill(255, 255, 255);
  if(debug) {
  stroke(255);
  line(0,360,1280,360);
  line(640,0,640,720);
  text((int)frameRate + " fps",10,20);
  }
  //lights();
  //translate(width / 2, height / 2);
  //rotateY(map(mouseX, 0, width, 0, PI));
  //rotateZ(map(mouseY, 0, height, 0, -PI));
  noStroke();


  //drawing
  pushMatrix();
  //FIXME aspect ratio
  //x = millis() / (12 * 0.6);
  
  if(update) {
  y = y + dy; 
  } 
  translate(0,y);

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

  popMatrix();

  //saveFrame();

}


class Triangles {

  PVector v1 = new PVector(width/2 - s, height/2);
  PVector v2 = new PVector(width/2 + s,height/2);
  PVector v3 = new PVector(v1.x - distance + random(-s,s),v1.y - distance - random(s));
  PVector c = new PVector(random(255),random(255),random(255));
  PVector mid = new PVector(0,0);
  PVector vmid = new PVector(0,0);
  PVector d = new PVector(0,0);
  float xs = 0;
  float ys = 0;

  Triangles () {
  }

  Triangles (PVector[] ancestor) {
    v1 = ancestor[0];
    v2 = ancestor[1];

    //calculate the vector to the middle between v1 and v2
    mid.set(v1);
    mid.add(v2);
    mid.div(2);

    //calculate the vector between v1 and v2
    vmid = new PVector(v1.x - v2.x, v1.y - v2.y);

    //calculate the orthogonal vector to vmid
    // with xs = 1000 the vector is ultralong
    xs = 1000;
    ys = ((-vmid.x)*xs) / vmid.y;

    //this is for direction of ys, so that is always be negative and moves up
    if(ys >= 0) {   
      ys = ys * -1;
      xs = xs * -1;
    }
    
    //calculate the difference from mouseX position to actual triangle position
    dx = (mouseX - mid.x) * -magnet;

    //create the vector with the variance of dx so the triangles move in that direction
    d = new PVector(xs - dx, ys);

    //limit the magnitude of the vector, so every vector has the same size
    d.limit(distance);

    //add mid to distance
    d.add(mid);

//        if(swi) {
//        d.add(v2);
//        swi = false;
//        }
//        else {
//          d.add(v1);
//          swi = true;
//        }

    //create the third vector for the new triangle with the distance
    //and the s (size of the area where the new vector is randomly created) 
    v3 = new PVector(d.x + random(-s,s),d.y + random(-s,s));  
  }

  PVector getLastVector() {
    return v3;
  }

  PVector[] getVectors() {
    PVector[] returnVector = new PVector[2]; 
    //return the two vectors for touching randomly
    //just return the two vectors from the new positions (which means including v3)
    PVector len_1_3 = new PVector(v1.x - v3.x, v1.y - v3.y);
    PVector len_2_3 = new PVector(v2.x - v3.x, v2.y - v3.y); 

    //    println(swi);
    //    if(mx >= 0) {
    //            returnVector[0] = v1;
    //      returnVector[1] = v3;
    //      swi = false;
    //    }else {
    returnVector[0] = v2;
    returnVector[1] = v3;
    //}

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
    fill(255,255,255,100);
    ellipse(mid.x,mid.y, 10, 10); 
    stroke(255);
    line(mid.x,mid.y,d.x,d.y);
    noStroke();
    fill(255,0,0,100);
    ellipse(d.x,d.y,s*2,s*2);
    }
  }
}

void keyPressed() {
  if(key == ' '){
    if(update) {
      update = false; 
    } else {
      update = true;
    }
  }
  
  if(key == 'd'){
    if(debug) {
      debug = false; 
    } else {
      debug = true;
    }
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

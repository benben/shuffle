/*
 * This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */

//how fast will the triangles be spawned
int interval = 500;
//maximum amount of triangles
int NUM = 30;

int a;
long previousMillis = 0;
Triangles[] myTriangles = new Triangles[NUM];
float x,y;

void setup() {
  size(1280, 720, P2D);
  frameRate(30);
  textMode(SCREEN);
  smooth();
}

void draw() {
  if (millis() - previousMillis > interval )
  {
    previousMillis = millis();
    
    //this is just for the first creation
   if (myTriangles[0] == null) {
      myTriangles[a] = new Triangles();
    }
    else {
      //if there is one or more object, create one as successor     
      myTriangles[a] = new Triangles(myTriangles[getAncestor(a)].getVectors());
    }    
    a++;
    if(a == NUM) { 
      a = 0;
    }
  }
  
  background(0);
  fill(255, 255, 255);
  text((int)frameRate + " fps",10,20);
  noStroke();
  
  x = millis() / (12 * 0.6);
  y = millis() / 12;  
  translate(-x,-y);

  if(myTriangles[NUM-1] == null) {
    for (int i = 0; i < a; i++) {
      myTriangles[i].drawtri();
    }
  }
  else {
    for (int i = 0; i < NUM; i++) {
      myTriangles[i].drawtri();
    }
  }    
}

class Triangles {
  int s = interval / 5;
  PVector v1 = new PVector(x + width - 100,y + height - 100);
  PVector v2 = new PVector(v1.x + random(s),v1.y + random(s));
  PVector v3 = new PVector(v1.x + random(s),v1.y + random(s));
  PVector c = new PVector(random(255),random(255),random(255));

  Triangles () {
  }

  Triangles (PVector[] ancestor) {
    v1 = ancestor[0];
    v2 = ancestor[1]; 
    v3 = new PVector(x + (width -160) + random(s * 1.6),y + (height -100) + random(s));
  }

  PVector getLastVector() {
    return v3;
  }

  PVector[] getVectors() {
    PVector[] returnVector = new PVector[2]; 
    //return the two vectors for touching randomly
    //just return the two vectors from the new positions (which means including v3)
    switch((int)random(1)) {
    case 0:
      returnVector[0] = v2;
      returnVector[1] = v3;
      break;
    case 1:
      returnVector[0] = v1;
      returnVector[1] = v3;
      break;
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

/*
 * This work is licensed under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
 */

//how fast will the triangles be spawned
int interval = 500;
//maximum amount of triangles
int NUM = 50;

int a;
long previousMillis = 0;
Triangles[] myTriangles = new Triangles[NUM];
float x,y,ratio;
boolean flip;

void setup() {
  size(1280, 720, P2D);
  frameRate(30);
  textMode(SCREEN);
  smooth();
  ratio = (float)width / (float)height;
}

void draw() {
  if (frameCount % 5 == 0)
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
  
  x = frameCount*2.8*ratio;
  y = frameCount*2.8;
  
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
  int s = 10;
  PVector v1 = new PVector(x+(width -100) + random(s),y+(height)+random(s));
  PVector v2 = new PVector(x+(width) + random(s),y+(height -100)+random(s));
  PVector v3 = new PVector(x+(width -100) + random(s),y+(height)+random(s));
  PVector c = new PVector(random(255),random(255),random(255));

  Triangles () {
  }

  Triangles (PVector[] ancestor) {
    v1 = ancestor[0];
    v2 = ancestor[1];
    if(flip) {
      v3 = new PVector(x+(width -100) + random(s),y+(height)+random(s));
    } else {
      v3 = new PVector(x+(width) + random(s),y+(height -100)+random(s));
    }
  }

  PVector getLastVector() {
    return v3;
  }

  PVector[] getVectors() {
    PVector[] returnVector = new PVector[2]; 
    //return the two vectors for touching randomly
    //just return the two vectors from the new positions (which means including v3)
    if(flip) {
      returnVector[1] = v2;
      returnVector[0] = v3;
      flip = false;
    } else {
      returnVector[0] = v1;
      returnVector[1] = v3;
      flip = true;
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

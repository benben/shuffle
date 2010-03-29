class Triangle {

  PVector v1 = new PVector(pnts[0].x, pnts[0].y);
  PVector v2 = new PVector(pnts[0].x + s,pnts[0].y + s);
  PVector v3 = new PVector(pnts[counterStep].x - distance - random(s), pnts[counterStep].y - distance - random(s));
  PVector c = new PVector(random(255),random(255),random(255));

  Triangle () {
  }

  Triangle (PVector[] ancestor) {

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
  
  protected void finalize() {
    v1.x  = 0; v1.y = 0;
    v2.x = 0; v2.y = 0;
     v3.x = 0; v3.y = 0;
  }
}

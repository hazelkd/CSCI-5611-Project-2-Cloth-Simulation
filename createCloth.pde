/*
// simulate cloth using triangles
void createTri() {
  //stroke(255);
  //noStroke();
  // fill(31,200,240);
  noStroke();
  noFill();
  textureMode(NORMAL);
  for (int i = 0; i < numRopes-1; i++) {
    for (int j = 0; j < numNodes-1; j++) {
      beginShape(TRIANGLE_STRIP);
      texture(cat);
      normal(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z, i/(numRopes-1), j/(numNodes-1));
      normal(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z, (i+1)/(numRopes-1), j/(numNodes-1));
      normal(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z, i/(numRopes-1), (j+1)/(numNodes-1));
      endShape(CLOSE);

      beginShape(TRIANGLE_STRIP);
      texture(cat);
      normal(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z, (i+1)/(numRopes-1), j/(numNodes-1));
      normal(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      vertex(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z, (i+1)/(numRopes-1), (j+1)/(numNodes-1));
      normal(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z, i/(numRopes-1), (j+1)/(numNodes-1));
      endShape(CLOSE);
    }
  }
}
*/

// simulate cloth using triangles
void createTri() {
  //stroke(255);
  //noStroke();
  // fill(31,200,240);
  noStroke();
  fill(#F7FEFF);
  textureMode(NORMAL);
  for (int j = 0; j < numNodes-1; j++) {
    beginShape(TRIANGLE_STRIP);
    texture(cat);
    for (int i = 0; i < numRopes-1; i++) {
      float u = map(i, 0, numRopes-2, 0, 1);
      float v1 = map(j, 0, numNodes-2, 0, 1);
      float v2 = map(j+1, 0, numNodes-2, 0, 1);
      
      normal(pos[i][j].y, pos[i][j].x, pos[i][j].z);
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z, u, v1);
      
      normal(pos[i][j+1].y, pos[i][j+1].x, pos[i][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z, u, v2);
    }
    endShape();
  }
}


// simulate cloth using quads
void createQuad() {
  //stroke(255);
  fill(255, 0, 0);
  for (int i = 0; i < numRopes-1; i++) {
    for (int j = 0; j < numNodes-1; j++) {
      vertex(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      vertex(pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      vertex(pos[i+1][j+1].x, pos[i+1][j+1].y, pos[i+1][j+1].z);
      vertex(pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      endShape(CLOSE);
    }
  }
}

void airDrag() {
  for (int i = 0; i < numRopes-1; i++) {
    for (int j = 0; j < numNodes-1; j++) {
      PVector area;
      PVector velocity;
      PVector vAir = new PVector(0, 0, 0);
      PVector van;
      PVector faero;
      float coef;

      velocity = (vel[i][j].copy().add(vel[i+1][j]).add(vel[i][j+1])).mult(1.0/3.0).sub(vAir);

      PVector v1 = pos[i][j+1].copy();
      PVector v2 = pos[i+1][j].copy();
      v1.sub(pos[i][j]);
      v2.sub(pos[i][j]);

      area = v1.cross(v2);

      coef = velocity.mag();
      coef *= velocity.dot(area);
      coef /= (2.0 * area.mag());

      van = area.copy().mult(coef);

      faero = van.copy().mult(-0.5 * cd);

      faero.div(mass);
      // println(faero);
      acc[i][j].add(faero.mult(1.0/3.0));
      acc[i+1][j].add(faero);
      acc[i][j+1].add(faero);

      //finding second triangle

      velocity = (vel[i+1][j].copy().add(vel[i+1][j+1]).add(vel[i][j+1])).mult(1.0/3.0).sub(vAir);

      v1 = pos[i+1][j+1].copy();
      v2 = pos[i][j+1].copy();
      v1.sub(pos[i+1][j]);
      v2.sub(pos[i+1][j]);

      area = v1.cross(v2);

      coef = velocity.mag();
      coef *= velocity.dot(area);
      coef /= (2.0 * area.mag());

      van = area.copy().mult(coef);

      faero = van.copy().mult(-0.5 * cd);

      faero.div(mass);

      acc[i+1][j+1].add(faero.mult(1.0/3.0));
      acc[i+1][j].add(faero);
      acc[i][j+1].add(faero);
    }
  }
}

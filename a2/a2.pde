PImage fly,flybye,swatter,swatted, gameOverScreen;
float[] fX,fY;  // fly locations array
float[] swat;  // fly swatted binary boolean array, 1 = swatted, 0 = not swatted
int score=0;  // increments when swatted.

boolean gameOver = false; 
float borderMargin = 40; // have a margin so the fly does not appear off screen
int startTime;
int elapsedTime;
int minutes;
int seconds;

void setup(){
  size(1600,800);
  noCursor(); // hide the cursor
  fX=new float[0];
  fY=new float[0];
  swat=new float[0];
  // load images
  fly = loadImage("fly.png");  // Load fly image
  flybye = loadImage("flybye.png");  // Load flybye image
  swatter = loadImage("swatter.png");  // Load swatter image
  swatted = loadImage("swatted.png");  // Load swatted image
  gameOverScreen = loadImage("gameOverScreen.png");  // Load game over screen image
  
  fX =append(fX, random(borderMargin, width - borderMargin)); //first fly - random location within the canvas so the fly doesnt appear off the canvas
  fY =append(fY, random(borderMargin, height - borderMargin));
  swat =append(swat,0); // used as a boolean and matches to each individual fly, 0 = fly not swatted, 1 = swatted.
  
  startTime = millis(); // record the starting time
}

void populate(){ // draw the flies in memory to the screen.
  for(int i=0;i<fX.length;i++){
    if(swat[i]==1){ // if swatted
      // resize the fly image and place based on fx/fy array values
      image(flybye, fX[i], fY[i]);
    } else { // not swatted
      image(fly, fX[i], fY[i]);
    }
  }
}

void collisionDetect(){ //collision detection - detect collision between swatter and fly 
  
  for(int i=0; i<swat.length;i++){ // bounding box detection
  
  // Calculate the center coordinates of the fly image because before it was using the top left corner of the image
    float centerX = fX[i] + fly.width / 2;
    float centerY = fY[i] + fly.height / 2;
    
    if (swat[i] == 0 && dist(mouseX, mouseY, centerX, centerY) < 80) { // if the swatter is within 80 pixels of the center of the fly the collision will be registered
      swat[i] = 1; // swatted
      fX =append(fX, random(borderMargin, width - borderMargin)); //new fly placed in random location when old fly dies.
      fY =append(fY, random(borderMargin, height - borderMargin));
      swat =append(swat,0); // new fly not swatted
      score++; //increment score
    }
  } 
}

void mouseClicked() { // ensures collision is detected only when mouse is pressed and released, this is so the user can't keep the mouse pressed and kill the flies that way
 collisionDetect();  
}

void draw(){ 
  background(255);
   if (!gameOver) {
    populate(); // draw flies to screen.
    fill(0);
    // set a text size and location for the score.
    textSize(40);
    text("Score: " + score, width - 200, 40);
    
    // Calculate time that has elapsed
    elapsedTime = millis() - startTime;
    seconds = (elapsedTime / 1000) % 60; // modulo 60 makes sure the result is capped at 59 because we don't have more than 59 seconds in a minute
    minutes = (elapsedTime / (1000 * 60)) % 60;
    
    // Display a timer
    text("Time: " + nf(minutes, 2) + ":" + nf(seconds, 2), 20, 40);

    if (score >= 30) {
      gameOver = true;
    }

    if (mousePressed) { // image swap
      image(swatted, mouseX - swatted.width/2, mouseY - 30);   // have the swatter shift so the middle of the swatter correlates with the position of the cursor
    } else {
      image(swatter, mouseX - swatter.width/2, mouseY - 30); // if not pressed then normal swatter
    }
  } else {
    // Display game over screen
    image(gameOverScreen, 0, 0, width, height);
    
    textSize(40);
    text("Final Time: " + nf(minutes, 2) + ":" + nf(seconds, 2), width/2 - 100, height/2);

  }
  
}

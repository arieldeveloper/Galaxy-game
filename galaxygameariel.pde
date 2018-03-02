// File name: Galaxygameariel                                         
// Date: 2017-12-07                                                   
// Programmer: Ariel Chouminov                                        
// Description: Galaxy game were your moving around space shooting bullets at the balls coming from the sky

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

PImage galaxyBackground; 
PImage rocket; 
PImage enemy;
PImage bullet; 


Minim minim;
AudioPlayer music; //background music 
AudioSample gunsound; //sound when ball hits paddle

//exposion variables 
int numImage = 23; 
PImage[] images = new PImage[numImage]; 
int currentImage = 1;

// ship variables
int shipW = 30;
int shipH = 50;
int shipX = 400;                             
int shipY = 600-shipH;                    
int shipSpeed = 12;

// ball variables / arrays
int ballD = 45;                              
int ballSpeed = 3;
int[] ballX = new int[100];
int[] ballY = new int[100];
boolean[] ballVisible = new boolean[100];

// bullet variables / arrays
int bulletW = 8;                             
int bulletH = 16;                             
int bulletSpeed = 10;
int currentBullet = 0; 
int[] bulletX = new int[100];
int[] bulletY = new int[100];
boolean[] bulletVisible = new boolean[100];

// distance between the current bullet and ball
int dist;            

//image vars
int imageY = 0;
int imageY2 = height;

// an array that holds the key input (LEFT and RIGHT arrow + SPACE)
boolean[] keys;                              
boolean triggerReleased = true;


String strength = "easy"; //changes difficulty 
int difficulty = 3; //keeps track of difficulty 
int score = 0; //score
int lives = difficulty; 


//Screens
boolean intro = true; //intro screen
boolean gameover = false; //gameover screen
boolean game = false; //game on 



void setup() {
  size(800, 600);
  background(0);
  smooth();
  noStroke();

  keys=new boolean[5];                     
  keys[0]=false;                           
  keys[1]=false;
  keys[2]=false;
  keys[3] = false;
  keys[4] = false;


  generateBalls();
  generateBullets();

  //images
  galaxyBackground = loadImage("spaceinvadersbackground.png");
  rocket = loadImage("ship.png");
  enemy = loadImage("enemy1.png");
  bullet = loadImage("bullet.png");

  minim = new Minim(this);

  music = minim.loadFile("music.mp3");
  gunsound = minim.loadSample("gun.mp3", 512);

  for (int i= 0; i< images.length; i++) { //imports explosion pngs
    String imageName = "explode" + nf(i + 1, 1) + ".png"; 
    images[i] = loadImage(imageName);
    images[i].resize(ballD + 70, ballD + 30);
  }
}

void draw() { 
  background(0);
  if (lives == 0) { //game over
    gameover = true;
    game = false;
    lives = difficulty;
  }
  if (key == 'q' && keyPressed && gameover == true) {  //when q pressed and its game over
    gameover = false;
    score = 0;
    game = true;
  }
  if (gameover == true) {
    game = false;
    fill(255); 
    text("Game Over", 330, 220);
    text("Your Score: " + score, 250, 290);

    text("Press Q to Play Again", 220, 380);
  }
  // move the ship with LEFT & RIGHT ARROWS KEYS as well as up and down 
  if (keys[0] && game) {

    shipX = shipX + shipSpeed;
  }

  if (keys[1] && game) {
    shipX = shipX - shipSpeed;
  }

  if (keys[3] && game) {
    shipY = shipY - shipSpeed;
    score +=1;
  }

  if (keys[4] && game) {
    shipY = shipY + shipSpeed;
  }
  // shut bullets with SPACE BAR
  if (keys[2] && triggerReleased && game) {         // triggerReleased is true when the SPACE bar is pressed
    triggerReleased = false;                // then it turns into false to prevent creating more then one bullet 
    bulletX[currentBullet] = shipX;        
    bulletY[currentBullet] = shipY;           
    bulletVisible[currentBullet] = true;   
    currentBullet++;
    score += 5;
    gunsound.trigger();
    if (currentBullet == 100) {
      currentBullet = 0;
    }
  } else if (keys[2]==false) {
    triggerReleased = true;
  }

  if (intro == true) { //intro
    textSize(50);
    text("Welcome to Galaxy Riders", 100, 100);
    textSize(25);
    text("Press q to start!", width / 2 - 80, 450);
    textSize(20);

    fill(255);
    rect(280, 250, 80, 80);
    rect(480, 250, 80, 80);
    textSize(17);
     fill(0);
     text(strength, 290, 290);
     textSize(25);
     text(ballSpeed, 515, 290);
     fill(255);


    text("Difficulty", 280, 355);
    text("ball speed", 480, 355);

    if (strength == "easy") {
      difficulty = 3; 
      lives = 3;
    } else if (strength == "medium") {
      difficulty = 2;
      lives = 2;
    } else if (strength == "hard") {
      difficulty = 1;
      lives = 1;
    }
  } 

  if (intro == true && key == 'q' && keyPressed) {
    intro = false;
    game = true;
  }
  if (game == true) {
    redrawGameField();
    ballSpeed += 0.1;
    fill(255);
    text("LIVES:" + lives, 50, 80);
  }


  moveBalls();
  moveBullets();
  checkCollision();

  shipX = constrain(shipX, shipW, width-shipW - 10); 
  shipY = constrain(shipY, shipY / 3 + shipH / 2, height - shipH - shipH / 2);

  if (!music.isPlaying()) {
    music.rewind();
    music.play();
  }
}


void keyPressed() {
  // move the ship left / right with the arrow keys
  if (key==CODED && keyCode==RIGHT) keys[0]=true;
  if (key==CODED && keyCode==LEFT)  keys[1]=true;
  if (key==CODED && keyCode== UP)  keys[3]=true;
  if (key==CODED && keyCode== DOWN)  keys[4]=true;
  // shoot bullets when SPACE BAR is pressed
  if (key==' ') keys[2]=true;
}

void keyReleased() {
  if (key==CODED && keyCode==RIGHT) keys[0]=false;
  if (key==CODED && keyCode==LEFT) keys[1]=false;
  if (key==CODED && keyCode== UP)  keys[3]= false;
  if (key==CODED && keyCode== DOWN)  keys[4]=false;
  if (key==' ') keys[2]=false;
}

void mousePressed() {
  if (intro == true) { //if difficulty square pressed
    if (mouseX >= 280 && mouseX <= 280 + 80 && mouseY >= 250 && mouseY <= 250 + 80 && mousePressed) {
      if (strength == "easy") { 
        strength = "medium";
      } else if (strength == "medium") {
        strength = "hard";
      } else if (strength == "hard") {
        strength = "easy";

      }
    }

    if (mouseX >= 480 && mouseX <= 480 + 80 && mouseY >= 250 && mouseY <= 250 + 80 && mousePressed) {
      if (ballSpeed <= 7) { //if ballspeed pressed
        ballSpeed += 1;
      } else {
        ballSpeed = 3;
        ballSpeed += 1;
      }
    }
  }
}
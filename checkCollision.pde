void checkCollision() {

  //if ball hits bullet
  for (int i = 0; i<100; i++) {
    for (int j = 0; j<100; j++) {
      dist = distance(ballX[i], ballY[i], bulletX[j], bulletY[j]);
      if (ballVisible[i]==true && bulletVisible[j]==true && dist < ballD/2 && game == true) {
        // add sound effect to indicate a collision (optional)
        ballVisible[i] = false;
        bulletVisible[j] = false;
        score += 10;
        explosion(ballX[i], ballY[i]);
      }
    }
  }

  //if ball hits ship
  for (int i = 0; i<100; i++) {
    if (ballVisible[i]==true && game == true) {
      if (ballX[i] - ballD / 2 >= shipX - 50  && ballX[i] + ballD / 2 <= shipX + 50) {
        if (ballY[i] + ballD / 2 > shipY - 30 && ballY[i] - ballD / 2 < shipY + 50 && ballY[i] - ballD / 2 > shipY - 25 ) { 
          // add sound effect to indicate a collision (optional)
          ballVisible[i] = false;
          score -= 100;
          lives = lives - 1;
        }
      }
    }
  }
}


int explosion(int x, int y) {
  image(images[currentImage], x - ballD, y - ballD); 

  for (int i = 0; i < images.length - 1; i++) { 
    currentImage++;

    if (currentImage > images.length - 1) { 
      currentImage = 0;
    }
  }

  return 2;
}
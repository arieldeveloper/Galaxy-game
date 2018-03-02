void redrawGameField() {
  galaxyBackground.resize(width, height);
  imageY -= 5; 
  image(galaxyBackground, 0, imageY);
  imageY2 = imageY + 600;
  image(galaxyBackground, 0, imageY2);
  if (imageY + 600 == 0) {
    imageY = 0;
  }

  for (int i = 0; i < 100; i++) { 
    if (ballVisible[i] == true) {
      fill(255, 0, 0); 
      //ellipse(ballX[i],ballY[i], ballD, ballD);
      enemy.resize(ballD, ballD);
      image(enemy, ballX[i] - ballD / 2, ballY[i] - ballD / 2);
    }
  }  
  for (int i = 0; i < 100; i++) {
    if (bulletVisible[i] == true) {
      bullet.resize(bulletW + 20, bulletH + 20);
      image(bullet, bulletX[i] - bulletW / 2 - 4, bulletY[i]);
    }
  }
  fill(255); 
  rocket.resize(shipW + 20, shipH + 20);
  image(rocket, shipX - shipW / 2 - 7, shipY +35 - shipH);

  textSize(40);
  text("Score: ", 310, 60);
  text(score, 430, 60);
}
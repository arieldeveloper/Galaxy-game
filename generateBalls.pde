void generateBalls() {
  for (int i = 0; i < 100; i++) { 
    ballX[i] = int(random(0 + ballD / 2, width - ballD / 2));
    ballY[i] = int(random((-7) * height, 0)); 
    ballVisible[i] = true;
    if (i == ballX.length || i == ballY.length) {
      i  = 0;
    }
  }
}
void moveBalls() {
  for (int i = 0; i < 100; i++) { 
    if (ballVisible[i] == true) {
      ballY[i] += ballSpeed;
    }
    if (ballY[i] >= height) {
      ballY[i] = (-7) * height;
    }
  }
}
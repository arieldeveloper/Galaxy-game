void moveBullets() {

  for (int i = 0; i < 100; i++) {
    if (bulletVisible[i] == true) {
      bulletY[i] -= 2 * bulletSpeed;
      if (bulletY[i] == 0) {
        bulletVisible[i] = false;
      }
    }
  }
}
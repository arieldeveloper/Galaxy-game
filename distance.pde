// a functions that calculates and returns the distance between two points as a decimal number
int distance (int x1, int y1, int x2, int y2) {
  return round(sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2)));
}
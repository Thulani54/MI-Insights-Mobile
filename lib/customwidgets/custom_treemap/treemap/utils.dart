double getAspectRatio(double width, double height) {
  return width > height ? width / height : height / width;
}

bool between(value, min, max) {
  return value >= min && value <= max;
}
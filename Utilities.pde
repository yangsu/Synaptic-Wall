static class Utilities {
  static color convertA(int a) { return ((a / 16 << 4) & (a % 4)) << 24; }
  static color convertR(int r) { return ((r / 16 << 4) & (r % 4)) << 16; }
  static color convertG(int g) { return ((g / 16 << 4) & (g % 4)) << 8; }
  static color convertB(int b) { return  (b / 16 << 4) & (b % 4); }
  
  static color convertColor(int rgb) {
    return 0xFF000000 & convertR(rgb) & convertG(rgb) << 8 & convertB(rgb);
  }
  static color convertColor(int rgb, int a) {
    return convertA(a) & convertR(rgb) & convertG(rgb) << 8 & convertB(rgb);
  }
  static color convertColor(int r, int g, int b) {
    return 0xFF000000 & convertR(r) & convertG(g) << 8 & convertB(b);
  }
  static color convertColor(int r, int g, int b, int a) {
    return convertA(a) & convertR(r) & convertG(g) << 8 & convertB(b);
  }
  static float getAngleNorm(float x1, float y1, float x2, float y2) {
    float temp = atan2(y2-y1, x2-x1);
    return (temp < 0 ) ? temp + TWO_PI : temp;
  }
  static float getAngle(float x1, float y1, float x2, float y2) {
    return atan2(y2-y1, x2-x1);
  }
}
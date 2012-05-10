static class Util {
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

  static PVector clone(PVector p) {
    return new PVector(p.x, p.y, p.z);
  }

  static color highlight(color c) {
    return blendColor(c, 0xFF333333, ADD);
  }

  static float convertToArcCoord(float val) {
    if (val >= -PI && val < HALF_PI)
      val += (PI + HALF_PI);
    else
      val -= HALF_PI;
    return val;
  }

  static float getAngleNorm(float x1, float y1, float x2, float y2) {
    float temp = atan2(y2-y1, x2-x1);
    return (temp < 0) ? temp + TWO_PI : temp;
  }

  static float thresholdAngle(float x1, float y1, float x2, float y2) {
    float temp = HALF_PI + atan2(y2 - y1, x2 - x1);
    if (temp >= PI && temp <= (PI + HALF_PI))
      temp -= TWO_PI;
    return temp;
  }

  static float getAngle(float x1, float y1, float x2, float y2) {
    return atan2(y2-y1, x2-x1);
  }

  static float constrain(float value, float min, float max) {
    float mid = (min + max)/2;
    float temp = mid + PI;
    float oppMid = (temp > TWO_PI) ? temp - TWO_PI : temp;
    if ((value > ((oppMid == TWO_PI) ? 0 : oppMid)) &&
        ((min == 0) || (value < min && min != 0)))
      return min;
    if ((value < oppMid) && ((max == TWO_PI) || (value > max && max != TWO_PI)))
      return max;
    return value;
  }

  static float thresholdConstrain(float value, float min, float max) {
    if (value >= min && value <= max)
      return constrain(value, min, max);
    else {
      float mid = (min + max)/2;
      return (value > -mid) ? min : max;
    }
  }

  static float pulse(float amplitude, int elapsed, float length) {
    return amplitude * (-0.5 * cos(elapsed * TWO_PI/length) + 0.5);
  }

  static PVector[] simplifyPath(PVector[] ptl, float epsilon) {
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    for (int i = 1; i < ptl.length-1; i++) {
      float d = ptToLineDist(ptl[0], ptl[ptl.length-1], ptl[i]);
      if (d > dmax) {
        index = i;
        dmax = d;
      }
    }
    //If max distance is greater than epsilon, recursively simplify
    if (dmax >= epsilon) {
      PVector[] r1 = simplifyPath((PVector[])subset(ptl, 0,index), epsilon);
      PVector[] r2 = simplifyPath((PVector[])subset(ptl, index, max(ptl.length-index, 0)), epsilon);
      return (PVector[])concat(subset(r1, 0, max(r1.length-1, 0)), r2);
    }
    else
      return new PVector[]{ptl[0], ptl[ptl.length-1]};
  }

  static List<PVector> simplifyPath(List<PVector> ptl, float epsilon) {
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    for (int i = 1; i < ptl.size()-1; i++) {
      float d = ptToLineDist(ptl.get(0), ptl.get(ptl.size()-1), ptl.get(i));
      if (d > dmax) {
        index = i;
        dmax = d;
      }
    }
    //If max distance is greater than epsilon, recursively simplify
    if (dmax >= epsilon) {
      List<PVector> r1 = simplifyPath(ptl.subList(0,index), epsilon);
      List<PVector> r2 = simplifyPath(ptl.subList(index, ptl.size()), epsilon);
      r1.subList(0, r1.size()-1).addAll(r2);
      return r1;
    }
    else
      return new ArrayList<PVector>(Arrays.asList(ptl.get(0), ptl.get(ptl.size()-1)));
  }
  static float ptToLineDist(PVector a, PVector b, PVector p) {
    return abs((p.x-a.x)*(b.y-a.y)-(p.y-a.y)*(b.x-a.x))/PVector.dist(a, b);
  }

  static float linear(float m, float b, float t) {
    return m*t + b;
  }
  static float linear(float m, float b, float t, float slowingFactor) {
    return m/slowingFactor*t + b;
  }

  static float expDecay(float a, float t, float tau) {
    return a*exp(-t/tau);
  }

  // static float secondsElapsed(int origTime) {
  //   return (millis() - origTime)/1000;
  // }
}
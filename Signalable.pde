interface Signalable {
  void addPath(Path p);
  void onSignal(int type, float value, int index);
}
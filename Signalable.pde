interface Signalable {
  void addPath(Path p);
  void receiveSignal(int type, float value, int position);
}
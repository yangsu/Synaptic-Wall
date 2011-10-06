interface Signalable {
  void fireSignal(int numSignal, int delayms, int type);
  void receiveSignal(int type, float value);
}
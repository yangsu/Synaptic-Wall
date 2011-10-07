class SubPath extends Path {
  int fPosition;
  SubPath(Path parent, int position) {
    fPosition = position;
    fColor = parent.fColor;
  }
}
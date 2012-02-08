class Synapse extends Path {
	public Synapse(Signalable src, float x, float y, color cc) {
		super(src, x, y, cc);
	}

	public int getType() {
    return Constants.SYNAPSE;
  }
}
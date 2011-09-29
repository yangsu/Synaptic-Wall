class Pulse extends Animatable {
	int type, currPos, endPos;
	float value, decayFactor;
	PVector begin, end;
	Pulse (int ee, int t, float v, float df, int d) {
		endPos = ee;
		type = t;
		value = v;
		decayFactor = df;
		currPos = -round(d / (1000.0/frameRate));
	}

	void draw() {
		pushStyle();
		if (type == 0) 
		  stroke(255);
		if (type == 1)
		  stroke(0);
		strokeWeight(5);
		line(begin.x, begin.y, end.x, end.y);
     
		popStyle();
	}
	int getType() {
		return type;
	}
	float getValue() {
		return value;
	}
	int updatePulse() {
		value *= decayFactor;
		return constrain(++currPos, 0, endPos - 2);
	}

	boolean reachedEnd() {
		return currPos == endPos - 2;
	}

	void setBeginAndEnd(PVector b, PVector e) {
		begin = b;
		end = e;
	}
}
class Pulse extends Animatable {
	int type, currPos, endPos;
	color c;
	PVector begin, end;
	Pulse (color cc, int ee, int t, int d) {
		c = cc;
		endPos = ee;
		type = t;
		currPos = -round(d / (1000.0/frameRate));
	}

	void draw() {
		pushStyle();
		stroke(255);
		strokeWeight(5);
		line(begin.x, begin.y, end.x, end.y);
     
		popStyle();
	}

	int updatePulse() {
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
// public class SignalVisualizer extends Interactive {
//   private Plot fPlot;
//   private Soma fSoma;
//   private Signal fSignal;
//   private Slider fScale, fZoom;

//   public SignalVisualizer() {
//     PVector
//     fPlot = new Plot(
//       new PVector(0, 0),
//       new PVector(width, height),
//       null
//     );
//   }


//   private static final float c = 2; // capacitance
//   private static final float r = 500; // resistance
//   private static final float rc = r * c;
//   private static final float ur =  -0.5; // reset potential
//   private static final float u0 = 0; // resting potential
//   private static final float q = 2.3; // total charge
//   private static final float tc = -100000;
//   private static final float th = 1; // the neuron threshold
//   private static final float taus = 500; // time constant

//   taus = 1;
//   taud = 1;
//   taul = 1;
//   taut = 1;
//   tpeak = 0.7;
//   cellt = +1

//   private float computeEPS(Signal s) {
//       int diff = now - s.fFiringTime;
//       if (fLastFired <= s.fFiringTime && s.fFiringTime <= now) {
//         return Math.exp(-diff/rc) - Math.exp(-diff/taus);
//       }
//       if (s.fFiringTime < fLastFired && fLastFired <= now) {
//         return Math.exp(-(fLastFired - s.fFiringTime)/taus)*(Math.exp(-timeSinceLastFiring/rc) - Math.exp(-timeSinceLastFiring/taus));
//       }
//   }

//   private float compute() {
//     double seps = 0, eps = 0;
//     int now = millis();
//     int timeSinceLastFiring = now - fLastFired;
//     for (int i = fReceivedSignals.size()-1; i >= 0; --i) {
//       Signal s = fReceivedSignals.get(i);
//       eps = computeEPS(s);
//       if (eps <= 0.005) {
//         fReceivedSignals.remove(s);
//       }
//       seps += s.fStrength * eps;
//     }

//     u(i) = cellt * taud * taul * (u0 + (ur - u0) * exp(-( i - tc) / (R*C))  +q/C * (1/(1-taus/(R*C)) / tpeak)*seps
//   }

//   public int getType() {
//     return -1;
//   }

//   public void draw() {
//     pushStyle();
//       fPlot.draw();
//     popStyle();
//   }

//   protected boolean isInBounds(float x, float y) {
//     return true;
//   }
// }
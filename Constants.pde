static class Constants {
  static final int MAX = 99999;
  static final int MIN = -99999;

  static final int WIDTH  = 800;
  static final int HEIGHT = 800;

  static float SCALE           = 1.0;
  static final float MAX_SCALE = 4.0;
  static float ZOOM_FACTOR     = 4.0;
  static final float MAX_ZOOM  = 10.0;

  static final int DBL_CLICK_THRESHOLD = 300;

  // Modes
  static final int CREATION    = 0;
  static final int DELETION    = 1;
  static final int INTERACTION = 2;

  // Types
  static final int INITIATOR   = 0;
  static final int SOMA        = 1;
  static final int AXON        = 2;
  static final int DENDRITE    = 3;
  static final int SYNAPSE     = 4;
  static final int SIGNAL      = 5;
  static final int CONTROL     = 6;
  static final int GRID        = 7;

  // Color Settings
  static final color BG_COLOR           = 0xFF4C4C4C;
  static final color FADE_COLOR         = 0xB4646464;
  static final color EX_COLOR           = 0xFFB08B47;
  static final color EX_HIGHLIGHT_COLOR = 0xFFFDFB98;
  static final color IN_COLOR           = 0xFF0A6891;
  static final color IN_HIGHLIGHT_COLOR = 0xFF67A4D0;
  static final color HIGHLIGHT_COLOR    = 0xFFCCCCCC;
  static final int   AP_COLOR   = 0xFFFDFB98;

  // Selection Settings
  static final color SELECTION_COLOR        = 0x44FFFFFF;
  static final color SELECTION_BORDER_COLOR = 0x88FFFFFF;
  static final int   SELECTION_BORDER_WIDTH = 2;

  // Shadow Settings
  static final color SHADOW_COLOR   = 0xBB323232;
  static float SHADOW_OFFSETX = 2/SCALE;
  static float SHADOW_OFFSETY = 2/SCALE;

  // Initiator Settings
  static final int INITIATOR_TIMING = 500;

  // Soma Settings
  static final int   EXCITATORY              = 0;
  static final int   INHIBITORY              = 1;
  static final int   SOMA_FIRING_DELAY       = 300;

  static float SOMA_SIZE               = 30 / SCALE;
  static float SOMA_RING_WIDTH         = 10 / SCALE;

  static final float SOMA_MAX_THRESHOLD      = 3.0;
  static final float SOMA_INIT_POS_THRESHOLD = SOMA_MAX_THRESHOLD * 0.75;
  static final float SOMA_INIT_NEG_THRESHOLD = SOMA_MAX_THRESHOLD * -0.75;

  // Path Settings
  static float PATH_WIDTH          = 8.0 / SCALE;
  static float PATH_JUNCTION_WIDTH = 6.0 / SCALE;

  // Synapse Settings
  static final int   SYNAPSE_TIMING     = 700; // Miliseconds
  static final float SYNAPSE_STRENGTH   = 1.0; // Thickness
  static final float SYNAPSE_MULT       = 2.0;

  static float SYNAPSE_BASE       = 2.0 / SCALE;
  static float SYNAPSE_SIZE       = 12.0 / SCALE; // radius
  static float SYNAPSE_OUTER_SIZE = (SYNAPSE_SIZE + SYNAPSE_STRENGTH*SYNAPSE_MULT + SYNAPSE_BASE) / SCALE;

  // Signals Settings
  static final int   EPSP       = 1;
  static final int   IPSP       = -1;
  static final int   AP         = 0;

  static final float   SIGNAL_DEFAULT_SPEED      = 1;
  static final float   SIGNAL_MAX_SPEED          = 5;

  static final float   SIGNAL_DEFAULT_STRENGTH   = 1;
  static final float   SIGNAL_MAX_STRENGTH       = 3;

  static final float   SIGNAL_DEFAULT_LENGTH     = 50;
  static final float   SIGNAL_MAX_LENGTH         = 100;

  static final boolean SIGNAL_LINEAR_DECAY       = false;
  static final float   SIGNAL_DEFAULT_DECAY      = 1; // No decay
  static final float   SIGNAL_MAX_DECAY          = 0.5; // Halves
  static final float   SIGNAL_DECAY_FACTOR       = 10;


  static final int     SIGNAL_SINGLE_FIRING_TIME = 800;
  static final int     SIGNAL_FIRING_MULTIPLIER  = 10;

  static float   AP_WIDTH                  = 4.0 / SCALE;
  static float   AP_BORDER_WIDTH           = 3.0 / SCALE;

  static float   PSP_WIDTH                 = 6.0 / SCALE;
  static float   PSP_BORDER_WIDTH          = 6.0 / SCALE;

  // Initiator Settings
  static final float DEFAULT_RHYTHMICITY = 1.0;
  static final int   DEFAULT_BURSTINESS  = 1; // per firing
  static final float DEFAULT_FREQUENCY   = 0.5; // Hz
  static final float MAX_RHYTHMICITY     = 1.0;
  static final int   MAX_BURSTINESS      = 5; // per firing
  static final float MAX_FREQUENCY       = 3.0; // Hz
  static final int   BURST_DELAY         = 300;

  // Slider Settings
  static final color SLIDER_BG_COLOR        = 0xFF7F7F7F;
  static final color SLIDER_BAR_COLOR       = 0xFFAAAAAA;
  static final color SLIDER_HANDLE_COLOR    = BG_COLOR;
  static final color THRESHOLD_POSITIVE_COLOR     = 0xFFFF6725;
  static final color THRESHOLD_POSITIVE_HIGHLIGHT = 0xFFFF8947;
  static final color THRESHOLD_NEGATIVE_COLOR     = 0xFF00329B;
  static final color THRESHOLD_NEGATIVE_HIGHLIGHT = 0xFF2254BD;

  static float SLIDER_BAR_WIDTH       = 7.5 / SCALE;
  static float SLIDER_BAR_LENGTH      = 0.1 / SCALE;
  static float SLIDER_HANDLE_WIDTH    = 0.03 / SCALE;
  static float THRESHOLD_HANDLE_WIDTH = 0.15 / SCALE;
  static float DBLSIDED_HANDLE_WIDTH  = 0.1 / SCALE;

  static final float SLIDER_LABEL_OFFSET    = 5;

  // Grid Settings
  static final color GRID_NODE_COLOR     = 0xFF666666;
  static final color GRID_NODE_HIGHLIGHT = 0xFFAAAAAA;
  static final float GRID_NODE_SIZE      = 1;
  static final int   GRID_RESOLUTION     = 40;

  // Control Panel Settings
  static final color CP_TEXT_COLOR   = SLIDER_BAR_COLOR;
  static float CP_TEXT_OFFSET  = 30 / SCALE;
  static float CP_BORDER_WIDTH = 2 / SCALE;
  static float CP_PADDING      = 6 / SCALE;

  static void recalculate() {
    SHADOW_OFFSETX         = 2/SCALE;
    SHADOW_OFFSETY         = 2/SCALE;
    SOMA_SIZE              = 30 / SCALE;
    SOMA_RING_WIDTH        = 10 / SCALE;
    PATH_WIDTH             = 8.0 / SCALE;
    PATH_JUNCTION_WIDTH    = 6.0 / SCALE;
    SYNAPSE_BASE           = 2.0 / SCALE;
    SYNAPSE_SIZE           = 12.0 / SCALE;
    SYNAPSE_OUTER_SIZE     = (SYNAPSE_SIZE + SYNAPSE_STRENGTH*SYNAPSE_MULT + SYNAPSE_BASE) / SCALE;
    AP_WIDTH               = 4.0 / SCALE;
    AP_BORDER_WIDTH        = 3.0 / SCALE;
    PSP_WIDTH              = 6.0 / SCALE;
    PSP_BORDER_WIDTH       = 6.0 / SCALE;
    SLIDER_BAR_WIDTH       = 7.5 / SCALE;
    SLIDER_BAR_LENGTH      = 0.1 / SCALE;
    SLIDER_HANDLE_WIDTH    = 0.03 / SCALE;
    THRESHOLD_HANDLE_WIDTH = 0.15 / SCALE;
    DBLSIDED_HANDLE_WIDTH  = 0.1 / SCALE;
    CP_TEXT_OFFSET         = 30 / SCALE;
    CP_BORDER_WIDTH        = 2 / SCALE;
    CP_PADDING             = 6 / SCALE;
  }

}
module pnm.pnm_defines;

import std.stdint;

enum PnmVersion : ubyte {
    P1_PNM_FILE,
    P2_PNM_FILE,
    P3_PNM_FILE,
    P4_PNM_FILE,
    P5_PNM_FILE,
    P6_PNM_FILE,
    P7_PNM_FILE
};

struct PnmHeader {
    PnmVersion image_format_version;
    
    size_t image_width;
    size_t image_height;

    size_t image_depth;

    size_t color_maxval;
};
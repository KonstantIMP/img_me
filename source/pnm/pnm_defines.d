module pnm.pnm_defines;

import std.stdint;

enum PnmVersion : ubyte {
    P1_PBM_FILE,
    P2_PGM_FILE,
    P3_PPM_FILE,
    P4_PBM_FILE,
    P5_PGM_FILE,
    P6_PPM_FILE,
    P7_PAM_FILE
};

struct PnmHeader {
    PnmVersion image_format_version;
    
    size_t image_width;
    size_t image_height;

    size_t image_depth;

    size_t color_maxval;
};
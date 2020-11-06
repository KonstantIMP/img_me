import std.string;
import std.stdio;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_me;

void main() {
    PnmImage a = new PnmImage();
    a.setImage(new Image!RgbaColor(100, 100));
}

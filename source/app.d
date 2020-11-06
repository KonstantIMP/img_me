import std.string;
import std.stdio;

import uncompressed_image.defines;
import uncompressed_image.image;

void main() {
    Image!(RgbColor) a = new Image!(RgbColor)(100, 100);
    writeln(a.getPixel(0, 0));
}

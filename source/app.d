import std.string;
import std.stdio;

import uncompressed_image.color_translater;
import uncompressed_image.defines;

void main() {
    rgb_color woof;
    woof.r = cast(double)125 / 255;
    woof.g = cast(double)29 / 255;
    woof.b = cast(double)107 / 255;
    writeln(woof);
    writeln(rgbToCmyk(woof));
}

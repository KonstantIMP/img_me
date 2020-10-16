import std.string;
import std.stdio;

import bmp_me;
import image;

void main() {
    bmp_image a = new bmp_image;
    a.parse_file("/home/kimp/Projects/img_me/test/bmp/5.bmp", true);
}

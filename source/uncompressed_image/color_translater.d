module uncompressed_image.image_translater;

import uncompressed_image.defines;

import std.algorithm;

rgba_color rgbToRgba(rgb_color input_color) {
    rgba_color ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    ret.a = 1.0;
    return ret;
}

rgb_color rgbaToRgb(rgba_color input_color) {
    rgb_color ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    return ret;
}

cmy_color rgbToCmy(rgb_color input_color) {
    cmy_color ret;
    ret.c = 1 - input_color.r;
    ret.m = 1 - input_color.g;
    ret.y = 1 - input_color.b;
    return ret;
}

rgb_color cmyToRgb(cmy_color input_color) {
    rgb_color ret;
    ret.r = 1 - input_color.c;
    ret.g = 1 - input_color.m;
    ret.b = 1 - input_color.y;
    return ret;
}

cmy_color cmykToCmy(cmyk_color input_color) {
    cmy_color ret;
    ret.c = (input_color.c * (1 - input_color.k) + input_color.k);
    ret.m = (input_color.m * (1 - input_color.k) + input_color.k);
    ret.y = (input_color.y * (1 - input_color.k) + input_color.k);
    return ret;
}

cmyk_color rgbToCmyk(rgb_color input_color) {
    cmyk_color ret;
    ret.k = 1 - max(max(input_color.r, input_color.g), input_color.b);
    ret.c = (1 - input_color.r - ret.k) / (1 - ret.k);
    ret.m = (1 - input_color.g - ret.k) / (1 - ret.k);
    ret.y = (1 - input_color.b - ret.k) / (1 - ret.k);
    return ret;
}
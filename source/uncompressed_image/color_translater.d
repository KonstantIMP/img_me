/**
 * @file color_translater.d
 * @brief      This file implements translatins for different color spaces
 *
 * @author     KonstantIMP
 * @date       2020
 */
module uncompressed_image.image_translater;

import uncompressed_image.defines;

import std.algorithm;

/**
 * @brief Translater from RgbColor to RgbaColor
 *
 * @param[in] input_color The RgbColor for translation
 *
 * @return Translated RgbaColor
 */
RgbaColor rgbToRgba(RgbColor input_color) @safe @nogc nothrow {
    RgbaColor ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    ret.a = 1.0;
    return ret;
}

/**
 * @brief Translater from RgbaColor to RgbColor
 *
 * @param[in] input_color The RgbaColor for translation
 *
 * @return Translated RgbColor
 */
RgbColor rgbaToRgb(RgbaColor input_color) @safe @nogc nothrow {
    RgbColor ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    return ret;
}

/**
 * @brief Translater from RgbColor to CmyColor
 *
 * @param[in] input_color The RgbColor for translation
 *
 * @return Translated CmyColor
 */
CmyColor rgbToCmy(RgbColor input_color) @safe @nogc nothrow {
    CmyColor ret;
    ret.c = 1 - input_color.r;
    ret.m = 1 - input_color.g;
    ret.y = 1 - input_color.b;
    return ret;
}

/**
 * @brief Translater from CmyColor to RgbColor
 *
 * @param[in] input_color The CmyColor for translation
 *
 * @return Translated RgbColor
 */
RgbColor cmyToRgb(CmyColor input_color) @safe @nogc nothrow {
    RgbColor ret;
    ret.r = 1 - input_color.c;
    ret.g = 1 - input_color.m;
    ret.b = 1 - input_color.y;
    return ret;
}

/**
 * @brief Translater from CmykColor to CmyColor
 *
 * @param[in] input_color The CmykColor for translation
 *
 * @return Translated CmyColor
 */
CmyColor cmykToCmy(CmykColor input_color) @safe @nogc nothrow {
    CmyColor ret;
    ret.c = (input_color.c * (1 - input_color.k) + input_color.k);
    ret.m = (input_color.m * (1 - input_color.k) + input_color.k);
    ret.y = (input_color.y * (1 - input_color.k) + input_color.k);
    return ret;
}

/**
 * @brief Translater from RgbColor to CmykColor
 *
 * @param[in] input_color The RgbColor for translation
 *
 * @return Translated CmykColor
 */
CmykColor rgbToCmyk(RgbColor input_color) @safe @nogc nothrow {
    CmykColor ret;
    ret.k = 1 - max(max(input_color.r, input_color.g), input_color.b);
    ret.c = (1 - input_color.r - ret.k) / (1 - ret.k);
    ret.m = (1 - input_color.g - ret.k) / (1 - ret.k);
    ret.y = (1 - input_color.b - ret.k) / (1 - ret.k);
    return ret;
}

/**
 * @brief Translater from RgbaColor to CmyColor
 *
 * @param[in] input_color The RgbaColor for translation
 *
 * @return Translated CmyColor
 */
CmyColor rgbaToCmy(RgbaColor input_color) @safe @nogc nothrow {
    return rgbToCmy(rgbaToRgb(input_color));
}

/**
 * @brief Translater from RgbaColor to CmykColor
 *
 * @param[in] input_color The RgbaColor for translation
 *
 * @return Translated CmykColor
 */
CmykColor rgbaToCmyk(RgbaColor input_color) @safe @nogc nothrow {
    return rgbToCmyk(rgbaToRgb(input_color));
}

/**
 * @brief Translater from CmyColor to RgbaColor
 *
 * @param[in] input_color The CmyColor for translation
 *
 * @return Translated RgbaColor
 */
RgbaColor cmyToRgba(CmyColor input_color) @safe @nogc nothrow {
    return rgbToRgba(cmyToRgb(input_color));
}

/**
 * @brief Translater from CmyColor to CmykColor
 *
 * @param[in] input_color The CmyColor for translation
 *
 * @return Translated CmykColor
 */
CmykColor cmyToCmyk(CmyColor input_color) @safe @nogc nothrow {
    return rgbToCmyk(cmyToRgb(input_color));
}

/**
 * @brief Translater from CmykColor to RgbColor
 *
 * @param[in] input_color The CmykColor for translation
 *
 * @return Translated RgbColor
 */
RgbColor cmykToRgb(CmykColor input_color) @safe @nogc nothrow {
    return cmyToRgb(cmykToCmy(input_color));
}

/**
 * @brief Translater from CmykColor to RgbaColor
 *
 * @param[in] input_color The CmykColor for translation
 *
 * @return Translated RgbaColor
 */
RgbaColor cmykToRgba(CmykColor input_color) @safe @nogc nothrow {
    return cmyToRgba(cmykToCmy(input_color));
}

template to(T : CmyColor) {
    T to(S : CmyColor)(S parent_color) { return parent_color; }
    T to(S : RgbColor)(S parent_color) { return rgbToCmy(parent_color); }
    T to(S : CmykColor)(S parent_color) { return cmykToCmy(parent_color); }
    T to(S : RgbaColor)(S parent_color) { return rgbaToCmy(parent_color); }
}

template to(T : RgbColor) {
    T to(S : CmyColor)(S parent_color) { return cmyToRgb(parent_color); }
    T to(S : RgbColor)(S parent_color) { return parent_color; }
    T to(S : CmykColor)(S parent_color) { return cmykToRgb(parent_color); }
    T to(S : RgbaColor)(S parent_color) { return rgbaToRgb(parent_color); }
}

template to(T : CmykColor) {
    T to(S : CmyColor)(S parent_color) { return cmyToCmyk(parent_color); }
    T to(S : RgbColor)(S parent_color) { return rgbToCmyk(parent_color); }
    T to(S : CmykColor)(S parent_color) { return parent_color; }
    T to(S : RgbaColor)(S parent_color) { return rgbaToCmyk(parent_color); }
}

template to(T : RgbaColor) {
    T to(S : CmyColor)(S parent_color) { return cmyToRgba(parent_color); }
    T to(S : RgbColor)(S parent_color) { return rgbToRgba(parent_color); }
    T to(S : CmykColor)(S parent_color) { return cmykToRgba(parent_color); }
    T to(S : RgbaColor)(S parent_color) { return parent_color; }
}
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
 * @brief Translater from rgb_color to rgba_color
 *
 * @param[in] input_color The rgb_color for translation
 *
 * @return Translated rgba_color
 */
rgba_color rgbToRgba(rgb_color input_color) @safe @nogc {
    rgba_color ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    ret.a = 1.0;
    return ret;
}

/**
 * @brief Translater from rgba_color to rgb_color
 *
 * @param[in] input_color The rgba_color for translation
 *
 * @return Translated rgb_color
 */
rgb_color rgbaToRgb(rgba_color input_color) @safe @nogc {
    rgb_color ret;
    ret.r = input_color.r;
    ret.g = input_color.g;
    ret.b = input_color.b;
    return ret;
}

/**
 * @brief Translater from rgb_color to cmy_color
 *
 * @param[in] input_color The rgb_color for translation
 *
 * @return Translated cmy_color
 */
cmy_color rgbToCmy(rgb_color input_color) @safe @nogc {
    cmy_color ret;
    ret.c = 1 - input_color.r;
    ret.m = 1 - input_color.g;
    ret.y = 1 - input_color.b;
    return ret;
}

/**
 * @brief Translater from cmy_color to rgb_color
 *
 * @param[in] input_color The cmy_color for translation
 *
 * @return Translated rgb_color
 */
rgb_color cmyToRgb(cmy_color input_color) @safe @nogc {
    rgb_color ret;
    ret.r = 1 - input_color.c;
    ret.g = 1 - input_color.m;
    ret.b = 1 - input_color.y;
    return ret;
}

/**
 * @brief Translater from cmyk_color to cmy_color
 *
 * @param[in] input_color The cmyk_color for translation
 *
 * @return Translated cmy_color
 */
cmy_color cmykToCmy(cmyk_color input_color) @safe @nogc {
    cmy_color ret;
    ret.c = (input_color.c * (1 - input_color.k) + input_color.k);
    ret.m = (input_color.m * (1 - input_color.k) + input_color.k);
    ret.y = (input_color.y * (1 - input_color.k) + input_color.k);
    return ret;
}

/**
 * @brief Translater from rgb_color to cmyk_color
 *
 * @param[in] input_color The rgb_color for translation
 *
 * @return Translated cmyk_color
 */
cmyk_color rgbToCmyk(rgb_color input_color) @safe @nogc {
    cmyk_color ret;
    ret.k = 1 - max(max(input_color.r, input_color.g), input_color.b);
    ret.c = (1 - input_color.r - ret.k) / (1 - ret.k);
    ret.m = (1 - input_color.g - ret.k) / (1 - ret.k);
    ret.y = (1 - input_color.b - ret.k) / (1 - ret.k);
    return ret;
}

/**
 * @brief Translater from rgba_color to cmy_color
 *
 * @param[in] input_color The rgba_color for translation
 *
 * @return Translated cmy_color
 */
cmy_color rgbaToCmy(rgba_color input_color) @safe @nogc {
    return rgbToCmy(rgbaToRgb(input_color));
}

/**
 * @brief Translater from rgba_color to cmyk_color
 *
 * @param[in] input_color The rgba_color for translation
 *
 * @return Translated cmyk_color
 */
cmyk_color rgbaToCmyk(rgba_color input_color) @safe @nogc {
    return rgbToCmyk(rgbaToRgb(input_color));
}

/**
 * @brief Translater from cmy_color to rgba_color
 *
 * @param[in] input_color The cmy_color for translation
 *
 * @return Translated rgba_color
 */
rgba_color cmyToRgba(cmy_color input_color) @safe @nogc {
    return rgbToRgba(cmyToRgb(input_color));
}

/**
 * @brief Translater from cmy_color to cmyk_color
 *
 * @param[in] input_color The cmy_color for translation
 *
 * @return Translated cmyk_color
 */
cmyk_color cmyToCmyk(cmy_color input_color) @safe @nogc {
    return rgbToCmyk(cmyToRgb(input_color));
}

/**
 * @brief Translater from cmyk_color to rgb_color
 *
 * @param[in] input_color The cmyk_color for translation
 *
 * @return Translated rgb_color
 */
rgb_color cmykToRgb(cmyk_color input_color) @safe @nogc {
    return cmyToRgb(cmykToCmy(input_color));
}

/**
 * @brief Translater from cmyk_color to rgba_color
 *
 * @param[in] input_color The cmyk_color for translation
 *
 * @return Translated rgba_color
 */
rgba_color cmykToRgba(cmyk_color input_color) @safe @nogc {
    return cmyToRgba(cmykToCmy(input_color));
}
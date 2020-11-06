/**
 * @file defines.d
 * @brief      This file implements basic color spaces defines.
 *
 * @author     KonstantIMP
 * @date       2020
 */
module uncompressed_image.defines;

/// @brief This struct describes a rgb color.
struct RgbColor {
    /// @brief Amount of red chanel in color
    double red = 0.0;
    /// @brief Amoint of green chanel in color
    double green = 0.0;
    /// @brief Amount of blue chanel in color
    double blue = 0.0;

    /// @brief Simple way to work with red chanel
    alias r = red;
    /// @brief Simple way to work with green chanel
    alias g = green;
    /// @brief Simple way to work with blue chanel
    alias b = blue;
}

/// @brief This struct describes a rgba color.
struct RgbaColor {
    /// @brief Amount of red chanel in color
    double red = 0.0;
    /// @brief Amount of green chanel in color
    double green = 0.0;
    /// @brief Amount of blue chanel in color
    double blue = 0.0;

    /// @brief Amount of alpha chanel in color (transparency level)
    double alpha = 0.0;

    /// @brief Simple way to work with red chanel
    alias r = red;
    /// @brief Simple way to work with green chanel
    alias g = green;
    /// @brief Simple way to work with blue chanel
    alias b = blue;
    /// @brief Simple way to work with alpha chanel (transparent chanel)
    alias a = alpha;
}

/// @brief This struct describes a cmy color.
struct CmyColor {
    /// @brief Amount of cyan color
    double cyan = 0.0;
    /// @brief Amount of magenta color
    double magenta = 0.0;
    /// @brief Amount of yellow color
    double yellow = 0.0;

    /// @brief Simple way to work with cyan chanel
    alias c = cyan;
    /// @brief Simple way to work with magenta chanel
    alias m = magenta;
    /// @brief Simple way to work with yellow chanel
    alias y = yellow;
}

/// @brief This struct describes a cmyk color.
struct CmykColor {
    /// @brief Amount of cyan color
    double cyan = 0.0;
    /// @brief Amount of magenta color
    double magenta = 0.0;
    /// @brief Amount of yellow color
    double yellow = 0.0;
    /// @brief Amount of key(black) color
    double key = 0.0;

    /// @brief Amount of key(black) color
    alias black = key;

    /// @brief Simple way to work with cyan chanel
    alias c = cyan;
    /// @brief Simple way to work with magenta chanel
    alias m = magenta;
    /// @brief Simple way to work with yellow chanel
    alias y = yellow;
    /// @brief Simple way to work with key(black) chanel
    alias k = key;

    /// @brief Simple way to work with key(black) chanel
    alias b = black;
}
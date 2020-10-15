module image;

import std.exception;
import std.stdio;

/**
 * @brief The rgba_color struct
 *
 * Struct to contain color in RGBA format
 */
struct rgba_color {
    /// @brief r Amount of red
    ubyte r = 0x00;
    /// @brief r Amount of green
    ubyte g = 0x00;
    /// @brief r Amount of blue
    ubyte b = 0x00;
    /// @brief r Alpha chanel (Amount of transparency)
    ubyte a = 0xff;
}


class image {
    public this(size_t width, size_t height) @safe {
        img_width = width; img_height = height;

        img_data = new rgba_color[][img_width];
        for (size_t i = 0; i < img_width; i++) 
            img_data[i] = new rgba_color[img_height];
    }

    public size_t get_width() @safe {
        return img_width;
    }

    public size_t get_height() @safe {
        return img_height;
    }


    public rgba_color get_pixel(size_t x, size_t y) @safe {
        enforce!ErrnoException(x < img_width, "X coordinate is more than image width (out of range)");
        enforce!ErrnoException(y < img_height, "Y coordinate is more than image height (out of range)");
        return img_data[x][y];
    }

    public void set_pixel(size_t x, size_t y, rgba_color source) @safe {
        enforce!ErrnoException(x < img_width, "X coordinate is more than image width (out of range)");
        enforce!ErrnoException(y < img_height, "Y coordinate is more than image height (out of range)");
        img_data[x][y] = source;
    }


    public ~this() @safe {
        for (size_t i = 0; i < img_width; i++) 
            img_data[i].destroy();
        
        img_data.destroy();
    }


    private size_t img_width;
    private size_t img_height;

    private rgba_color[][] img_data;
}
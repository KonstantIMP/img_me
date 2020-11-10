module uncompressed_image.image;

import uncompressed_image.defines;

import std.exception;

class UncompressedImage(T) if (is(T == RgbColor) || is(T == RgbaColor) || is(T == CmyColor) || is(T == CmykColor)) {
    public this(size_t w, size_t h, T background_source = T()) @safe {
        image_width = w; image_height = h;

        img_data = new T [][h];

        for(size_t i = 0; i < h; i++) {
            img_data[i] = new T[w];
            if(background_source != T()) {
                for(size_t j = 0; j < w; j++) {
                    img_data[i][j] = background_source;
                }
            }
        }
    }

    public ~this() @safe {
        clearMemory();
    }

    public void clear(T source_color = T()) @safe @nogc {
        for(size_t i = 0; i < image_height; i++) {
            for(size_t j = 0; j < image_width; j++) {
                img_data[i][j] = source_color;
            }
        }
    }

    public T getPixel(size_t left, size_t top) @safe {
        enforce!ErrnoException(left < image_width, "Going beyond the image (in width)");
        enforce!ErrnoException(top < image_height, "Going beyond the image (in height)");

        return img_data[top][left];
    }

    public void setPixel(size_t left, size_t top, T source_color) @safe {
        enforce!ErrnoException(left < image_width, "Going beyond the image (in width)");
        enforce!ErrnoException(top < image_height, "Going beyond the image (in height)");

        img_data[top][left] = source_color;
    }

    public size_t gitImageWidth() @safe @nogc {
        return image_width;
    }

    public size_t getImageHeight() @safe @nogc {
        return image_height;
    }

    private void clearMemory() @safe {
        for(size_t i = image_height; i > 0; i--) {
            img_data[i - 1].destroy();
        } img_data.destroy();
    }

    private T [][] img_data;

    private size_t image_width;
    private size_t image_height;
}
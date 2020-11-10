module pnm.pnm_me;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_defines;

import std.exception;

class PnmImage {
    public this() @safe @nogc {}

    public PnmHeader getImageHeader() @safe @nogc nothrow {
        return image_header;
    }

    public void setImageHeader(PnmHeader source_header) @safe @nogc nothrow {
        image_header = source_header;
    }

    public ref UncompressedImage!RgbaColor getImage() @safe {
        enforce!ErrnoException(image_data !is null, "You haven\'t set PNM image yet");
        return image_data;
    }

    public void setImage(UncompressedImage!RgbaColor source_image) @trusted {
        if(image_data !is null) image_data.destroy(); 
        image_data = new UncompressedImage!RgbaColor(source_image.gitImageWidth, source_image.getImageHeight);

        for(size_t i = 0; i < source_image.getImageHeight; i++) {
            for(size_t j = 0; j < source_image.gitImageWidth; j++) {
                image_data.setPixel(j, i, source_image.getPixel(j, i));
            }
        }
    }

    private PnmHeader image_header;
    private UncompressedImage!RgbaColor image_data = null;
}
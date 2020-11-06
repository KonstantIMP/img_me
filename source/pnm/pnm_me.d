module pnm.pnm_me;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_defines;

import std.exception;
import std.variant;
import std.string;
import std.stdio;
import std.file;

class PnmImage {
    public this() @safe @nogc {}

    public PnmHeader getImageHeader() @safe @nogc nothrow {
        return image_header;
    }

    public void setImageHeader(PnmHeader source_header) @safe @nogc nothrow {
        image_header = source_header;
    }

    public ref Image!RgbaColor getImage() @safe {
        enforce!ErrnoException(image_data !is null, "You haven\'t set PNM image yet");
        return image_data;
    }

    public void setImage(Image!RgbaColor source_image) @trusted {
        if(image_data !is null) image_data.destroy(); 
    }

    private PnmHeader image_header;
    private Image!RgbaColor image_data = null;
}
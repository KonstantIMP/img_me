module bmp_me;

import std.exception;
import std.string;

import std.stdio;
import std.file;

enum bmp_version : ubyte {
    BMP_CORE_v1 =  12,
    BMP_CORE_v3 =  40,
    BMP_CORE_v4 = 108,
    BMP_CORE_v5 = 124,
    BMP_CORE_vU = 255
}

struct bmp_header {
    ushort bmp_mark;

    uint   file_size;

    ushort reserved_1;
    ushort reserved_2;

    uint   data_address; 
}

class bmp_image {
    public this() @safe {
        image_format_ver = bmp_version.BMP_CORE_vU;
    }


    public bmp_version get_image_version() @safe {
        return image_format_ver;
    }

    public void parse_file(string bmp_file_path, bool is_debug) {
        if(is_debug) writeln("[DEBUG] Start parsing BMP image \'", bmp_file_path, '\'');

        if(exists(bmp_file_path) == false) {
            if(is_debug) writeln("[DEBUG] [ERROR] File \'", bmp_file_path, "\' doen\'t exist");
            throw new ErrnoException("File \'" ~ bmp_file_path ~ "\' doesn\'t exist");
        }

        if(is_debug) writeln("[DEBUG] Image file opening...");
        auto image_file = File(bmp_file_path, "r");

        //// Header parsing
        {
            if(is_debug) writeln("[DEBUG] BMP file header parsing");
            char [] buf; buf.length = 2;

            image_file.rawRead(buf);
            if(buf[0] == 'B' && buf[1] == 'M') {
                image_header.bmp_mark = (buf[0] << 8) | buf[1];
                if(is_debug) writeln("\tFirst 2 bytes is \'", buf, "\' (", image_header.bmp_mark, ") : OK");
            }
            else {
                if(is_debug) writeln("\tFirst 2 bytes is not \'BM\' : ERROR");
                throw new ErrnoException("First 2 byte must be \'BM\'(It may be not a BMP file)");
            }

            buf[0] = buf[1] = 0; buf.length = 4;

            image_file.rawRead(buf);
            image_header.file_size = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];

            if(is_debug) writeln("\tImage file size is : ", image_header.file_size, " bytes");

            buf[0] = buf[1] = buf[2] = buf[3] = 0; buf.length = 2;
            for(size_t i = 0; i < 2; i++) {
                image_file.rawRead(buf);
                if(buf[0] == 0 && buf[1] == 0) {
                    if(is_debug) writeln('\t', i + 1, "th reserved byted is 0x0000  : OK");
                }
                else {
                    if(is_debug) writeln("\tNext 2 bytes is not 0x0000 : ERROR");
                    throw new ErrnoException("Next 2 bytes must be 0x00(It is reserved by RFC)");
                }
            } image_header.reserved_1 = image_header.reserved_2 = 0x0000;

            buf[0] = buf[1] = 0; buf.length = 4;

            image_file.rawRead(buf);
            image_header.data_address = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];

            if(is_debug) writeln("\tImage data offset is : ", image_header.data_address);

            image_format_ver = cast(bmp_version)(image_header.data_address - 14);

            if (image_format_ver != bmp_version.BMP_CORE_v1 && 
                image_format_ver != bmp_version.BMP_CORE_v3 &&
                image_format_ver != bmp_version.BMP_CORE_v4 &&
                image_format_ver != bmp_version.BMP_CORE_v5 ) {
                if(is_debug) writeln("[DEBUG] [ERROR] Incorrect BMP version");
                throw new ErrnoException("Incorrect BMP version");
            }

            if(is_debug) {
                switch(image_format_ver) {
                    case bmp_version.BMP_CORE_v1 :
                        writeln("\tBMP version is : 1 (BMP_CORE_v1)"); break;
                    case bmp_version.BMP_CORE_v3 :
                        writeln("\tBMP version is : 3 (BMP_CORE_v3)"); break;
                    case bmp_version.BMP_CORE_v4 :
                        writeln("\tBMP version is : 4 (BMP_CORE_v4)"); break;
                    case bmp_version.BMP_CORE_v5 :
                        writeln("\tBMP version is : 5 (BMP_CORE_v5)"); break;
                    default :
                        writeln("\tBMP version is : UNDEFINED"); break;
                }
            }
        }
    }

    private bmp_header image_header;
    private bmp_version image_format_ver;
}

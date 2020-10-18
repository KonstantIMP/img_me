module bmp_me;

/**
 * @file bmp_me.d
 * @brief Classes for work with Microsoft BitMap format(.bmp)
 * @author KonstantIMP
 */

import std.exception;
import std.variant;
import std.string;

import std.stdio;
import std.file;

/// @brief Enumeration of supported BMP file versions
enum bmp_version : ubyte {
    BMP_CORE          = 0x0C, ///< The first and the smalest BMP version (CORE)
    BMP_OS2_CORE      = 0x10, ///< Lightweight BMP_OS2_CORE (Only first 16 bytes)
    BMP_INFOHEADER    = 0x28, ///< The base BMP file version (INFOHEADER)
    BMP_INFOHEADER_v2 = 0x34, ///< Undocumented header was made by Adobe
    BMP_INFOHEADER_v3 = 0x38, ///< Undocumented header was made by Adobe with alpha
    BMP_OS2_CORE_v2   = 0x40, ///< BMP which was created at OS/2 os
    BMP_INFOHEADER_v4 = 0x6C, ///< Extended base BMP file version (v4 with some additional feautures)
    BMP_INFOHEADER_v5 = 0x7C, ///< More extended base BMP file version (v5)
    BMP_UNSET_VER     = 0xFF  ///< Unset BMP file version
};

/// @brief Enumeration of supported MBP image compression methods
enum bmp_compression : ubyte {
    BMP_RGB            = 0x00, ///< Standart compression method (most common)
    BMP_RLE8           = 0x01, ///< With RLE 8-bit/pixel compression
    BMP_RLE4           = 0x02, ///< With RLE 4-but/pixel compression
    BMP_BITFIELDS      = 0x03, ///< Currently only the standard RGBA compression method is supported
    BMP_JPEG           = 0x04, ///< There is a JPEG image into the BMP file
    BMP_PNG            = 0x05, ///< There is a PNG image into the BMP file
    BMP_ALPHABITFIELDS = 0x06, ///< This is an RGBA compression method, but better
    BMP_CMYK           = 0x0B, ///< The image uses a CMYK color scheme
    BMP_CMYKRLE8       = 0x0C, ///< The image uses a CMYK color scheme with RLE 8-bit/pixel compression
    BMP_CMYKRLE4       = 0x0D  ///< The image uses a CMYK color scheme with RLE 4-bit/pixel compression
};

/// @brief BMP file first header (To set .BMP format)
struct bmp_header {
    /**
     * @brief bmp_mark
     * 
     * Need to identify BMP and DIB file
     * 
     * Can be :\n
     *      BM - Windows 3.1x, 95, NT and etc.\n
     *      BA - OS/2 struct bitmap array\n
     *      CI - OS/2 struct color icon\n
     *      CP - OS/2 const color pointer\n
     *      IC - OS/2 struct icon\n
     *      PT - OS/2 pointer\n
     */
    ushort bmp_mark;

    /// @brief .BMP file size in bytes
    uint   file_size;

    /// @brief First reserved bytes (must be 0x0000)
    ushort reserved_1;
    /// @brief Second reserved bytes (must be 0x0000)
    ushort reserved_2;

    /// @brief Image data offset from file start
    uint   data_address; 
}

/// @brief Second .BMP file header for CORE version
struct bmp_core_header {
    /// @brief Second header size in bytes (must be 12)
    uint header_size;

    /// @brief Image width (in px)
    ushort img_width;
    /// @brief Image height (in px)
    ushort img_height;

    /// @brief Image surfaces num (must be 1)
    ushort surface_num;

    /**
     * @brief pixel_weight
     * 
     * Number bits per pixels
     * 
     * Can be : 1, 4, 8, 24 or 32 
     */
    ushort pixel_weight;
}

/// @brief Secpnd .BMP file header for INFOHEADER version
struct bmp_infoheader {
    /// @brief Second header size in bytes (must be 40)
    uint header_size;

    /// @brief Image width (in px)
    uint img_width;
    /// @brief Image height (in px)
    uint img_height;

    /// @brief Image surfaces num (must be 1)
    ushort surface_num;

    /**
     * @brief pixel_weight
     * 
     * Number bits per pixel
     * 
     * Can be : 1, 4, 8, 16, 24, 32
     */
    ushort pixel_weight;

    /// @brief Compression method used for the image
    bmp_compression compression_type;

    /// @brief Image data size (in bytes)
    uint img_data_size;

    /// @brief Horizontal resolution (pixel per meter)
    int horizontal_res;

    /// @brief Vertical resolution (pixel per meter)
    int vertical_res;

    /// @brief Number of colors in pallete (0 or 2**n)
    uint used_color_num;

    /// @brief Number of really used color in pallete (may be 0) 
    uint need_color_num;
}

struct bmp_infoheader_v4 {
    bmp_infoheader base_header;

    uint red_mask;
    uint green_mask;
    uint blue_mask;
    uint alpha_mask;

    uint color_space_type;

    int red_x;
    int red_y;
    int red_z;

    int green_x;
    int green_y;
    int green_z;

    int blue_x;
    int blue_y;
    int blue_z;

    uint gamma_red;
    uint gamma_green;
    uint gamma_blue;
}


struct bmp_infoheader_v5 {
    bmp_infoheader_v4 base_header;

    uint render_type;

    uint profile_data_offset;

    uint profile_data_size;

    uint reserved_z;
}

class bmp_image {
    public this() @safe {
        image_format_ver = bmp_version.BMP_UNSET_VER;
    }


    public bmp_version get_image_version() @safe {
        return image_format_ver;
    }

    public void parse_file(string bmp_file_path, bool is_debug) @safe {
        if(is_debug) writeln("[DEBUG] Start parsing BMP image \'", bmp_file_path, '\'');

        if(exists(bmp_file_path) == false) {
            if(is_debug) writeln("[DEBUG] [ERROR] File \'", bmp_file_path, "\' doen\'t exist");
            throw new ErrnoException("File \'" ~ bmp_file_path ~ "\' doesn\'t exist");
        }

        if(is_debug) writeln("[DEBUG] Image file opening...");
        auto image_file = new File(bmp_file_path, "r");

        //// Header parsing
        parse_header(image_file, is_debug);

        // Second header parsing
        if(is_debug) writefln("[DEBUG] Second header parsing");

        switch(image_format_ver) {
            case bmp_version.BMP_CORE :
                if(is_debug) writefln("\tUsing header struct : bmp_core_header");
                parse_bmp_core(image_file, is_debug);
            break;
            case bmp_version.BMP_INFOHEADER :
                if(is_debug) writefln("\tUsing header struct : bmp_infoheader");
                parse_infoheader(image_file, is_debug);
            break;
            default: break;
        }   

        image_file.close(); image_file.destroy();
    }

    private void parse_header(File * image_file, bool is_debug) @safe {
        if(is_debug) writeln("[DEBUG] BMP file header parsing");
        char [] buf; buf.length = 2;

        image_file.rawRead(buf);
        if((buf[0] == 'B' && buf[1] == 'M') || 
           (buf[0] == 'B' && buf[1] == 'A') ||
           (buf[0] == 'C' && buf[1] == 'I') ||
           (buf[0] == 'C' && buf[1] == 'P') ||
           (buf[0] == 'I' && buf[1] == 'C') ||
           (buf[0] == 'P' && buf[1] == 'T')) {
                image_header.bmp_mark = (buf[0] << 8) | buf[1];
                if(is_debug) writeln("\tFirst 2 bytes is \'", buf, "\' (", image_header.bmp_mark, ") : OK");
            }
        else {
            if(is_debug) writeln("\tFirst 2 bytes is not \'BM\', \'BA\', \'CI\', \'CP\', \'IC\' or \'PT\' : ERROR");
            throw new ErrnoException("First 2 byte must be \'BM\', \'BA\', \'CI\', \'CP\', \'IC\' or \'PT\' (It may be not a BMP file)");
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

        if (image_format_ver !=          bmp_version.BMP_CORE && 
            image_format_ver !=    bmp_version.BMP_INFOHEADER &&
            image_format_ver != bmp_version.BMP_INFOHEADER_v4 &&
            image_format_ver != bmp_version.BMP_INFOHEADER_v5 &&
            image_format_ver != bmp_version.BMP_INFOHEADER_v2 &&
            image_format_ver != bmp_version.BMP_INFOHEADER_v3 &&
            image_format_ver !=      bmp_version.BMP_OS2_CORE &&
            image_format_ver !=   bmp_version.BMP_OS2_CORE_v2 ) {
            if(is_debug) writeln("[DEBUG] [ERROR] Incorrect or unsupported BMP version");
            throw new ErrnoException("Incorrect or unsopported BMP version");
        }

        if(is_debug) writeln("\tBMP version is : ", image_format_ver);
    }

    private void parse_bmp_core(File * image_file, bool is_debug) @trusted {
        ubyte [] buf; buf.length = 4;
        image_file.rawRead(buf);

        bmp_core_header tmp_header;
        tmp_header.header_size = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];

        if(is_debug) writeln("\tHeader size is : ", tmp_header.header_size, " bytes");

        if(tmp_header.header_size != 12) {
            if(is_debug) writeln("[DEBUG][ERROR] Header size must be 12 bytes");
            throw new ErrnoException("Incorrect header size (It must be 12 bytes)");
        }

        buf[0] = buf[1] = buf[2] = buf[3] = 0;
        image_file.rawRead(buf);

        tmp_header.img_width =(buf[1] << 8) | buf[0];
        tmp_header.img_height = (buf[3] << 8) | buf[2];

        if(is_debug) {
            writeln("\tImage width is : ", tmp_header.img_width, " px");
            writeln("\tImage height is : ", tmp_header.img_height, " px");
        }

        buf[0] = buf[1] = buf[2] = buf[3] = 0;
        image_file.rawRead(buf);

        tmp_header.surface_num =(buf[1] << 8) | buf[0];
        tmp_header.pixel_weight = (buf[3] << 8) | buf[2];

        if(is_debug) writeln("\tNumber of image surfaces : ", tmp_header.surface_num);

        if(tmp_header.surface_num != 1) {
            if(is_debug) writeln("[DEBUG][ERROR] Number of surfaces is not 1");
            throw new ErrnoException("Incorrect number of surfaces (It must be 1)");
        }

        if(is_debug) writeln("\tPixel weight is : ", tmp_header.pixel_weight, " bit-per-pixel");

        if(tmp_header.pixel_weight !=  1 &&
           tmp_header.pixel_weight !=  4 &&
           tmp_header.pixel_weight !=  8 &&
           tmp_header.pixel_weight != 24 &&
           tmp_header.pixel_weight != 32) {
            if(is_debug) writeln("[DEBUG][ERROR] Incorrect pixel weight value");
            throw new ErrnoException("Incorrect pixel weight value");
        }

        second_image_header = tmp_header;
    }

    private void parse_infoheader(File * image_file, bool is_debug) @trusted {

    }

    private bmp_header image_header;
    private bmp_version image_format_ver;

    private VariantN!(maxSize!(bmp_core_header, bmp_infoheader, bmp_infoheader_v4, bmp_infoheader_v5)) second_image_header;
}

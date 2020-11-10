module pnm.pnm_parser;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_defines;
import pnm.pnm_me;

import std.exception;
import std.string;
import std.stdio;
import std.ascii;
import std.conv;
import std.file;

class PnmParser {
    public static PnmImage parsePnmImage(string image_path, bool is_debug = false) @safe {
        if(is_debug) writeln("[Debug] Start parsing PNM file \'", image_path, '\'');

        if(exists(image_path) == false) {
            if(is_debug) writeln("[Debug][Error] Incorrect image file path (\'" ~ image_path ~ "\' doesn\'t exist)");
            throw new ErrnoException("Incorrect image file path (\'" ~ image_path ~ "\' doesn\'t exist)");
        }

        if(is_debug) writeln("[Debug] Opening image file...");
        File * img_file = new File(image_path, "r");

        PnmImage ret_img = new PnmImage();

        ret_img.setImageHeader = parseHeader(img_file, is_debug);

        img_file.close(); img_file.destroy();
        return ret_img;
    }

    private static PnmHeader parseHeader(File * image_file, bool is_debug) @trusted {
        if(is_debug) writeln("[Debug] Parsing PNM header...");
        ubyte [] buffer; buffer.length = 3; PnmHeader ret_header;
        image_file.rawRead(buffer);

        if(buffer[0] != 'P' || isDigit(buffer[1]) == false || buffer[2] != '\n') {
            if(is_debug) writeln("[Debug][Error] Incorrect image signature (must start from \'PX\')");
            throw new ErrnoException("Incorrect image signature (must start from \'PX\')");
        } 

        switch(buffer[1]) {
            case '1' : ret_header.image_format_version = PnmVersion.P1_PBM_FILE; break;
            case '2' : ret_header.image_format_version = PnmVersion.P2_PGM_FILE; break;
            case '3' : ret_header.image_format_version = PnmVersion.P3_PPM_FILE; break;
            case '4' : ret_header.image_format_version = PnmVersion.P4_PBM_FILE; break;
            case '5' : ret_header.image_format_version = PnmVersion.P5_PGM_FILE; break;
            case '6' : ret_header.image_format_version = PnmVersion.P6_PPM_FILE; break;
            case '7' : ret_header.image_format_version = PnmVersion.P7_PAM_FILE; break;
            default :
                if(is_debug) writeln("[Debug][Error] Incorrect image signature (must start from \'PX\')");
                throw new ErrnoException("Incorrect image signature (must start from \'PX\')");
        }

        if(is_debug) writeln("\tPNM file format version : ", ret_header.image_format_version);

        if(ret_header.image_format_version == PnmVersion.P7_PAM_FILE) {

        }
        else {
            
        }

        return ret_header;
    }
}
module pnm.pnm_parser;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_defines;
import pnm.pnm_me;

import std.container;
import std.exception;
import std.string;
import std.stdio;
import std.ascii;
import std.conv;
import std.file;

enum PnmTocken {
    PNM_COMMENT,
    PNM_VERSION,
    PNM_NL_CHAR,
    PNM_IMAGE_INFO,
    PNM_EMPTY_LINE,
    PNM_HEADER_INFO
}

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

        writeln(tockenizePnmFile(img_file).opSlice());

        img_file.close(); img_file.destroy();
        return ret_img;
    }

    private static SList!PnmTocken tockenizePnmFile(File * image_file) @trusted {
        SList!PnmTocken tocken_list = SList!PnmTocken();

        ubyte img_version = 0, header_block_num = 0;

        while(image_file.eof() == false) {
            string current_line = image_file.readln();

            if(current_line == "\n" || current_line == "\r\n") {
                tocken_list.insert(PnmTocken.PNM_EMPTY_LINE);
                continue;
            }

            if((header_block_num == 2 && (img_version == cast(ubyte)(PnmVersion.P1_PBM_FILE) || img_version == cast(ubyte)(PnmVersion.P4_PBM_FILE))) ||
               (header_block_num == 3 && (img_version == cast(ubyte)(PnmVersion.P2_PGM_FILE) || img_version == cast(ubyte)(PnmVersion.P5_PGM_FILE))) ||
               (header_block_num == 3 && (img_version == cast(ubyte)(PnmVersion.P3_PPM_FILE) || img_version == cast(ubyte)(PnmVersion.P6_PPM_FILE))) ||
               (header_block_num == 11 && (img_version == cast(ubyte)(PnmVersion.P7_PAM_FILE)))) {
                if(current_line[0] == '#') {
                    tocken_list.insert(PnmTocken.PNM_COMMENT);
                    continue;
                }
                tocken_list.insert(PnmTocken.PNM_IMAGE_INFO);
                break;
            }

            for(size_t i = 0; i < current_line.length; i++) {
                if(current_line[i] == ' ' || current_line[i] == '\r') continue;
                else if(current_line[i] == '\n') {
                    tocken_list.insert(PnmTocken.PNM_NL_CHAR); continue;
                }
                else if(current_line[i] == '#') {
                    tocken_list.insert(PnmTocken.PNM_COMMENT);
                    tocken_list.insert(PnmTocken.PNM_NL_CHAR);
                    break;
                }
                else if(current_line[i] == 'P' && img_version == 0) {
                    if(i + 1 < current_line. length) {
                        i = i + 1;
                        switch(current_line[i]) {
                            case '1' : img_version = cast(ubyte)(PnmVersion.P1_PBM_FILE); break; 
                            case '2' : img_version = cast(ubyte)(PnmVersion.P2_PGM_FILE); break;
                            case '3' : img_version = cast(ubyte)(PnmVersion.P3_PPM_FILE); break;
                            case '4' : img_version = cast(ubyte)(PnmVersion.P4_PBM_FILE); break;
                            case '5' : img_version = cast(ubyte)(PnmVersion.P5_PGM_FILE); break;
                            case '6' : img_version = cast(ubyte)(PnmVersion.P6_PPM_FILE); break;
                            case '7' : img_version = cast(ubyte)(PnmVersion.P7_PAM_FILE); break;
                            default : throw new ErrnoException("Incorrect PNM file signature");
                        }
                        tocken_list.insert(PnmTocken.PNM_VERSION);
                    }
                    else throw new ErrnoException("Incorrect PNM file signature");
                }
                else {
                    tocken_list.insert(PnmTocken.PNM_HEADER_INFO);
                    while(1) {
                        i = i + 1;
                        if(current_line[i] == ' ' || current_line[i] == '\n' || current_line[i] == '\r') break;
                    }
                    if(current_line[i] == '\n') tocken_list.insert(PnmTocken.PNM_NL_CHAR);
                    header_block_num++; continue;
                }
            }
        }
        tocken_list.reverse();
        return tocken_list;
    }
}
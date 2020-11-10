import std.string;
import std.stdio;

import uncompressed_image.defines;
import uncompressed_image.image;

import pnm.pnm_parser;
import pnm.pnm_me;

import gtk.Main;
import gtk.Widget;
import gtk.MainWindow;

import cairo.Context;

import gtk.DrawingArea;
import gtk.Image;

void main(string [] args) {
    /*Main.init(args);
    MainWindow win = new MainWindow("Woof");

    DrawingArea a = new DrawingArea();

    a.addOnDraw((Scoped!Context context, Widget w){
        UncompressedImage!RgbaColor img = new UncompressedImage!RgbaColor(100, 100, RgbaColor(1.0, 1.0, 1.0, 1.0));
        img.setPixel(75, 25, RgbaColor(1.0, 0.0, 0.0, 1.0));
        for(size_t i = 0; i < img.gitImageWidth; i++) {
            for(size_t j = 0; j < img.getImageHeight; j++) {
                context.setSourceRgba(img.getPixel(i, j).r, img.getPixel(i, j).g, img.getPixel(i, j).b, img.getPixel(i, j).a); context.setLineWidth(1);
	            context.rectangle(i, j, 1, 1);
	            context.stroke();                
            }
        }

        return true;
    });

    win.add(a);

    win.showAll();
    Main.run();*/

    PnmImage p = PnmParser.parsePnmImage("/home/kimp/Projects/img_me/test/pnm/p1.pbm", true);
}

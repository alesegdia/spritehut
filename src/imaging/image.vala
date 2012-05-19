/*
** Copyright © 2011-2012 Juan José Bernal Rodríguez <juanjose.bernal.rodriguez@gmail.com>
**
** This file is part of Sprite Hut.
**
** Sprite Hut is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Sprite Hut is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Sprite Hut.  If not, see <http://www.gnu.org/licenses/>.
*/
using Gdk;

/**
* Imaging namespace
*/
namespace Imaging
{
/**
* Abstract image class
* 
* A simple abstract image class to inherit from
*
* @since 0.1
*/
    public abstract class Image: Object {
        public enum Mode {
            INDEXED,
            RGB,
            RGBA
        }
        
        /**
        * width property
        * 
        * The width of the image
        */
        public int width {get;set;}
        public int height {get;set;}
        public int bpp {get; set;}
        public bool has_alpha {get; set; default = true;}
        public Mode mode {
        get{
            return (bpp <= 8) ? Image.Mode.INDEXED : (has_alpha) ? Image.Mode.RGBA : Image.Mode.RGB;
        }
        
        }
        public Palette palette {get;set;}
        
        public Image(int width, int height, int bpp)
        {
            this.width = width;
            this.height = height;
            this.bpp = bpp;
        }
        
        /**
        * Constructs an image from a uint array containing the pixel data
        * 
        * @param width The width of the image
        * @param height The height of the image
        * @param bpp The depth (Bits Per Pixel) of the image
        * @param pixel_data The array pixel data. This will be interpreted according to the bpp parameter
        */
        public Image.from_pixel_data(int width, int height, int bpp, uint8* pixel_data);
        public abstract uint8* get_pixel_data();
        public abstract RGBA get_pixel_color(int x, int y);
        public abstract uint8 get_index(int x, int y);
        public abstract Image to_rgba();
    }
}

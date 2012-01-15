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
using Cairo;

namespace Imaging
{
    public abstract class Image: Object {
        public enum Mode {
            INDEXED,
            RGBA
        }
        public int width {get;set;}
        public int height {get;set;}
        public Pixbuf thumbnail {get;set;}
        public Mode mode {get;set;}
        public ImageSurface cairo_surface {get;set;}
        public Palette palette {get;set;}
        
        public abstract RGBA get_pixel(int x, int y);
        public abstract uint8 get_index(int x, int y);
        public abstract Image to_rgba();
    }
}

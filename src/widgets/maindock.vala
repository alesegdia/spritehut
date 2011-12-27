/*
** Copyright (C) 2011 Juan José Bernal Rodríguez <juanjose.bernal.rodriguez@gmail.com>
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

using Gtk;
using Gdl;

namespace Widgets
{
    public class MainDock : Gtk.Box {
        private DockMaster master;
        private DockLayout layout;
        
        public MainDock()
        {
            Gdl.Dock dock = new Gdl.Dock();
            this.master = dock.master;

            /* ... and the layout manager */
            this.layout = new DockLayout(dock);

            /* create the dockbar */
            var dockbar = new DockBar (dock);
            dockbar.set_style (DockBarStyle.BOTH);
            
            this.pack_start(dockbar, false, true, 0);
            this.pack_start(dock, true, true, 0);
            
            /* the canvas dock */
            var canvas = new DockItem.with_stock("canvas", "Canvas", Gtk.Stock.STOP, DockItemBehavior.NORMAL |
                                              DockItemBehavior.CANT_ICONIFY | DockItemBehavior.LOCKED);
            var widget = new Label ("This is where you would work and swear at, most of the time");
            widget.set_size_request(400,300);
            canvas.add(widget);
            dock.add_item (canvas, DockPlacement.CENTER);
            canvas.show();

            /* Tool box */
            var toolbox = add_dock_item(dock, "toolbox", _("Toolbox"), new TreeView(), canvas,
            DockPlacement.LEFT, 50, 200);

            /* the color_picker dock */
            var color_picker = add_dock_item(dock, "color_picker", _("Color Picker"), new HSV(), toolbox,
            DockPlacement.BOTTOM, 50, 50);

            /* preview */
            var preview = add_dock_item(dock, "preview", _("Preview"), new TreeView(), canvas,
            DockPlacement.RIGHT, 100, 100);

            // Palette
            var palette = add_dock_item(dock, "palette", _("Palette"), new TreeView(), preview,
            DockPlacement.BOTTOM, 100, 100);

            // Animations
            var animations = add_dock_item(dock, "animations", _("Animations"), new TreeView(), palette,
            DockPlacement.BOTTOM, 100, 100);
            
            // Frames
            var frames = add_dock_item(dock, "frames", _("Frames"), new TreeView(), canvas,
            DockPlacement.BOTTOM, 200, 100);
        }
        
        private DockItem add_dock_item(Dock dock, string name, string id, Gtk.Widget? widget=null,
         DockItem? target=null, DockPlacement dock_placement=DockPlacement.NONE, 
         int req_width=0, int req_height=0, DockItemBehavior behavior=DockItemBehavior.NORMAL)
        {   
            var item = new DockItem(name, id, behavior);
            var _widget = widget;
            widget.set_size_request(req_width,req_height);
            if (_widget != null) {
                item.add(_widget);
            }
            dock.add_item (item, dock_placement);
            item.dock_to(target, dock_placement, -1);
            item.show();
            
            return item;
        }
    }
}


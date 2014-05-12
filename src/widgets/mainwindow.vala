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

using Gtk;
using Document;

namespace Widgets
{
    public class MainWindow : Gtk.ApplicationWindow {
        public Gtk.MenuBar main_menubar;
        public Gtk.Toolbar main_toolbar;
        public Gtk.Statusbar main_statusbar;
        public Gtk.Builder builder;
        public Document.Document document {get;set;}

        private Gtk.Application app;

        public const GLib.ActionEntry[] actions = {
        /*{ "action name", cb to connect to "activate" signal, parameter type,
         initial state, cb to connect to "change-state" signal } */
            { "save", on_save },
            { "save-as", on_save_as },
            { "close", on_close },
            { "undo", on_undo },
            { "redo", on_redo },
            { "cut", on_cut },
            { "copy", on_copy },
            { "paste", on_paste },
            { "undo", on_undo },
            { "delete", on_delete },
            { "toggle-toolbar", on_toggle_toolbar, null, "true" },
            { "toggle-statusbar", on_toggle_statusbar, null, "true" }
        };
        
        public MainWindow (Gtk.Application app, Document.Document? doc)
        {
            Object (application: app, title: _("Sprite Hut"), type: Gtk.WindowType.TOPLEVEL);
            
            this.set_default_size (800, 600);
            this.icon_name = "spritehut";
            
            try
            {
                string main_window_path = GLib.Path.build_filename( Config.PKGDATADIR, "ui",
                                             "mainwindow.ui", null );
                builder = new Builder ();
                builder.add_from_file (main_window_path);
                
//                builder.get_object ("main-window") as Gtk.ApplicationWindow;
                main_menubar = builder.get_object ("main-menubar") as Gtk.MenuBar;
                this.add_accel_group(builder.get_object ("main-accelgroup") as Gtk.AccelGroup);
                this.add_action_entries( actions, this);
                
                Box box = builder.get_object("main-box") as Box;
                box.reparent(this);
                
                main_toolbar = builder.get_object("main-toolbar") as Toolbar;
//                main_toolbar.get_style_context().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
                main_statusbar = builder.get_object("main-statusbar") as Statusbar;
                main_statusbar.push(0, _("Ready"));

                MainDock main_dock = new MainDock(this);
                box.pack_start(main_dock, true, true, 0);
                
                document = doc;
                if (document != null)
                {
                    document.notify.connect(update_window_status);
                }
                
                this.delete_event.connect(on_window_delete); // redirect delete_event
                
                this.show_all ();

            } catch (Error e) {
                stderr.printf ("Could not load UI: %s\n", e.message);
            } 
        }
        
        //Window Statuses
        public void update_window_status(){
//        TODO Update window actions depending on document status
            ((SimpleAction) this.lookup_action("redo")).set_enabled(document.undo_history.can_redo());
            ((SimpleAction) this.lookup_action("undo")).set_enabled(document.undo_history.can_undo());
        }

        
        public void set_busy_status(){
//        TODO disable all actions while doing long tasks e.g. loading or saving and inform the user
        }
//      
        // File action handlers
        public void on_save(SimpleAction action, Variant? parameter) {
            stdout.printf("Save Stub\n");
            set_busy_status();
            update_window_status();
        }
        
        public void on_save_as(SimpleAction action, Variant? parameter) {
            FileChooserDialog fcd = new FileChooserDialog(null, null, FileChooserAction.SAVE, Stock.CANCEL, ResponseType.CANCEL,
                                      Stock.SAVE_AS, ResponseType.ACCEPT);
            if (fcd.run () == ResponseType.ACCEPT) {
//                open_file (file_chooser.get_filename ());
                stdout.printf("Saving to %s\n", fcd.get_filename ());
                set_busy_status();
                update_window_status();
            }
            
            fcd.destroy();
        }
        
        public void on_close(SimpleAction action, Variant? parameter) {

            close_intent();
        }
        
        public bool on_window_delete(Gdk.EventAny? event) {
            close_intent();
            
            return true;
        }
        
        public void close_intent() {
            if (document != null && document.modified)
            {
                MessageDialog md = new MessageDialog(null, DialogFlags.MODAL,MessageType.WARNING,ButtonsType.YES_NO,
                _("There are unsaved changes in this project. Close the window anyway?"));
                if (md.run() == ResponseType.YES) {
                    document.notify.disconnect(update_window_status);   // detach document from window
                    this.destroy();
                }
                md.destroy();
            }
            else
            {
                this.destroy();
            }
        }
        
        // Edit action handlers
        public void on_undo(SimpleAction action, Variant? parameter) {
            stdout.printf("Undo Stub\n");
        }
        
        public void on_redo(SimpleAction action, Variant? parameter) {
            stdout.printf("Redo Stub\n");
        }
        
        public void on_cut(SimpleAction action, Variant? parameter) {
            stdout.printf("Cut Stub\n");
        }
        
        public void on_copy(SimpleAction action, Variant? parameter) {
            stdout.printf("Copy Stub\n");
        }
        
        public void on_paste(SimpleAction action, Variant? parameter) {
            stdout.printf("Paste Stub\n");
        }
        
        public void on_delete(SimpleAction action, Variant? parameter) {
            stdout.printf("Delete Stub\n");
        }
        
        public void on_preferences(SimpleAction action, Variant? parameter) {
            stdout.printf("Preferences Stub\n");
        }
        
        // View action handlers
        public void on_toggle_toolbar(SimpleAction action, Variant? parameter) {
            var active = action.get_state ().get_boolean ();
            action.set_state (new Variant.boolean (!active));
            main_toolbar.visible = !active;
            print("Toggled toolbar\n");
        }
        
        public void on_toggle_statusbar(SimpleAction action, Variant? parameter) {
            var active = action.get_state ().get_boolean ();
            action.set_state (new Variant.boolean (!active));
            main_statusbar.visible = !active;
            print("Toggled status bar \n");
        }
    }
}


/*
 * Copyright (c) 2011-2018 Patrick Gantner
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Indicator for toggling sleep settings quickly. 
 */
public class DontNap.Indicator : Wingpanel.Indicator {
    /* display widget, a composited icon */
    private Wingpanel.Widgets.OverlayIcon icon;

    /* popover */
    private Gtk.Grid widget;

    private Settings power_settings;
    private Settings session_settings;
    private Settings dpms_settings;

    public string sleep_settings_ac { get; set; }
    public string sleep_settings_bat { get; set; }
    public bool idle_dim { get; set; }
    public uint session_timeout { get; set; }
    public int standby_time {get; set; }

    public Indicator () {
        Object (
            code_name : "dontnap-indicator",
            display_name : _("DontNap Indicator"),
            description: _("Indicator only application to toggle sleep behaviour!")
        );
    }

    construct {
        /* Create a new composited icon */
        icon = new Wingpanel.Widgets.OverlayIcon ("weather-clear-night-symbolic");

        var nap_switch = new Wingpanel.Widgets.Switch (_("Prevent Sleep"));

        widget = new Gtk.Grid ();
        widget.attach (nap_switch, 0, 2);

        var settings = new Settings("com.github.theswiftfox.dontnap");

        // initialize the glib settings loaders and get the currently stored values
        this.power_settings = new Settings("org.gnome.settings-daemon.plugins.power");
        this.session_settings = new Settings("org.gnome.desktop.session");
        this.dpms_settings = new Settings("io.elementary.dpms");

        settings.bind("ac-type", this, "sleep_settings_ac", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("bat-type", this, "sleep_settings_bat", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("dim-on-idle", this, "idle_dim", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("session-timeout", this, "session_timeout", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("standby-time", this, "standby_time", GLib.SettingsBindFlags.DEFAULT);
        settings.bind("active", nap_switch, "active", GLib.SettingsBindFlags.DEFAULT);

        icon.set_overlay_icon_name (nap_switch.active ? "network-vpn-lock-symbolic" : "");
        nap_switch.notify["active"].connect (() => {
            // if the switch is enabled display small lock on top of base icon 
            icon.set_overlay_icon_name (nap_switch.active ? "network-vpn-lock-symbolic" : "");
            if (nap_switch.active) {
                // store old sleep settings
                this.sleep_settings_ac = power_settings.get_string("sleep-inactive-ac-type");
                this.sleep_settings_bat = power_settings.get_string("sleep-inactive-battery-type");
                this.idle_dim = power_settings.get_boolean("idle-dim");
                this.session_timeout = session_settings.get_uint("idle-delay");
                this.standby_time = dpms_settings.get_int("standby-time");

                // disable sleep settings and session idle
                power_settings.set_string("sleep-inactive-ac-type", "nothing");
                power_settings.set_string("sleep-inactive-battery-type", "nothing");
                power_settings.set_boolean("idle-dim", false);
                session_settings.set_uint("idle-delay", 0);
                dpms_settings.set_int("standby-time", 0);
            } else {
                // restore settings
                power_settings.set_string("sleep-inactive-ac-type", this.sleep_settings_ac);
                power_settings.set_string("sleep-inactive-battery-type", this.sleep_settings_bat);
                power_settings.set_boolean("idle-dim", this.idle_dim);
                session_settings.set_uint("idle-delay", this.session_timeout);
                dpms_settings.set_int("standby-time", this.standby_time);
            }
        });

        this.visible = true;
    }

    public override Gtk.Widget get_display_widget () {
        return icon;
    }

    public override Gtk.Widget? get_widget () {
        return widget;
    }

    public override void opened () {

    }

    public override void closed () {

    }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {

    /* Check which server has loaded the plugin */
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        /* We want to display our sample indicator only in the "normal" session, not on the login screen, so stop here! */
        return null;
    }

    /* Create the indicator */
    var indicator = new DontNap.Indicator ();

    /* Return the newly created indicator */
    return indicator;
}


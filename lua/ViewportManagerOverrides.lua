core:module("CoreViewportManager")
core:import("CoreApp")
core:import("CoreCode")
core:import("CoreEvent")
core:import("CoreManagerBase")
core:import("CoreScriptViewport")
core:import("CoreEnvironmentManager")

require("lib/managers/hud/hudpresenter")

function ViewportManager:set_apply_render_settings_flag()
    self._has_applied_queued_settings = false
end

function ViewportManager:apply_queued_render_settings()
    if self._render_settings_change_map == nil then
        return
    end

    log("Applying queued RenderSettings changes ...")

    local is_resolution_changed = self._render_settings_change_map.resolution ~= nil

    for setting_name, setting_value in pairs(self._render_settings_change_map) do
        RenderSettings[setting_name] = setting_value
    end

    self._render_settings_change_map = nil

    Application:orig_apply_render_settings()
    Application:save_render_settings()

    if is_resolution_changed then
        self:resolution_changed()
    end

    -- NOTE:
    -- Do not call our own `FullscreenWindowed.library.change_display_mode` here
    -- or the game dies completely and crashes
end

function ViewportManager:end_frame(t, dt)
    if not self._has_applied_queued_settings or self._has_applied_queued_settings == nil then
        self:apply_queued_render_settings()
        self._has_applied_queued_settings = true
    end

    self._current_camera = nil
    self._current_camera_position_updated = nil
    self._current_camera_rotation = nil
end
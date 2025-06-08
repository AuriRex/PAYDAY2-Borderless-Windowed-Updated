core:module("CoreViewportManager")

function ViewportManager:do_apply_render_settings()
    self._apply_queued_settings = true
end

-- This function is at the start of `ViewportManager:end_frame` in the original code
-- We extract it to control when to actually apply the settings
function ViewportManager:apply_queued_render_settings()
    if self._render_settings_change_map == nil then
        return
    end

    log("[Borderless Window] Applying queued RenderSettings changes ...")

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
end

function ViewportManager:end_frame(t, dt)
    if self._apply_queued_settings == true then
        self:apply_queued_render_settings()
        self._apply_queued_settings = false
    end

    self._current_camera = nil
    self._current_camera_position_updated = nil
    self._current_camera_rotation = nil
end
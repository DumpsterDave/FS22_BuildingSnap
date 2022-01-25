BuildingSnap = {
    VERSION = g_modManager:getModByName(g_currentModName).version,
    MOD_NAME = g_currentModName,
    BASE_DIRECTORY = g_currentModDirectory,
    MOD_SETTINGS = getUserProfileAppPath() .. "modSettings",
    POS_SNAP = 0.5,
    POS_SNAP_OPTIONS = {
        ["0"] = 0.5,
        ["0.5"] = 1,
        ["1"] = 2,
        ["2"] = 3,
        ["3"] = 4,
        ["4"] = 5,
        ["5"] = 0

    },
    ROT_SNAP = 5,
    ROT_SNAP_OPTIONS = {
        ["0"] = 1,
        ["1"] = 5,
        ["5"] = 11.25,
        ["11.25"] = 22.5,
        ["22.5"] = 45,
        ["45"] = 90,
        ["90"] = 0
    }
}

addModEventListener(BuildingSnap)

function BuildingSnap:loadMap()
    Logging.info(string.format("[BS] - Loading Building Snap version %s", BuildingSnap.VERSION))
    ConstructionBrushPlaceable.loadedPlaceable = Utils.appendedFunction(ConstructionBrushPlaceable.loadedPlaceable, BuildingSnap.addSnap)
    ConstructionScreen.registerBrushActionEvents = Utils.appendedFunction(ConstructionScreen.registerBrushActionEvents, BuildingSnap.registerBindings)
    ConstructionScreen.removeBrushActionEvents = Utils.appendedFunction(ConstructionScreen.removeBrushActionEvents, BuildingSnap.unregisterBindings)
end

function BuildingSnap:addSnap()
    if self.placeable.spec_placement.rotationSnapAngle ~= nil then
        if self.placeable.spec_placement.rotationSnapAngle ~= 0 then
            Logging.info("[BS] - Building rotation snap angle already set to " .. math.deg(self.placeable.spec_placement.rotationSnapAngle))
        else
            Logging.info("[BS] - Setting building rotation snap angle to " .. BuildingSnap.ROT_SNAP)
            self.placeable.spec_placement.rotationSnapAngle = math.rad(BuildingSnap.ROT_SNAP)
        end
    end

    if self.placeable.spec_placement.positionSnapSize ~= nil then
        if self.placeable.spec_placement.positionSnapSize ~= 0 then
            Logging.info("[BS] - Building grid snap size already set to " .. self.placeable.spec_placement.positionSnapSize)
        else
            Logging.info("[BS] - Setting building grid snap size to " .. BuildingSnap.POS_SNAP)
            self.placeable.spec_placement.positionSnapSize = BuildingSnap.POS_SNAP
        end
    end

    BuildingSnap.lastBuilding = self
end

function BuildingSnap:registerBindings()
    local _, eventId = nil
    Logging.info("[BS] - Registering Bindings")
    _, eventId = self.inputManager:registerActionEvent("BS_ADJUST_POS_SNAP", self, BuildingSnap.togglePosSnap, false, true, false, true)
    table.insert(self.brushEvents, eventId)
    self.togglePosSnapEvent = eventId
    BuildingSnap.PosSnapEvent = eventId
    self.inputManager:setActionEventTextPriority(eventId, GS_PRIO_HIGH)
    self.inputManager:setActionEventText(self.togglePosSnapEvent, string.format(g_i18n:getText("BS_ADJUST_POS_SNAP_TEXT"), tostring(BuildingSnap.POS_SNAP)))
    _, eventId = self.inputManager:registerActionEvent("BS_ADJUST_ROT_SNAP", self, BuildingSnap.toggleRotSnap, false, true, false, true)
    table.insert(self.brushEvents, eventId)
    self.toggleRotSnapEvent = eventId
    BuildingSnap.RotSnapEvent = eventId
    self.inputManager:setActionEventTextPriority(self.toggleRotSnapEvent, GS_PRIO_HIGH)
    self.inputManager:setActionEventText(self.toggleRotSnapEvent, string.format(g_i18n:getText("BS_ADJUST_ROT_SNAP_TEXT"), tostring(BuildingSnap.ROT_SNAP)))
end

function BuildingSnap:unregisterBindings()
    Logging.info("[BS] - De-registering Bindings")
    self.togglePosSnapEvent = nil
    BuildingSnap.PosSnapEvent = nil
    self.toggleRotSnapEvent = nil
    BuildingSnap.RotSnapEvent = nil
end

function BuildingSnap:togglePosSnap()
    BuildingSnap.POS_SNAP = BuildingSnap.POS_SNAP_OPTIONS[tostring(BuildingSnap.POS_SNAP)]
    Logging.info("[BS] - Position Snap Changed to " .. BuildingSnap.POS_SNAP)
    BuildingSnap.lastBuilding.placeable.spec_placement.positionSnapSize = BuildingSnap.POS_SNAP
    g_inputBinding:setActionEventText(BuildingSnap.PosSnapEvent, string.format(g_i18n:getText("BS_ADJUST_POS_SNAP_TEXT"), tostring(BuildingSnap.POS_SNAP)))
    g_inputBinding:setActionEventTextVisibility(BuildingSnap.PosSnapEvent, true)
end

function BuildingSnap:toggleRotSnap()
    BuildingSnap.ROT_SNAP = BuildingSnap.ROT_SNAP_OPTIONS[tostring(BuildingSnap.ROT_SNAP)]
    Logging.info("[BS] - Rotation Snap Changed to " .. BuildingSnap.ROT_SNAP)
    BuildingSnap.lastBuilding.placeable.spec_placement.rotationSnapAngle = math.rad(BuildingSnap.ROT_SNAP)
    g_inputBinding:setActionEventText(BuildingSnap.RotSnapEvent, string.format(g_i18n:getText("BS_ADJUST_ROT_SNAP_TEXT"), tostring(BuildingSnap.ROT_SNAP)))
    g_inputBinding:setActionEventTextVisibility(BuildingSnap.RotSnapEvent, true)
end
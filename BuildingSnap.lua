BuildingSnap = {
    VERSION = "1.0.0.0",
    POS_SNAP = 0.5,
    ROT_SNAP = 5
}

addModEventListener(BuildingSnap)

function BuildingSnap:loadMap()
    Logging.info(string.format("[BS] - Loading Building Snap version %s", BuildingSnap.VERSION))
    ConstructionBrushPlaceable.loadedPlaceable = Utils.appendedFunction(ConstructionBrushPlaceable.loadedPlaceable, BuildingSnap.addSnap)
end

function BuildingSnap:addSnap()
    print"Called Add Snap"
    if self.placeable.spec_placement.rotationSnapAngle ~= nil then
        if self.placeable.spec_placement.rotationSnapAngle ~= 0 then
            print("Rotation Snap already set to " .. math.deg(self.placeable.spec_placement.rotationSnapAngle))
        else
            print("Setting building rotation snap angle to " ..BuildingSnap.ROT_SNAP)
            self.placeable.spec_placement.rotationSnapAngle = math.rad(BuildingSnap.ROT_SNAP)
        end
    end

    if self.placeable.spec_placement.positionSnapSize ~= nil then
        if self.placeable.spec_placement.positionSnapSize ~= 0 then
            print("Placement Snap Size already set to " .. self.placeable.spec_placement.positionSnapSize)
        else
            print("Setting placement snap size to " .. BuildingSnap.POS_SNAP)
            self.placeable.spec_placement.positionSnapSize = BuildingSnap.POS_SNAP
        end
    end
    --self.placeable.spec_placement.rotationSnapAngle
end

--local spec = self.spec_placement
--local snapAngle = math.deg(spec.rotationSnapAngle)
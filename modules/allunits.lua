local oldSelection = nil
local isAutoSelection = false
local allUnits = {}
local lastFocusedArmy = 0

function SelectBegin()
	oldSelection = GetSelectedUnits() or {}
	isAutoSelection = true
end
function SelectEnd()
	SelectUnits(oldSelection)
	isAutoSelection = false
end

function AddSelection()
	for _, unit in (GetSelectedUnits() or {}) do
		if unit:IsInCategory("BUILTBYQUANTUMGATE") or unit:IsInCategory("COMMAND") then
			allUnits[unit:GetEntityId()] = unit
		end
	end
end

function Reset()
	local currentlySelected = GetSelectedUnits() or {}
	isAutoSelection = true
	UISelectionByCategory("BUILTBYQUANTUMGATE COMMAND", false, false, false, false)
	AddSelection()
	SelectUnits(currentlySelected)
	isAutoSelection = false
end

function UpdateAllUnits()
	if GetFocusArmy() != lastFocusedArmy then
		Reset()
		lastFocusedArmy = GetFocusArmy()
	end

	AddSelection()
	
	-- Add focused (building or assisting)
	for _, unit in allUnits do
		if not unit:IsDead() and unit:GetFocus() and not unit:GetFocus():IsDead() then
			allUnits[unit:GetFocus():GetEntityId()] = unit:GetFocus()
		end
	end
	
	-- Remove dead
	for entityid, unit in allUnits do
		if unit:IsDead() then
			allUnits[entityid] = nil
		end
	end
end

function GetAllUnits()
	return allUnits
end

function IsAutoSelection()
	return isAutoSelection
end

-- EDIT THIS FILE TO YOUR OWN REQUIREMENTS!
-- Intended for use when none of the existing exporters fit your use case
-- You could also just edit one of the existing exporters
-- Could be named and added as a new exporter in the config if its useful enough
local Exporter = Class(function(self, inst)
	self.inst = inst
	self.output = nil
end,
nil)

function Exporter:SetOutput(outputter)
	self.output = outputter
	-- List all the columns you want, in the correct order
	self.output:setFields({
		"user id",
		"user name",
		"item name",
		"item prefab",
	})
end


-- worldstate.lua has a lot of variables that could be saved on the record
-- e.g. TheWorld.state.cycles, TheWorld.state.time, TheWorld.state.phase, TheWorld.state.timeinphase,
-- Some options for giver: GUID, name, userid (KU_), playercolour {r, g, b, a}
-- Some options for item: name, prefab, spawntime
-- item.components.edible:GetHunger()/GetHealth()/GetSanity(), fuel.fuelvalue, eater.hunger?
-- perishable.spoiled_health, perishable.spoiled_hunger, perishable.stale_health, perishable.stale_hunger
-- perishable:GetPercent(), perishable:IsFresh(), perishable:IsStale(), perishable:IsSpoiled()
-- if using factions, access the team name with giver.components.faction.table.name

function colour01to255(value)
	return math.floor((value*255)+0.5)
end

-- `OnAcceptItem()` triggered when `AcceptTest()` returns true, meaning the item was taken from the player
function Exporter:OnAcceptItem(inst, giver, item)
	-- Basic example values
	self.output:addEntry({
		["user id"] = giver.userid,
		["user name"] = giver.name,
		["item name"] = item.name,
		["item prefab"] = item.prefab,
	})
	-- Call one of these if you want to say something
	-- inst.components.talker:Say(item.name.." Accepted!")
	-- TheNet:Announce(giver.name.." has submitted "..item.name.."!")
	-- (you should also disable the default message in the companion mod settings)
	return;
end

-- `OnRefuseItem()` triggered when `AcceptTest()` returns false
function Exporter:OnRefuseItem(inst, giver, item)
	return;
end

-- `AbleToAcceptTest()` prevents the player from clicking with the item
-- e.g. the pig king returns false here when it is sleeping
function Exporter:AbleToAcceptTest(inst, item, giver)
	return true
end

-- `AcceptTest()` lets the player click but doesn't take the item (triggers `OnRefuseItem()`)
-- e.g. this causes the pig king to shake his head
-- e.g. return item.components.tradable.goldvalue > 0
function Exporter:AcceptTest(inst, item, giver)
	-- put any logic you want here and return true for any items that are acceptable
	return true
end

return Exporter

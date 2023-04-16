local Exporter = Class(function(self, inst)
	self.inst = inst
	self.output = nil
end,
nil)

function Exporter:SetOutput(outputter)
	self.output = outputter
	-- day = the worlds day number (integer)
	-- time = the time of day (number between 0 and 1)
	-- phase = "day" or "night" or "dusk"
	-- time in phase = number between 0 and 1
	-- user id = unique user identifier of the format "KU_etc"
	-- user name = the users displayed name
	-- player colour = rgba colour formatted like (r, g, b, a) (converted from 0 to 1 format to 0 to 255 format)
	-- item name = the display name for the item e.g. "Cut Grass"
	-- item prefab = the prefab name for the item e.g. "cutgrass"
	-- perishable percentage = number between 0 and 1 where 1 is fresh and 0 is rotten (nil means not food)
	-- perishable state = "fresh" or "stale" or "spoiled" (nil means not food)
	self.output:setFields({
		"user id",
		"user name",
		"team",
		"item name",
		"item prefab",
		"perishable percentage",
		"perishable state",
		"hunger value",
		"health value",
		"sanity value",
	})
end


-- worldstate.lua has a lot of variables that could be saved on the record
-- Some options for giver: GUID, name, userid (KU_), playercolour {r, g, b, a}
-- Some options for item: name, prefab, spawntime
-- edible.hungervalue, fuel.fuelvalue, eater.hunger?
-- perishable.spoiled_health, perishable.spoiled_hunger, perishable.stale_health, perishable.stale_hunger
-- perishable:GetPercent(), perishable:IsFresh(), perishable:IsStale(), perishable:IsSpoiled()


-- OMNI food group is the one that most player characters eat
function isOMNI(foodType)
	for index, value in ipairs(FOODGROUP.OMNI.types) do
		if value == foodType then
			return true
		end
	end
	return false;
end


-- `OnAcceptItem()` triggered when `AcceptTest()` returns true, meaning the item was taken from the player
function Exporter:OnAcceptItem(inst, giver, item)
	local perishablePercentage = nil
	local perishableState = nil
	local hungerValue = nil
	local healthValue = nil
	local sanityValue = nil
	if item.components.perishable then
		perishablePercentage = item.components.perishable:GetPercent()
		if item.components.perishable:IsFresh() then
			perishableState = "fresh"
		elseif item.components.perishable:IsStale() then
			perishableState = "stale"
		elseif item.components.perishable:IsSpoiled() then
			perishableState = "spoiled"
		end
	end
	if item.components.edible and isOMNI(item.components.edible.foodtype) then
		-- Don't pass giver to these functions because we want the base stats
		hungerValue = item.components.edible:GetHunger()
		healthValue = item.components.edible:GetHealth()
		sanityValue = item.components.edible:GetSanity()
	end

	self.output:addEntry({
		["user id"] = giver.userid,
		["user name"] = giver.name,
		["team"] = giver.components.faction and giver.components.faction.table.name,
		["item name"] = item.name,
		["item prefab"] = item.prefab,
		["perishable percentage"] = perishablePercentage,
		["perishable state"] = perishableState,
		["hunger value"] = hungerValue,
		["health value"] = healthValue,
		["sanity value"] = sanityValue,
	})
	return;
end

-- `OnRefuseItem()` triggered when `AcceptTest()` returns false
function Exporter:OnRefuseItem(inst, giver, item)
	return;
end

-- `AbleToAcceptTest()` prevents the player from clicking with the item
-- e.g. the pig king returns false here when it is sleeping
function Exporter:AbleToAcceptTest(inst, item, giver)
	-- always accept
	return true
end

-- `AcceptTest()` lets the player click but doesn't take the item (triggers `OnRefuseItem()`)
-- e.g. this causes the pig king to shake his head
-- e.g. return item.components.tradable.goldvalue > 0
function Exporter:AcceptTest(inst, item, giver)
	return item.components.edible and isOMNI(item.components.edible.foodtype)
end

return Exporter

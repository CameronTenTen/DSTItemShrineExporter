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
		"day",
		"time",
		"phase",
		"time in phase",
		"user id",
		"user name",
		"player colour",
		"team",
		"item name",
		"item prefab",
		"perishable percentage",
		"perishable state"
	})
end

function colour01to255(value)
	return math.floor((value*255)+0.5)
end

-- `OnAcceptItem()` triggered when `AcceptTest()` returns true, meaning the item was taken from the player
function Exporter:OnAcceptItem(inst, giver, item)
	local perishablePercentage = nil
	local perishableState = nil
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

	self.output:addEntry({
		["day"] = TheWorld.state.cycles,
		["time"] = TheWorld.state.time,
		["phase"] = TheWorld.state.phase,
		["time in phase"] = TheWorld.state.timeinphase,
		["user id"] = giver.userid,
		["user name"] = giver.name,
		-- giver colour format is (r, g, b, a)? (values between 0 and 1), I convert it to rgba (0 to 255)
		["player colour"] = "("..colour01to255(giver.playercolour[1])..", "..colour01to255(giver.playercolour[2])..", "..colour01to255(giver.playercolour[3])..", "..colour01to255(giver.playercolour[4])..")",
		["team"] = giver.components.faction and giver.components.faction.table.name,
		["item name"] = item.name,
		["item prefab"] = item.prefab,
		["perishable percentage"] = perishablePercentage,
		["perishable state"] = perishableState
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
	-- accept anything
	return true
end

return Exporter

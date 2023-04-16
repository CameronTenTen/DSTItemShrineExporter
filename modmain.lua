-- local modname = KnownModIndex:GetModActualName("Item Submission Exporter")
local EXPORTER_TYPE = GetModConfigData("EXPORTER_TYPE")

-- how am I supposed to run something once when the server starts?
-- runs twice
local file = nil
-- runs twice
-- AddGamePostInit(function (inst)
-- too late
-- AddSimPostInit(function (inst)
-- runs on both cave and overworld
-- AddPrefabPostInit("world", function (inst)
-- this is the best so far
AddPrefabPostInit("forest_network", function (inst)
	if GLOBAL.TheWorld.ismastersim then
		-- if we want to create a new file on startup each time, use GLOBAL.os.time()
		-- GLOBAL.TheWorld.GUID is the same each time the server starts, but CSVOutputter doesn't support append
		-- could also create a new file for each shrine
		-- file = require "CSVOutputter"("itemlog"..GLOBAL.TheWorld.GUID..".csv", false)
		file = require "CSVOutputter"("../mods/itemlog"..GLOBAL.os.time()..".csv", false)
	end
end)

AddPrefabPostInit("scorershrine", function (inst)
	-- output file only on the master (trader is only on master too)
	if GLOBAL.TheWorld.ismastersim then
		-- inst.GUID - changes each time the game starts
		inst:AddComponent("exporters/"..EXPORTER_TYPE)
		inst.components["exporters/"..EXPORTER_TYPE]:SetOutput(file)
		-- hook up the trader to the exporter
		inst.components.trader:SetAbleToAcceptTest(function(...)
			return inst.components["exporters/"..EXPORTER_TYPE]:AbleToAcceptTest(...)
		end)
		inst.components.trader:SetAcceptTest(function(...)
			return inst.components["exporters/"..EXPORTER_TYPE]:AcceptTest(...)
		end)
		local onacceptOld = inst.components.trader.onaccept
		inst.components.trader.onaccept = function(...)
			onacceptOld(...)
			inst.components["exporters/"..EXPORTER_TYPE]:OnAcceptItem(...)
		end
		local onrefuseOld = inst.components.trader.onrefuse
		inst.components.trader.onrefuse = function(...)
			onrefuseOld(...)
			inst.components["exporters/"..EXPORTER_TYPE]:OnRefuseItem(...)
		end
	end
end)

name = "Item Submission Exporter"
description = [[
Hooks into the "Item Submission Shrine" mod.
Provides the interface between that mod and the file output.
This part of the mod is server only.
Which allows for it to be modified without sharing the scripts with clients.
]]
author = "camerontenten"
version = "0.1"
forumthread = ""
api_version_dst = 10
all_clients_require_mod = false
client_only_mod = false
dst_compatible = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {"Competition", "Scorer"}

-- recorder, outputter, saver, logger, tracker, exporter

-- add configuration option for 1 file per world vs per entity?
-- instead of outputting to file we could save to memory and have a scoreboard and end game condition
-- more preconfigured outputters

configuration_options =
{
	{
		name = "EXPORTER_TYPE",
		label = "Exporter Type",
		hover = "There are several presets for the output format, or a custom script can be provided",
		options =
		{
			{description = "All", data = "all"},
			{description = "Basic Food", data = "foodbasic"},
			-- TODO: other preconfigured outputters
			-- {description = "Food Points", data = "foodpoints"},
			-- {description = "Basic Fish", data = "fishbasic"},
			{description = "Custom", data = "custom"},
		},
		default = "all"
	},
}

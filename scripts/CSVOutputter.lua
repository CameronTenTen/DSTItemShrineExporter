
-- TODO: add configuration options, e.g. delimiter, append

-- Initialises the csv file
-- After creation columns should be set with `self:setColumns(columns)`
-- filename: string file to save to, can be a path
return Class(function(self, filename)

	-- initialise the file based on the content of the first row?
	self.file = io.open(filename, "w")
	self.inferColumns = true

	-- Add the column headers in the order provided
	-- If not provided, the headers will be inferred from the content of the first row added
	-- Note: Inferred columns wont be in the expected order
	-- columns: array of column names(e.g. {"day", "time", "phase", "time in phase"})
	function self:setFields(columns)
		self.inferColumns = false
		self.columnNames = columns
		self.file:write(table.concat(self.columnNames,", "), "\n")
	end

	-- any table entries with keys that dont exist in the column name list wont be added to the file
	-- record: object where the keys are the column names, and the values are the data for the new row
	function self:addEntry(record)
		if self.inferColumns then
			-- use the first row to infer column headers
			self.inferColumns = false
			self.columnNames = {}
			for columnName, _ in pairs(record) do
				table.insert(self.columnNames, columnName)
			end
			self.file:write(table.concat(self.columnNames,", "), "\n")
		end
		-- TODO: error check, throw if any of the keys in the row aren't a column name (maybe even created "required" fields and type checks)
		-- Create a map of column name to random value (or type info) when columns are added
		-- Loop over the new row pairs and check that each of them exist in the map
		-- Loop over the map to check that the requirements for each field are met
		local row = {}
		-- add each column value to the row in the provided columnName order
		for _, columnName in ipairs(self.columnNames) do
			local value = record[columnName]
			if record[columnName] == nil then
				-- add empty strings instead of nils to maintain column order
				table.insert(row, "")
			else
				-- add quotes, in case the value contains a comma (could change it to only add quotes when a comma exists)
				table.insert(row, "\""..record[columnName].."\"")
			end
		end
		self.file:write(table.concat(row,", "), "\n")
		-- TODO: do we need to flush?
	end

	-- Cleanup, just closes the file?
	function self:cleanup()
		self.file:close()
	end


end)



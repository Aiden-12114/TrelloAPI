--[[
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????


		----------------------------------------------------------------------
]]
local TrelloAPI = {}
local HTTPService = game:GetService("HttpService")

function TrelloAPI:Init(key, token)
	local MainTrelloAPI = {}
	print("Initiating Trello API")

	function getAddon()
		local addon
		addon = "?key=" .. key .. "&token=" .. token
		return addon
	end

	function MainTrelloAPI:GetBoard(id)
		local JSON
		local addon = getAddon()

		local success, fail =
			pcall(
				function()
				JSON = HTTPService:GetAsync("https://api.trello.com/1/boards/" .. id .. "" .. addon)
			end
			)

		if success then
			print("Successfully Got Board")
			local DecodedData = HTTPService:JSONDecode(JSON)
			return DecodedData.id
		else
			error("Trello API Fatal Error: " .. fail)
		end
	end

	function MainTrelloAPI:CreateList(name, id)
		local addon = getAddon()
		local Return

		if name == nil or id == nil then
			error("Invalid Arguments")
			return nil
		else
			local PreData = {name = name, idBoard = id}
			local Data = HTTPService:JSONEncode(PreData)

			local success, fail =
				pcall(
					function()
					Return = HTTPService:PostAsync("https://api.trello.com/1/boards/" .. id .. "/lists" .. addon, Data)
				end
				)

			if success then
				print("Successfully Created List")
				local ReturnDecoded = HTTPService:JSONDecode(Return)
				return ReturnDecoded.id
			else
				error("Trello API Fatal Error: " .. fail)
			end
		end
	end

	function MainTrelloAPI:GetListID(name, boardid)
		local addon = getAddon()
		local Data

		if name == nil or boardid == nil then
			error("Invalid Arguments!")
		else
			local success, fail =
				pcall(
					function()
					Data =
						HTTPService:GetAsync(
							"https://api.trello.com/1/boards/" .. boardid .. "/lists" .. addon .. "&value=true"
						)
				end
				)

			if success then
				print("Successfully Got List")
				local DecodedData = HTTPService:JSONDecode(Data)
				for _, tab in pairs(DecodedData) do
					for _, v in pairs(tab) do
						if tab.name == name then
							return tab.id
						end
					end
				end
			else
				error("Trello API Fatal Error: " .. fail)
			end
		end
	end

	function MainTrelloAPI:GetListInfo(name, boardid)
		local addon = getAddon()
		local Data

		if name == nil or boardid == nil then
			error("Invalid Arguments!")
		else
			local success, fail =
				pcall(
					function()
					Data =
						HTTPService:GetAsync(
							"https://api.trello.com/1/boards/" .. boardid .. "/lists" .. addon .. "&value=true"
						)
				end
				)

			if success then
				print("Successfully Got List Info")
				local DecodedData = HTTPService:JSONDecode(Data)
				for _, tab in pairs(DecodedData) do
					for _, v in pairs(tab) do
						if tab.name == name then
							return tab.body
						end
					end
				end
			else
				error("Trello API Fatal Error: " .. fail)
			end
		end
	end

	function MainTrelloAPI:CreateCard(name, desc, id)
		local addon = getAddon()
		local Return

		if name == nil or id == nil or desc == nil then
			error("Invalid Arguments")
		end

		local PreData = {name = name, desc = desc, idList = id}
		local Data = HTTPService:JSONEncode(PreData)

		local success, fail =
			pcall(
				function()
				Return = HTTPService:PostAsync("https://api.trello.com/1/cards/" .. addon, Data)
			end
			)

		if success then
			print("Successfully Created Card")
			local ReturnDecoded = HTTPService:JSONDecode(Return)
			return ReturnDecoded.id
		else
			error("Trello API Fatal Error: " .. fail)
		end
	end

	function MainTrelloAPI:GetCardInfo(id)
		local addon = getAddon()
		local Return

		local success, fail =
			pcall(
				function()
				Return = HTTPService:GetAsync("https://api.trello.com/1/cards/" .. id .. addon)
			end
			)

		local Decode = HTTPService:JSONDecode(Return)
		return Decode
	end

	function MainTrelloAPI:DeleteCard(id)
		local Return

		if id == nil then
			error("Invalid Arguments")
		end

		local Data = "?cardid=" .. id .. "&token=" .. token .. "&key=" .. key

		local success, fail =
			pcall(
				function()
				Return =
					HTTPService:RequestAsync(
						{
							Url = "https://api.trello.com/1/cards/" .. id .. Data,
							Method = "DELETE",
							Body = Data
						}
					)
			end
			)

		if success then
			print("Successfully Deleted Card")
		else
			error("Trello API Fatal Error: " .. fail)
		end
	end

	function MainTrelloAPI:ArchiveList(listid)
		local addon = getAddon()

		local PreData = {id = listid}
		local Data = HTTPService:JSONEncode(PreData)

		local success, fail =
			pcall(
				function()
				HTTPService:RequestAsync(
					{
						Url = "https://api.trello.com/1/lists/" .. listid .. "/closed" .. addon .. "&value=true",
						Method = "PUT",
						Body = Data
					}
				)
			end
			)

		if success then
			print("Successfully Archived List")
		else
			error("Trello API Fatal Error: " .. fail)
		end
	end

	return MainTrelloAPI
end

return TrelloAPI

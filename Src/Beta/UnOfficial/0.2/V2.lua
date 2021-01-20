--[[

        ████████╗██████╗░███████╗██╗░░░░░██╗░░░░░░█████╗░  ░█████╗░██████╗░██╗
        ╚══██╔══╝██╔══██╗██╔════╝██║░░░░░██║░░░░░██╔══██╗  ██╔══██╗██╔══██╗██║
        ░░░██║░░░██████╔╝█████╗░░██║░░░░░██║░░░░░██║░░██║  ███████║██████╔╝██║
        ░░░██║░░░██╔══██╗██╔══╝░░██║░░░░░██║░░░░░██║░░██║  ██╔══██║██╔═══╝░██║
        ░░░██║░░░██║░░██║███████╗███████╗███████╗╚█████╔╝  ██║░░██║██║░░░░░██║
        ░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝░╚════╝░  ╚═╝░░╚═╝╚═╝░░░░░╚═╝

        NOTE: UnOfficial Build
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

		assert(id, "Invalid Arguments")

		local success, fail =
			pcall(
				function()
				JSON = HTTPService:GetAsync("https://api.trello.com/1/boards/" .. id .. "" .. addon)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Got Board")
		local DecodedData = HTTPService:JSONDecode(JSON)
		return DecodedData.id
	end

	function MainTrelloAPI:CreateList(name, id)
		local addon = getAddon()
		local Return

		assert(name and id, "Invalid Arguments")

		local PreData = {name = name, idBoard = id}
		local Data = HTTPService:JSONEncode(PreData)

		local success, fail =
			pcall(
				function()
				Return = HTTPService:PostAsync("https://api.trello.com/1/boards/" .. id .. "/lists" .. addon, Data)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Created List")
		local ReturnDecoded = HTTPService:JSONDecode(Return)
		return ReturnDecoded.id
	end

	function MainTrelloAPI:GetListID(name, boardid)
		local addon = getAddon()
		local Data

		assert(name and boardid, "Invalid Arguments!")

		local success, fail =
			pcall(
				function()
				Data =
					HTTPService:GetAsync(
						"https://api.trello.com/1/boards/" .. boardid .. "/lists" .. addon .. "&value=true"
					)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Got List")
		local DecodedData = HTTPService:JSONDecode(Data)
		for _, tab in pairs(DecodedData) do
			for _, v in pairs(tab) do
				if tab.name == name then
					return tab.id
				end
			end
		end
	end

	function MainTrelloAPI:GetListInfo(name, boardid)
		local addon = getAddon()
		local Data

		assert(name and boardid, "Invalid Arguments!")

		local success, fail =
			pcall(
				function()
				Data =
					HTTPService:GetAsync(
						"https://api.trello.com/1/boards/" .. boardid .. "/lists" .. addon .. "&value=true"
					)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Got List Info")
		local DecodedData = HTTPService:JSONDecode(Data)
		for _, tab in pairs(DecodedData) do
			for _, v in pairs(tab) do
				if tab.name == name then
					return tab.body
				end
			end
		end
	end

	function MainTrelloAPI:CreateCard(name, desc, id)
		local addon = getAddon()
		local Return

		assert(name and desc and id, "Invalid Arguments")

		local PreData = {name = name, desc = desc, idList = id}
		local Data = HTTPService:JSONEncode(PreData)

		local success, fail =
			pcall(
				function()
				Return = HTTPService:PostAsync("https://api.trello.com/1/cards/" .. addon, Data)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Created Card")
		local ReturnDecoded = HTTPService:JSONDecode(Return)
		return ReturnDecoded.id
	end

	function MainTrelloAPI:GetCardInfo(id)
		local addon = getAddon()
		local Return

		assert(id, "Invalid Arguments")

		local success, fail =
			pcall(
				function()
				Return = HTTPService:GetAsync("https://api.trello.com/1/cards/" .. id .. addon)
			end
			)

		assert(success, "Trello API Fatal Error: " .. fail)

		local Decode = HTTPService:JSONDecode(Return)
		return Decode
	end

	function MainTrelloAPI:DeleteCard(id)
		local Return

		assert(id, "Invalid Arguments")

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

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Deleted Card")
	end

	function MainTrelloAPI:ArchiveList(listid)
		local addon = getAddon()

		assert(listid, "Invalid Arguments")

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

		assert(success, "Trello API Fatal Error: " .. fail)

		print("Successfully Archived List")
	end

	return MainTrelloAPI
end

return TrelloAPI
--[[
		████████╗██████╗░███████╗██╗░░░░░██╗░░░░░░█████╗░  ░█████╗░██████╗░██╗
		╚══██╔══╝██╔══██╗██╔════╝██║░░░░░██║░░░░░██╔══██╗  ██╔══██╗██╔══██╗██║
		░░░██║░░░██████╔╝█████╗░░██║░░░░░██║░░░░░██║░░██║  ███████║██████╔╝██║
		░░░██║░░░██╔══██╗██╔══╝░░██║░░░░░██║░░░░░██║░░██║  ██╔══██║██╔═══╝░██║
		░░░██║░░░██║░░██║███████╗███████╗███████╗╚█████╔╝  ██║░░██║██║░░░░░██║
		░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝░╚════╝░  ╚═╝░░╚═╝╚═╝░░░░░╚═╝


		----------------------------------------------------------------------
]]








local TrelloAPI = {}
local HTTPService = game:GetService("HttpService")

function TrelloAPI:Init(key, token)
	local MainTrelloAPI = {}
	print("Initiating Trello API")
	
	function getAddon()
		local addon
		addon = "?key="..key.."&token="..token
		return addon
	end
	
	function MainTrelloAPI:GetBoard(id)
		local JSON
		local addon = getAddon()
		
		local success, fail = pcall(function()
			JSON = HTTPService:GetAsync("https://api.trello.com/1/boards/"..id..''..addon)
		end)
		
		if success then
			print("Successfully Got Board")
			local DecodedData = HTTPService:JSONDecode(JSON)
			return DecodedData.id
		else
			error("Trello API Fatal Error: "..fail)
		end
	end
	
	function MainTrelloAPI:CreateList(name, id)
		local addon = getAddon()
		local Return
		
		if name == nil or id == nil then
			error("Invalid Arguments")
			return nil
			
		else
			
			local PreData = {name=name, idBoard=id}
			local Data = HTTPService:JSONEncode(PreData)
			
			local success, fail = pcall(function()
				Return = HTTPService:PostAsync("https://api.trello.com/1/boards/"..id.."/lists"..addon, Data)
			end)
			
			if success then
				print("Successfully Created List")
				local ReturnDecoded = HTTPService:JSONDecode(Return)
				return ReturnDecoded.id
			else
				error("Trello API Fatal Error: "..fail)
			end
		end
	end
	
	function MainTrelloAPI:CreateCard(name, desc, id)
		local addon = getAddon()
		local Return
		
		if name == nil or id == nil or desc == nil then
			error("Invalid Arguments")
		end
		
		local PreData = {name=name, desc=desc, idList=id}
		local Data = HTTPService:JSONEncode(PreData)
		
		local success, fail = pcall(function()
			Return = HTTPService:PostAsync("https://api.trello.com/1/cards/"..addon, Data)
		end)

		if success then
			print("Successfully Created Card")
			local ReturnDecoded = HTTPService:JSONDecode(Return)
			return ReturnDecoded.id
		else
			error("Trello API Fatal Error: "..fail)
		end
	end
	
	function MainTrelloAPI:DeleteCard(id)
		local Return
		
		if id == nil then
			error("Invalid Arguments")
		end
		
		local Data = "?cardid="..id.."&token="..token.."&key="..key
		
		local success, fail = pcall(function()
			Return = HTTPService:RequestAsync(
				{
					Url = "https://api.trello.com/1/cards/"..id..Data,
					Method = "DELETE",
					Body = Data
				}
			)
		end)
		
		if success then
			print("Successfully Deleted Card")
		else
			error("Trello API Fatal Error: "..fail)
		end
	end	
	
	return MainTrelloAPI
end

return TrelloAPI
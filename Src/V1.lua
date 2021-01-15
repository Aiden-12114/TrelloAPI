--[[
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????
		??????????????????????????????????????????????????????????????????????


		----------------------------------------------------------------------

	Available Functions:

	TrelloAPI:GetBoard(BoardID) -- The difference between :GetBoardID and :GetBoard is that :GetBoard uses an ID and :GetBoardID gets the Board's ID.

	TrelloAPI:GetBoardID(BoardName) -- Get the Board's name.
	
	TrelloAPI:CreateList(ListName, BoardID) -- Create a list with 2 arguments. The first argument is the List's name and the second one is the Board's ID.
	
	TrelloAPI:GetListID(ListName) -- Get an existing list's ID.
	
	TrelloAPI:CreateCard(CardName, CardDesc, ListID) -- Create a new card with a name, description and listid.

	TrelloAPI:RemoveList(ListID) -- Archive/remove a list from the board.

	TrelloAPI:DeleteCard(CardID) -- Delete a card from a list.
]]








local TrelloAPI = {}
local HTTPService = game:GetService("HttpService")
local Key = script.Key.Value
local Token = script.Token.Value

script.Key:Destroy()
script.Token:Destroy()

function getAddon()
	local addon
	addon = "?key="..Key.."&token="..Token
	return addon
end

function TrelloAPI:GetBoard(boardId)
	local addon = getAddon()
	local JSON = HTTPService:GetAsync("https://api.trello.com/1/boards/"..boardId..''..addon)
	local DecodedData = HTTPService:JSONDecode(JSON)
	return DecodedData.name
end

function TrelloAPI:GetBoardID(name)
	local addon = getAddon()
	local JSON = HTTPService:GetAsync("https://api.trello.com/1/members/me/boards"..addon)
	local DecodedData = HTTPService:JSONDecode(JSON)
	if name ~= nil then
			for _,tab in pairs(DecodedData) do
			for _,v in pairs(tab) do
				if tab.name == name then
					return tab.id
				end
			end
		end
		error(name.." Was Not Found!")
		return nil
	end
end

function TrelloAPI:CreateList(name, boardid)
	local addon = getAddon()
	if name == nil or boardid == nil then
		error('Invalid Arguments!')
		return nil
	else
		local data = {name=name,idBoard=boardid}
		local EncodedData = HTTPService:JSONEncode(data)
		local Return = HTTPService:PostAsync("https://api.trello.com/1/lists"..addon.."&name="..name.."&idBoard="..boardid, EncodedData)
		local ReturnDecoded = HTTPService:JSONDecode(Return)
		return ReturnDecoded.id
	end
end

function TrelloAPI:GetListID(name, boardid)
	local addon = getAddon()
	if name == nil or boardid == nil then
		error('Invalid Arguments!')
		return nil
	else
		local Data = HTTPService:GetAsync("https://api.trello.com/1/boards/"..boardid.."/lists"..addon.."&value=true")
		local DecodedData = HTTPService:JSONDecode(Data)
		for _,tab in pairs(DecodedData) do
			for _,v in pairs(tab) do
				if tab.name == name then
					return tab.id
				end
			end
		end
	end
end

function TrelloAPI:CreateCard(name, desc, listid)
	local addon = getAddon()
	if name == nil or desc == nil or listid == nil then
		error('Invalid Arguments!')
		return nil
	else
		local data = {name=name, desc=desc, idList=listid}
		local dataencoded = HTTPService:JSONEncode(data)
		local Return = HTTPService:PostAsync("https://api.trello.com/1/cards"..addon.."&name="..name.."&desc="..desc.."&idList="..listid, dataencoded)
		local ReturnDecoded = HTTPService:JSONDecode(Return)
		return ReturnDecoded.id
	end
end

function TrelloAPI:RemoveList(listid)
	local addon = getAddon()
	if addon == nil then
		error('Invalid Arguments!')
		return nil
	else
		local data = {id=listid}
		local EncodedData = HTTPService:JSONEncode(data)
		HTTPService:RequestAsync({
			Url = "https://api.trello.com/1/lists/"..listid.."/closed"..addon.."&value=true",
			Method = "PUT",
			Body = EncodedData
		})
	end
end

function TrelloAPI:DeleteCard(cardid)
		local addon = getAddon()
	if addon == nil then
		error('Invalid Arguments!')
		return nil
	else
		local data = {id=cardid}
		local EncodedData = HTTPService:JSONEncode(data)
		HTTPService:RequestAsync({
			Url = "https://api.trello.com/1/cards/"..cardid..addon,
			Method = "DELETE",
			Body = EncodedData
		})
	end
end

return TrelloAPI
-- Feel free to use this library --
-- but do not modify without sending a pm to me (votan at www.esoui.com) to avoid version conflicts --

-- Register with LibStub
local MAJOR, MINOR = "LibAlchemyStation", 2
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end -- the same or newer version of this lib is already loaded into memory

local function HideOtherTabs(tab)
	local content = lib.content
	for i = 1, content:GetNumChildren() do
		local child = content:GetChild(i)
		child:SetHidden(child ~= tab)
	end
end

local function InitStationButton()
	local buttonData = ALCHEMY.modeBar.m_object:ButtonObjectForDescriptor(nil).m_buttonData
	local orgCallback = buttonData.callback
	local function AlchemySelectTab(...)
		orgCallback(...)
		HideOtherTabs(ZO_AlchemyTopLevelInventory)
	end
	buttonData.callback = AlchemySelectTab
end

function lib:Init()
	if not lib.content then
		local content = WINDOW_MANAGER:CreateControl("$(parent)Content", ZO_AlchemyTopLevel, CT_CONTROL)
		content:SetExcludeFromResizeToFitExtents(true)
		content:SetWidth(568)
		content:SetAnchor(TOPLEFT, ZO_SharedRightPanelBackground, TOPLEFT, 0, 67)
		content:SetAnchor(BOTTOMLEFT, ZO_SharedRightPanelBackground, BOTTOMLEFT, 0, -30)
		lib.content = content

		ZO_AlchemyTopLevelInventory:SetParent(content)
		InitStationButton()
	end
end

function lib:AddTab(tabData)
	local name = tabData.name
	local control = WINDOW_MANAGER:CreateControl("$(grandparent)" .. tabData.descriptor, lib.content, CT_CONTROL)
	control:SetAnchorFill()

	local creationData = {
		activeTabText = name,
		categoryName = name,
		descriptor = tabData.descriptor,
		normal = tabData.normal,
		pressed = tabData.pressed,
		highlight = tabData.highlight,
		disabled = tabData.disabled,
		callback = function(...)
			lib:SetText(GetString(name))
			HideOtherTabs(control)
			if tabData.callback then tabData.callback(...) end
		end,
	}
	ZO_MenuBar_AddButton(ALCHEMY.modeBar, creationData)
	return control
end

function lib:SelectTab(descriptor)
	ZO_MenuBar_SelectDescriptor(ALCHEMY.modeBar, descriptor, false)
end

function lib:GetSelectedTab()
	return ZO_MenuBar_GetSelectedDescriptor(ALCHEMY.modeBar)
end

function lib:SetText(text)
	ALCHEMY.modeBarLabel:SetText(text)
end

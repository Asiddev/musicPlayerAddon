local soundType = {

    CUSTOM = 3
}

-- local sounds = {
--     ["4"] = {
--         ["sound"] = "Interface\\AddOns\\musicChode\\Sounds\\custom3_filicias_dubstep.mp3",
--         ["description"] = "K-391 - This Is Felicitas!",
--         ["type"] = soundType.CUSTOM
--     },
--     ["3"] = {
--         ["sound"] = "Interface\\AddOns\\musicChode\\Sounds\\custom4_PSY_or_DIE.mp3",
--         ["description"] = "Carnage x Timmy Trumpet - PSY or DIE",
--         ["type"] = soundType.CUSTOM
--     },
--     ["2"] = {
--         ["sound"] = "Interface\\AddOns\\musicChode\\Sounds\\custom2_becoming_insane.mp3",
--         ["description"] = "Becoming Insane",
--         ["type"] = soundType.CUSTOM
--     },
--     ["1"] = {
--         ["sound"] = "Interface\\AddOns\\musicChode\\Sounds\\custom1.mp3",
--         ["description"] = "Lee Mvtthews - Dice (ft. Rachel Leo)",
--         ["type"] = soundType.CUSTOM
--     },
-- }

-- Initialize the SavedVariable table if it doesn't exist
SavedChodeyPlayerMusic = SavedChodeyPlayerMusic or {}


-- Function to be called when the addon is loaded
local function OnAddonLoaded()
    sounds = SavedChodeyPlayerMusic
    print("Addon loaded. Current SavedChodeyPlayerMusic contents:")
    for label, soundData in pairs(sounds) do
        print("Label:", label, "Description:", soundData.description, "sound", soundData.sound)
        -- You can now directly assign your sounds object to use the SavedVariable
       
    end
end

-- Event frame to handle addon loading
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "musicChode" then
        OnAddonLoaded()
    end
end)

local function displaySoundList()
    print("----------------------------")
    for command in pairs(sounds) do
        local description = sounds[command].description
        print("Command: /playsound " .. command .. " - Description: " .. description)
    end
    print("----------------------------")
end



local customSoundId;

local function stopSoundHandler()
    StopMusic()
  
    if(customSoundId ~= nil) then
        StopSound(customSoundId)
        customSoundId = nil
    end
  end


local function playTrack(track)
  print(track.type)
  print(track.description)

  if(track.type == soundType.GAME_MUSIC) then
      PlayMusic(track.sound)

      print("To stop the music type /stopsound")
  elseif(track.type == soundType.SOUND) then
      PlaySound(track.sound)
  elseif(track.type == soundType.CUSTOM) then
      stopSoundHandler()
      customSoundId = select(2, PlaySoundFile(track.sound))
  end
end

local function playSoundHandler(trackId)
    stopSoundHandler()
  if(string.len(trackId) > 0) then
      local hasTrack = sounds[trackId] ~= nil

      if (hasTrack) then
          local track = sounds[trackId]
          
          playTrack(track)
      else
          displaySoundList()
          
          print(trackId .. " - Doesn't match a known track.")
      end
  else
      displaySoundList()
  end
end

local function ToggleMusicLibraryFrame()
    if MusicLibraryFrame:IsShown() then
        MusicLibraryFrame:Hide()
    else
        MusicLibraryFrame:Show()
    end
end

local function ToggleAddNewSong()
    if NewSoundInputFrame:IsShown() then
        NewSoundInputFrame:Hide()
    else
        NewSoundInputFrame:Show()
    end
end



-- Create the main frame
local frame = CreateFrame("Frame", "MusicLibraryFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 125) -- Initial size
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("TOP", frame, "TOP", 0, -5)
frame.title:SetText("Chodey's Music Player")

-- Create a "Plus" button
local plusButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
plusButton:SetSize(20, 20) -- width, height
plusButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -42, -30) -- position in the top right corner
plusButton:SetText("+") -- set the text to a plus symbol
plusButton:SetNormalFontObject("GameFontNormal")
plusButton:SetHighlightFontObject("GameFontHighlight")

-- Define the OnClick script for the plus button
plusButton:SetScript("OnClick", ToggleAddNewSong)

-- Create a texture for the magnifying glass icon
local magnifyingGlassIcon = frame:CreateTexture(nil, "OVERLAY")
magnifyingGlassIcon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_03") -- Path to your icon
magnifyingGlassIcon:SetSize(16, 16) -- Width and height of the icon

-- Position the icon
-- Adjust the coordinates (-10, -10) as needed to position the icon in the top right corner
magnifyingGlassIcon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -259, -33)

magnifyingGlassIcon:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT") -- Position the tooltip
    GameTooltip:SetText("Filter Dropdown Box") -- Set the tooltip text
    GameTooltip:Show() -- Show the tooltip
end)

magnifyingGlassIcon:SetScript("OnLeave", function(self)
    GameTooltip:Hide() -- Hide the tooltip
end)


-- Create a minimap button
local minimapButton = CreateFrame("Button", "MusicLibraryMinimapButton", Minimap)
minimapButton:SetSize(20,20) -- Button size
minimapButton:SetFrameLevel(8)
minimapButton:SetScript("OnClick", ToggleMusicLibraryFrame)


local angle = 0  -- 0 degrees, at the top of the minimap
local radius = 65 -- Close to the edge of the default minimap
minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (radius * cos(angle)), (radius * sin(angle)) - 52)
minimapButton:SetScript("OnClick", ToggleMusicLibraryFrame)
-- Set the icon texture with a round border or background
minimapButton:SetNormalTexture("Interface\\Icons\\inv_misc_drum_01")

-- Adjusting the texture to fit better
local texture = minimapButton:GetNormalTexture()
texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)  -- Crop the texture to make it more round





-- Register the /chodeyplayer command
SLASH_CHODEYPLAYER1 = "/chode"
SLASH_SOUND1 = "/playsound"
SLASH_STOPSOUND1 = "/stopsound"

SlashCmdList["CHODEYPLAYER"] = ToggleMusicLibraryFrame
SlashCmdList["SOUND"] = playSoundHandler;
SlashCmdList["STOPSOUND"] = stopSoundHandler;


-- Dropdown Menu for Sound Selection
local dropdown = CreateFrame("Frame", "MusicLibraryDropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOP", frame, "TOP", 0, -50)
UIDropDownMenu_SetWidth(dropdown, 200) -- Set the dropdown width to be almost as wide as the frame






local function UpdateDropdownMenu(searchQuery)
    UIDropDownMenu_ClearAll(MusicLibraryDropdown)
    UIDropDownMenu_Initialize(MusicLibraryDropdown, function(self, level, menuList)
        -- Set default dropdown text
        UIDropDownMenu_SetText(dropdown, "Select a Song")
        local info = UIDropDownMenu_CreateInfo()
        for id, sound in pairs(sounds) do
            if string.find(string.lower(sound.description), string.lower(searchQuery)) then
                info.text = sound.description
                info.arg1 = id
                info.func = function()
                    playSoundHandler(id)
                    UIDropDownMenu_SetText(MusicLibraryDropdown, sound.description)
                end
                UIDropDownMenu_AddButton(info)
            end
        end
    end)
end

-- Create an EditBox for the search input
local searchBox = CreateFrame("EditBox", "MusicLibrarySearchBox", frame, "InputBoxTemplate")
searchBox:SetSize(180, 20)
searchBox:SetPoint("TOP", frame, "TOP", -12, -30)
searchBox:SetAutoFocus(false)
searchBox:SetScript("OnTextChanged", function(self)
    local text = self:GetText()
    UpdateDropdownMenu(text)
end)




-- Create a "Stop" button
local stopButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
stopButton:SetSize(260, 30) -- width, height
stopButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10) -- position at the bottom
stopButton:SetText("Stop Music")
stopButton:SetNormalFontObject("GameFontNormal")
stopButton:SetHighlightFontObject("GameFontHighlight")
stopButton:SetScript("OnClick", stopSoundHandler)


-- Function to add a new sound
local function addNewSound(label, description)
    SavedChodeyPlayerMusic[label] = {
        sound = "Interface\\AddOns\\musicChode\\Sounds\\" .. label .. ".mp3",
        description = description,
        type = soundType.CUSTOM -- Assuming 'CUSTOM' is a valid type
    }
end

-- Create a frame for user input
local inputFrame = CreateFrame("Frame", "NewSoundInputFrame", UIParent, "BasicFrameTemplateWithInset")
inputFrame:SetSize(300, 150)
inputFrame:SetPoint("CENTER")
inputFrame:Hide()
inputFrame.title = frame:CreateFontString(nil, "OVERLAY")
inputFrame.title:SetFontObject("GameFontHighlight")
inputFrame.title:SetPoint("TOP", inputFrame, "TOP", 0, -5)
inputFrame.title:SetText("Add Song")
inputFrame.title:SetParent(inputFrame)

-- When closing the modal
local function CloseModal()
    addSongFrame:Hide() -- This will also hide all child elements, including the title
end

-- Song Label/MP3 Name Label
local songLabel = inputFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
songLabel:SetPoint("TOP", inputFrame, "TOP", 0, -20)
songLabel:SetText("Name of mp3 file (without .mp3)")

-- Song Label/MP3 Name Input
local labelInput = CreateFrame("EditBox", nil, inputFrame, "InputBoxTemplate")
labelInput:SetSize(180, 20)
labelInput:SetPoint("TOP", songLabel, "BOTTOM", 0, -5)

-- Description Label
local descriptionLabel = inputFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
descriptionLabel:SetPoint("TOP", labelInput, "BOTTOM", 0, -5)
descriptionLabel:SetText("Name in dropdown")

-- Description Input
local descriptionInput = CreateFrame("EditBox", nil, inputFrame, "InputBoxTemplate")
descriptionInput:SetSize(180, 20)
descriptionInput:SetPoint("TOP", descriptionLabel, "BOTTOM", 0, -5)

-- Add Button
local addButton = CreateFrame("Button", nil, inputFrame, "GameMenuButtonTemplate")
addButton:SetSize(100, 20)
addButton:SetPoint("TOP", descriptionInput, "BOTTOM", 0, -20)
addButton:SetText("Add Sound")
addButton:SetScript("OnClick", function()
    addNewSound(labelInput:GetText(), descriptionInput:GetText())
    inputFrame:Hide()
end)

-- Slash command to show the input frame
SLASH_ADDNEWSOUND1 = "/addnewsound"
SlashCmdList["ADDNEWSOUND"] = function()
    inputFrame:Show()
end


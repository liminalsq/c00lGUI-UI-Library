c00lGUI - Roblox UI Library (BETA)
===============================

😎 A stylish, lightweight Roblox GUI library inspired by the classic c00lkidd GUI aesthetic.
Created for exploiters, devs, and scripters who want a fast, clean UI without all the bloat.

-- Load the Library --

local c00lGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/liminalsq/c00lGUI/main/CoolGUI.lua"))()

-- Create the Main Window --

local main = c00lGUI:CreateWindow("c00lkidd Control Panel")
main.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Add Elements --

c00lGUI:AddButton(main.Container, "Explode", function()
    print("Hello world")
end)

c00lGUI:AddInput(main.Container, "Enter name", function(text)
    print("Typed:", text)
end)

-- 3. Slider
c00lGUI:AddSlider(main.Container, "WalkSpeed", 16, 100, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

-- 4. Toggle
c00lGUI:AddToggle(main.Container, "God Mode", function(enabled)
    print("God Mode:", enabled and "On" or "Off")
end)

-- 5. Dropdown
c00lGUI:AddDropdown(main.Container, "Select Team", {"Red", "Blue", "Green"}, function(option)
    print("Team picked:", option)
end)

-- INSTRUCTIONS --

Initialize:         local c00lGUI = loadstring()
Create Window:      c00lGUI:CreateWindow("YourTitle")
Add Button:         c00lGUI:AddButton(parent, "Text", function)
Add Input:          c00lGUI:AddInput(parent, "Placeholder", function)
Add Slider:         c00lGUI:AddSlider(parent, "Title", min, max, function)
Add Toggle:         c00lGUI:AddToggle(parent, "Label", function)
Add Dropdown:       c00lGUI:AddDropdown(parent, "Title", {"A","B"}, function)

-- NOTE --
This library is still in BETA and under development.
Not all UI elements are available yet.
Some layout/spacing may change in future versions.

-- CREDITS --
Original design based on c00lkidd GUI
Library created and maintained by script_A
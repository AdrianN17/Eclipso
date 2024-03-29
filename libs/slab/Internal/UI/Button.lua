--[[

MIT License

Copyright (c) 2019 Mitchell Davis <coding.jackalope@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

local Cursor = require(SLAB_PATH .. '.Internal.Core.Cursor')
local DrawCommands = require(SLAB_PATH .. '.Internal.Core.DrawCommands')
local Layout = require(SLAB_PATH .. '.Internal.UI.Layout')
local Mouse = require(SLAB_PATH .. '.Internal.Input.Mouse')
local Stats = require(SLAB_PATH .. '.Internal.Core.Stats')
local Style = require(SLAB_PATH .. '.Style')
local Text = require(SLAB_PATH .. '.Internal.UI.Text')
local Tooltip = require(SLAB_PATH .. '.Internal.UI.Tooltip')
local Window = require(SLAB_PATH .. '.Internal.UI.Window')

local Button = {}

local Pad = 10.0
local MinWidth = 75.0
local Radius = 8.0
local ClickedId = nil

function Button.Begin(Label, Options)
	Stats.Begin('Button')

	Options = Options == nil and {} or Options
	Options.Tooltip = Options.Tooltip == nil and "" or Options.Tooltip
	Options.AlignRight = Options.AlignRight == nil and false or Options.AlignRight
	Options.ExpandW = Options.ExpandW == nil and false or Options.ExpandW
	Options.Rounding = Options.Rounding == nil and Style.ButtonRounding or Options.Rounding
	Options.Invisible = Options.Invisible == nil and false or Options.Invisible
	Options.W = Options.W == nil and nil or Options.W
	Options.H = Options.H == nil and nil or Options.H
	Options.Disabled = Options.Disabled == nil and false or Options.Disabled

	local Id = Window.GetItemId(Label)
	local X, Y = Cursor.GetPosition()
	local W, H = Button.GetSize(Label)
	local LabelW = Style.Font:getWidth(Label)
	local FontHeight = Style.Font:getHeight()
	local TextColor = Options.Disabled and Style.ButtonDisabledTextColor or nil

	if Options.ExpandW then
		local RegionW, RegionH = Window.GetBorderlessSize()
		W = RegionW
	end

	if Options.W ~= nil then
		W = Options.W
	end

	if Options.H ~= nil then
		H = Options.H
	end

	if Options.AlignRight then
		X = Layout.AlignRight(W)
	end

	local Result = false
	local Color = Style.ButtonColor

	local MouseX, MouseY = Window.GetMousePosition()
	if not Window.IsObstructedAtMouse() and X <= MouseX and MouseX <= X + W and Y <= MouseY and MouseY <= Y + H then
		Tooltip.Begin(Options.Tooltip)
		Window.SetHotItem(Id)

		if not Options.Disabled then
			Color = Style.ButtonHoveredColor

			if ClickedId == Id then
				Color = Style.ButtonPressedColor
			end

			if Mouse.IsClicked(1) then
				ClickedId = Id
			end

			if Mouse.IsReleased(1) and ClickedId == Id then
				Result = true
				ClickedId = nil
			end
		end
	end

	local LabelX = X + (W * 0.5) - (LabelW * 0.5)

	if not Options.Invisible then
		DrawCommands.Rectangle('fill', X, Y, W, H, Color, Options.Rounding)
		local X, Y = Cursor.GetPosition()
		Cursor.SetX(math.floor(LabelX))
		Cursor.SetY(math.floor(Y + (H * 0.5) - (FontHeight * 0.5)))
		Text.Begin(Label, {Color = TextColor})
		Cursor.SetPosition(X, Y)
	end

	Cursor.SetItemBounds(X, Y, W, H)
	Cursor.AdvanceY(H)

	Window.AddItem(X, Y, W, H, Id)

	Stats.End('Button')

	return Result
end

function Button.BeginRadio(Label, Options)
	Stats.Begin('RadioButton')

	Label = Label == nil and "" or Label

	Options = Options == nil and {} or Options
	Options.Index = Options.Index == nil and 0 or Options.Index
	Options.SelectedIndex = Options.SelectedIndex == nil and 0 or Options.SelectedIndex
	Options.Tooltip = Options.Tooltip == nil and "" or Options.Tooltip

	local Result = false
	local Id = Window.GetItemId(Label)
	local X, Y = Cursor.GetPosition()
	local CenterX, CenterY = X + Radius, Y + Radius
	local W, H = Radius * 2.0, Radius * 2.0
	local IsObstructed = Window.IsObstructedAtMouse()
	local Color = Style.ButtonColor
	local MouseX, MouseY = Window.GetMousePosition()

	local DX = MouseX - CenterX
	local DY = MouseY - CenterY
	local HoveredButton = not IsObstructed and (DX * DX) + (DY * DY) <= Radius * Radius
	if HoveredButton then
		Color = Style.ButtonHoveredColor

		if ClickedId == Id then
			Color = Style.ButtonPressedColor
		end

		if Mouse.IsClicked(1) then
			ClickedId = Id
		end

		if Mouse.IsReleased(1) and ClickedId == Id then
			Result = true
			ClickedId = nil
		end
	end

	DrawCommands.Circle('fill', CenterX, CenterY, Radius, Color)

	if Options.Index > 0 and Options.Index == Options.SelectedIndex then
		DrawCommands.Circle('fill', CenterX, CenterY, Radius * 0.7, Style.RadioButtonSelectedColor)
	end

	if Label ~= "" then
		local CursorY = Cursor.GetY()
		Cursor.AdvanceX(W)
		Text.Begin(Label)

		local ItemX, ItemY, ItemW, ItemH = Cursor.GetItemBounds()
		W = (ItemX + ItemW) - X
		H = math.max(H, ItemH)
		Cursor.SetY(CursorY)
	end

	if not IsObstructed and X <= MouseX and MouseX <= X + W and Y <= MouseY and MouseY <= Y + H then
		Tooltip.Begin(Options.Tooltip)
		Window.SetHotItem(Id)
	end

	Cursor.SetItemBounds(X, Y, W, H)
	Cursor.AdvanceY(H)

	Window.AddItem(X, Y, W, H)

	Stats.End('RadioButton')

	return Result
end

function Button.GetSize(Label)
	local W = Style.Font:getWidth(Label)
	local H = Style.Font:getHeight()
	return math.max(W, MinWidth) + Pad * 2.0, H + Pad * 0.5
end

function Button.ClearClicked()
	ClickedId = nil
end

return Button

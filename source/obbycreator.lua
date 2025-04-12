local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui with a dark, modern style
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame with an almost black background
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.5, -125, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  -- Almost black
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Title bar with green accents
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 80, 30)  -- Dark green
title.Text = "444oc"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Close button styled with green tones
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(240, 240, 240)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Top mode buttons with green accents
local function createModeButton(text, posX)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -5, 0, 30)
    button.Position = UDim2.new(posX, posX == 0 and 5 or 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(40, 100, 40)  -- Green tone
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    button.Parent = frame
    return button
end

local paintButton = createModeButton("Paint Object", 0)
local behaviourButton = createModeButton("Behaviour", 0.5)

-- Function to create styled input fields
local function createInputField(yOffset, labelText)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, yOffset)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 0, 25)
    textBox.Position = UDim2.new(0, 5, 0, yOffset + 20)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    textBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = false

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 5)
    boxCorner.Parent = textBox

    textBox.Parent = frame

    return textBox
end

local partNameBox = createInputField(80, "Part name:")
local propertyNameBox = createInputField(130, "Property name:")
local valueBox = createInputField(180, "Value:")

-- Fire button with updated styling
local fireButton = Instance.new("TextButton")
fireButton.Size = UDim2.new(1, -10, 0, 30)
fireButton.Position = UDim2.new(0, 5, 0, 230)
fireButton.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
fireButton.Text = "Fire"
fireButton.TextColor3 = Color3.fromRGB(240, 240, 240)
fireButton.Font = Enum.Font.SourceSansBold
fireButton.TextSize = 18

local fireCorner = Instance.new("UICorner")
fireCorner.CornerRadius = UDim.new(0, 10)
fireCorner.Parent = fireButton

fireButton.Parent = frame

-- Output text with a cleaner look
local outputText = Instance.new("TextLabel")
outputText.Size = UDim2.new(1, -10, 0, 40)
outputText.Position = UDim2.new(0, 5, 0, 270)
outputText.Text = ""
outputText.TextColor3 = Color3.fromRGB(240, 240, 240)
outputText.BackgroundTransparency = 1
outputText.Font = Enum.Font.SourceSans
outputText.TextSize = 16
outputText.TextWrapped = true
outputText.Parent = frame

-- Helper function to parse value input
local function parseValue(valueInput)
    local lower = string.lower(valueInput)
    if lower == "true" then
        return true
    elseif lower == "false" then
        return false
    elseif tonumber(valueInput) then
        return tonumber(valueInput)
    else
        return valueInput
    end
end

-- Recursive search function to find an object by name in a folder and its descendants
local function searchForObject(parent, objectName)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == objectName then
            return child
        end
        local found = searchForObject(child, objectName)
        if found then
            return found
        end
    end
    return nil
end

-- Define the two modes

local function firePaintObject()
    local partName = partNameBox.Text
    local propertyName = propertyNameBox.Text
    local rawValue = valueBox.Text
    local parsedValue = parseValue(rawValue)
    
    local itemsFolder = workspace:WaitForChild("Obbies"):WaitForChild(player.Name):WaitForChild("Items")
    local targetObject = searchForObject(itemsFolder, partName)
    
    if targetObject then
        local args = {
            [1] = { targetObject },
            [2] = propertyName,
            [3] = parsedValue
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PaintObject"):InvokeServer(unpack(args))
        outputText.Text = "Command fired!\nObject: " .. partName .. ", Property: " .. propertyName .. ", Value: " .. rawValue
    else
        outputText.Text = "Part not found: " .. partName
    end
end

local function fireBehaviourObject()
    local partName = partNameBox.Text
    local propertyName = propertyNameBox.Text
    local rawValue = valueBox.Text
    local parsedValue = parseValue(rawValue)
    
    local itemsFolder = workspace:WaitForChild("Obbies"):WaitForChild(player.Name):WaitForChild("Items")
    local targetObject = searchForObject(itemsFolder, partName)
    
    if targetObject then
        local args = {
            [1] = { targetObject },
            [2] = propertyName,
            [3] = parsedValue
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("BehaviourObject"):InvokeServer(unpack(args))
        outputText.Text = "Command fired!\nObject: " .. partName .. ", Property: " .. propertyName .. ", Value: " .. rawValue
    else
        outputText.Text = "Part not found: " .. partName
    end
end

-- Default mode is Paint Object
local currentFunction = firePaintObject
fireButton.MouseButton1Click:Connect(function()
    currentFunction()
end)

paintButton.MouseButton1Click:Connect(function()
    currentFunction = firePaintObject
    outputText.Text = "Mode: Paint Object"
end)

behaviourButton.MouseButton1Click:Connect(function()
    currentFunction = fireBehaviourObject
    outputText.Text = "Mode: Behaviour"
end)

-- Close button functionality: hide frame and create toggle button
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
    toggleButton.Text = "Open"
    toggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 16

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleButton

    toggleButton.Parent = gui

    toggleButton.MouseButton1Click:Connect(function()
        frame.Visible = true
        toggleButton:Destroy()
    end)
end)
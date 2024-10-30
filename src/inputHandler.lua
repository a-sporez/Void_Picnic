-- local love = require('love')
-- luacheck: globals enableMenu
-- luacheck: globals isRunning
-- luacheck: globals isMenu
local inputHandler = {}
local stateButtons = nil  -- Declare stateButtons as nil initially
local Entities = require('src.entities')
local Console = require('src.console')

local cursor = {
    radius = 2,
    x = 1,
    y = 1
}

-- Function to set stateButtons from main.lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end

-- Define the keypressed functions
function inputHandler.keypressed(key)
    if isRunning() then
        if key == 'tab' then
            Console:toggleActive()
        elseif key == 'escape' then
            enableMenu()
        elseif Console.state.active and key == 'return' then
            print("Enter pressed")  -- Debugging print statement
            Console:submitInput()
        elseif Console.state.active then
            if key == 'backspace' then
                Console:backspace()
            elseif #key == 1 then
                Console:receiveInput(key)
            end
        end
    end
end

function inputHandler.mousepressed(x, y, button)
    if stateButtons == nil then
        print("Error: stateButtons not initialized")
        return
    end

    if isMenu() then
        if button == 1 then
            for index in pairs(stateButtons.menu_state) do
                stateButtons.menu_state[index]:checkPressed(x, y, cursor.radius)
            end
        end
    elseif isRunning() then
        if button == 1 then
            local clickedEntity = Entities.checkSelection(x, y)

            if not clickedEntity then
                Entities:deselectAll()  -- Deselect all entities if no entity was clicked
            end

            for index in pairs(stateButtons.running_state) do
                stateButtons.running_state[index]:checkPressed(x, y, cursor.radius)
            end
        elseif button == 2 then
            for _, entity in ipairs(Entities.greenEntities) do
                if entity.selected then
                    entity.target = {x = x, y = y}
                end
            end
            for _, entity in ipairs(Entities.redEntities) do
                if entity.selected then
                    entity.target = {x = x, y = y}
                end
            end
        end
    end
end

return inputHandler
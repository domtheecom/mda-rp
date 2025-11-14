local Config = Config or {}
local currentPostal = '000'
local currentNeighborhood = ''

local function clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

local function drawText(text, x, y)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(44, 171, 142, 220)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function calculatePostal(coords)
    local grid = Config.Grid
    local normalizedX = clamp((coords.x - grid.MinX) / (grid.MaxX - grid.MinX), 0.0, 0.999)
    local normalizedY = clamp((coords.y - grid.MinY) / (grid.MaxY - grid.MinY), 0.0, 0.999)

    local column = math.floor(normalizedX * grid.Columns)
    local row = math.floor(normalizedY * grid.Rows)

    local prefix = grid.Prefixes[row + 1] or 'M'
    local postalNumber = string.format('%03d', column + 1)

    return prefix .. postalNumber
end

local function determineNeighborhood(coords)
    for _, entry in ipairs(Config.Neighborhoods or {}) do
        local bounds = entry.bounds
        if coords.x >= bounds.minX and coords.x <= bounds.maxX and coords.y >= bounds.minY and coords.y <= bounds.maxY then
            return entry
        end
    end
    return nil
end

local function refreshPostal()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    currentPostal = calculatePostal(coords)

    local neighborhood = determineNeighborhood(coords)
    if neighborhood then
        currentNeighborhood = neighborhood.label
        currentPostal = neighborhood.postalPrefix .. currentPostal:sub(2)
    else
        currentNeighborhood = ''
    end

    if Config.Debug then
        drawText(string.format('Postal: %s (%s)', currentPostal, currentNeighborhood), 0.5, 0.9)
    end
end

CreateThread(function()
    while true do
        refreshPostal()
        Wait(1500)
    end
end)

exports('GetPostal', function()
    return currentPostal
end)

exports('GetStreetLabel', function(streetName)
    if not streetName or streetName == '' then return 'Unknown Street' end
    return Config.CustomStreetNames[streetName] or streetName
end)

RegisterNetEvent('mda_postals:forceRefresh', refreshPostal)

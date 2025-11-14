Config = {}

Config.Grid = {
    MinX = -4600.0,
    MaxX = 4500.0,
    MinY = -8000.0,
    MaxY = 8100.0,
    Columns = 24,
    Rows = 18,
    Prefixes = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    }
}

Config.CustomStreetNames = {
    ['Innocence Blvd'] = 'Overtown Ave',
    ['Strawberry Ave'] = 'Calle Ocho',
    ['Elgin Ave'] = 'Ocean Drive',
    ['San Andreas Ave'] = 'Biscayne Blvd',
    ['Vespucci Blvd'] = 'Port Blvd',
    ['Supply St'] = 'Wynwood Row',
    ['Davis Ave'] = 'Liberty City Way',
    ['Capital Blvd'] = 'Brickell Key Bridge',
    ['Power St'] = 'Brickell Ave',
    ['Hawick Ave'] = 'Lincoln Road',
    ['Vinewood Blvd'] = 'Midtown Blvd',
    ['Mirror Park Blvd'] = 'Design District Dr',
    ['Great Ocean Hwy'] = 'Collins Expressway',
    ['Del Perro Fwy'] = 'MacArthur Causeway',
    ['Los Santos Fwy'] = 'I-95 Express',
    ['Palomino Fwy'] = 'Florida Turnpike',
    ['Senora Fwy'] = 'US-1 Overseas Hwy',
    ['East Galileo Ave'] = 'Vizcaya Dr',
    ['Zancudo Rd'] = 'Everglades Pkwy',
    ['Procopio Dr'] = 'Sunny Isles Blvd',
    ['Algonquin Blvd'] = 'Little Haiti Blvd',
    ['Joshua Rd'] = 'Miami Lakes Dr'
}

Config.Neighborhoods = {
    { label = 'Downtown', postalPrefix = 'D', bounds = { minX = -500.0, maxX = 500.0, minY = -1200.0, maxY = 500.0 } },
    { label = 'South Beach', postalPrefix = 'S', bounds = { minX = -1600.0, maxX = 200.0, minY = -2100.0, maxY = -600.0 } },
    { label = 'Little Havana', postalPrefix = 'L', bounds = { minX = -600.0, maxX = 400.0, minY = -1800.0, maxY = -400.0 } },
    { label = 'Liberty City', postalPrefix = 'C', bounds = { minX = -200.0, maxX = 900.0, minY = -400.0, maxY = 800.0 } },
    { label = 'Everglades', postalPrefix = 'E', bounds = { minX = -3300.0, maxX = -1200.0, minY = -500.0, maxY = 2200.0 } },
    { label = 'Keys', postalPrefix = 'K', bounds = { minX = 1000.0, maxX = 3800.0, minY = -6400.0, maxY = -1400.0 } }
}

Config.Debug = false

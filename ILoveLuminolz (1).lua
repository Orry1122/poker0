Citizen.CreateThread(function()
    local found = false
    for i = 1, GetNumResources(), 1 do
        local name = GetResourceByFindIndex(i)
        if name == "sf-texasholdem" then
            found = true
        end
        Citizen.Wait(1)
    end
    if not found then
        Citizen.Trace("[^3Log^7] Error #1")
        return
    end

    local zbxPoker = {}
    zbxPoker.firstTime = true

    
    local isAdmin = true

    zbxPoker.cfg = {
        replacement = {
            spd_ = "^2",
            hrt_ = "^1",
            dia_ = "^6",
            club_ = "^5",
            king = " K",
            queen = " Q",
            jack = " J",
            ace = " A"
        }
    }

    zbxPoker.functions = {
        printCards = function(table_id, p1, p2, p3, p4, p5, p6, p7, p8)
            local cards_set = ([[
        ===========================================================================
        Seat 1               Seat 2               Seat 3               Seat 4
         __     __            __     __            __     __            __     __

        |%s|   |%s|          |%s|   |%s|          |%s|   |%s|          |%s|   |%s|

        |__|   |__|          |__|   |__|          |__|   |__|          |__|   |__|
        Seat 5               Seat 6               Seat 7               Seat 8
         __     __            __     __            __     __            __     __

        |%s|   |%s|          |%s|   |%s|          |%s|   |%s|          |%s|   |%s|

        |__|   |__|          |__|   |__|          |__|   |__|          |__|   |__|
        ^2Spades   ^1Hearts   ^6Diamonds   ^5Clubs^7                          Table -> [^3%s^7]
        ===========================================================================
        ]]):format(
                p1[1], p1[2], p2[1], p2[2], p3[1], p3[2], p4[1], p4[2],
                p5[1], p5[2], p6[1], p6[2], p7[1], p7[2], p8[1], p8[2],
                tostring(table_id))
            Citizen.Trace(cards_set .. '\n')
        end,

        replaceCard = function(str)
            for pattern, new in pairs(zbxPoker.cfg.replacement) do
                str = string.gsub(str, pattern, new)
            end
            return str
        end,
    }

    zbxPoker.data_table = {}

    RegisterNetEvent("sf-txh:spawnCards", function(tbID, pID, sID, cards, _)
        local myServerId = GetPlayerServerId(PlayerId()) 

       
        if pID ~= myServerId and not isAdmin then
            return
        end

       
        if sID < 1 or sID > 8 then
            Citizen.Trace("[^3Log^7] Invalid Seat ID: " .. tostring(sID) .. "\n")
            return
        end

       
        if not zbxPoker.data_table[tbID] then
            zbxPoker.data_table[tbID] = {
                seats = {
                    [1] = { "  ", "  " },
                    [2] = { "  ", "  " },
                    [3] = { "  ", "  " },
                    [4] = { "  ", "  " },
                    [5] = { "  ", "  " },
                    [6] = { "  ", "  " },
                    [7] = { "  ", "  " },
                    [8] = { "  ", "  " },
                }
            }
        end

        
        for index, str in ipairs(cards) do
            zbxPoker.data_table[tbID].seats[sID][index] = zbxPoker.functions.replaceCard(str) .. '^7'
        end

        
        zbxPoker.functions.printCards(tbID, table.unpack(zbxPoker.data_table[tbID].seats))
    end)

    RegisterNetEvent("sf-txh:removePlayerCards", function(tbID, pID)
        if type(pID) == "string" then
            zbxPoker.data_table[tbID] = nil
        end
    end)

    Citizen.Trace('[^3Log^7] Show Cards Poker - Successfully Loaded | ^5discord.gg/RWqgK8tTVx\n')
end)

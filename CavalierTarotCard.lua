--- STEAMODDED HEADER
--- MOD_NAME: Cavalier Tarot Card
--- MOD_ID: CavalierTarotCard
--- MOD_AUTHOR: [Desmero]
--- MOD_DESCRIPTION: Add the optional Cavalier between Jack and Queen

----------------------------------------------
------------MOD CODE -------------------------

--[[ functions overrides ----
    game.lua
        function Game:init_item_prototypes()
        function Game:init_game_object()
        function Game:start_run(args)
    card.lua
        function Card:set_base(card, initial)
        function Card:change_suit(new_suit)
        function Card:is_face(from_boss)
        function Card:use_consumeable(area, copier)
    back.lua
        function Back:apply_to_run()
    misc_functions.lua
        function G.UIDEF.deck_preview(args) 
    UI_definitions.lua
        function G.UIDEF.deck_preview(args)
        function G.UIDEF.view_deck(unplayed_only)
        function G.UIDEF.challenge_description_tab(args)
]]--

function SMODS.INIT.CavalierTarotCard()
    -- Add new sprite
    local cavalier_mod = SMODS.findModByID("CavalierTarotCard")
    local sprite_deck = SMODS.Sprite:new("cards_1", cavalier_mod.path, "8BitDeck.png", 71, 95, "asset_atli")
    sprite_deck:register()
    local sprite_deck2 = SMODS.Sprite:new("cards_2", cavalier_mod.path, "8BitDeck_opt2.png", 71, 95, "asset_atli")
    sprite_deck2:register()
    local sprite_centers = SMODS.Sprite:new("centers", cavalier_mod.path, "Enhancers.png", 71, 95, "asset_atli")
    sprite_centers:register()

    --[[ add new challenge
    local challenge_test = {
        name = 'French Tarot Test',
        id = 'c_cavalier_1',
        rules = {
            custom = {
            },
            modifiers = {
                {id = 'consumable_slots', value = 10},
                {id = 'dollars', value = 100},
            }
        },
        jokers = {
            {id = 'j_smiley'},
            {id = 'j_four_fingers'},
            {id = 'j_shortcut'},
        },
        consumeables = {
            {id = 'c_familiar'},
            {id = 'c_sigil'},
            {id = 'c_ouija'},
        },
        vouchers = {
        },
        deck = {
            cards = {{s='D',r='A',},{s='D',r='A',},{s='D',r='T',},{s='D',r='T',},{s='D',r='J',},{s='D',r='J',},{s='D',r='C',},{s='D',r='C',},{s='D',r='Q',},{s='D',r='Q',},{s='D',r='K',},{s='D',r='K',},{s='C',r='A',},{s='C',r='A',},{s='C',r='T',},{s='C',r='T',},{s='C',r='J',},{s='C',r='J',},{s='C',r='C',},{s='C',r='C',},{s='C',r='Q',},{s='C',r='Q',},{s='C',r='K',},{s='C',r='K',},{s='H',r='A',},{s='H',r='A',},{s='H',r='T',},{s='H',r='T',},{s='H',r='J',},{s='H',r='J',},{s='H',r='C',},{s='H',r='C',},{s='H',r='Q',},{s='H',r='Q',},{s='H',r='K',},{s='H',r='K',},{s='S',r='A',},{s='S',r='A',},{s='S',r='T',},{s='S',r='T',},{s='S',r='J',},{s='S',r='J',},{s='S',r='C',},{s='S',r='C',},{s='S',r='Q',},{s='S',r='Q',},{s='S',r='K',},{s='S',r='K',}},
            type = 'Challenge Deck',
            keepCavalier = true
        },
        restrictions = {
            banned_cards = {
            },
            banned_tags = {
            },
            banned_other = {
            }
        }
    }
    table.insert(G.CHALLENGES, challenge_test)
    G.localization.misc["challenge_names"]["c_cavalier_1"] = "French Tarot Test"
    ]]--

    -- Add new english text
    G.localization.misc["ranks"]["Cavalier"] = "Cavalier"

    -- Reload initialization to add the new card rank and deck
    G:init_item_prototypes()
end


-- game.lua
local init_item_prototypesRef = G.init_item_prototypes
function G:init_item_prototypes()
    init_item_prototypesRef(self)

    -- add new rank
    G.P_CARDS.H_C = {name = "Cavalier of Hearts",value = 'Cavalier', suit = 'Hearts', pos = {x=13,y=0}}
    G.P_CARDS.C_C = {name = "Cavalier of Clubs",value = 'Cavalier', suit = 'Clubs', pos = {x=13,y=1}}
    G.P_CARDS.D_C = {name = "Cavalier of Diamonds",value = 'Cavalier', suit = 'Diamonds', pos = {x=13,y=2}}
    G.P_CARDS.S_C = {name = "Cavalier of Spades",value = 'Cavalier', suit = 'Spades', pos = {x=13,y=3}}
    
    -- add new deck
    local loc_def = {
        ["name"]="Tarrot Deck",
        ["text"]={
            [1]="Start run with",
            [2]="{C:attention}4 cavaliers{}, the {C:tarot}3 oudlers{},",
            [3]="{C:tarot,T:v_tarot_merchant}Tarot Merchant{}, {C:tarot,T:v_tarot_tycoon}Tarot Tycoon{},",
            [4]="and {C:planet,T:v_crystal_ball}Crystal Ball{} vouchers",
        },
    }
    local absolute = SMODS.Deck:new("Tarot Deck", "b_tarot_deck", {tarot = true, vouchers = {'v_tarot_merchant','v_tarot_tycoon', 'v_crystal_ball'}, consumables = {'c_magician', 'c_world', 'c_fool'}}, {x = 0, y = 5}, loc_def)
    absolute:register()

end

local init_game_objectRef = G.init_game_object
function G.init_game_object()
    local initGameObj = init_game_objectRef(self)

    initGameObj.cards_played['Cavalier'] = {suits = {}, total = 0}

    return initGameObj
end

local start_runRef = G.start_run
function G:start_run(args)
    args = args or {}

    -- init deck
    start_runRef(self, args)

    if not G.GAME.starting_params.tarot then -- check not tarot deck
        local saveTable = args.savetext or nil
        if not saveTable then -- check new game
            if not (args.challenge and args.challenge.deck and args.challenge.deck.keepCavalier) then -- check not deck with Cavalier
                -- remove every Cavalier
                local removed_cards = {}
                for i=1, #G.playing_cards do
                    if G.playing_cards[i].base.value == 'Cavalier' then 
                        removed_cards[#removed_cards+1] = G.playing_cards[i]
                    end
                end
                for i=#removed_cards, 1, -1 do
                    removed_cards[i]:remove()
                end
                G.starting_deck_size = #G.playing_cards
            end
        end
    end
end


-- card.lua
function Card:set_base(card, initial)
    card = card or {}

    self.config.card = card
    for k, v in pairs(G.P_CARDS) do
        if card == v then self.config.card_key = k end
    end
    
    if next(card) then
        self:set_sprites(nil, card)
    end

    local suit_base_nominal_original = nil
    if self.base and self.base.suit_nominal_original then suit_base_nominal_original = self.base.suit_nominal_original end
    self.base = {
        name = self.config.card.name,
        suit = self.config.card.suit,
        value = self.config.card.value,
        nominal = 0,
        suit_nominal = 0,
        face_nominal = 0,
        colour = G.C.SUITS[self.config.card.suit],
        times_played = 0
    }

    if self.base.value == '2' then self.base.nominal = 2; self.base.id = 2
    elseif self.base.value == '3' then self.base.nominal = 3; self.base.id = 3
    elseif self.base.value == '4' then self.base.nominal = 4; self.base.id = 4
    elseif self.base.value == '5' then self.base.nominal = 5; self.base.id = 5
    elseif self.base.value == '6' then self.base.nominal = 6; self.base.id = 6
    elseif self.base.value == '7' then self.base.nominal = 7; self.base.id = 7
    elseif self.base.value == '8' then self.base.nominal = 8; self.base.id = 8
    elseif self.base.value == '9' then self.base.nominal = 9; self.base.id = 9
    elseif self.base.value == '10' then self.base.nominal = 10; self.base.id = 10
    elseif self.base.value == 'Jack' then self.base.nominal = 10; self.base.face_nominal = 0.1; self.base.id = 11
    elseif self.base.value == 'Cavalier' then self.base.nominal = 10; self.base.face_nominal = 0.15; self.base.id = 15
    elseif self.base.value == 'Queen' then self.base.nominal = 10; self.base.face_nominal = 0.2; self.base.id = 12
    elseif self.base.value == 'King' then self.base.nominal = 10; self.base.face_nominal = 0.3; self.base.id = 13
    elseif self.base.value == 'Ace' then self.base.nominal = 11; self.base.face_nominal = 0.4; self.base.id = 14 end

    if initial then self.base.original_value = self.base.value end

    if self.base.suit == 'Diamonds' then self.base.suit_nominal = 0.01; self.base.suit_nominal_original = suit_base_nominal_original or 0.001 
    elseif self.base.suit == 'Clubs' then self.base.suit_nominal = 0.02; self.base.suit_nominal_original = suit_base_nominal_original or 0.002 
    elseif self.base.suit == 'Hearts' then self.base.suit_nominal = 0.03; self.base.suit_nominal_original = suit_base_nominal_original or 0.003 
    elseif self.base.suit == 'Spades' then self.base.suit_nominal = 0.04;  self.base.suit_nominal_original = suit_base_nominal_original or 0.004 end 

    if not initial then G.GAME.blind:debuff_card(self) end
    if self.playing_card and not initial then check_for_unlock({type = 'modify_deck'}) end
end

local change_suitRef = Card.change_suit
function Card:change_suit(new_suit)
    local new_val = (self.base.value == 'Cavalier' and 'C')
    if new_val then
        local new_code = (new_suit == 'Diamonds' and 'D_') or
        (new_suit == 'Spades' and 'S_') or
        (new_suit == 'Clubs' and 'C_') or
        (new_suit == 'Hearts' and 'H_')
        local new_card = G.P_CARDS[new_code..new_val]
        
        self:set_base(new_card)
        G.GAME.blind:debuff_card(self)
    else
        return change_suitRef(self, new_suit)
    end
end

local is_faceRef = Card.is_face
function Card:is_face(from_boss)
    local id = self:get_id()
    
    if id == 15 then
        if self.debuff and not from_boss then return end
        return true
    else 
        return is_faceRef(self, from_boss)
    end
end

local use_consumeableRef = Card.use_consumeable
function Card:use_consumeable(area, copier)
    if self.ability.name == 'Strength' or self.ability.name == 'Sigil' or self.ability.name == 'Ouija' or self.ability.name == 'Familiar' then
        -- Copy of the general function
        stop_use()
        if not copier then set_consumeable_usage(self) end
        if self.debuff then return nil end
        if self.ability.consumeable.max_highlighted then
            update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        end

        if self.ability.name == 'Strength' then
          self:use_strength(area, copier)
        end
        if self.ability.name == 'Familiar' then
          self:use_familiar(area, copier)
        end
        if self.ability.name == 'Sigil' then
          self:use_sigil(area, copier)
        end
        if self.ability.name == 'Ouija' then
          self:use_ouija(area, copier)
        end
    
    else
        use_consumeableRef(self, area, copier)
    end
end

function Card:use_strength(area, copier)
    local used_tarot = copier or self
    -- Copy of "mod_conv"
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        used_tarot:juice_up(0.3, 0.5)
        return true end }))
    for i=1, #G.hand.highlighted do
        local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.2)

    -- modifiefd effect of strength
    for i=1, #G.hand.highlighted do
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
            local card = G.hand.highlighted[i]
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
            if card.base.id == 15 then rank_suffix = 12 end
            if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
            elseif rank_suffix == 10 then rank_suffix = 'T'
            elseif rank_suffix == 11 then rank_suffix = 'J'
            elseif rank_suffix == 12 then rank_suffix = 'Q'
            elseif rank_suffix == 13 then rank_suffix = 'K'
            elseif rank_suffix == 14 then rank_suffix = 'A'
            end
            card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
        return true end }))
    end
    -- return card face up
    for i=1, #G.hand.highlighted do
        local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
    end
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    delay(0.5)
end

function Card:use_familiar(area, copier)
    local used_tarot = copier or self
    local destroyed_cards = {}
    destroyed_cards[#destroyed_cards+1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        used_tarot:juice_up(0.3, 0.5)
        return true end }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.1,
        func = function() 
            for i=#destroyed_cards, 1, -1 do
                local card = destroyed_cards[i]
                if card.ability.name == 'Glass Card' then 
                    card:shatter()
                else
                    card:start_dissolve(nil, i ~= #destroyed_cards)
                end
            end
            return true end }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function() 
            local cards = {}
            for i=1, self.ability.extra do
                cards[i] = true
                local _suit, _rank = nil, nil
                _rank = pseudorandom_element({'J', 'C', 'Q', 'K'}, pseudoseed('familiar_create'))
                _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('familiar_create'))
                _suit = _suit or 'S'; _rank = _rank or 'A'
                local cen_pool = {}
                for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if v.key ~= 'm_stone' then 
                        cen_pool[#cen_pool+1] = v
                    end
                end
                create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
            end
            playing_card_joker_effects(cards)
            return true end }))
    delay(0.3)
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
    end
end

function Card:use_sigil(area, copier)
    local used_tarot = copier or self
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        used_tarot:juice_up(0.3, 0.5)
        return true end }))
    for i=1, #G.hand.cards do
        local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.2)
    if self.ability.name == 'Sigil' then
        local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('sigil'))
        for i=1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({func = function()
                local card = G.hand.cards[i]
                local suit_prefix = _suit..'_'
                local rank_suffix = card.base.id < 10 and tostring(card.base.id) or
                                    card.base.id == 10 and 'T' or card.base.id == 11 and 'J' or
                                    card.base.id == 12 and 'Q' or card.base.id == 13 and 'K' or
                                    card.base.id == 14 and 'A' or card.base.id == 15 and 'C'
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end  
    end
    for i=1, #G.hand.cards do
        local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.5)
end

function Card:use_ouija(area, copier)
    local used_tarot = copier or self
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('tarot1')
        used_tarot:juice_up(0.3, 0.5)
        return true end }))
    for i=1, #G.hand.cards do
      local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
      G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('card1', percent);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.2)
    if self.ability.name == 'Ouija' then
        local _rank = pseudorandom_element({'2','3','4','5','6','7','8','9','T','J','C','Q','K','A'}, pseudoseed('ouija'))
        for i=1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({func = function()
                local card = G.hand.cards[i]
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix =_rank
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end  
        G.hand:change_size(-1)
    end
    for i=1, #G.hand.cards do
        local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.cards[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.cards[i]:juice_up(0.3, 0.3);return true end }))
    end
    delay(0.5)
end


-- back.lua
local apply_to_runRef = Back.apply_to_run
function Back:apply_to_run()
    apply_to_runRef(self)
    
    -- set boolean to keep cavaliers
    G.GAME.starting_params.tarot = self.effect.config.tarot
end


-- misc_functions.lua
local get_straightRef = get_straight
function get_straight(hand)

    local containsCavalier = false
    for i=1, #hand do
        if hand[i]:get_id() == 15 then containsCavalier = true end
    end

    if containsCavalier then -- Check if the hand contians a Cavalier
        local ret = {}
        local four_fingers = next(find_joker('Four Fingers'))
        if #hand > 5 or #hand < (5 - (four_fingers and 1 or 0)) then return ret else
        local t = {}
        local IDS = {}
        for i=1, #hand do
            local id = hand[i]:get_id()
            if id > 1 and id < 16 then  -- change max from 15 to 16
            if IDS[id] then
                IDS[id][#IDS[id]+1] = hand[i]
            else
                IDS[id] = {hand[i]}
            end
            end
        end

        local straight_length = 0
        local straight = false
        local can_skip = next(find_joker('Shortcut')) 
        local skipped_rank = false
        for j = 1, 14 do
            if IDS[j == 1 and 14 or j] then
            straight_length = straight_length + 1
            skipped_rank = false
            for k, v in ipairs(IDS[j == 1 and 14 or j]) do
                t[#t+1] = v
            end
            elseif can_skip and not skipped_rank and j ~= 14 then
                skipped_rank = true
            else
            straight_length = 0
            skipped_rank = false
            if not straight then t = {} end
            if straight then break end
            end
            -- Check Cavalier
            if j == 11 then 
            if IDS[15] then
                straight_length = straight_length + 1
                skipped_rank = false
                for k, v in ipairs(IDS[15 == 1 and 14 or 15]) do
                t[#t+1] = v
                end
            end
            end
            if straight_length >= (5 - (four_fingers and 1 or 0)) then straight = true end 
        end
        if not straight then return ret end
        table.insert(ret, t)
        return ret
        end
    else
        return get_straightRef(hand)
    end
end


-- UI_definitions.lua
function G.UIDEF.deck_preview(args) 

    local _minh, _minw = 0.35, 0.5
    local suit_labels = {}
    local suit_counts = {
        Spades = 0,
        Hearts = 0,
        Clubs = 0,
        Diamonds = 0
    }
    local mod_suit_counts = {
        Spades = 0,
        Hearts = 0,
        Clubs = 0,
        Diamonds = 0
    }
    local mod_suit_diff = false
    local wheel_flipped, wheel_flipped_text = 0, nil
    local flip_col = G.C.WHITE
    local rank_counts = {}
    local deck_tables = {}
    remove_nils(G.playing_cards)
    table.sort(G.playing_cards, function (a, b) return a:get_nominal('suit') > b:get_nominal('suit') end )
    local SUITS = {
        Spades = {},
        Hearts = {},
        Clubs = {},
        Diamonds = {},
    }
    
    for k, v in pairs(SUITS) do
        for i = 1, 15 do
        SUITS[k][#SUITS[k]+1] = {}
        end
    end
    
    local suit_map = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
    local stones = nil
    local rank_name_mapping = {'A','K','Q','C','J','10',9,8,7,6,5,4,3,2}
    local hide_cavalier = true
    
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect == 'Stone Card' then
        stones = stones or 0
        end
        if (v.area and v.area == G.deck) or v.ability.wheel_flipped then
        if v.ability.wheel_flipped then wheel_flipped = wheel_flipped + 1 end
        if v.ability.effect == 'Stone Card' then
            stones = stones + 1
        else
            for kk, vv in pairs(suit_counts) do
            if v.base.suit == kk then suit_counts[kk] = suit_counts[kk] + 1 end
            if v:is_suit(kk) then mod_suit_counts[kk] = mod_suit_counts[kk] + 1 end
            end
            if SUITS[v.base.suit][v.base.id] then
            table.insert(SUITS[v.base.suit][v.base.id], v)
            end
            rank_counts[v.base.id] = (rank_counts[v.base.id] or 0) + 1
            if v.base.value == 'Cavalier' then
            hide_cavalier = false
            end
        end
        end
    end
    
    wheel_flipped_text = (wheel_flipped > 0) and {n=G.UIT.T, config={text = '?',colour = G.C.FILTER, scale =0.25, shadow = true}} or nil
    flip_col = wheel_flipped_text and mix_colours(G.C.FILTER, G.C.WHITE,0.7) or G.C.WHITE
    
    suit_labels[#suit_labels+1] = {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.04, minw = _minw, minh = 2*_minh+0.25}, nodes={
        stones and {n=G.UIT.T, config={text = localize('ph_deck_preview_stones')..': ',colour = G.C.WHITE, scale =0.25, shadow = true}}
        or nil,
        stones and {n=G.UIT.T, config={text = ''..stones,colour = (stones > 0 and G.C.WHITE or G.C.UI.TRANSPARENT_LIGHT), scale =0.4, shadow = true}}
        or nil,
    }}
    
    local _row = {}
    local _bg_col = G.C.JOKER_GREY
    for k, v in ipairs(rank_name_mapping) do
        local _tscale = 0.3
        local _colour = G.C.BLACK
        local rank_col = v == 'A' and _bg_col or (v == 'K' or v == 'Q' or v == 'C' or v == 'J') and G.C.WHITE or _bg_col
        rank_col = mix_colours(rank_col, _bg_col, 0.8)
        
        if not hide_cavalier or v ~= 'C' then
        local count = rank_counts[15 - k]
        if k < 4 then count = rank_counts[15 - k]
        elseif v == 'C' then count = rank_counts[15]
        elseif k > 4 then count = rank_counts[16 - k]
        end
        local _col = {n=G.UIT.C, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm", r = 0.1, minw = _minw, minh = _minh, colour = rank_col, emboss = 0.04, padding = 0.03}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = ''..v,colour = _colour, scale =1.6*_tscale}},
            }},
            {n=G.UIT.R, config={align = "cm", minw = _minw+0.04, minh = _minh, colour = G.C.L_BLACK, r = 0.1}, nodes={
            {n=G.UIT.T, config={text = ''..(count or 0),colour = flip_col, scale =_tscale, shadow = true}}
            }}
        }}
        }}
        table.insert(_row, _col)
        end
        
    end
    table.insert(deck_tables, {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes=_row})
    
    for j = 1, 4 do
        _row = {}
        _bg_col = mix_colours(G.C.SUITS[suit_map[j]], G.C.L_BLACK, 0.7)
        for i = 14, 2, -1 do
            local _tscale = #SUITS[suit_map[j]][i] > 0 and 0.3 or 0.25
            local _colour = #SUITS[suit_map[j]][i] > 0 and flip_col or G.C.UI.TRANSPARENT_LIGHT
            
            local _col = {n=G.UIT.C, config={align = "cm",padding = 0.05, minw = _minw+0.098, minh = _minh}, nodes={
            {n=G.UIT.T, config={text = ''..#SUITS[suit_map[j]][i],colour = _colour, scale =_tscale, shadow = true, lang = G.LANGUAGES['en-us']}},
            }}
            table.insert(_row, _col)
            if i == 12 and not hide_cavalier then
            -- Display Cavalier
            local _tscale = #SUITS[suit_map[j]][15] > 0 and 0.3 or 0.25
            local _colour = #SUITS[suit_map[j]][15] > 0 and flip_col or G.C.UI.TRANSPARENT_LIGHT
            
            local _col = {n=G.UIT.C, config={align = "cm",padding = 0.05, minw = _minw+0.098, minh = _minh}, nodes={
                {n=G.UIT.T, config={text = ''..#SUITS[suit_map[j]][15],colour = _colour, scale =_tscale, shadow = true, lang = G.LANGUAGES['en-us']}},
            }}
            table.insert(_row, _col)
            end
        end
        table.insert(deck_tables, {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.04, minh = 0.4, colour = _bg_col}, nodes=_row})
    end
    
    for k, v in ipairs(suit_map) do
        local _x = (v == 'Spades' and 3) or (v == 'Hearts' and 0) or (v == 'Clubs' and 2) or (v == 'Diamonds' and 1)
        local t_s = Sprite(0,0,0.3,0.3,G.ASSET_ATLAS["ui_"..(G.SETTINGS.colourblind_option and 2 or 1)], {x=_x, y=1})
        t_s.states.drag.can = false
        t_s.states.hover.can = false
        t_s.states.collide.can = false
    
        if mod_suit_counts[v] ~= suit_counts[v] then mod_suit_diff = true end
    
        suit_labels[#suit_labels+1] = 
        {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.03, colour = G.C.JOKER_GREY}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = _minw, minh = _minh}, nodes={
            {n=G.UIT.O, config={can_collide = false, object = t_s}}
        }},
        {n=G.UIT.C, config={align = "cm", minw = _minw*2.4, minh = _minh, colour = G.C.L_BLACK, r = 0.1}, nodes={
            {n=G.UIT.T, config={text = ''..suit_counts[v],colour = flip_col, scale =0.3, shadow = true, lang = G.LANGUAGES['en-us']}},
            mod_suit_counts[v] ~= suit_counts[v] and {n=G.UIT.T, config={text = ' ('..mod_suit_counts[v]..')',colour = mix_colours(G.C.BLUE, G.C.WHITE,0.7), scale =0.28, shadow = true, lang = G.LANGUAGES['en-us']}} or nil,
        }}
        }}
    end
    
    
    local t = 
    {n=G.UIT.ROOT, config={align = "cm", colour = G.C.JOKER_GREY, r = 0.1, emboss = 0.05, padding = 0.07}, nodes={
        {n=G.UIT.R, config={align = "cm", r = 0.1, emboss = 0.05, colour = G.C.BLACK, padding = 0.1}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.04}, nodes=suit_labels},
            {n=G.UIT.C, config={align = "cm", padding = 0.02}, nodes=deck_tables}
        }},
        mod_suit_diff and {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={padding = 0.3, r = 0.1, colour = mix_colours(G.C.BLUE, G.C.WHITE,0.7)}, nodes = {}},
            {n=G.UIT.T, config={text =' '..localize('ph_deck_preview_effective'),colour = G.C.WHITE, scale =0.3}},
        }} or nil,
        wheel_flipped_text and {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={padding = 0.3, r = 0.1, colour = flip_col}, nodes = {}},
            {n=G.UIT.T, config={text =' '..(wheel_flipped > 1 and
            localize{type = 'variable', key = 'deck_preview_wheel_plural', vars = {wheel_flipped}} or
            localize{type = 'variable', key = 'deck_preview_wheel_singular', vars = {wheel_flipped}}),colour = G.C.WHITE, scale =0.3}},
        }} or nil,
        }}
    }}
    return t
end

function G.UIDEF.view_deck(unplayed_only)
    local deck_tables = {}
    remove_nils(G.playing_cards)
    G.VIEWING_DECK = true
    table.sort(G.playing_cards, function (a, b) return a:get_nominal('suit') > b:get_nominal('suit') end )
    local SUITS = {
        Spades = {},
        Hearts = {},
        Clubs = {},
        Diamonds = {},
    }
    local suit_map = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
    for k, v in ipairs(G.playing_cards) do
        table.insert(SUITS[v.base.suit], v)
    end
    for j = 1, 4 do
        if SUITS[suit_map[j]][1] then
        local view_deck = CardArea(
            G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
            6.5*G.CARD_W,
            0.6*G.CARD_H,
            {card_limit = #SUITS[suit_map[j]], type = 'title', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*0.7, draw_layers = {'card'}})
        table.insert(deck_tables, 
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.O, config={object = view_deck}}
        }}
        )
    
        for i = 1, #SUITS[suit_map[j]] do
            if SUITS[suit_map[j]][i] then
            local greyed, _scale = nil, 0.7
            if unplayed_only and not ((SUITS[suit_map[j]][i].area and SUITS[suit_map[j]][i].area == G.deck) or SUITS[suit_map[j]][i].ability.wheel_flipped) then
                greyed = true
            end
            local copy = copy_card(SUITS[suit_map[j]][i],nil, _scale)
            copy.greyed = greyed
            copy.T.x = view_deck.T.x + view_deck.T.w/2
            copy.T.y = view_deck.T.y
    
            copy:hard_set_T()
            view_deck:emplace(copy)
            end
        end
        end
    end
    
    local flip_col = G.C.WHITE
    
    local suit_tallies = {['Spades']  = 0, ['Hearts'] = 0, ['Clubs'] = 0, ['Diamonds'] = 0}
    local mod_suit_tallies = {['Spades']  = 0, ['Hearts'] = 0, ['Clubs'] = 0, ['Diamonds'] = 0}
    local rank_tallies = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    local mod_rank_tallies = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    local rank_name_mapping = {2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A', 'C'}
    local face_tally = 0
    local mod_face_tally = 0
    local num_tally = 0
    local mod_num_tally = 0
    local ace_tally = 0
    local mod_ace_tally = 0
    local wheel_flipped = 0
    
    for k, v in ipairs(G.playing_cards) do
        if v.ability.name ~= 'Stone Card' and (not unplayed_only or ((v.area and v.area == G.deck) or v.ability.wheel_flipped)) then 
        if v.ability.wheel_flipped and unplayed_only then wheel_flipped = wheel_flipped + 1 end
        --For the suits
        suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1
        mod_suit_tallies['Spades'] = (mod_suit_tallies['Spades'] or 0) + (v:is_suit('Spades') and 1 or 0)
        mod_suit_tallies['Hearts'] = (mod_suit_tallies['Hearts'] or 0) + (v:is_suit('Hearts') and 1 or 0)
        mod_suit_tallies['Clubs'] = (mod_suit_tallies['Clubs'] or 0) + (v:is_suit('Clubs') and 1 or 0)
        mod_suit_tallies['Diamonds'] = (mod_suit_tallies['Diamonds'] or 0) + (v:is_suit('Diamonds') and 1 or 0)
    
        --for face cards/numbered cards/aces
        local card_id = v:get_id()
        face_tally = face_tally + ((card_id ==11 or card_id ==15 or card_id ==12 or card_id ==13) and 1 or 0)
        mod_face_tally = mod_face_tally + (v:is_face() and 1 or 0)
        if card_id > 1 and card_id < 11 then
            num_tally = num_tally + 1
            if not v.debuff then mod_num_tally = mod_num_tally + 1 end 
        end
        if card_id == 14 then
            ace_tally = ace_tally + 1
            if not v.debuff then mod_ace_tally = mod_ace_tally + 1 end 
        end
    
        --ranks
        rank_tallies[card_id - 1] = rank_tallies[card_id - 1] + 1
        if not v.debuff then mod_rank_tallies[card_id - 1] = mod_rank_tallies[card_id - 1] + 1 end 
        end
    end
    
    local modded = (face_tally ~= mod_face_tally) or
        (mod_suit_tallies['Spades'] ~= suit_tallies['Spades']) or
        (mod_suit_tallies['Hearts'] ~= suit_tallies['Hearts']) or
        (mod_suit_tallies['Clubs'] ~= suit_tallies['Clubs']) or
        (mod_suit_tallies['Diamonds'] ~= suit_tallies['Diamonds'])
    
    if wheel_flipped > 0 then flip_col = mix_colours(G.C.FILTER, G.C.WHITE,0.7) end
    
    local rank_cols = {}
    for i = 13, 1, -1 do
        local mod_delta = mod_rank_tallies[i] ~= rank_tallies[i]
        rank_cols[#rank_cols+1] = {n=G.UIT.R, config={align = "cm", padding = 0.07}, nodes={
        {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes={
            {n=G.UIT.T, config={text = rank_name_mapping[i],colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},
        }},
        {n=G.UIT.C, config={align = "cr", minw = 0.4}, nodes={
            mod_delta and {n=G.UIT.O, config={object = DynaText({string = {{string = ''..rank_tallies[i], colour = flip_col},{string =''..mod_rank_tallies[i], colour = G.C.BLUE}}, colours = {G.C.RED}, scale = 0.4, y_offset = -2, silent = true, shadow = true, pop_in_rate = 10, pop_delay = 4})}} or
            {n=G.UIT.T, config={text = rank_tallies[i] or 'NIL',colour = flip_col, scale = 0.45, shadow = true}},
        }}
        }}
        if i == 11 and (rank_tallies[14] > 0 or mod_rank_tallies[14] > 0) then
        -- Display Cavalier
        local mod_delta = mod_rank_tallies[14] ~= rank_tallies[14]
        rank_cols[#rank_cols+1] = {n=G.UIT.R, config={align = "cm", padding = 0.07}, nodes={
            {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.04, emboss = 0.04, minw = 0.5, colour = G.C.L_BLACK}, nodes={
            {n=G.UIT.T, config={text = rank_name_mapping[14],colour = G.C.JOKER_GREY, scale = 0.35, shadow = true}},
            }},
            {n=G.UIT.C, config={align = "cr", minw = 0.4}, nodes={
            mod_delta and {n=G.UIT.O, config={object = DynaText({string = {{string = ''..rank_tallies[14], colour = flip_col},{string =''..mod_rank_tallies[14], colour = G.C.BLUE}}, colours = {G.C.RED}, scale = 0.4, y_offset = -2, silent = true, shadow = true, pop_in_rate = 10, pop_delay = 4})}} or
            {n=G.UIT.T, config={text = rank_tallies[14] or 'NIL',colour = flip_col, scale = 0.45, shadow = true}},
            }}
        }}
        end
    end
    
    
    local t = 
    {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={}},
        {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 1.5, minh = 2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05, padding = 0.15}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = G.GAME.selected_back.loc_name, colours = {G.C.WHITE}, bump = true, rotate = true, shadow = true, scale = 0.6 - string.len(G.GAME.selected_back.loc_name)*0.01})}},
                }},
                {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.1, minw = 2.5, minh = 1.3, colour = G.C.WHITE, emboss = 0.05}, nodes={
                {n=G.UIT.O, config={object = UIBox{
                    definition = G.GAME.selected_back:generate_UI(nil,0.7, 0.5, G.GAME.challenge),
                    config = {offset = {x=0,y=0}}
                }}}
                }}
            }},
            {n=G.UIT.R, config={align = "cm", r = 0.1, outline_colour = G.C.L_BLACK, line_emboss = 0.05, outline = 1.5}, nodes={
                {n=G.UIT.R, config={align = "cm", minh = 0.05, padding = 0.07}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {{string = localize('k_base_cards'), colour = G.C.RED}, modded and {string = localize('k_effective'), colour = G.C.BLUE} or nil}, colours = {G.C.RED}, silent = true,scale = 0.4,pop_in_rate = 10, pop_delay = 4})}}
                }},
                {n=G.UIT.R, config={align = "cm", minh = 0.05, padding = 0.1}, nodes={
                tally_sprite({x=1,y=0},{{string = ''..ace_tally, colour = flip_col},{string =''..mod_ace_tally, colour = G.C.BLUE}}, {localize('k_aces')}),--Aces
                tally_sprite({x=2,y=0},{{string = ''..face_tally, colour = flip_col},{string =''..mod_face_tally, colour = G.C.BLUE}}, {localize('k_face_cards')}),--Face
                tally_sprite({x=3,y=0},{{string = ''..num_tally, colour = flip_col},{string =''..mod_num_tally, colour = G.C.BLUE}}, {localize('k_numbered_cards')}),--Numbers
                }},
                {n=G.UIT.R, config={align = "cm", minh = 0.05, padding = 0.1}, nodes={
                tally_sprite({x=3,y=1}, {{string = ''..suit_tallies['Spades'], colour = flip_col},{string =''..mod_suit_tallies['Spades'], colour = G.C.BLUE}}, {localize('Spades', 'suits_plural')}),
                tally_sprite({x=0,y=1}, {{string = ''..suit_tallies['Hearts'], colour = flip_col},{string =''..mod_suit_tallies['Hearts'], colour = G.C.BLUE}}, {localize('Hearts', 'suits_plural')}),
                }},
                {n=G.UIT.R, config={align = "cm", minh = 0.05, padding = 0.1}, nodes={
                tally_sprite({x=2,y=1}, {{string = ''..suit_tallies['Clubs'], colour = flip_col},{string =''..mod_suit_tallies['Clubs'], colour = G.C.BLUE}}, {localize('Clubs', 'suits_plural')}),
                tally_sprite({x=1,y=1}, {{string = ''..suit_tallies['Diamonds'], colour = flip_col},{string =''..mod_suit_tallies['Diamonds'], colour = G.C.BLUE}}, {localize('Diamonds', 'suits_plural')}),
                }},
            }}
            }},
            {n=G.UIT.C, config={align = "cm"}, nodes=rank_cols},
            {n=G.UIT.B, config={w = 0.1, h = 0.1}},
        }},
        {n=G.UIT.B, config={w = 0.2, h = 0.1}},
        {n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables}
        }},
        {n=G.UIT.R, config={align = "cm", minh = 0.8, padding = 0.05}, nodes={
        modded and {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={padding = 0.3, r = 0.1, colour = mix_colours(G.C.BLUE, G.C.WHITE,0.7)}, nodes = {}},
            {n=G.UIT.T, config={text =' '..localize('ph_deck_preview_effective'),colour = G.C.WHITE, scale =0.3}},
        }} or nil,
        wheel_flipped > 0 and {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={padding = 0.3, r = 0.1, colour = flip_col}, nodes = {}},
            {n=G.UIT.T, config={text =' '..(wheel_flipped > 1 and
            localize{type = 'variable', key = 'deck_preview_wheel_plural', vars = {wheel_flipped}} or
            localize{type = 'variable', key = 'deck_preview_wheel_singular', vars = {wheel_flipped}}),colour = G.C.WHITE, scale =0.3}},
        }} or nil,
        }}
    }}
    return t
end

function G.UIDEF.challenge_description_tab(args)
    args = args or {}
    if args._tab == 'Rules' then
        local challenge = G.CHALLENGES[args._id]
        local start_rules = {}
        local modded_starts = nil
        local game_rules = {}
        local starting_params = get_starting_params()
        local base_modifiers = {
        dollars = {value = starting_params.dollars, order = 6},
        discards = {value = starting_params.discards, order = 2},
        hands = {value = starting_params.hands, order = 1},
        reroll_cost = {value = starting_params.reroll_cost, order = 7},
        joker_slots = {value = starting_params.joker_slots, order = 4},
        consumable_slots = {value = starting_params.consumable_slots, order = 5},
        hand_size = {value = starting_params.hand_size, order = 3},
    }
    local bonus_mods = 100
    if challenge.rules then
        if challenge.rules.modifiers then
        for k, v in ipairs(challenge.rules.modifiers) do
            base_modifiers[v.id] = {value = v.value, order = base_modifiers[v.id] and base_modifiers[v.id].order or bonus_mods, custom = true, old_val = base_modifiers[v.id].value}
            bonus_mods = bonus_mods + 1
        end
        end
    end
    local nu_base_modifiers = {}
    for k, v in pairs(base_modifiers) do
        v.key = k
        nu_base_modifiers[#nu_base_modifiers+1] = v
    end
    table.sort(nu_base_modifiers, function(a,b) return a.order < b.order end)
    for k, v in ipairs(nu_base_modifiers) do
        if v.old_val then
        modded_starts = modded_starts or {}
        modded_starts[#modded_starts+1] = {n=G.UIT.R, config={align = "cl", maxw = 3.5}, nodes= localize{type = 'text', key = 'ch_m_'..v.key, vars = {v.value}, default_col = G.C.L_BLACK}}
        
        else
        start_rules[#start_rules+1] = {n=G.UIT.R, config={align = "cl", maxw =3.5}, nodes= localize{type = 'text', key = 'ch_m_'..v.key, vars = {v.value}, default_col = not v.custom and G.C.UI.TEXT_INACTIVE or nil}}
        end
    end
    
    if modded_starts then
        start_rules = {
        modded_starts and {n=G.UIT.R, config={align = "cl", padding = 0.05}, nodes=modded_starts} or nil,
        {n=G.UIT.R, config={align = "cl", padding = 0.05, colour = G.C.GREY}, nodes={}},
        {n=G.UIT.R, config={align = "cl", padding = 0.05}, nodes=start_rules},
        }
    end
    
        if challenge.rules then
        if challenge.rules.custom then
            for k, v in ipairs(challenge.rules.custom) do
            game_rules[#game_rules+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_c_'..v.id, vars = {v.value}}}
            end  
        end
        end
        if (not start_rules[1]) and (not modded_starts) then  start_rules[#start_rules+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_m_none', vars = {}}} end
        if not game_rules[1] then  game_rules[#game_rules+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_c_none', vars = {}}} end
    
        local starting_rule_list = {n=G.UIT.C, config={align = "cm", minw = 3, r = 0.1, colour = G.C.BLUE}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
            {n=G.UIT.T, config={text = localize('k_game_modifiers'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minh = 4.1, minw = 4.2, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes= start_rules}
        }}
    
        local override_rule_list = {n=G.UIT.C, config={align = "cm", minw = 3, r = 0.1, colour = G.C.BLUE}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
            {n=G.UIT.T, config={text = localize('k_custom_rules'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minh = 4.1, minw = 6.8, maxw = 6.7, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes= game_rules}
        }}
    
        return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.L_BLACK, r = 0.1, minw = 3}, nodes={
            override_rule_list,starting_rule_list
        }}
        }}
    elseif args._tab == 'Restrictions' then
        local challenge = G.CHALLENGES[args._id]
    
        local banned_cards, banned_tags, banned_other = {}, {}, {}
    
        if challenge.restrictions then
        if challenge.restrictions.banned_cards then
            local row_cards = {}
            local n_rows = math.max(1, math.floor(#challenge.restrictions.banned_cards/10) + 2 - math.floor(math.log(6, #challenge.restrictions.banned_cards)))
            local max_width = 1
            for k, v in ipairs(challenge.restrictions.banned_cards) do
            local _row = math.floor((k-1)*n_rows/(#challenge.restrictions.banned_cards)+1)
            row_cards[_row] = row_cards[_row] or {}
            row_cards[_row][#row_cards[_row]+1] = v
            if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
            end
    
            local card_size = math.max(0.3, 0.75 - 0.01*(max_width*n_rows))
    
            for _, row_card in ipairs(row_cards) do
            local banned_card_area = CardArea(
                0,0,
                6.7,
                3.3/n_rows,
                {card_limit = nil, type = 'title_2', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*card_size})
            table.insert(banned_cards, 
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.O, config={object = banned_card_area}}
            }}
            )
            for k, v in ipairs(row_card) do
                local card = Card(0,0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v.id], {bypass_discovery_center = true,bypass_discovery_ui = true})
                banned_card_area:emplace(card)
            end
            end
        end
        if challenge.restrictions.banned_tags then
            local tag_tab = {}
            for k, v in pairs(challenge.restrictions.banned_tags) do
            tag_tab[#tag_tab+1] = G.P_TAGS[v.id]
            end
        
            table.sort(tag_tab, function (a, b) return a.order < b.order end)
    
            for k, v in ipairs(tag_tab) do
            local temp_tag = Tag(v.key)
            local temp_tag_ui = temp_tag:generate_UI(1.1 - 0.25*(math.sqrt(#challenge.restrictions.banned_tags)))
            table.insert(banned_tags, 
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                temp_tag_ui
            }}
            )
            end
        end
        end
        if not banned_cards[1] then  banned_cards[#banned_cards+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_m_none', vars = {}}} end
        if not banned_tags[1] then  banned_tags[#banned_tags+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_c_none', vars = {}}} end
        if not banned_other[1] then  banned_other[#banned_other+1] = {n=G.UIT.R, config={align = "cl"}, nodes= localize{type = 'text', key = 'ch_c_none', vars = {}}} end
    
        local banned_cards = {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.RED}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
            {n=G.UIT.T, config={text = localize('k_banned_cards'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minh = 4.1, minw =7.33, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes= 
            banned_cards
        }
        }}
    
        local banned_tags = {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.RED}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6, maxw = 1.48}, nodes={
            {n=G.UIT.T, config={text =  localize('k_banned_tags'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minh = 4.1, minw = 1.48, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes= 
        banned_tags}
        }}
    
        local banned_other = {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.RED}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6, maxw = 1.84}, nodes={
            {n=G.UIT.T, config={text = localize('k_other'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minh = 4.1, minw = 2, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes= 
        banned_other}
        }}
    
        return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.L_BLACK, r = 0.1}, nodes={
            banned_cards, banned_tags, banned_other
        }}
        }}
    elseif args._tab == 'Deck' then
        local challenge = G.CHALLENGES[args._id]
        local deck_tables = {}
        local SUITS = {
        S = {},
        H = {},
        C = {},
        D = {},
        }
        local suit_map = {'S', 'H', 'C', 'D'}
        local card_protos = nil
        local _de = nil
        if challenge then
            _de = challenge.deck
        end
    
        if _de and _de.cards then
            card_protos = _de.cards
        end
    
        if not card_protos then 
            card_protos = {}
            for k, v in pairs(G.P_CARDS) do
                local _r, _s = string.sub(k, 3, 3), string.sub(k, 1, 1)
                local keep, _e, _d, _g = true, nil, nil, nil
                if _de then
                    if _de.yes_ranks and not _de.yes_ranks[_r] then keep = false end
                    if _de.no_ranks and _de.no_ranks[_r] then keep = false end
                    if _de.yes_suits and not _de.yes_suits[_s] then keep = false end
                    if _de.no_suits and _de.no_suits[_s] then keep = false end
                    if _de.enhancement then _e = _de.enhancement end
                    if _de.edition then _d = _de.edition end
                    if _de.seal then _g = _de.seal end
                end
                
                if _r == 'C' then keep = false end
                
                if keep then card_protos[#card_protos+1] = {s=_s,r=_r,e=_e,d=_d,g=_g} end
            end
        end 
        for k, v in ipairs(card_protos) do
        local _card = Card(0,0, G.CARD_W*0.45, G.CARD_H*0.45, G.P_CARDS[v.s..'_'..v.r], G.P_CENTERS[v.e or 'c_base'])
        if v.d then _card:set_edition({[v.d] = true}, true, true) end
        if v.g then _card:set_seal(v.g, true, true) end
        SUITS[v.s][#SUITS[v.s]+1] = _card
        end
    
    for j = 1, 4 do
        if SUITS[suit_map[j]][1] then
        table.sort(SUITS[suit_map[j]], function(a,b) return a:get_nominal() > b:get_nominal() end )
        local view_deck = CardArea(
            0,0,
            5.5*G.CARD_W,
            0.42*G.CARD_H,
            {card_limit = #SUITS[suit_map[j]], type = 'title_2', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*0.5, draw_layers = {'card'}})
        table.insert(deck_tables, 
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.O, config={object = view_deck}}
        }}
        )
    
        for i = 1, #SUITS[suit_map[j]] do
            if SUITS[suit_map[j]][i] then
            view_deck:emplace(SUITS[suit_map[j]][i])
            end
        end
        end
    end
        return {n=G.UIT.ROOT, config={align = "cm", padding = 0, colour = G.C.BLACK, r = 0.1, minw = 11.4, minh = 4.2}, nodes=deck_tables}
    end
end

----------------------------------------------
------------MOD CODE END----------------------
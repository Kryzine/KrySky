-- Custom Sky Hub - GUI Épica (OrionLib)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "🌌 Sky Hub v2.0",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SkyHub"
})

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- === PACK DE CÉUS INSANOS (50+ via JSON) ===
local Skies = {}
local success, response = pcall(function()
    Skies = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Kryzine/KrySky/main/skies.json"))
end)

if not success then
    Skies = {
        Default = { -- Fallback
            SkyboxBk = "", SkyboxDn = "", SkyboxFt = "", SkyboxLf = "", SkyboxRt = "", SkyboxUp = "",
            SunAngularSize = 15, StarCount = 0, MoonTextureId = "", CelestialBodiesShown = false
        }
    }
end

local CurrentSky = nil
local CurrentSkyObj = nil

-- Função para Aplicar Céu
local function ApplySky(skyData)
    if CurrentSkyObj then CurrentSkyObj:Destroy() end
    
    CurrentSkyObj = Instance.new("Sky")
    CurrentSkyObj.Parent = Lighting
    
    CurrentSkyObj.SkyboxBk = skyData.SkyboxBk or ""
    CurrentSkyObj.SkyboxDn = skyData.SkyboxDn or ""
    CurrentSkyObj.SkyboxFt = skyData.SkyboxFt or ""
    CurrentSkyObj.SkyboxLf = skyData.SkyboxLf or ""
    CurrentSkyObj.SkyboxRt = skyData.SkyboxRt or ""
    CurrentSkyObj.SkyboxUp = skyData.SkyboxUp or ""
    
    CurrentSkyObj.SunAngularSize = skyData.SunAngularSize or 15
    CurrentSkyObj.StarCount = skyData.StarCount or 1000
    CurrentSkyObj.MoonTextureId = skyData.MoonTextureId or ""
    CurrentSkyObj.CelestialBodiesShown = skyData.CelestialBodiesShown or true
    
    -- Remove outros skies
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") and obj ~= CurrentSkyObj then
            obj:Destroy()
        end
    end
    
    CurrentSky = skyData
    OrionLib:MakeNotification({
        Name = "Sky Hub",
        Content = "Céu '" .. (skyData.Name or "Custom") .. "' Aplicado! ✨",
        Image = "rbxassetid://4483345998",
        Time = 4
    })
end

-- === ABA 1: CÉUS ===
local SkyTab = Window:MakeTab({
    Name = "🌌 Céus Insanos",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local SkyDropdown = SkyTab:AddDropdown({
    Name = "👑 Escolha um Céu:",
    Default = "Nebula Galaxy",
    Options = (function()
        local opts = {}
        for name, _ in pairs(Skies) do
            table.insert(opts, name)
        end
        table.sort(opts)
        return opts
    end)(),
    Callback = function(Value)
        ApplySky(Skies[Value])
    end    
})
SkyTab:AddButton({
    Name = "🎲 Randomizar Céu",
    Callback = function()
        local keys = {}
        for k in pairs(Skies) do table.insert(keys, k) end
        local rand = keys[math.random(1, #keys)]
        SkyDropdown:Set(rand)
    end
})
SkyTab:AddButton({
    Name = "🔄 Restaurar Default",
    Callback = function()
        SkyDropdown:Set("Default")
    end
})

-- === ABA 2: CONFIGS ===
local ConfigTab = Window:MakeTab({
    Name = "⚙️ Configs Avançadas",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

ConfigTab:AddSlider({
    Name = "⭐ Qtd Estrelas",
    Min = 0,
    Max = 5000,
    Default = 1000,
    Color = Color3.fromRGB(255,255,255),
    Increment = 100,
    ValueName = "Estrelas",
    Callback = function(Value)
        if CurrentSkyObj then
            CurrentSkyObj.StarCount = Value
        end
    end    
})
ConfigTab:AddSlider({
    Name = "☀️ Tamanho Sol",
    Min = 0,
    Max = 50,
    Default = 15,
    Color = Color3.fromRGB(255,170,0),
    Increment = 1,
    ValueName = "Graus",
    Callback = function(Value)
        if CurrentSkyObj then
            CurrentSkyObj.SunAngularSize = Value
        end
    end    
})
ConfigTab:AddToggle({
    Name = "🌙 Mostrar Corpos Celestes",
    Default = true,
    Callback = function(Value)
        if CurrentSkyObj then
            CurrentSkyObj.CelestialBodiesShown = Value
        end
    end    
})

ConfigTab:AddButton({
    Name = "🗑️ Remover Céu",
    Callback = function()
        if CurrentSkyObj then
            CurrentSkyObj:Destroy()
            CurrentSkyObj = nil
        end
        OrionLib:MakeNotification({
            Name = "Sky Hub", Content = "Céu Removido!", Time = 3
        })
    end
})

-- Carrega Default
ApplySky(Skies["Nebula Galaxy"] or Skies.Default)

OrionLib:Init()
print("🌌 Sky Hub Carregado! Feito com ❤️")

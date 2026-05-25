if (not LPH_OBFUSCATED) then
      LPH_ENCNUM = function(toEncrypt, ...)
          assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
          return toEncrypt
      end
      LPH_NUMENC = LPH_ENCNUM
  
      LPH_ENCSTR = function(toEncrypt, ...)
          assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
          return toEncrypt
      end
      LPH_STRENC = LPH_ENCSTR
  
      LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
          assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
          return toEncrypt
      end
      LPH_FUNCENC = LPH_ENCFUNC
  
      LPH_JIT = function(f, ...)
          assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
          return f
      end
      LPH_JIT_MAX = LPH_JIT
  
      LPH_NO_VIRTUALIZE = function(f, ...)
          assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
          return f
      end
  
      LPH_NO_UPVALUES = function(f, ...)
          assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
          assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")
          return f
      end
  
      LPH_CRASH = function(...)
          assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
      end
  end
  
  local Cheat = { GameName = 'None', Modules = { }, Globals = { } }
  
  game:GetService("ScriptContext").Error:Connect(function(msg, trace, scr)
      if not scr or trace:find("''") or msg:find("''") or trace:find('ChocoSploit') or msg:find('ChocoSploit') then
          game:GetService("Players").LocalPlayer:Kick('error detected\n' .. msg)
      end
  end)
  
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LunarSync1515/velo/refs/heads/main/ui.lua"))()

Library:Notification("Loading Bypass", 4, 5)
task.wait(4.6)
Library:Notification("✓ Bypass Loaded Successfully", 4.5)

local flags = Library.Flags
local Window = Library:Window({Name = 'Aether', Logo = '87697542892608'})

  local VisualsPage = Window:Page({Name = 'Visuals'})

  local Debris, Players, Workspace, GuiService, RunService, UserInputService, ReplicatedStorage, Lighting, HttpService = game:GetService('Debris'), game:GetService('Players'), game:GetService('Workspace'), game:GetService('GuiService'), game:GetService('RunService'), game:GetService('UserInputService'), game:GetService('ReplicatedStorage'), game:GetService('Lighting'), game:GetService('HttpService')
  
  Cheat.Globals.HitSoundNames = {}
  Cheat.Globals.QuickStackFunctions = {}
  Cheat.Globals.HitSoundIds = {}
  Cheat.Globals.DesyncParts = {}
  Cheat.Globals.DesyncedPositions = {}
  
  Cheat.Globals.LastManip = tick()
  Cheat.Globals.LastAutoReload = tick()
  
      --// Visuals
    do
        do --// Players
            local className = 'Players'
            local PlayersMain = VisualsPage:Section({Name = className, Side = 1})

            PlayersMain:Toggle({
                Name = "Enable",
                Flag = className .. "ESPEnabled",
            })

            PlayersMain:Toggle({
                Name = "Boxes",
                Flag = className .. "Boxes",
            })
            PlayersMain:Label("Box Colors")
            PlayersMain:Label("Color 1"):Colorpicker({
                Name = "Color 1",
                Flag = className .. "BoxColor1",
                Default = Color3.fromRGB(90,120,255),
            })
            PlayersMain:Label("Color 2"):Colorpicker({
                Name = "Color 2",
                Flag = className .. "BoxColor2",
                Default = Color3.fromRGB(180,90,255),
            })

            PlayersMain:Toggle({
                Name = "Chams",
                Flag = className .. "Chams",
            })

            PlayersMain:Label("Chams Fill"):Colorpicker({
                Name = "Color 1",
                Flag = className .. "ChamsColor1",
                Alpha = 0.5,
                Default = Color3.fromRGB(90,120,255),
            })
            PlayersMain:Label("Chams Outline"):Colorpicker({
                Name = "Color 2",
                Flag = className .. "ChamsColor2",
                Alpha = 0,
                Default = Color3.fromRGB(180,90,255),
            })


            PlayersMain:Toggle({
                Name = "Names",
                Flag = className .. "Names",
            }):Colorpicker({
                Name = "Name Color",
                Flag = className .. "NameColor",
                Default = Color3.fromRGB(255,255,255),
            })

            PlayersMain:Toggle({
                Name = "Health Bar",
                Flag = className .. "Health",
            })
            PlayersMain:Label("Health Colors")
            PlayersMain:Label("Color 1"):Colorpicker({
                Name = "Health Color 1",
                Flag = className .. "HealthColor1",
                Default = Color3.fromRGB(255,70,70),
            })
            PlayersMain:Label("Color 2"):Colorpicker({
                Name = "Health Color 2",
                Flag = className .. "HealthColor2",
                Default = Color3.fromRGB(255,220,70),
            })
            PlayersMain:Label("Color 3"):Colorpicker({
                Name = "Health Color 3",
                Flag = className .. "HealthColor3",
                Default = Color3.fromRGB(80,255,120),
            })

            PlayersMain:Toggle({
                Name = "Distance",
                Flag = className .. "Distance",
            }):Colorpicker({
                Name = "Distance Color",
                Flag = className .. "DistanceColor",
                Default = Color3.fromRGB(255,255,255),
            })

            PlayersMain:Toggle({
                Name = "Weapon",
                Flag = className .. "Weapon",
            }):Colorpicker({
                Name = "Weapon Color",
                Flag = className .. "WeaponColor",
                Default = Color3.fromRGB(255,255,255),
            })
            
            PlayersMain:Slider({
                Name = "Max Distance (studs)",
                Flag = className .. "MaxDistance",
                Min = 20,
                Max = 10000,
                Default = 10000,
                Decimals = 1,
            })
        end
          do --// Boss
              local className = 'Boss'
              local PlayersMain = VisualsPage:Section({Name = className, Side = 1})
  
              PlayersMain:Toggle({
                  Name = "Enable",
                  Flag = className .. "ESPEnabled",
              })
  
              PlayersMain:Toggle({
                  Name = "Boxes",
                  Flag = className .. "Boxes",
              })
              PlayersMain:Label("Color 1"):Colorpicker({
                  Name = "Color 1",
                  Flag = className .. "BoxColor1",
                  Default = Color3.fromRGB(90,120,255),
              })
              PlayersMain:Label("Color 2"):Colorpicker({
                  Name = "Color 2",
                  Flag = className .. "BoxColor2",
                  Default = Color3.fromRGB(180,90,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Names",
                  Flag = className .. "Names",
              }):Colorpicker({
                  Name = "Name Color",
                  Flag = className .. "NameColor",
                  Default = Color3.fromRGB(255,255,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Health Bar",
                  Flag = className .. "Health",
              })
              PlayersMain:Label("Color 1"):Colorpicker({
                  Name = "Health Color 1",
                  Flag = className .. "HealthColor1",
                  Default = Color3.fromRGB(255,70,70),
              })
              PlayersMain:Label("Color 2"):Colorpicker({
                  Name = "Health Color 2",
                  Flag = className .. "HealthColor2",
                  Default = Color3.fromRGB(255,220,70),
              })
              PlayersMain:Label("Color 3"):Colorpicker({
                  Name = "Health Color 3",
                  Flag = className .. "HealthColor3",
                  Default = Color3.fromRGB(80,255,120),
              })
  
              PlayersMain:Toggle({
                  Name = "Distance",
                  Flag = className .. "Distance",
              }):Colorpicker({
                  Name = "Distance Color",
                  Flag = className .. "DistanceColor",
                  Default = Color3.fromRGB(255,255,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Weapon",
                  Flag = className .. "Weapon",
              }):Colorpicker({
                  Name = "Weapon Color",
                  Flag = className .. "WeaponColor",
                  Default = Color3.fromRGB(255,255,255),
              })
              
              PlayersMain:Slider({
                  Name = "Max Distance (studs)",
                  Flag = className .. "MaxDistance",
                  Min = 20,
                  Max = 10000,
                  Default = 10000,
                  Decimals = 1,
              })
          end
          do --// AI
              local className = 'AI'
              local PlayersMain = VisualsPage:Section({Name = className, Side = 1})
  
              PlayersMain:Toggle({
                  Name = "Enable",
                  Flag = className .. "ESPEnabled",
              })
  
              PlayersMain:Toggle({
                  Name = "Boxes",
                  Flag = className .. "Boxes",
              })
              PlayersMain:Label("Color 1"):Colorpicker({
                  Name = "Color 1",
                  Flag = className .. "BoxColor1",
                  Default = Color3.fromRGB(90,120,255),
              })
              PlayersMain:Label("Color 2"):Colorpicker({
                  Name = "Color 2",
                  Flag = className .. "BoxColor2",
                  Default = Color3.fromRGB(180,90,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Names",
                  Flag = className .. "Names",
              }):Colorpicker({
                  Name = "Name Color",
                  Flag = className .. "NameColor",
                  Default = Color3.fromRGB(255,255,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Health Bar",
                  Flag = className .. "Health",
              })
              PlayersMain:Label("Color 1"):Colorpicker({
                  Name = "Health Color 1",
                  Flag = className .. "HealthColor1",
                  Default = Color3.fromRGB(255,70,70),
              })
              PlayersMain:Label("Color 2"):Colorpicker({
                  Name = "Health Color 2",
                  Flag = className .. "HealthColor2",
                  Default = Color3.fromRGB(255,220,70),
              })
              PlayersMain:Label("Color 3"):Colorpicker({
                  Name = "Health Color 3",
                  Flag = className .. "HealthColor3",
                  Default = Color3.fromRGB(80,255,120),
              })
  
              PlayersMain:Toggle({
                  Name = "Distance",
                  Flag = className .. "Distance",
              }):Colorpicker({
                  Name = "Distance Color",
                  Flag = className .. "DistanceColor",
                  Default = Color3.fromRGB(255,255,255),
              })
  
              PlayersMain:Toggle({
                  Name = "Weapon",
                  Flag = className .. "Weapon",
              }):Colorpicker({
                  Name = "Weapon Color",
                  Flag = className .. "WeaponColor",
                  Default = Color3.fromRGB(255,255,255),
              })
              
              PlayersMain:Slider({
                  Name = "Max Distance (studs)",
                  Flag = className .. "MaxDistance",
                  Min = 20,
                  Max = 10000,
                  Default = 10000,
                  Decimals = 1,
              })
          end
        do
            local MiscESPSection = VisualsPage:Section({Name = "Misc", Side = 2})
            MiscESPSection:Toggle({Name = "Enabled", Flag = "MiscEnabledESP"})
            for i, v in next, {'Stone', 'Metal', 'Phosphate', 'Wool', 'Animals', 'Care Package', 'Drops', 'Body Bag', 'Salvaged Flycopter', 'Auto Turret', 'Shotgun Turret'} do
                MiscESPSection:Toggle({Name = v, Flag = v .. "Enabled"}):Colorpicker({
                    Name = v .. " Color",
                    Flag = v .. "Color",
                })

                MiscESPSection:Slider({
                    Name = "Max Distance",
                    Flag = v .. "MaxDistance",
                    Min = 10,
                    Max = (v == 'Care Package' or v == 'Salvaged Flycopter') and 3000 or v == 'Body Bag' and 1000 or 400,
                    Default = (v == 'Care Package' or v == 'Salvaged Flycopter') and 3000 or 50,
                })
            end

        end
        do
            local MiscVisualsSection = VisualsPage:Section({Name = "Misc Visuals", Side = 2})
            MiscVisualsSection:Toggle({
                Name = "Ambience",
                Flag = "AmbienceEnabled",
            }):Colorpicker({
                Name = "Color",
                Flag = "AmbienceColor",
                Default = Color3.fromRGB(255, 255, 255),
            })

            MiscVisualsSection:Slider({
                Name = "Brightness",
                Flag = "AmbienceBrightness",
                Min = 0,
                Max = 1,
                Default = 0.12,
                Decimals = 0.001,
            })

            MiscVisualsSection:Slider({
                Name = "Indoor Brightness",
                Flag = "AmbienceIndoorBrightness",
                Min = 0,
                Max = 1,
                Default = 0.035,
                Decimals = 0.001,
            })

            MiscVisualsSection:Toggle({
                Name = "Bullet Tracers",
                Flag = "BulletTracers",
            }):Colorpicker({
                Name = "Color",
                Flag = "BulletTracersColor",
                Default = Color3.fromRGB(255, 255, 255),
            })

            MiscVisualsSection:Slider({
                Name = "Duration",
                Flag = "BulletTracersDuration",
                Min = 1,
                Max = 5,
                Default = 2,
                Decimals = 1,
            })
        end
    end
  
  --// Game Code
  local Camera = Workspace.CurrentCamera
  local Client = Players.LocalPlayer
  
local wsVFXFolder = Workspace:WaitForChild("VFX", 5)
if not wsVFXFolder then
    warn("[Aether] Workspace.VFX not found, creating it.")
    wsVFXFolder = Instance.new("Folder")
    wsVFXFolder.Name = "VFX"
    wsVFXFolder.Parent = Workspace
end

local VMs = wsVFXFolder:FindFirstChild("VMs")
if not VMs then
    VMs = Instance.new("Folder")
    VMs.Name = "VMs"
    VMs.Parent = wsVFXFolder
end

local Drops = Workspace:FindFirstChild("Drops")
local Plants = Workspace:FindFirstChild("Plants")
local Animals = Workspace:FindFirstChild("Animals")
  
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("Modules", 5)
local rsVFXFolder = ReplicatedStorage:WaitForChild("VFX", 5)
local Values = ReplicatedStorage:WaitForChild("Values", 5)

if not Modules then
    warn("[Aether] ReplicatedStorage.Modules not found.")
    -- debug: show what *is* in ReplicatedStorage
    for _, c in ipairs(ReplicatedStorage:GetChildren()) do
        warn("[RS]", c.Name, c.ClassName)
    end
    return
end

if not rsVFXFolder then
    warn("[Aether] ReplicatedStorage.VFX not found.")
    -- you can return here too if you require it:
    -- return
end

if not Values then
    warn("[Aether] ReplicatedStorage.Values not found.")
    -- return if required
end
  
  local ItemClass = Modules and require(Modules:WaitForChild("ItemClass"))
  local VFXModule = Modules and require(Modules.VFXModule)
  local ItemsModule = Modules and require(Modules.Items)
  local RaycastUtil = Modules and require(Modules.RaycastUtil)
  local SettingsModule = Modules and require(Modules.SettingsModule)
  local SoundModule = Modules and require(Modules.SoundModule)
  local ToolInfo = Modules and require(Modules.ToolInfo)
  
  if not (ItemClass and VFXModule and ItemsModule and RaycastUtil and SettingsModule and SoundModule) then
      Client:Kick("Failed to load game modules.")
      return
  end
  
  local clanController, clanControllerShared
  if Client:FindFirstChild("PlayerScripts") and Client.PlayerScripts:FindFirstChild("ClanController") then
      clanController = getsenv(Client.PlayerScripts:WaitForChild("ClanController"))
      clanControllerShared = clanController and clanController.shared
  else
      clanControllerShared = {cachedTeamModels = {}}
  end
  
  local isTeam = LPH_NO_VIRTUALIZE(function(player)
      if typeof(player) ~= 'Instance' or not player:IsA('Player') then return false end
      local teamCache = clanControllerShared and clanControllerShared.cachedTeamModels
      return teamCache and teamCache[player.UserId] or false
  end)
  
  local getgun = function(character)
      if not character then return "None" end
      for _, model in character:GetChildren() do
          if not model:IsA('Model') then
              continue
          end
  
          if model.Name == 'Hair' or model.Name == 'HolsterModel' then
              continue
          end
  
          if not model.PrimaryPart then
              continue
          end
  
          if model:FindFirstChild("Detail") or model:FindFirstChild("Main") or model:FindFirstChild("Handle") or model:FindFirstChild("Attachments") or model:FindFirstChild("ArrowAttach") or model:FindFirstChild("Attach") then
              return model.Name
          end;
      end;
  
      return "None"
  end
  
local Targeting = {
    TargetPart = nil,
    TargetCharacter = nil,
    ManipulatedPosition = nil,
    ManipPos = nil,
    Targets = {},
}

  do --// Visuals
      --// Player ESP
      do
          local ESP = {}
  
          local ScreenGui = Instance.new('ScreenGui')
          ScreenGui.IgnoreGuiInset = true
          ScreenGui.Parent = gethui()
  
          local OUTLINE = 1
          local BOX_THICKNESS = 2
          local NAME_PADDING_X = 6
          local NAME_PADDING_Y = 2
  
          local function BoxMath(item)
              if not item then return nil, nil, false end
              local Torso =
                  item:FindFirstChild('HumanoidRootPart')
                  or item:FindFirstChild('UpperTorso')
                  or item:FindFirstChild('Torso')
              if not Torso then return nil, nil, false end
              local cf = Torso.CFrame
              local pos = Torso.Position
              local vTop = pos + (cf.UpVector * 2)
              local vBottom = pos - (cf.UpVector * 2.8)
              local top, topVisible = Camera:WorldToViewportPoint(vTop)
              local bottom, bottomVisible = Camera:WorldToViewportPoint(vBottom)
              if not topVisible and not bottomVisible then return nil, nil, false end
              local height = math.abs(bottom.Y - top.Y)
              if height <= 0 then return nil, nil, false end
              local width = height / 1.2
              return Vector2.new(
                  math.floor((top.X + bottom.X) * 0.5 - width * 0.5),
                  math.min(top.Y, bottom.Y)
              ), Vector2.new(width, height), true
          end
  
          local function createBox(parent, color)
              local box = Instance.new('Frame')
              box.BackgroundTransparency = 1
              box.Parent = parent
              local sides = {}
              for i = 1, 4 do
                  local f = Instance.new('Frame')
                  f.BorderSizePixel = 0
                  f.BackgroundColor3 = color
                  f.Parent = box
                  sides[i] = f
              end
              return box, sides
          end
  
          local function newText()
              local t = Instance.new('TextLabel')
              t.BackgroundTransparency = 1
              t.TextColor3 = Color3.new(1,1,1)
              t.TextTransparency = 0
              t.TextStrokeColor3 = Color3.new(0,0,0)
              t.TextStrokeTransparency = 0
              t.FontFace = Library.Font
              t.TextSize = 11
              t.TextXAlignment = Enum.TextXAlignment.Center
              t.TextYAlignment = Enum.TextYAlignment.Center
              return t
          end
  
          local function createESP(char, name, classname)
              local holder = Instance.new('Frame')
              holder.BackgroundTransparency = 1
              holder.Visible = false
              holder.Parent = ScreenGui
  
              local nameText = newText()
              nameText.Text = name
              nameText.Parent = holder
  
              local boxGroup = Instance.new('Frame')
              boxGroup.BackgroundTransparency = 1
              boxGroup.Parent = holder
  
              local outerBox, outerSides = createBox(boxGroup, Color3.new(0,0,0))
              local gradBox, gradSides = createBox(boxGroup, Color3.new(1,1,1))
              local innerBox, innerSides = createBox(boxGroup, Color3.new(0,0,0))
  
              local gradients = {}
              for i = 1, 4 do
                  local g = Instance.new('UIGradient')
                  g.Rotation = 90
                  g.Parent = gradSides[i]
                  gradients[i] = g
              end
  
              local healthBack = Instance.new('Frame')
              healthBack.BackgroundTransparency = 1
              healthBack.BorderSizePixel = 0
              healthBack.Parent = holder
  
              local healthOutline = Instance.new('Frame')
              healthOutline.BackgroundColor3 = Color3.new(0,0,0)
              healthOutline.BorderSizePixel = 0
              healthOutline.Parent = healthBack
  
              local healthInner = Instance.new('Frame')
              healthInner.BackgroundColor3 = Color3.fromRGB(35,35,35)
              healthInner.BorderSizePixel = 0
              healthInner.Parent = healthBack
  
              local healthFillHolder = Instance.new('Frame')
              healthFillHolder.BackgroundTransparency = 1
              healthFillHolder.BorderSizePixel = 0
              healthFillHolder.ClipsDescendants = true
              healthFillHolder.Parent = healthInner
  
              local healthFill = Instance.new('Frame')
              healthFill.BorderSizePixel = 0
              healthFill.AnchorPoint = Vector2.new(0,1)
              healthFill.Position = UDim2.fromScale(0,1)
              healthFill.Size = UDim2.fromScale(1,1)
              healthFill.BackgroundColor3 = Color3.new(1,1,1)
              healthFill.Parent = healthFillHolder
  
              local healthGradient = Instance.new('UIGradient')
              healthGradient.Rotation = 90
              healthGradient.Parent = healthFill
  
              local distText = newText()
              distText.Parent = holder

              local hpText = newText()
              hpText.Text = "HP: 0"
              hpText.Parent = holder
  
              local weaponText = newText()
              weaponText.Text = '[None]'
              weaponText.Parent = holder
  
              local cham = Instance.new('Highlight')
              cham.Parent = ScreenGui
              cham.Adornee = char
              cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  
              ESP[char] = {
                  Holder = holder,
                  Name = nameText,
                  BoxGroup = boxGroup,
                  OuterBox = outerBox,
                  OuterSides = outerSides,
                  GradBox = gradBox,
                  GradSides = gradSides,
                  Gradients = gradients,
                  InnerBox = innerBox,
                  InnerSides = innerSides,
                  HealthBack = healthBack,
                  HealthOutline = healthOutline,
                  HealthInner = healthInner,
                  HealthFillHolder = healthFillHolder,
                  HealthFill = healthFill,
                  HealthGradient = healthGradient,
                  Distance = distText,
                  Weapon = weaponText,
                  HP = hpText,
                  Class = classname,
                  Cham = cham
              }
          end
  
          local function sizeSides(sides, w, h, t)
              sides[1].Position = UDim2.fromOffset(0,0)
              sides[1].Size = UDim2.fromOffset(w, t)
              sides[2].Position = UDim2.fromOffset(0, h - t)
              sides[2].Size = UDim2.fromOffset(w, t)
              sides[3].Position = UDim2.fromOffset(0,0)
              sides[3].Size = UDim2.fromOffset(t, h)
              sides[4].Position = UDim2.fromOffset(w - t,0)
              sides[4].Size = UDim2.fromOffset(t, h)
          end
  
          RunService.RenderStepped:Connect(function()
              for char, e in pairs(ESP) do
                  local class = e.Class
                  if not flags[class .. 'ESPEnabled'] then
                      e.Holder.Visible = false
                      if e.Cham then
                          e.Cham.Enabled = false
                      end
                      continue
                  end
  
                  local hum = char:FindFirstChildOfClass('Humanoid')
                  if not hum or hum.Health <= 0 then
                      e.Holder.Visible = false
                      if e.Cham then
                          e.Cham.Enabled = false
                      end
                      continue
                  end
  
                  local pos, size, ok = BoxMath(char)
                  if not ok then
                      e.Holder.Visible = false
                      if e.Cham then
                          e.Cham.Enabled = false
                      end
                      continue
                  end
                  local distance = (Camera.CFrame.Position - char:GetPivot().Position).Magnitude
                  if distance > flags[class .. 'MaxDistance'] then
                      e.Holder.Visible = false
                      if e.Cham then
                          e.Cham.Enabled = false
                      end
                      continue
                  end
  
                  local barW = 4
                  local gap = 4
                  local reservedLeft = barW + gap + OUTLINE
  
                  e.Holder.Position = UDim2.fromOffset(pos.X - reservedLeft, pos.Y)
                  e.Holder.Visible = true
  
                  e.BoxGroup.Position = UDim2.fromOffset(reservedLeft, 0)
                  e.BoxGroup.Size = UDim2.fromOffset(size.X, size.Y)
  
                  e.Name.Position = UDim2.fromOffset(reservedLeft - NAME_PADDING_X, -15 - NAME_PADDING_Y)
                  e.Name.Size = UDim2.fromOffset(size.X + NAME_PADDING_X*2, 14 + NAME_PADDING_Y*2)
                  e.Name.Visible = flags[class .. 'Names']
                  e.Name.TextColor3 = flags[class .. 'NameColor'].Color
  
                  e.OuterBox.Position = UDim2.fromOffset(-OUTLINE, -OUTLINE)
                  e.OuterBox.Size = UDim2.fromOffset(size.X + OUTLINE*2, size.Y + OUTLINE*2)
                  sizeSides(e.OuterSides, size.X + OUTLINE*2, size.Y + OUTLINE*2, OUTLINE)
  
                  e.GradBox.Position = UDim2.fromOffset(0,0)
                  e.GradBox.Size = UDim2.fromOffset(size.X, size.Y)
                  sizeSides(e.GradSides, size.X, size.Y, BOX_THICKNESS)
  
                  e.InnerBox.Position = UDim2.fromOffset(OUTLINE, OUTLINE)
                  e.InnerBox.Size = UDim2.fromOffset(size.X - OUTLINE*2, size.Y - OUTLINE*2)
                  sizeSides(e.InnerSides, size.X - OUTLINE*2, size.Y - OUTLINE*2, OUTLINE)
  
                  local on = flags[class .. 'Boxes']
                  e.OuterBox.Visible = on
                  e.GradBox.Visible = on
                  e.InnerBox.Visible = on
  
                  for _, g in ipairs(e.Gradients) do
                      g.Color = ColorSequence.new({
                          ColorSequenceKeypoint.new(0, flags[class .. 'BoxColor1'].Color),
                          ColorSequenceKeypoint.new(1, flags[class .. 'BoxColor2'].Color),
                      })
                  end
  
                  e.HealthBack.Visible = flags[class .. 'Health']
                  e.HealthBack.Position = UDim2.fromOffset(reservedLeft - barW - gap, 0)
                  e.HealthBack.Size = UDim2.fromOffset(barW, size.Y)
  
                  e.HealthOutline.Position = UDim2.fromOffset(0,0)
                  e.HealthOutline.Size = UDim2.fromOffset(barW, size.Y)
  
                  e.HealthInner.Position = UDim2.fromOffset(1,1)
                  e.HealthInner.Size = UDim2.fromOffset(barW - 2, size.Y - 2)
  
                  e.HealthFillHolder.Position = UDim2.fromOffset(0,0)
                  e.HealthFillHolder.Size = UDim2.fromScale(1,1)
  
local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

                  e.HP.Text = math.floor(hum.Health)
                  e.HP.TextColor3 = Color3.fromRGB(0,255,0)

                  e.HealthFill.Size = UDim2.fromScale(1, hp)

                  -- THE AUTO-SCALING DISTANCE FIX
                  e.HP.AnchorPoint = Vector2.new(1, 0.5) -- Anchors from middle-right of the text
                  e.HP.Size = UDim2.fromScale(2.5, 0.2) -- Size scales relatively with the ESP box size

                  -- Positions it perfectly on the left side, exactly halfway (0.5) down the bar
                  e.HP.Position = UDim2.new(0, reservedLeft - barW - gap - 2, 0.5, 0)
                  
                  e.HP.TextXAlignment = Enum.TextXAlignment.Right -- Aligns text cleanly against the bar
                  e.HP.TextYAlignment = Enum.TextYAlignment.Center
  
                  e.HealthGradient.Color = ColorSequence.new({
                      ColorSequenceKeypoint.new(0, flags[class .. 'HealthColor1'].Color),
                      ColorSequenceKeypoint.new(0.5, flags[class .. 'HealthColor2'].Color),
                      ColorSequenceKeypoint.new(1, flags[class .. 'HealthColor3'].Color),
                  })
  
                  if class == 'Players' then
                      if flags[class .. 'Chams'] and e.Cham then
                          e.Cham.Enabled = true
                          e.Cham.FillColor = flags[class .. 'ChamsColor1'].Color
                          e.Cham.OutlineColor = flags[class .. 'ChamsColor2'].Color
                          e.Cham.FillTransparency = flags[class .. 'ChamsColor1'].Transparency
                          e.Cham.OutlineTransparency = flags[class .. 'ChamsColor2'].Transparency
                      else
                          e.Cham.Enabled = false
                      end
                  end
  
                  e.Distance.Position = UDim2.fromOffset(reservedLeft, size.Y + 6)
                  e.HP.Visible = flags[class .. 'Health']
                  e.Distance.Size = UDim2.fromOffset(size.X, 14)
                  e.Distance.Visible = flags[class .. 'Distance']
                  e.Distance.Text = math.floor(distance) .. ' studs'
                  e.Distance.TextColor3 = flags[class .. 'DistanceColor'].Color
  
                  e.Weapon.Position = UDim2.fromOffset(reservedLeft, size.Y + 20)
                  e.Weapon.Size = UDim2.fromOffset(size.X, 14)
                  e.Weapon.Visible = flags[class .. 'Weapon']
                  e.Weapon.Text = `[{getgun(char)}]`
                  e.Weapon.TextColor3 = flags[class .. 'WeaponColor'].Color
              end
          end)
  
          local function hookPlayer(p)
              if p == Client then return end
              p.CharacterAdded:Connect(function(c) createESP(c, p.Name, 'Players') end)
              p.CharacterRemoving:Connect(function(c) 
                  local e = ESP[c]
                  if e then 
                      e.Holder:Destroy() 
                      ESP[c] = nil
                      if e.Cham then
                          e.Cham:Destroy()
                      end
                  end 
              end)
              if p.Character then 
                  createESP(p.Character, p.Name, 'Players') 
              end
          end
  
          for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
          Players.PlayerAdded:Connect(hookPlayer)
          Players.PlayerRemoving:Connect(function(p)
              if p.Character and ESP[p.Character] then 
                  local e = ESP[p.Character]
                  e.Holder:Destroy()
                  ESP[p.Character]=nil 
                  if e.Cham then
                      e.Cham.Enabled = false
                  end
              end
          end)
  
          local SoldierClassType = {
              Brutus = "Boss",
              Bruno = "Boss",
              BTR = "Boss",
              Boris = "Boss",
              Soldier = "AI",
          }
  
          local Military = workspace:FindFirstChild('Military')
          local Events = workspace:FindFirstChild('Events')
  
          if Military and Events then
              local function CacheSoldier(model)
                  if (not model) or (not model.Parent) then return end
                  local classType = SoldierClassType[model.Name]
                  if not classType then return end
                  if ESP[model] then return end
                  createESP(model, model.Name, classType)
              end
  
              local function OnModelAdded(model)
                  task.defer(function()
                      if model and model.Parent then
                          CacheSoldier(model)
                      end
                  end)
              end
  
              local function OnModelRemoved(model)
                  if model and ESP[model] then ESP[model].Holder:Destroy() ESP[model]=nil end
              end
  
              for _, obj in ipairs(Events:GetChildren()) do
                  if obj.Name == 'BTR' then
                      CacheSoldier(obj)
                  end
              end
  
              Events.ChildAdded:Connect(function(obj)
                  if obj.Name == 'BTR' then
                      OnModelAdded(obj)
                  end
              end)
  
              Events.ChildRemoved:Connect(function(obj)
                  if obj.Name == 'BTR' then
                      OnModelRemoved(obj)
                  end
              end)
  
              for _, folder in ipairs(Military:GetChildren()) do
                  for _, soldier in ipairs(folder:GetChildren()) do
                      if soldier:IsA('Model') then
                          CacheSoldier(soldier)
                      end
                  end
  
                  folder.ChildAdded:Connect(function(soldier)
                      if soldier:IsA('Model') then
                          OnModelAdded(soldier)
                      end
                  end)
  
                  folder.ChildRemoved:Connect(function(soldier)
                      if soldier:IsA('Model') then
                          OnModelRemoved(soldier)
                      end
                  end)
              end
          end
      end
  
      --// Fov Circle
      do
          local FovCircleOutline = Drawing.new('Circle')
          FovCircleOutline.Visible = false
          FovCircleOutline.NumSides = 64
          FovCircleOutline.ZIndex = 9
          FovCircleOutline.Filled = false
          FovCircleOutline.Transparency = 1
          FovCircleOutline.Radius = 200
          FovCircleOutline.Thickness = 4
          FovCircleOutline.Color = Color3.fromRGB(0, 0, 0)
  
          local FovCircle = Drawing.new('Circle')
          FovCircle.Visible = false
          FovCircle.NumSides = 64
          FovCircle.ZIndex = 10
          FovCircle.Filled = false
          FovCircle.Transparency = 1
          FovCircle.Radius = 200
          FovCircle.Thickness = 2
          FovCircle.Color = Color3.fromRGB(255, 20, 147)
  
          local textHolder = Instance.new('Frame')
          textHolder.BackgroundTransparency = 1
          textHolder.BorderSizePixel = 0
          textHolder.ZIndex = 3
          textHolder.AnchorPoint = Vector2.new(0.5, 0)
          textHolder.Size = UDim2.fromOffset(0, 0)
          textHolder.Position = UDim2.new(0.5, 0, 0.5, 10)
          textHolder.AutomaticSize = Enum.AutomaticSize.XY
          textHolder.Visible = true
          textHolder.Parent = gethui()
  
          local layout = Instance.new('UIListLayout')
          layout.FillDirection = Enum.FillDirection.Vertical
          layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
          layout.VerticalAlignment = Enum.VerticalAlignment.Top
          layout.Padding = UDim.new(0, 2)
          layout.Parent = textHolder
  
          local manipulationText = Instance.new('TextLabel')
          manipulationText.BackgroundTransparency = 1
          manipulationText.Size = UDim2.fromOffset(0, 0)
          manipulationText.AutomaticSize = Enum.AutomaticSize.XY
          manipulationText.TextWrapped = false
          manipulationText.FontFace = Library.Font
          manipulationText.TextSize = 12
          manipulationText.TextColor3 = Color3.new(1, 1, 1)
          manipulationText.TextStrokeTransparency = 0.6
          manipulationText.ZIndex = textHolder.ZIndex
          manipulationText.Parent = textHolder
  
          local visibleText = Instance.new('TextLabel')
          visibleText.BackgroundTransparency = 1
          visibleText.Size = UDim2.fromOffset(0, 0)
          visibleText.AutomaticSize = Enum.AutomaticSize.XY
          visibleText.TextWrapped = false
          visibleText.FontFace = Library.Font
          visibleText.TextSize = 12
          visibleText.TextColor3 = Color3.new(1, 1, 1)
          visibleText.TextStrokeTransparency = 0.6
          visibleText.ZIndex = textHolder.ZIndex
          visibleText.Parent = textHolder
  
          RunService.RenderStepped:Connect(function()
              local radius = flags.FovSize or 200
              local thickness = flags.FovThickness or 2
  
              local vp = Camera.ViewportSize
              local pos = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
  
              -- local yOff = math.floor(radius + (thickness) + (textHolder.AbsoluteSize.Y > 0 and 0 or 0))
              -- textHolder.Position = UDim2.fromOffset(math.floor(pos.X), math.floor(pos.Y + yOff))
  
              if flags.CombatIndicators then
                  if Targeting.ManipulatedPosition then
                      manipulationText.Text = 'Manipulated'
                      manipulationText.TextColor3 = flags.ManipulationIndicatorColor.Color
                      manipulationText.Visible = true
                  else
                      manipulationText.Visible = false
                  end
                  
                  if Targeting.TargetObject and Targeting.TargetObject.CoreInformation and Targeting.TargetObject.CoreInformation.Visible then
                      visibleText.Text = "Visible"
                      visibleText.TextColor3 = flags.VisibleIndicatorColor.Color
                      visibleText.Visible = true
                  else
                      visibleText.Visible = false
                  end
              else
                  manipulationText.Visible = false
                  visibleText.Visible = false
              end
  
              if (not flags.FovEnabled) then
                  FovCircle.Visible = false
                  FovCircleOutline.Visible = false
                  return
              end
  
              local col = flags.FovColor
  
              FovCircle.Position = pos
              FovCircleOutline.Position = pos
  
              FovCircle.Radius = radius
              FovCircleOutline.Radius = radius
  
              FovCircle.Thickness = thickness
              FovCircleOutline.Thickness = thickness + 2
  
              if col then
                  FovCircle.Color = col.Color
                  FovCircle.Transparency = (col.Transparency or 0)
                  FovCircleOutline.Transparency = FovCircle.Transparency
              end
  
              FovCircle.Filled = (flags.FovFilled == true)
              FovCircleOutline.Filled = false
  
  
              FovCircle.Visible = true
              FovCircleOutline.Visible = true
          end)
      end
  

  --// Main Hooks
  do
      local OldRaycast = RaycastUtil.Raycast;
      RaycastUtil.Raycast = LPH_NO_VIRTUALIZE(function(self, ...)
          local Arguments = {...};
  
          if (not checkcaller()) then
              local Traceback = debug.traceback();
  
              if (Traceback and Traceback:find('ViewmodelController') and flags.Reach) then
                  Arguments[2] = Arguments[2] * 10
              end;
  
              if (flags.PerfectFarm) then
                  local Output = {OldRaycast(self, ...)};
                  local HitInstance  = Output[1];
                  local HitPosition = Output[2];
  
                  if (not HitInstance or typeof(HitInstance) ~= 'Instance') then
                      return unpack(Output);
                  end;
  
                  if (not HitPosition or typeof(HitPosition) ~= 'Vector3') then
                      return unpack(Output);
                  end;
  
                  local Model = HitInstance.Parent;
                  if (not Model or (not Model:IsA('Model'))) then
                      return unpack(Output);
                  end;
  
                  local Folder = Model.Parent;
                  if (Folder and (Folder.Name == 'Trees' or Folder.Name == 'Nodes') and Folder:IsA('Folder')) then
                      local CriticalPart = Model:FindFirstChild('NodeSpark') or Model:FindFirstChild('TreeX')
                      if (CriticalPart and typeof(CriticalPart) == 'Instance' and CriticalPart:IsA('Model') and CriticalPart.PrimaryPart) then
                          Output[1] = CriticalPart.PrimaryPart;
                          return unpack(Output);
                      end;
                  end;
              end;
          end;
  
          return OldRaycast(self, unpack(Arguments));
      end);
  
      local hitsoundsbind = Instance.new('BindableEvent', game:GetService('ReplicatedStorage'))
      local bullettracersbind = Instance.new('BindableEvent', game:GetService('ReplicatedStorage'))
      hitsoundsbind.Event:Connect(function()
          if flags.Hitsounds and flags.HitsoundSelect and Cheat.Globals.HitSoundIds[flags.HitsoundSelect] then
              local sound = Instance.new("Sound")
              sound.SoundId = Cheat.Globals.HitSoundIds[flags.HitsoundSelect]
              sound.Volume = flags.HitsoundVolume
              sound.PlayOnRemove = true
              sound.Parent = workspace
              sound:Destroy()
          end
      end)
  
      bullettracersbind.Event:Connect(function(position)
          if (not flags.BulletTracers) then
              return;
          end;
  
          local character = Client.Character;
          if (not character) then
              return;
          end;
  
          local head = character:FindFirstChild('Head');
          if (not head) then
              return;
          end;
  
          local att0 = Instance.new('Attachment');
          att0.Name = 'IgnoreMe';
          att0.WorldPosition = head.Position;
          att0.Parent = VMs;
  
          local att1 = Instance.new('Attachment');
          att1.Name = 'IgnoreMe';
          att1.WorldPosition = position;
          att1.Parent = VMs;
  
          local beam = Instance.new('Beam');
          beam.Name = 'IgnoreMe';
          beam.Attachment0 = att0;
          beam.Attachment1 = att1;
          beam.Transparency = NumberSequence.new({
              NumberSequenceKeypoint.new(0, 0),
              NumberSequenceKeypoint.new(1, 0)
          })
  
          beam.Color = ColorSequence.new({
              ColorSequenceKeypoint.new(0, flags.BulletTracersColor.Color),
              ColorSequenceKeypoint.new(1, flags.BulletTracersColor.Color),
          });
  
          beam.Texture = 'rbxassetid://115789305736770'
          beam.TextureSpeed = 1;
          beam.TextureLength = 4;
          beam.Width0 = 0.2;
          beam.Width1 = 0.2;
          beam.FaceCamera = true;
          beam.LightEmission = 1;
          beam.Parent = VMs;
          beam.Brightness = 1
          beam.TextureMode = Enum.TextureMode.Stretch
  
          local expiry = flags.BulletTracersDuration or 1;        
          Debris:AddItem(att0, expiry);
          Debris:AddItem(att1, expiry);
          Debris:AddItem(beam, expiry);
      end)
  
      local CreateBlood = VFXModule.CreateBlood
      VFXModule.CreateBlood = LPH_NO_UPVALUES(function(self, hit, position)
          local tb = debug.traceback();
          
          if not tb:find("ReplicatedStorage.Modules.VFXModule:153 function HitVFX") then
              hitsoundsbind:Fire()
              bullettracersbind:Fire(position)
          end
  
          return CreateBlood(self, hit, position)
      end);
  
      local CreateHole = VFXModule.CreateHole
      VFXModule.CreateHole = LPH_NO_UPVALUES(function(self, hit, position, normal, material, item, impactOnly)
          local tb = debug.traceback();
          
          if not tb:find("ReplicatedStorage.Modules.VFXModule:153 function HitVFX") then
              bullettracersbind:Fire(position)
          end
  
          return CreateHole(self, hit, position, normal, material, item, impactOnly)
      end);
  
      local LastPredictionPos
      local CreateProjectile = VFXModule.CreateProjectile
      VFXModule.CreateProjectile = LPH_NO_UPVALUES(function(self, ...)
          local Args = {...}
          
          local Traceback = debug.traceback();
          if Traceback:find("ViewmodelController") and Args[1].StepFunction ~= "FakeStepFunc" and Args[1].HitFunction ~= "FakeHitFunc" and not tostring(Args[1].HitFunction):find("Ignore") then
              local now = tick()
  
              if flags.ForcePenetration then
                  for _, v in ipairs(workspace:GetChildren()) do
                      if not v:IsA('Folder') then
                          continue
                      end
  
                      if v.Name == 'Military' or v.Name == 'Events' then
                          continue 
                      end
  
                      local skip = false
                      for _, c in ipairs(v:GetChildren()) do
                          if c:IsA('Model') and (
                              c.Name == 'Soldier'
                              or c.Name == 'Brutus'
                              or c.Name == 'Bruno'
                              or c.Name == 'Boris'
                              or c.Name == 'BTR'
                          ) then
                              skip = true
                              break
                          end
                      end
  
                      if not skip then
                          table.insert(Args[1].Filters, v)
                      end
                  end
                  table.insert(Args[1].Filters, workspace.Terrain);
              end;
  
              Cheat.Globals.ShouldHit = ((math.floor(Random.new():NextNumber(0, 1) * 100) / 100) <= (flags.HitChance / 100))
              local isvalidstack3 = isvalidlevel(3)
              local isvalidstack2 = isvalidlevel(2)
              local stacklevel = isvalidstack3 and 3 or isvalidstack2 and 2
  
              if (stacklevel and Targeting.TargetPart and Client.Character) then
                  LastPredictionPos = nil
                  local HitFunction = Args[1].HitFunction;
                  local startPos = Args[1].Position or Args[1].PositionFirst or Camera.CFrame.Position;
                  local manipPos = Targeting.ManipulatedPosition
                  local targetPos = Targeting.TargetPart and Targeting.TargetPart.Position
                  
                  -- if flags.InstantBullet then
                  --     Args[1].Speed = 9e9
                  --     Args[1].Gravity = 0
                  -- end
  
                  local gun = getgun(Client.Character)
                  local oldspeed = Args[1].Speed
                  if gun and ToolInfo[gun] and Cheat.Globals.ClientCharacter and Cheat.Globals.ClientCharacter:FindFirstChild("InventoryController") and Cheat.Globals.ClientCharacter:FindFirstChild("ViewmodelController") then
                      local InventoryController = Cheat.Globals.ClientCharacter.InventoryController
                      local ViewmodelController = Cheat.Globals.ClientCharacter.ViewmodelController
                      local v376 = InventoryController.Fetch:Invoke();
                      local v377;
                      if not v376 then
                          v377 = nil;
                      else
                          local l_Toolbar_5 = v376.Toolbar;
                          if not l_Toolbar_5 then
                              v377 = nil;
                          else
                              local v379 = l_Toolbar_5[ViewmodelController:GetAttribute("Equipped")];
                              v377 = false;
                              if v379 ~= nil then
                                  v377 = false;
                                  if v379 ~= 0 then
                                      v377 = v379;
                                  end;
                              end;
                          end;
                      end;
  
                      if v377 then
                          v376 = v377.Ammo;
                          v382 = ItemsModule[v377.ID];
                      end;
                      if v376 then
                          v381 = ItemsModule[v376.ID].AmmoStats;
                      end;
  
                      local bullet = ToolInfo[gun].Bullet
                      oldspeed = bullet.Speed * (v381.SpeedMult or 1)
                  end
                  
                  local Speed, Gravity = Args[1].Speed, Args[1].Gravity
                  local Distance = (Camera.CFrame.Position - targetPos).Magnitude
                  local TimeToHit = Distance / oldspeed
  
                  local G = Gravity * -196.2
                  local Drop = -0.5 * G * TimeToHit * TimeToHit
                  if tostring(Drop):find("nan") then
                      Drop = 0
                  end
  
                  LastPredictionPos = Vector3.new(0, Drop, 0)
                  
                  local Stack = debug.getstack(stacklevel);
                  local CameraIndex, HRPIndex, FlashIndex, MouseIndex
                  local CameraValue, HRPValue, FlashValue, MouseValue
  
                  for i = 1, 100 do
                      local v = rawget(Stack, i)
                      if v then
                          local t = typeof(v)
                          if t == "CFrame" and not CameraValue then
                              local ok, p = pcall(function()
                                  return v.p
                              end)
                              if ok and typeof(p) == "Vector3" then
                                  CameraValue = v
                                  CameraIndex = i
                              end
                          elseif t == "CFrame" and CameraValue and not HRPValue and v ~= CameraValue then
                              local ok, p = pcall(function()
                                  return v.p
                              end)
                              if ok and typeof(p) == "Vector3" then
                                  HRPValue = v
                                  HRPIndex = i
                              end
                          elseif t == "Vector3" and not FlashValue then
                              FlashValue = v
                              FlashIndex = i
                          elseif t == "Vector3" and FlashValue and v ~= FlashValue and not MouseValue then
                              MouseValue = v
                              MouseIndex = i
                          end
                      end
                  end
                  
                  if CameraValue and HRPValue and FlashValue and MouseValue and Targeting.TargetPart and Targeting.TargetPart.Position and LastPredictionPos then
                      local finalTarget = Targeting.TargetPart and Targeting.TargetPart.Position
                      if LastPredictionPos then
                          finalTarget = finalTarget + LastPredictionPos
                      end
  
                      local camPos = CameraValue.p
                      local hrpPos = HRPValue.p
                      local newFlash = CFrame.new(FlashValue, finalTarget).p
  
                      if manipPos then
                          local offC = camPos - FlashValue
                          local offH = hrpPos - FlashValue
                          local newCam = manipPos + offC
                          local newHrp = manipPos + offH
                          CameraValue = CFrame.new(newCam, finalTarget)
                          HRPValue = CFrame.new(newHrp, finalTarget)
                          newFlash = manipPos
                      else
                          CameraValue = CFrame.new(camPos, finalTarget)
                          HRPValue = CFrame.new(hrpPos, finalTarget)
                      end
                      debug.setstack(stacklevel, CameraIndex, CameraValue)
                      debug.setstack(stacklevel, HRPIndex, HRPValue)
                      debug.setstack(stacklevel, FlashIndex, newFlash)
                      debug.setstack(stacklevel, MouseIndex, finalTarget)
                  end
              end;
  
              if (Args[1]['Terminate']) then
                  Args[1]['Terminate'] = nil;
              end;
  
              if Targeting.TargetPart and Cheat.Globals.ShouldHit then
                  local p = Targeting.TargetPart
                  local hit = p and p.Position
                  if p and hit then
                      local origin = Args[1].Position
                      local dir = (hit - origin).Unit
                      local cp = CFrame.new(origin, hit).Position
                      if Targeting.ManipulatedPosition or Targeting.ManipPos then
                          local mp = Targeting.ManipulatedPosition or Targeting.ManipPos
                          dir = (hit - mp).Unit
                          cp = CFrame.new(mp, hit).p
                      end
                      Args[1].Position = cp
                      if Args[1].PositionFirst then
                          Args[1].PositionFirst = cp
                      end
                      Args[1].DirectionFirst = dir
                      Args[1].Direction = dir
                  end	 
              end
          end;
  
          return CreateProjectile(self, unpack(Args));
      end);
      
      local UpdateChar = LPH_NO_VIRTUALIZE(function()
          local character = Client.Character or Client.CharacterAdded:Wait()
          Cheat.Globals.ClientCharacter = character
          
          local hum = character:FindFirstChildOfClass('Humanoid') or character:WaitForChild('Humanoid')
          local InventoryController = character:WaitForChild('InventoryController')
          local EquipArmor = InventoryController:WaitForChild('EquipArmor')
          
          for _, conn in getconnections(EquipArmor.Event) do
              local f = conn.Function
              if not f then continue end
              for _, v in debug.getupvalues(f) do
                  if type(v) ~= 'function' then continue end
                  local Constants = debug.getconstants(v)
                  if Constants[1] == "ArmorEquip" and Constants[5] == "GetAttribute" then
                      if flags.InstantLoot then
                          debug.setconstant(v, 19, 0)
                          debug.setconstant(v, 20, 0)
                          debug.setconstant(v, 21, 0)
                      end;
                      table.insert(Cheat.Globals.QuickStackFunctions, v)
                  end
              end
          end
  
          for _, c in getconnections(hum.StateChanged) do
              local fn = c.Function
              if type(fn) == 'function' then
                  local i = debug.getinfo(fn)
                  if i and i.short_src and i.short_src:find('ViewmodelController') then
                      local Old; Old = hookfunction(fn, LPH_NO_UPVALUES(function(oldState, newState, ...)
                          if flags.NoGrounded then
                              oldState = Enum.HumanoidStateType.Running
                              newState = Enum.HumanoidStateType.Running
                          end
                          local s, r = pcall(Old, oldState, newState, ...)
                          if s then
                              return r
                          end
                          return nil
                      end))
                  end
              else
                  c:Disconnect()
              end
          end
      end);
  
      UpdateChar();
      Client.CharacterAdded:Connect(UpdateChar);
  end

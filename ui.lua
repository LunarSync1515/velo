-- ==========================================
-- Variables 
    local InputService, HttpService, GuiService, RunService, Stats, TweenService, SoundService, Workspace, Players = game:GetService("UserInputService"), game:GetService("HttpService"), game:GetService("GuiService"), game:GetService("RunService"), game:GetService("Stats"), game:GetService("TweenService"), game:GetService("SoundService"), game:GetService("Workspace"), game:GetService("Players")
    local Camera, lp, gui_offset = Workspace.CurrentCamera, Players.LocalPlayer, GuiService:GetGuiInset().Y
    local ScreenGui = lp.PlayerGui
    local CoreGui = game:GetService("CoreGui")
    local mouse = lp:GetMouse()
    local vec2, vec3, dim2, dim, rect, dim_offset = Vector2.new, Vector3.new, UDim2.new, UDim.new, Rect.new, UDim2.fromOffset
    local color, rgb, hex, hsv, rgbseq, rgbkey, numseq, numkey = Color3.new, Color3.fromRGB, Color3.fromHex, Color3.fromHSV, ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new, NumberSequenceKeypoint.new
-- 

-- Library init
    local Library = {
        Directory = "Disconnect",
        Folders = {
            "/fonts",
            "/configs",
            "/sounds",
        },
        Flags = {},
        ConfigFlags = {},
        Connections = {},   
        Notifications = {Notifs = {}},
        OpenElement = {}; -- type: table or userdata
        EasingStyle = Enum.EasingStyle.Quint;
        TweeningSpeed = 0.25;
        DraggingSpeed = .05,
        CopiedColor = nil -- Store copied color for colorpicker copy/paste
    }
    getgenv().Library = Library
    local themes = {
        preset = {
            accent = rgb(135, 1, 253),
            ActiveText = rgb(246, 246, 246),
            SecondaryColor = rgb(91, 91, 92),
            Outline = rgb(16, 15, 16),
            Liner = rgb(7, 5, 7),
            Background = rgb(10, 9, 10)
        },
        utility = {},
        gradients = {
            Selected = {};
            Deselected = {};
        },
    }

    for theme,color in pairs(themes.preset) do 
        themes.utility[theme] = {
            BackgroundColor3 = {}; 	
            TextColor3 = {};
            ImageColor3 = {};
            ScrollBarImageColor3 = {};
            Color = {};
        }
    end
    
    themes.utility.Outline.BorderColor3 = {} 

    local Keys = {
        [Enum.KeyCode.LeftShift] = "LSHIFT",
        [Enum.KeyCode.RightShift] = "RSHIFT",
        [Enum.KeyCode.LeftControl] = "LCTRL",
        [Enum.KeyCode.RightControl] = "RCTRL",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BACKSPACE",
        [Enum.KeyCode.Return] = "RETURN",
        [Enum.KeyCode.LeftAlt] = "LALT",
        [Enum.KeyCode.RightAlt] = "RALT",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESCAPE",
        [Enum.KeyCode.Space] = "SPACE",
    }
        
    Library.__index = Library

    for _,path in Library.Folders do 
        makefolder(Library.Directory .. path)
    end

    local Flags = {}
    Library.Flags = Flags 
    local ConfigFlags = Library.ConfigFlags
    local Notifications = Library.Notifications
--

-- Library functions 
    -- Misc functions
        function Library:GetTransparency(obj)
            if obj:IsA("Frame") then
                return {"BackgroundTransparency"}
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif obj:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif obj:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif obj:IsA("UIStroke") then 
                return { "Transparency" }
            end
            
            return nil
        end

        function Library:Tween(Object, Properties, Info)
            local tween = TweenService:Create(Object, Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0), Properties)
            tween:Play()
            
            return tween
        end

        function Library:Fade(obj, prop, vis, speed)
            if not (obj and prop) then
                return
            end

            local OldTransparency = obj[prop]
            obj[prop] = vis and 1 or OldTransparency

            local Tween = Library:Tween(obj, { [prop] = vis and OldTransparency or 1 }, TweenInfo.new(speed or Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0))

            Library:Connection(Tween.Completed, function()
                if not vis then
                    task.wait()
                    obj[prop] = OldTransparency
                end
            end)

            return Tween
        end

        function Library:Resizify(Parent)
            local Resizing = Library:Create("TextButton", {
                Position = dim2(1, -10, 1, -10);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 10, 0, 10);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
                Parent = Parent;
                BackgroundTransparency = 1; 
                Text = ""
            })
            
            local IsResizing = false 
            local Size 
            local InputLost 
            local ParentSize = Parent.Size  
            
            Resizing.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsResizing = true
                    InputLost = input.Position
                    Size = Parent.Size
                end
            end)
        
            Resizing.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsResizing = false
                end
            end)
        
            Library:Connection(InputService.InputChanged, function(input, game_event) 
                if IsResizing and input.UserInputType == Enum.UserInputType.MouseMovement then            
                    Library:Tween(Parent, {
                        Size = dim2(
                            Size.X.Scale,
                            math.clamp(Size.X.Offset + (input.Position.X - InputLost.X), ParentSize.X.Offset, Camera.ViewportSize.X), 
                            Size.Y.Scale, 
                            math.clamp(Size.Y.Offset + (input.Position.Y - InputLost.Y), ParentSize.Y.Offset, Camera.ViewportSize.Y)
                        )
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end)
        end
        
        function Library:Hovering(Object)
            if type(Object) == "table" then 
                local Pass = false;

                for _,obj in Object do 
                    if Library:Hovering(obj) then 
                        Pass = true
                        return Pass
                    end 
                end 
            else 
                local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
                local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
    
                return (y_cond and x_cond)
            end 
        end  

        function Library:ConvertHex(color)
            local r = math.floor(color.R * 255)
            local g = math.floor(color.G * 255)
            local b = math.floor(color.B * 255)
            return string.format("#%02X%02X%02X", r, g, b)
        end

        function Library:ConvertFromHex(color)
            color = color:gsub("#", "")
            local r = tonumber(color:sub(1, 2), 16) / 255
            local g = tonumber(color:sub(3, 4), 16) / 255
            local b = tonumber(color:sub(5, 6), 16) / 255
            return Color3.new(r, g, b)
        end

        function Library:Draggify(Parent)
            local Dragging = false 
            local IntialSize = Parent.Position
            local InitialPosition 

            Parent.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    InitialPosition = Input.Position
                    InitialSize = Parent.Position
                end
            end)

            Parent.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            Library:Connection(InputService.InputChanged, function(Input, game_event) 
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    local Horizontal = Camera.ViewportSize.X
                    local Vertical = Camera.ViewportSize.Y

                    local NewPosition = dim2(
                        0,
                        math.clamp(
                            InitialSize.X.Offset + (Input.Position.X - InitialPosition.X),
                            0,
                            Horizontal - Parent.Size.X.Offset
                        ),
                        0,
                        math.clamp(
                            InitialSize.Y.Offset + (Input.Position.Y - InitialPosition.Y),
                            0,
                            Vertical - Parent.Size.Y.Offset
                        )
                    )

                    Library:Tween(Parent, {
                        Position = NewPosition
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end
            end)
        end 

        function Library:Convert(str)
            local Values = {}

            for Value in string.gmatch(str, "[^,]+") do
                table.insert(Values, tonumber(Value))
            end

            if #Values == 4 then              
                return unpack(Values)
            else
                return
            end
        end
        
        function Library:Lerp(start, finish, t)
            t = t or 1 / 8

            return start * (1 - t) + finish * t
        end

        function Library:ConvertEnum(enum)
            local EnumParts = {}
            
            for part in string.gmatch(enum, "[%w_]+") do
                table.insert(EnumParts, part)
            end
        
            local EnumTable = Enum

            for i = 2, #EnumParts do
                local EnumItem = EnumTable[EnumParts[i]]
        
                EnumTable = EnumItem
            end
            
            return EnumTable
        end

        function Library:ConvertHex(color, alpha)
            local r = math.floor(color.R * 255)
            local g = math.floor(color.G * 255)
            local b = math.floor(color.B * 255)
            local a = alpha and math.floor(alpha * 255) or 255
            return string.format("#%02X%02X%02X%02X", r, g, b, a)
        end

        function Library:ConvertFromHex(color)
            color = color:gsub("#", "")
            local r = tonumber(color:sub(1, 2), 16) / 255
            local g = tonumber(color:sub(3, 4), 16) / 255
            local b = tonumber(color:sub(5, 6), 16) / 255
            local a = tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16) / 255 or 1
            return Color3.new(r, g, b), a
        end

        local ConfigHolder;
        function Library:UpdateConfigList() 
            if not ConfigHolder then 
                return 
            end
            
            local List = {}
            
            for _,file in listfiles(Library.Directory .. "/configs") do
                local Name = file:gsub(Library.Directory .. "/configs\\", ""):gsub(".cfg", ""):gsub(Library.Directory .. "\\configs\\", "")
                List[#List + 1] = Name
            end

            -- for _,v in List do 
            --     print(_,v)
            -- end 

            ConfigHolder.RefreshOptions(List)
        end

        function Library:Keypicker(properties) 
            local Cfg = {
                Name = properties.Name or "Color", 
                Flag = properties.Flag or properties.Name or "Colorpicker",
                Callback = properties.Callback or function() end,

                Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
                Alpha = properties.Alpha or properties.Transparency or 1,
                
                -- Other
                Open = false, 
                Items = {};
            }

            local DraggingSat = false 
            local DraggingHue = false 
            local DraggingAlpha = false 

            local h, s, v = Cfg.Color:ToHSV() 
            local a = Cfg.Alpha 

            Flags[Cfg.Flag] = {Color = Cfg.Color, Transparency = Cfg.Alpha}

            local Items = Cfg.Items; do 
                -- Component
                    Items.ColorHolder = Library:Create( "Frame" , {
                        Parent = self.Items.Components;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 28, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Color = Library:Create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.ColorHolder;
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 28, 0, 12);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.AlphaObject = Library:Create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Color;
                        Name = "\0";
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.AlphaObject;
                        CornerRadius = dim(0, 4)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Color;
                        CornerRadius = dim(0, 4)
                    });
                --
                
                -- Colorpicker
                    Items.Window = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Name = "\0";
                        Position = dim2(0.04117647930979729, 0, 0.23366835713386536, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 236, 0, 186);
                        Visible = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Window;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Window;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.SatValBackground = Library:Create( "TextButton" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 4, 0, 4);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -8, 1, -51);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(21, 255, 99)
                    });

                    Items.SatValPickerHolder = Library:Create( "Frame" , {
                        Parent = Items.SatValBackground;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 5, 0, 5);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -10, 1, -10);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Value = Library:Create( "TextButton" , {
                        Name = "\0";
                        Parent = Items.SatValBackground;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Parent = Items.Value;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Value;
                        CornerRadius = dim(0, 4)
                    });

                    Items.SatValPicker = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = Items.SatValPickerHolder;
                        Name = "\0";
                        Position = dim2(0.5, 0, 0.5, 0);
                        Size = dim2(0, 10, 0, 10);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.SatValPicker;
                        CornerRadius = dim(0, 999)
                    });

                    Items.SaturationPicker = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = Items.SatValPicker;
                        Name = "\0";
                        Position = dim2(0.5, 0, 0.5, 0);
                        Size = dim2(1, -2, 1, -2);
                        ZIndex = 100;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.SaturationPicker;
                        CornerRadius = dim(0, 999)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.SatValBackground;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Saturation = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.SatValBackground;
                        Size = dim2(1, 2, 1, 0);
                        Name = "\0";
                        ZIndex = 2;
                        Position = dim2(0, -1, 0, 0);
                        Selectable = false;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = Items.Saturation;
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Saturation;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Hue = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 4, 1, -40);
                        Selectable = false;
                        Size = dim2(1, -8, 0, 13);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Hue
                    });

                    Library:Create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = Items.Hue
                    });

                    Items.HueDragger = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.Hue;
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 0, 19);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.HueDragger;
                        CornerRadius = dim(0, 100)
                    });

                    Items.Alpha = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 4, 1, -20);
                        Selectable = false;
                        Size = dim2(1, -8, 0, 13);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Alpha
                    });

                    Items.AlphaPicker = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.Alpha;
                        Name = "\0";
                        Position = dim2(0.5, 0, 0.5, 0);
                        Size = dim2(0, 15, 0, 15);
                        ZIndex = 99;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.AlphaPicker;
                        CornerRadius = dim(0, 100)
                    });

                    Items.AlphaIndicator = Library:Create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Alpha;
                        Name = "\0";
                        ZIndex = 2;
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Frame = Library:Create( "Frame" , {
                        Parent = Items.AlphaIndicator;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Frame
                    });

                    Items.AlphaColor = Library:Create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(21, 255, 99)), rgbkey(1, rgb(21, 255, 99))};
                        Transparency = numseq{numkey(0, 1), numkey(1, 0)};
                        Parent = Items.Frame
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.AlphaIndicator
                    });
                --
                
                -- 
                    Items.ContextMenu = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 100, 0, 50);
                        Visible = false;
                        BorderSizePixel = 0;
                        ZIndex = 1000;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.ContextMenu;
                        CornerRadius = dim(0, 4)
                    });

                    Items.ContextInline = Library:Create( "Frame" , {
                        Parent = Items.ContextMenu;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    }); Library:Themify(Items.ContextInline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.ContextInline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.CopyButton = Library:Create( "TextButton" , {
                        Parent = Items.ContextInline;
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -4, 0, 21);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background;
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.ActiveText;
                        TextSize = 14;
                        AutoButtonColor = false;
                        TextXAlignment = Enum.TextXAlignment.Center;
                        TextYAlignment = Enum.TextYAlignment.Center;
                    }); Items.CopyButton.Text = "Copy Color"; Library:Themify(Items.CopyButton, "Background", "BackgroundColor3"); Library:Themify(Items.CopyButton, "ActiveText", "TextColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.CopyButton;
                        CornerRadius = dim(0, 4)
                    });

                    Items.PasteButton = Library:Create( "TextButton" , {
                        Parent = Items.ContextInline;
                        Name = "\0";
                        Position = dim2(0, 2, 0, 25);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -4, 0, 21);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background;
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.ActiveText;
                        TextSize = 14;
                        AutoButtonColor = false;
                        TextXAlignment = Enum.TextXAlignment.Center;
                        TextYAlignment = Enum.TextYAlignment.Center;
                    }); Items.PasteButton.Text = "Paste Color"; Library:Themify(Items.PasteButton, "Background", "BackgroundColor3"); Library:Themify(Items.PasteButton, "ActiveText", "TextColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.PasteButton;
                        CornerRadius = dim(0, 4)
                    });
                --
            end
            
            function Cfg.SetVisible(bool)
                if Cfg.Tweening == true then
                    return 
                end 

                Items.Window.Position = dim2(0, Items.Color.AbsolutePosition.X + 2, 0, Items.Color.AbsolutePosition.Y + 74)
                    
                Cfg.Tween(bool)
                Cfg.Set(hsv(h, s, v), a)
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Window.Visible = true
                end

                local Children = Items.Window:GetDescendants()
                table.insert(Children, Items.Window)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Window.Visible = bool
                end)
            end

            function Cfg.UpdateColor() 
                local Mouse = InputService:GetMouseLocation()
                local offset = vec2(Mouse.X, Mouse.Y - gui_offset) 
                
                if DraggingSat then	
                    s = math.clamp((offset - Items.SatValBackground.AbsolutePosition).X / Items.SatValBackground.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - Items.SatValBackground.AbsolutePosition).Y / Items.SatValBackground.AbsoluteSize.Y, 0, 1)
                elseif DraggingHue then
                    h = math.clamp((offset - Items.Hue.AbsolutePosition).X / Items.Hue.AbsoluteSize.X, 0, 1)
                elseif DraggingAlpha then
                    a = math.clamp((offset - Items.Alpha.AbsolutePosition).X / Items.Alpha.AbsoluteSize.X, 0, 1)
                end

                Cfg.Set()
            end
            
            function Cfg.Set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 

                local Color = hsv(h, s, v)

                Items.Color.BackgroundColor3 = Color

                Library:Tween(Items.SatValPicker, {
                    Position = dim2(s, 0, 1 - v, 0)
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                Library:Tween(Items.AlphaPicker, {
                    Position = dim2(a, -1 * (a * Items.AlphaPicker.AbsoluteSize.X), 0.5, 0)
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                Library:Tween(Items.HueDragger, {
                    Position = dim2(h, -1 * (h * Items.HueDragger.AbsoluteSize.X), 0.5, 0)
                }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                Items.SatValBackground.BackgroundColor3 = hsv(h, 1, 1)
                
                Items.Color.BackgroundColor3 = Color 
                Items.AlphaObject.ImageTransparency = a
                Items.AlphaColor.Color = rgbseq{rgbkey(0, hsv(h, 1, 1)), rgbkey(1, hsv(h, 1, 1))};

                Flags[Cfg.Flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                Cfg.Callback(Color, a)
            end

            Items.Color.MouseButton1Click:Connect(function()
                Cfg.Open = not Cfg.Open
                Cfg.SetVisible(Cfg.Open)            
            end)
            
            Items.Color.MouseButton2Click:Connect(function()
                Items.ContextMenu.Position = dim2(0, Items.Color.AbsolutePosition.X, 0, Items.Color.AbsolutePosition.Y + Items.Color.AbsoluteSize.Y + 2)
                Items.ContextMenu.Visible = true
            end)
            
            Items.CopyButton.MouseButton1Click:Connect(function()
                Library.CopiedColor = {
                    Color = hsv(h, s, v),
                    Alpha = a
                }
                Items.ContextMenu.Visible = false
            end)
            
            Items.PasteButton.MouseButton1Click:Connect(function()
                if Library.CopiedColor then
                    local copiedH, copiedS, copiedV = Library.CopiedColor.Color:ToHSV()
                    h, s, v = copiedH, copiedS, copiedV
                    a = Library.CopiedColor.Alpha
                    Cfg.Set(Library.CopiedColor.Color, Library.CopiedColor.Alpha)
                end
                Items.ContextMenu.Visible = false
            end)

            InputService.InputChanged:Connect(function(input)
                if (DraggingSat or DraggingHue or DraggingAlpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Cfg.UpdateColor() 
                end
            end)

            Library:Connection(InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Library:Hovering({Items.Window}) and Items.Window.Visible then
                        Cfg.SetVisible(false)
                    end
                    if not Library:Hovering({Items.ContextMenu}) and Items.ContextMenu.Visible then
                        Items.ContextMenu.Visible = false
                    end
                end
            end) 

            Library:Connection(InputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    DraggingSat = false
                    DraggingHue = false
                    DraggingAlpha = false
                end
            end)    

            Items.Alpha.MouseButton1Down:Connect(function()
                DraggingAlpha = true 
            end)
            
            Items.Hue.MouseButton1Down:Connect(function()
                DraggingHue = true 
            end)
            
            Items.Saturation.MouseButton1Down:Connect(function()
                DraggingSat = true  
            end)

            Cfg.Set(Cfg.Color, Cfg.Alpha)
            Cfg.SetVisible(false)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:GetConfig()
            local Config = {}
            
            for Idx, Value in Flags do
                if type(Value) == "table" and Value.key then
                    Config[Idx] = {active = false, mode = Value.mode, key = tostring(Value.key)}
                elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                    Config[Idx] = {Transparency = Value["Transparency"], Color = Value["Color"]:ToHex()}
                else
                    Config[Idx] = Value
                end
            end 
            
            local uiPositions = {}
            
            if Library.UIElements then
                if Library.UIElements.Watermark then
                    local pos = Library.UIElements.Watermark.Position
                    uiPositions.Watermark = {
                        X = {Scale = pos.X.Scale, Offset = pos.X.Offset},
                        Y = {Scale = pos.Y.Scale, Offset = pos.Y.Offset}
                    }
                end
                
                if Library.UIElements.Keybinds then
                    local pos = Library.UIElements.Keybinds.Position
                    uiPositions.Keybinds = {
                        X = {Scale = pos.X.Scale, Offset = pos.X.Offset},
                        Y = {Scale = pos.Y.Scale, Offset = pos.Y.Offset}
                    }
                end
            end
            
            if Library.InventoryView and Library.InventoryView.Inventory then
                uiPositions.Inventory = {
                    X = {Scale = Library.InventoryView.Inventory.Position.X.Scale, Offset = Library.InventoryView.Inventory.Position.X.Offset},
                    Y = {Scale = Library.InventoryView.Inventory.Position.Y.Scale, Offset = Library.InventoryView.Inventory.Position.Y.Offset}
                }
            end
            
            if Library.Radar and Library.Radar.Container then
                uiPositions.Radar = {
                    X = {Scale = Library.Radar.Container.Position.X.Scale, Offset = Library.Radar.Container.Position.X.Offset},
                    Y = {Scale = Library.Radar.Container.Position.Y.Scale, Offset = Library.Radar.Container.Position.Y.Offset}
                }
            end
            
            if next(uiPositions) then
                Config["__UIPositions"] = uiPositions
            end

            return HttpService:JSONEncode(Config)
        end

        function Library:LoadConfig(JSON) 
            local Config = HttpService:JSONDecode(JSON)
            
            for Idx, Value in Config do                
                if Idx == "config_name_list" or Idx == "__UIPositions" then 
                    continue 
                end

                if type(Value) == "table" and Value["active"] ~= nil then
                    Value['active'] = false
                end

                local Function = ConfigFlags[Idx]

                if Function then 
                    if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
                        Function(hex(Value["Color"]), Value["Transparency"])
                    elseif type(Value) == "table" and Value["active"] ~= nil then 
                        Function(Value)
                    else
                        Function(Value)
                    end
                end 
            end 
            
            if Config["__UIPositions"] then
                local positions = Config["__UIPositions"]
                
                if Library.UIElements then
                    if positions.Watermark and Library.UIElements.Watermark then
                        local newPos = dim2(
                            positions.Watermark.X.Scale, positions.Watermark.X.Offset,
                            positions.Watermark.Y.Scale, positions.Watermark.Y.Offset
                        )
                        Library:Tween(Library.UIElements.Watermark, {Position = newPos})
                    end
                    
                    if positions.Keybinds and Library.UIElements.Keybinds then
                        local newPos = dim2(
                            positions.Keybinds.X.Scale, positions.Keybinds.X.Offset,
                            positions.Keybinds.Y.Scale, positions.Keybinds.Y.Offset
                        )
                        Library:Tween(Library.UIElements.Keybinds, {Position = newPos})
                    end
                end
                
                if positions.Inventory and Library.InventoryView and Library.InventoryView.Inventory then
                    local newPos = dim2(
                        positions.Inventory.X.Scale, positions.Inventory.X.Offset,
                        positions.Inventory.Y.Scale, positions.Inventory.Y.Offset
                    )
                    Library.InventoryView.TargetPosition = newPos
                    Library:Tween(Library.InventoryView.Inventory, {Position = newPos})
                end
                
                if positions.Radar and Library.Radar and Library.Radar.Container then
                    local newPos = dim2(
                        positions.Radar.X.Scale, positions.Radar.X.Offset,
                        positions.Radar.Y.Scale, positions.Radar.Y.Offset
                    )
                    Library:Tween(Library.Radar.Container, {Position = newPos})
                end
            end
        end 
        
        function Library:Round(num, float) 
            local Multiplier = 1 / (float or 1)
            return math.floor(num * Multiplier + 0.5) / Multiplier
        end

        function Library:Themify(instance, theme, property)
            table.insert(themes.utility[theme][property], instance)
        end

        function Library:SaveGradient(instance, theme) -- instance, tabfill or background, color
            table.insert(themes.gradients[theme], instance)
        end

        function Library:RefreshTheme(theme, color)
            for property,instances in pairs(themes.utility[theme] or {}) do 
                for _,object in pairs(instances) do
                    if object[property] == themes.preset[theme] then 
                        object[property] = color 
                    end
                end 
            end

            themes.preset[theme] = color 
        end 

        function Library:Connection(signal, callback)
            local connection = signal:Connect(callback)
            
            table.insert(Library.Connections, connection)

            return connection 
        end

        function Library:CloseElement() 
            local IsMulti = typeof(Library.OpenElement)

            if not Library.OpenElement then 
                return 
            end

            for i = 1, #Library.OpenElement do
                local Data = Library.OpenElement[i]

                if Data.Ignore then 
                    continue 
                end 

                Data.SetVisible(false)
                Data.Open = false
            end

            Library.OpenElement = {}
        end

        function Library:Create(instance, options)
            local ins = Instance.new(instance) 

            for prop, value in options do
                ins[prop] = value
            end

            if ins.ClassName == "TextButton" then 
                ins["AutoButtonColor"] = false 
                ins["Text"] = ""
                -- Library:Themify(ins, "text_color", "TextColor3")
            end 

            -- if ins.ClassName == "TextLabel" or ins.ClassName == "TextBox" then 
            --     Library:Themify(ins, "text_color", "TextColor3")
            --     Library:Themify(ins, "unselected", "TextColor3")
            -- end 

            return ins 
        end

        function Library:Unload() 
            if Library.Items then 
                Library.Items:Destroy()
            end

            if Library.Other then 
                Library.Other:Destroy()
            end
            
            for _,connection in Library.Connections do 
                connection:Disconnect() 
                connection = nil 
            end
        end
    --
    
    -- Initialize notification holder globally in CoreGui
    do
        local NotificationScreenGui = Library:Create( "ScreenGui" , {
            Parent = CoreGui;
            Name = "NotificationGui";
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            IgnoreGuiInset = true;
            DisplayOrder = 999;
        });
        
        Library.NotificationHolder = Library:Create( "Frame" , {
            Parent = NotificationScreenGui;
            Name = "NotificationHolder";
            BackgroundTransparency = 1;
            AnchorPoint = vec2(1, 0);
            Position = dim2(0.9946571588516235, 0, 0.0012376237427815795, 12);
            Size = dim2(0, -27, 0, 65);
            AutomaticSize = Enum.AutomaticSize.XY;
        });
        
        Library:Create( "UIListLayout" , {
            Parent = Library.NotificationHolder;
            Padding = dim(0, 12);
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
        });
    end
    
    -- Unsupported Executor Popup System
    do
        local UNSUPPORTED_EXECUTORS = {"SOLARA", "XENO"}
        local REQUIRED_FUNCTIONS = {
            "hookmetamethod",
            "getnamecallmethod",
            "hookfunction",
            "getgenv",
            "Drawing",
            "Drawing.new"
        }
        
        local function checkExecutor()
            local executorName = "Unknown"
            local executorVersion = "Unknown"
            
            if identifyexecutor then
                local name, version = identifyexecutor()
                executorName = name or "Unknown"
                executorVersion = version or "Unknown"
            end
            
            local isUnsupported = false
            for _, unsupported in ipairs(UNSUPPORTED_EXECUTORS) do
                if string.upper(executorName):find(string.upper(unsupported)) then
                    isUnsupported = true
                    break
                end
            end
            
            local missingFunctions = {}
            for _, funcName in ipairs(REQUIRED_FUNCTIONS) do
                local func = getfenv(0)
                local path = funcName
                while func ~= nil and path ~= "" do
                    local name, nextPath = string.match(path, "^([^.]+)%.?(.*)$")
                    func = func[name]
                    path = nextPath
                end
                
                if func == nil then
                    table.insert(missingFunctions, funcName)
                end
            end
            
            return isUnsupported, executorName, missingFunctions
        end
        
        local function createPopup(executorName, missingFunctions, parentFrame)
            -- Black overlay background
            local Overlay = Library:Create("Frame", {
                Parent = parentFrame;
                Name = "Overlay";
                Size = dim2(1, 0, 1, 0);
                Position = dim2(0, 0, 0, 0);
                BackgroundColor3 = rgb(0, 0, 0);
                BackgroundTransparency = 0.25;
                BorderSizePixel = 0;
                ZIndex = 9999;
            })

            Library:Create("UICorner", {
                Parent = Overlay;
                CornerRadius = dim(0, 4);
            })
            
            local Popup = Library:Create("Frame", {
                Parent = parentFrame;
                Name = "Popup";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.5, 0);
                Size = dim2(0, 0, 0, 0);
                BackgroundColor3 = rgb(10, 9, 10);
                BorderSizePixel = 0;
                BackgroundTransparency = 1;
                ZIndex = 10000;
            })
            
            Library:Create("UIStroke", {
                Parent = Popup;
                Color = rgb(16, 15, 16);
            })
            
            Library:Create("UICorner", {
                Parent = Popup;
                CornerRadius = dim(0, 4);
            })
            
            local IconHolder = Library:Create("Frame", {
                Parent = Popup;
                Name = "IconHolder";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.4976744055747986, 0, 0.2663043439388275, 0);
                Size = dim2(0, 100, 0, 100);
                BackgroundColor3 = rgb(255, 32, 32);
                BackgroundTransparency = 0.949999988079071;
                BorderSizePixel = 0;
            })
            
            Library:Create("UICorner", {
                Parent = IconHolder;
                CornerRadius = dim(1.100000023841858, 0);
            })
            
            Library:Create("ImageLabel", {
                Parent = IconHolder;
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.5, 0);
                Size = dim2(0, 65, 0, 65);
                Image = "rbxassetid://94616661895541";
                ImageColor3 = rgb(255, 32, 32);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            Library:Create("TextLabel", {
                Parent = IconHolder;
                Name = "Label";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.5, 85);
                Size = dim2(0, 1, 0, 1);
                Text = '<font color="#FF2020">' .. executorName .. '</font> Unsupported';
                RichText = true;
                TextColor3 = rgb(255, 255, 255);
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                TextSize = 18;
                AutomaticSize = Enum.AutomaticSize.XY;
                BackgroundTransparency = 1;
            })
            
            Library:Create("TextLabel", {
                Parent = IconHolder;
                Name = "Description";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.25999999046325684, 135);
                Size = dim2(0, 1, 0, 1);
                Text = "Missing Functions";
                RichText = true;
                TextColor3 = rgb(66, 66, 66);
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                TextSize = 18;
                AutomaticSize = Enum.AutomaticSize.XY;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            local Holder = Library:Create("Frame", {
                Parent = Popup;
                Name = "Holder";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0.3774564862251282, 130);
                Size = dim2(0, 325, 0, 84);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            Library:Create("UIListLayout", {
                Parent = Holder;
                Padding = dim(0, 4);
                SortOrder = Enum.SortOrder.LayoutOrder;
                FillDirection = Enum.FillDirection.Horizontal;
                Wraps = true;
            })
            
            Library:Create("UIPadding", {
                Parent = Holder;
                PaddingTop = dim(0, 4);
                PaddingLeft = dim(0, 4);
            })
            
            for _, funcName in ipairs(missingFunctions) do
                local FunctionLabel = Library:Create("TextLabel", {
                    Parent = Holder;
                    Name = "Description";
                    AnchorPoint = vec2(0.5, 0.5);
                    Size = dim2(0, 1, 0, 1);
                    Text = funcName;
                    RichText = true;
                    TextColor3 = rgb(255, 32, 32);
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                    TextSize = 16;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 32, 32);
                    BackgroundTransparency = 0.98;
                })
                
                Library:Create("UIPadding", {
                    Parent = FunctionLabel;
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 4);
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4);
                })
                
                Library:Create("UICorner", {
                    Parent = FunctionLabel;
                })
            end
            
            local ExitButton = Library:Create("Frame", {
                Parent = Popup;
                Position = dim2(0.1302325576543808, 0, 0.8097826242446899, 0);
                Size = dim2(0, 314, 0, 46);
                BackgroundColor3 = rgb(255, 32, 32);
                BackgroundTransparency = 0.9;
                BorderSizePixel = 0;
                ZIndex = 10001;
            })
            
            Library:Create("UICorner", {
                Parent = ExitButton;
            })
            
            local ExitLabel = Library:Create("TextLabel", {
                Parent = ExitButton;
                Size = dim2(1, 0, 1, 0);
                Position = dim2(0, 0, 0, 0);
                Text = "Exit";
                TextColor3 = rgb(255, 32, 32);
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                TextSize = 18;
                TextXAlignment = Enum.TextXAlignment.Center;
                TextYAlignment = Enum.TextYAlignment.Center;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = 10002;
            })
            
            -- Hover effect
            ExitButton.MouseEnter:Connect(function()
                Library:Tween(ExitButton, {BackgroundTransparency = 0.85})
            end)
            
            ExitButton.MouseLeave:Connect(function()
                Library:Tween(ExitButton, {BackgroundTransparency = 0.9})
            end)
            
            ExitButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    -- Destroy the entire library
                    Library:Unload()
                end
            end)
            
            -- Smooth entrance animations
            task.spawn(function()
                -- 1. Fade in overlay
                Library:Tween(Overlay, {BackgroundTransparency = 0.25}, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
                
                -- 2. Scale and fade in popup with elastic bounce
                task.wait(0.1)
                local popupTween = TweenService:Create(Popup, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = dim2(0, 430, 0, 368),
                    BackgroundTransparency = 0
                })
                popupTween:Play()
                
                -- 3. Fade in icon holder
                task.wait(0.2)
                IconHolder.BackgroundTransparency = 1
                Library:Tween(IconHolder, {BackgroundTransparency = 0.949999988079071}, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
                
                -- 4. Staggered fade in for function labels
                task.wait(0.15)
                for i, child in ipairs(Holder:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child.TextTransparency = 1
                        child.BackgroundTransparency = 1
                        task.wait(0.05)
                        Library:Tween(child, {
                            TextTransparency = 0,
                            BackgroundTransparency = 0.98
                        }, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
                    end
                end
                
                -- 5. Fade in exit button
                task.wait(0.1)
                ExitButton.BackgroundTransparency = 1
                ExitLabel.TextTransparency = 1
                Library:Tween(ExitButton, {BackgroundTransparency = 0.9}, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
                Library:Tween(ExitLabel, {TextTransparency = 0}, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out))
            end)
        end
        
        -- Store the popup creation function for later use
        Library.CreateExecutorPopup = function(parentFrame)
            local isUnsupported, executorName, missingFunctions = checkExecutor()
            if isUnsupported or #missingFunctions > 0 then
                createPopup(executorName, missingFunctions, parentFrame)
            end
        end
    end
    
    repeat wait() until game:GetService("ReplicatedStorage"):FindFirstChild("Modules")

    local Modules = game:GetService('ReplicatedStorage').Modules
    
    local ItemsModule = Modules and require(Modules.Items)
    local Guns = {}
    for name, data in next, ItemsModule do
        if data.Type == "Gun" then
            Guns[name] = type(data.Image) == 'string' and data.Image or type(data.Image) == 'table' and data.Image.Default or nil
        end
    end

    -- Radar Module
    Library.Radar = {
        Config = {
            Enabled = false,
            Radius = 150,
            Scale = 1,
            Rotation = true,
            ShowTeam = true,
            ShowUsername = true,
            ShowDistance = true,
            ShowTool = true,
            ToolStyle = "Text+Icon",
            Style = "Disconnect",
            VisibleColor = rgb(0, 255, 85),
            HiddenColor = rgb(255, 0, 0),
            TeamColor = rgb(0, 170, 255),
            RingColor = rgb(16, 15, 16),
            BackgroundColor = rgb(0, 0, 0),
            BackgroundTransparency = 0.5,
        },
        EntityDots = {},
        GUI = nil,
        Container = nil,
        PlayerArrow = nil,
        UpdateConnection = nil,
        GUNS = Guns,
    }
    
    function Library.Radar:Initialize()
        self.GUI = Library:Create( "ScreenGui" , {
            Parent = CoreGui;
            Name = "RadarGui";
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            IgnoreGuiInset = true;
        });
        
        self.Container = Library:Create( "Frame" , {
            Parent = self.GUI;
            Name = "Radar";
            ClipsDescendants = true;
            BackgroundColor3 = self.Config.BackgroundColor;
            BackgroundTransparency = self.Config.BackgroundTransparency;
            Position = dim2(0, 20, 0.5, -125);
            Size = dim2(0, 250, 0, 250);
            BorderSizePixel = 0;
            Visible = false;
        });
        
        Library:Draggify(self.Container)
        Library:Resizify(self.Container)
        
        Library:Create( "UICorner" , {
            Parent = self.Container;
            CornerRadius = dim(1, 0);
        });
        
        Library:Create( "UIStroke" , {
            Parent = self.Container;
            Color = self.Config.RingColor;
            Thickness = 2;
        });
        
        local innerRing = Library:Create( "Frame" , {
            Parent = self.Container;
            Name = "InnerRing";
            AnchorPoint = vec2(0.5, 0.5);
            BackgroundTransparency = 1;
            Position = dim2(0.5, 0, 0.5, 0);
            Size = dim2(0, 100, 0, 100);
        });
        
        Library:Create( "UICorner" , {
            Parent = innerRing;
            CornerRadius = dim(1, 0);
        });
        
        Library:Create( "UIStroke" , {
            Parent = innerRing;
            Color = self.Config.RingColor;
            Transparency = 0.5;
        });
        
        Library:Create( "TextLabel" , {
            Parent = innerRing;
            Name = "DistanceLabel";
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            TextColor3 = rgb(255, 255, 255);
            Text = math.floor(self.Config.Radius / 3) .. "m";
            TextStrokeTransparency = 0;
            AnchorPoint = vec2(1, 0.5);
            Size = dim2(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Position = dim2(1, 0, 0.5, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 14;
        });
        
        local outerRing = Library:Create( "Frame" , {
            Parent = self.Container;
            Name = "OuterRing";
            AnchorPoint = vec2(0.5, 0.5);
            BackgroundTransparency = 1;
            Position = dim2(0.5, 0, 0.5, 0);
            Size = dim2(0, 185, 0, 185);
        });
        
        Library:Create( "UICorner" , {
            Parent = outerRing;
            CornerRadius = dim(1, 0);
        });
        
        Library:Create( "UIStroke" , {
            Parent = outerRing;
            Color = self.Config.RingColor;
            Transparency = 0.5;
        });
        
        Library:Create( "TextLabel" , {
            Parent = outerRing;
            Name = "DistanceLabel";
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            TextColor3 = rgb(255, 255, 255);
            Text = math.floor(self.Config.Radius * 0.74) .. "m";
            TextStrokeTransparency = 0;
            AnchorPoint = vec2(1, 0.5);
            Size = dim2(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Position = dim2(1, 0, 0.5, 0);
            BorderSizePixel = 0;
            AutomaticSize = Enum.AutomaticSize.X;
            TextSize = 14;
        });
        
        self.PlayerArrow = Library:Create( "ImageLabel" , {
            Parent = self.Container;
            Name = "PlayerArrow";
            AnchorPoint = vec2(0.5, 0.5);
            BackgroundTransparency = 1;
            Position = dim2(0.5, 0, 0.5, 0);
            Size = dim2(0, 8, 0, 8);
            BorderSizePixel = 0;
            Image = "rbxassetid://74230686468323";
            ImageColor3 = rgb(255, 255, 255);
        });
    end
    
    function Library.Radar:CreateEntityDot(player)
        local container = Library:Create( "Frame" , {
            Parent = self.Container;
            Name = "EntityContainer_" .. player.Name;
            AnchorPoint = vec2(0.5, 1);
            BackgroundTransparency = 1;
            Size = dim2(0, 100, 0, 50);
            ZIndex = 2;
        });
        
        local dot
        
        if self.Config.Style == "Modern" or self.Config.Style == "Calamari" then
            dot = Library:Create("ImageLabel", {
                Parent = container;
                Name = "Dot";
                AnchorPoint = vec2(0.5, 0.5);
                Position = dim2(0.5, 0, 0, 0);
                Image = "rbxassetid://77925699840868";
                ImageColor3 = self.Config.VisibleColor;
                BackgroundTransparency = 1;
                Size = dim2(0, 12, 0, 12);
                BorderSizePixel = 0;
                ZIndex = 999;
            })
        else
            dot = Library:Create("Frame", {
                Parent = container;
                Name = "Dot";
                AnchorPoint = vec2(0.5, 0);
                Position = dim2(0.5, 0, 0, 0);
                BackgroundColor3 = self.Config.VisibleColor;
                Size = dim2(0, 6, 0, 6);
                BorderSizePixel = 0;
            })
            
            Library:Create("UICorner", {
                Parent = dot;
                CornerRadius = dim(1, 0);
            })
        end
        
        local labelContainer = Library:Create( "Frame" , {
            Parent = container;
            Name = "Labels";
            AnchorPoint = vec2(0.5, 0);
            Position = dim2(0.5, 0, 0, 8);
            BackgroundTransparency = 1;
            Size = dim2(0, 100, 0, 40);
            AutomaticSize = Enum.AutomaticSize.Y;
        });
        
        Library:Create( "UIListLayout" , {
            Parent = labelContainer;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            SortOrder = Enum.SortOrder.LayoutOrder;
        });
        
        Library:Create( "TextLabel" , {
            Parent = labelContainer;
            Name = "Username";
            Text = player and player.Name or '';
            TextColor3 = rgb(255, 255, 255);
            TextStrokeTransparency = 0;
            BackgroundTransparency = 1;
            Size = dim2(0, 1, 0, 1);
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 12;
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
            Visible = self.Config.ShowUsername;
        });
        
        Library:Create( "TextLabel" , {
            Parent = labelContainer;
            Name = "Distance";
            Text = "0m";
            TextColor3 = rgb(200, 200, 200);
            TextStrokeTransparency = 0;
            BackgroundTransparency = 1;
            Size = dim2(0, 1, 0, 1);
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 11;
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            Visible = self.Config.ShowDistance;
        });
        
        local toolContainer = Library:Create("Frame", {
            Parent = labelContainer;
            Name = "ToolContainer";
            BackgroundTransparency = 1;
            Size = dim2(0, 1, 0, 1);
            AutomaticSize = Enum.AutomaticSize.XY;
            Visible = self.Config.ShowTool;
        })
        
        Library:Create("UIListLayout", {
            Parent = toolContainer;
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Padding = dim(0, 2);
        })
        
        Library:Create("ImageLabel", {
            Parent = toolContainer;
            Name = "ToolIcon";
            BackgroundTransparency = 1;
            Size = dim2(0, 20, 0, 20);
            BorderSizePixel = 0;
            Image = "";
            Visible = false;
        })
        
        Library:Create("TextLabel", {
            Parent = toolContainer;
            Name = "ToolText";
            Text = "";
            TextColor3 = rgb(255, 200, 100);
            TextStrokeTransparency = 0;
            BackgroundTransparency = 1;
            Size = dim2(0, 1, 0, 1);
            AutomaticSize = Enum.AutomaticSize.XY;
            TextSize = 11;
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            Visible = false;
        });
        
        self.EntityDots[player] = container
        return container
    end
    
    function Library.Radar:UpdateToolIcon(imageLabel, tool)
        -- Get icon from GUNS table based on tool name
        local iconAssetId = self.GUNS[tool and tool.Name or '']
        
        if iconAssetId then
            imageLabel.Image = iconAssetId
        else
            -- Default icon if tool not in GUNS table
            imageLabel.Image = ""
        end
    end
    
    function Library.Radar:UpdateEntityPosition(player, dot)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            dot.Visible = false
            return
        end
        
        local character = lp.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local myPos = character.HumanoidRootPart.Position
        local theirPos = player.Character.HumanoidRootPart.Position
        local distance = (theirPos - myPos).Magnitude
        
        if distance > self.Config.Radius then
            dot.Visible = false
            return
        end
        
        dot.Visible = true
        
        local relativePos = theirPos - myPos
        local angle = math.atan2(relativePos.Z, relativePos.X)
        
        if self.Config.Rotation then
            local camLook = Camera.CFrame.LookVector
            local camAngle = math.atan2(camLook.Z, camLook.X)
            angle = angle - camAngle
        end
        
        local scale = (distance / self.Config.Radius) * (self.Container.AbsoluteSize.X / 2)
        local x = math.cos(angle) * scale
        local y = math.sin(angle) * scale
        
        dot.Position = dim2(0.5, x, 0.5, y)
        
        local actualDot = dot:FindFirstChild("Dot")
        local labels = dot:FindFirstChild("Labels")
        
        if actualDot then
            local color
            if self.Config.ShowTeam and player.Team == lp.Team and player.Team then
                color = self.Config.TeamColor
            else
                local ray = Ray.new(myPos, (theirPos - myPos).Unit * distance)
                local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {character, player.Character})
                
                if hit then
                    color = self.Config.HiddenColor
                else
                    color = self.Config.VisibleColor
                end
            end
            
            -- Set color based on dot type (ImageLabel uses ImageColor3, Frame uses BackgroundColor3)
            if actualDot:IsA("ImageLabel") then
                actualDot.ImageColor3 = color
                
                -- Rotate arrow based on player direction for Modern and Calamari styles
                if self.Config.Style == "Modern" or self.Config.Style == "Calamari" then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        local lookVector = hrp.CFrame.LookVector
                        local playerAngle = math.atan2(lookVector.Z, lookVector.X)
                        
                        -- Adjust for camera rotation if radar rotation is enabled
                        if self.Config.Rotation then
                            local camLook = Camera.CFrame.LookVector
                            local camAngle = math.atan2(camLook.Z, camLook.X)
                            playerAngle = playerAngle - camAngle
                        end
                        
                        actualDot.Rotation = math.deg(playerAngle) + 90
                    end
                end
            else
                actualDot.BackgroundColor3 = color
            end
        end
        
        if labels then
            local distanceLabel = labels:FindFirstChild("Distance")
            if distanceLabel then
                distanceLabel.Text = math.floor(distance) .. "m"
                distanceLabel.Visible = self.Config.ShowDistance
            end
            
            local usernameLabel = labels:FindFirstChild("Username")
            if usernameLabel then
                usernameLabel.Visible = self.Config.ShowUsername
            end
            
            local toolContainer = labels:FindFirstChild("ToolContainer")
            if toolContainer then
                toolContainer.Visible = self.Config.ShowTool
                local tool
                for i, v in next, player.Character:GetChildren() do
                    if v:IsA('Model') and self.GUNS[v and v.Name or ''] then
                        tool = v
                        break
                    end
                end
                
                local toolIcon = toolContainer:FindFirstChild("ToolIcon")
                local toolText = toolContainer:FindFirstChild("ToolText")
                
                if tool and self.Config.ShowTool then
                    -- Update based on ToolStyle
                    if self.Config.ToolStyle == "Text+Icon" then
                        -- Show both icon and text
                        if toolText then
                            toolText.Text = tool.Name
                            toolText.Visible = true
                        end
                        if toolIcon then
                            self:UpdateToolIcon(toolIcon, tool)
                            toolIcon.Visible = true
                        end
                    elseif self.Config.ToolStyle == "Icon" then
                        -- Show only icon
                        if toolText then
                            toolText.Visible = false
                        end
                        if toolIcon then
                            self:UpdateToolIcon(toolIcon, tool)
                            toolIcon.Visible = true
                        end
                    elseif self.Config.ToolStyle == "Text" then
                        -- Show only text
                        if toolText then
                            toolText.Text = tool.Name
                            toolText.Visible = true
                        end
                        if toolIcon then
                            toolIcon.Visible = false
                        end
                    end
                else
                    -- No tool equipped, hide everything
                    if toolText then
                        toolText.Text = ""
                        toolText.Visible = false
                    end
                    if toolIcon then
                        toolIcon.Visible = false
                    end
                end
            end
        end
    end
    
    function Library.Radar:Update()
        if not self.Config.Enabled or not self.Container then
            return
        end
        
        if self.PlayerArrow and not self.Config.Rotation then
            local character = lp.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local camLook = Camera.CFrame.LookVector
                local angle = math.atan2(camLook.Z, camLook.X)
                self.PlayerArrow.Rotation = math.deg(angle) + 90
            end
        elseif self.PlayerArrow then
            self.PlayerArrow.Rotation = 0
        end
        
        local visibleCount = 0
        local hiddenCount = 0
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= lp then
                local dot = self.EntityDots[player]
                if not dot then
                    dot = self:CreateEntityDot(player)
                end
                self:UpdateEntityPosition(player, dot)
                
                -- Count visible/hidden entities for Calamari style
                if self.Config.Style == "Calamari" then
                    local dotFrame = dot:FindFirstChild("Dot")
                    if dotFrame and dotFrame.Visible then
                        local dotColor
                        if dotFrame:IsA("ImageLabel") then
                            dotColor = dotFrame.ImageColor3
                        else
                            dotColor = dotFrame.BackgroundColor3
                        end
                        
                        if dotColor == self.Config.VisibleColor then
                            visibleCount = visibleCount + 1
                        else
                            hiddenCount = hiddenCount + 1
                        end
                    end
                end
            end
        end
        
        -- Update Calamari entity counters and label frame position
        if self.Config.Style == "Calamari" and self.GUI then
            local labelFrame = self.GUI:FindFirstChild("LabelFrame")
            if labelFrame then
                -- Sync label frame position with radar container
                labelFrame.Position = self.Container.Position
                labelFrame.Size = self.Container.Size
                
                local visibleText = labelFrame:FindFirstChild("VisibleText")
                local hiddenText = labelFrame:FindFirstChild("HiddenText")
                
                if visibleText then
                    visibleText.Text = "Visible Enities: " .. visibleCount
                end
                if hiddenText then
                    hiddenText.Text = "Hidden Enities: " .. hiddenCount
                end
            end
        end
    end
    
    function Library.Radar:Toggle(enabled)
        self.Config.Enabled = enabled
        
        if self.Container then
            self.Container.Visible = enabled
        end
        
        if enabled then
            if not self.UpdateConnection then
                self.UpdateConnection = RunService.RenderStepped:Connect(function()
                    self:Update()
                end)
            end
        else
            if self.UpdateConnection then
                self.UpdateConnection:Disconnect()
                self.UpdateConnection = nil
            end
        end
    end
    
    function Library.Radar:SetRadius(radius)
        self.Config.Radius = radius
        
        if self.Container then
            local innerRing = self.Container:FindFirstChild("InnerRing")
            local outerRing = self.Container:FindFirstChild("OuterRing")
            
            if innerRing then
                local innerLabel = innerRing:FindFirstChild("DistanceLabel")
                if innerLabel then
                    innerLabel.Text = math.floor(radius / 3) .. "m"
                end
            end
            
            if outerRing then
                local outerLabel = outerRing:FindFirstChild("DistanceLabel")
                if outerLabel then
                    outerLabel.Text = math.floor(radius * 0.74) .. "m"
                end
            end
        end
    end
    
    function Library.Radar:SetScale(scale)
        self.Config.Scale = scale
        if self.Container then
            local size = 250 * scale
            self.Container.Size = dim2(0, size, 0, size)
        end
    end
    
    function Library.Radar:SetRotation(enabled)
        self.Config.Rotation = enabled
    end
    
    function Library.Radar:SetVisibleColor(color)
        self.Config.VisibleColor = color
    end
    
    function Library.Radar:SetHiddenColor(color)
        self.Config.HiddenColor = color
    end
    
    function Library.Radar:SetTeamColor(color)
        self.Config.TeamColor = color
    end
    
    function Library.Radar:SetRingColor(color)
        self.Config.RingColor = color
        if self.Container then
            for _, child in pairs(self.Container:GetChildren()) do
                if child:IsA("UIStroke") then
                    child.Color = color
                elseif child.Name == "InnerRing" or child.Name == "OuterRing" then
                    local stroke = child:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color = color
                    end
                end
            end
        end
    end
    
    function Library.Radar:SetBackgroundColor(color)
        self.Config.BackgroundColor = color
        if self.Container then
            self.Container.BackgroundColor3 = color
        end
    end
    
    function Library.Radar:SetStyle(style)
        self.Config.Style = style
        if not self.Container then return end
        
        -- Clear existing style elements from Container
        for _, child in pairs(self.Container:GetChildren()) do
            if child.Name == "StyleElement" or child.Name == "LocalCursor" then
                child:Destroy()
            end
        end
        
        -- Clear existing style elements from GUI (label frame and labels)
        if self.GUI then
            for _, child in pairs(self.GUI:GetChildren()) do
                if child.Name == "VisibleText" or child.Name == "HiddenText" or child.Name == "LabelFrame" then
                    child:Destroy()
                end
            end
        end
        
        -- Destroy all existing entity dots so they can be recreated with the new style
        for player, dotContainer in pairs(self.EntityDots) do
            if dotContainer then
                dotContainer:Destroy()
            end
        end
        self.EntityDots = {}
        
        local uiCorner = self.Container:FindFirstChildOfClass("UICorner")
        local uiStroke = self.Container:FindFirstChildOfClass("UIStroke")
        local innerRing = self.Container:FindFirstChild("InnerRing")
        local outerRing = self.Container:FindFirstChild("OuterRing")
        
        if style == "Modern" then
            -- Modern style: square with small corner radius, no rings
            if uiCorner then
                uiCorner.CornerRadius = dim(0, 1)
            end
            if uiStroke then
                uiStroke.Color = rgb(255, 255, 255)
            end
            
            -- Hide rings for Modern style
            if innerRing then
                innerRing.Visible = false
            end
            if outerRing then
                outerRing.Visible = false
            end
            
            -- Replace PlayerArrow with LocalCursor
            if self.PlayerArrow then
                self.PlayerArrow:Destroy()
            end
            
            -- Create LocalCursor (replaces PlayerArrow)
            local localCursor = Library:Create("ImageLabel", {
                Parent = self.Container;
                Name = "LocalCursor";
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 12, 0, 12);
                AnchorPoint = vec2(0.5, 0.5);
                Image = "rbxassetid://140701848809918";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 0.5, 0);
                ZIndex = 999;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            -- Add direction indicator as child of LocalCursor
            Library:Create("ImageLabel", {
                Parent = localCursor;
                Name = "StyleElement";
                BorderColor3 = rgb(0, 0, 0);
                AnchorPoint = vec2(0.5, 1);
                Image = "rbxassetid://139494354842900";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 1, 0);
                Size = dim2(0, 151, 0, 190);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            self.PlayerArrow = localCursor
            
        elseif style == "Calamari" then
            -- Calamari style: circular with crosshairs and entity counters, no rings
            if uiCorner then
                uiCorner.CornerRadius = dim(1, 100)
            end
            if uiStroke then
                uiStroke.Color = rgb(255, 0, 4)
            end
            
            -- Hide rings for Calamari style
            if innerRing then
                innerRing.Visible = false
            end
            if outerRing then
                outerRing.Visible = false
            end
            
            -- Replace PlayerArrow with LocalCursor
            if self.PlayerArrow then
                self.PlayerArrow:Destroy()
            end
            
            -- Create LocalCursor (replaces PlayerArrow)
            local localCursor = Library:Create("ImageLabel", {
                Parent = self.Container;
                Name = "LocalCursor";
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0, 12, 0, 12);
                AnchorPoint = vec2(0.5, 0.5);
                Image = "rbxassetid://140701848809918";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 0.5, 0);
                ZIndex = 999;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            -- Add direction indicator as child of LocalCursor (smaller for Calamari)
            Library:Create("ImageLabel", {
                Parent = localCursor;
                Name = "StyleElement";
                BorderColor3 = rgb(0, 0, 0);
                AnchorPoint = vec2(0.5, 1);
                Image = "rbxassetid://139494354842900";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 1, 0);
                Size = dim2(0, 100, 0, 100);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            self.PlayerArrow = localCursor
            
            -- Add horizontal crosshair
            Library:Create("ImageLabel", {
                Parent = self.Container;
                Name = "StyleElement";
                ImageColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                Size = dim2(0.52, 100, 0, 10);
                AnchorPoint = vec2(0.5, 0.5);
                Image = "rbxassetid://98490989712349";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 0.5, 0);
                Rotation = 90;
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            -- Add vertical crosshair
            Library:Create("ImageLabel", {
                Parent = self.Container;
                Name = "StyleElement";
                ImageColor3 = rgb(0, 0, 0);
                BorderColor3 = rgb(0, 0, 0);
                AnchorPoint = vec2(0.5, 0.5);
                Image = "rbxassetid://98490989712349";
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 0.5, 0);
                Size = dim2(0.482, 100, 0, 10);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            -- Create transparent frame for labels (same position as radar)
            local labelFrame = Library:Create("Frame", {
                Parent = self.GUI;
                Name = "LabelFrame";
                BackgroundTransparency = 1;
                Position = self.Container.Position;
                Size = self.Container.Size;
                BorderColor3 = rgb(0, 0, 0);
                BorderSizePixel = 0;
                BackgroundColor3 = rgb(0, 0, 0);
            })
            
            Library:Create("UICorner", {
                Parent = labelFrame;
                CornerRadius = dim(1, 100);
            })
            
            -- Add visible entities counter
            Library:Create("TextLabel", {
                Parent = labelFrame;
                Name = "VisibleText";
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                TextColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                Text = "Visible Enities: 0";
                TextStrokeTransparency = 0;
                AnchorPoint = vec2(0.5, 1);
                Size = dim2(0, 1, 0, 1);
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 1, 15);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.X;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
            -- Add hidden entities counter
            Library:Create("TextLabel", {
                Parent = labelFrame;
                Name = "HiddenText";
                FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                TextColor3 = rgb(255, 255, 255);
                BorderColor3 = rgb(0, 0, 0);
                Text = "Hidden Enities: 0";
                TextStrokeTransparency = 0;
                AnchorPoint = vec2(0.5, 1);
                Size = dim2(0, 1, 0, 1);
                BackgroundTransparency = 1;
                Position = dim2(0.5, 0, 1, 35);
                BorderSizePixel = 0;
                AutomaticSize = Enum.AutomaticSize.X;
                TextSize = 14;
                BackgroundColor3 = rgb(255, 255, 255);
            })
            
        else
            -- Disconnect style (default): circular with rings
            if uiCorner then
                uiCorner.CornerRadius = dim(1, 0)
            end
            if uiStroke then
                uiStroke.Color = self.Config.RingColor
            end
            
            -- Show rings for Disconnect style
            if innerRing then
                innerRing.Visible = true
            end
            if outerRing then
                outerRing.Visible = true
            end
            
            -- Restore original PlayerArrow if it was replaced
            if self.PlayerArrow and self.PlayerArrow.Name == "LocalCursor" then
                self.PlayerArrow:Destroy()
                
                self.PlayerArrow = Library:Create("ImageLabel", {
                    Parent = self.Container;
                    Name = "PlayerArrow";
                    AnchorPoint = vec2(0.5, 0.5);
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    Size = dim2(0, 8, 0, 8);
                    BorderSizePixel = 0;
                    Image = "rbxassetid://74230686468323";
                    ImageColor3 = rgb(255, 255, 255);
                })
            end
        end
    end
    
    Players.PlayerRemoving:Connect(function(player)
        if Library.Radar.EntityDots[player] then
            Library.Radar.EntityDots[player]:Destroy()
            Library.Radar.EntityDots[player] = nil
        end
    end)
    
    Library.Radar:Initialize()
    
    Library.AmmoBar = {
        Config = {
            ReloadTime = 9,
            IsReloading = false,
        },
        GUI = nil,
        BarBG = nil,
        BarProgress = nil,
        ColorConnection = nil,
    }

    local GREEN = Color3.fromHex('#53ED21')
    local YELLOW = Color3.fromHex('#C9FF2B')
    local RED = Color3.fromHex('#DB1E03')

    local function LerpColor(a, b, t)
        return Color3.new(
            a.R + (b.R - a.R) * t,
            a.G + (b.G - a.G) * t,
            a.B + (b.B - a.B) * t
        )
    end

    function Library.AmmoBar:Initialize()
        self.GUI = Library:Create('ScreenGui', {
            Parent = CoreGui,
            Name = 'AmmoBarGui',
            IgnoreGuiInset = true,
            Enabled = false,
        })

        self.BarBG = Library:Create('Frame', {
            Parent = self.GUI,
            AnchorPoint = vec2(0.5, 0),
            Position = dim2(0.5, 0, 0.5, 20),
            Size = dim2(0, 152, 0, 6),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0),
            BackgroundTransparency = 1,
        })

        Library:Create('UICorner', {
            Parent = self.BarBG,
            CornerRadius = dim(0, 3),
        })

        self.BarProgress = Library:Create('Frame', {
            Parent = self.BarBG,
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(0, 0, 0.5, 0),
            Size = dim2(0, 0, 0, 4),
            BorderSizePixel = 0,
            BackgroundColor3 = GREEN,
            BackgroundTransparency = 1,
        })

        Library:Create('UICorner', {
            Parent = self.BarProgress,
            CornerRadius = dim(0, 3),
        })
    end

    function Library.AmmoBar:Reload(time)
        if (self.Config.IsReloading) then return end

        self.Config.ReloadTime = time or self.Config.ReloadTime
        self.Config.IsReloading = true

        if (self.ColorConnection) then
            self.ColorConnection:Disconnect()
            self.ColorConnection = nil
        end

        self.GUI.Enabled = true

        self.BarBG.Position = dim2(0.5, 0, 0, 600)
        self.BarBG.Size = dim2(0, 0, 0, 6)
        self.BarBG.BackgroundTransparency = 1

        self.BarProgress.Size = dim2(0, 0, 0, 4)
        self.BarProgress.BackgroundTransparency = 1
        self.BarProgress.BackgroundColor3 = GREEN

        local reloadTime = self.Config.ReloadTime
        local startTime = tick()

        TweenService:Create(
            self.BarBG,
            TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = dim2(0.5, 0, 0.5, 20) }
        ):Play()

        local sizeTweenBG = TweenService:Create(
            self.BarBG,
            TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            { Size = dim2(0, 152, 0, 6) }
        )

        TweenService:Create(self.BarBG, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
        TweenService:Create(self.BarProgress, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()

        sizeTweenBG:Play()
        sizeTweenBG.Completed:Wait()

        local maxWidth = self.BarBG.AbsoluteSize.X - 4

        self.ColorConnection = RunService.RenderStepped:Connect(function()
            local alpha = math.clamp((tick() - startTime) / reloadTime, 0, 1)

            self.BarProgress.Size = dim2(0, maxWidth * alpha, 0, 4)

            if (alpha < 0.5) then
                self.BarProgress.BackgroundColor3 = LerpColor(GREEN, YELLOW, alpha * 2)
            else
                self.BarProgress.BackgroundColor3 = LerpColor(YELLOW, RED, (alpha - 0.5) * 2)
            end

            if (alpha >= 1) then
                if (self.ColorConnection) then
                    self.ColorConnection:Disconnect()
                    self.ColorConnection = nil
                end
            end
        end)

        task.delay(reloadTime, function()
            self.Config.IsReloading = false

            TweenService:Create(self.BarBG, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(self.BarProgress, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()

            TweenService:Create(
                self.BarBG,
                TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
                { Size = dim2(0, 0, 0, 6) }
            ):Play()

            local outTween = TweenService:Create(
                self.BarBG,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                { Position = dim2(0.5, 0, 0, 600) }
            )

            outTween:Play()
            outTween.Completed:Wait()

            self.GUI.Enabled = false
            self.BarProgress.Size = dim2(0, 0, 0, 4)
            self.BarProgress.BackgroundColor3 = GREEN
        end)
    end


    Library.AmmoBar:Initialize()
    
    -- Inventory View Module
    Library.InventoryView = {
        Config = { Enabled = false },
        GUI = nil,
        Inventory = nil,
        PlayerName = nil,
        Holder = nil,
        Slots = {},
        _slotPool = {},
        _slotCache = setmetatable({}, { __mode = 'k' })
    }

    function Library.InventoryView:_HydrateSlot(Item)
        local selBg = Library:Create('Frame', {
            Parent = Item,
            Name = 'SelectedBG',
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.85,
            BackgroundColor3 = rgb(75, 153, 255),
            ZIndex = 0,
            Visible = false
        })

        local inlineL = Library:Create('Frame', {
            Parent = Item,
            Name = 'InlineL',
            Size = dim2(0, 4, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(113, 142, 80),
            ZIndex = 1,
            Visible = false
        })

        local inlineR = Library:Create('Frame', {
            Parent = Item,
            Name = 'InlineR',
            AnchorPoint = vec2(1, 0.5),
            Position = dim2(1, 0, 0.5, 0),
            Size = dim2(0, 4, 1, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(113, 142, 80),
            ZIndex = 1,
            Visible = false
        })

        local img = Library:Create('ImageLabel', {
            Parent = Item,
            Name = 'Image',
            AnchorPoint = vec2(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = dim2(0.5, 0, 0.5, 0),
            Size = dim2(0, 65, 0, 65)
        })

        local amt = Library:Create('TextLabel', {
            Parent = Item,
            Name = 'Amount',
            FontFace = Font.new('rbxassetid://12187365364'),
            TextColor3 = rgb(255, 255, 255),
            TextStrokeTransparency = 0,
            AnchorPoint = vec2(1, 1),
            BackgroundTransparency = 1,
            Position = dim2(1, -8, 1, -4),
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 14,
            Visible = false
        })

        self._slotCache[Item] = {
            selBg = selBg,
            inlineL = inlineL,
            inlineR = inlineR,
            img = img,
            amt = amt
        }
    end

    function Library.InventoryView:_AcquireSlot()
        local pool = self._slotPool
        local n = #pool
        if (n > 0) then
            local slot = pool[n]
            pool[n] = nil
            if (not self._slotCache[slot]) then
                self:_HydrateSlot(slot)
            end
            slot.Visible = true
            slot.Parent = self.Holder
            return slot
        end

        local Item = Library:Create('Frame', {
            Name = 'Item',
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 103, 0, 89),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        self:_HydrateSlot(Item)
        return Item
    end

    function Library.InventoryView:_ReleaseAllSlots()
        local slots = self.Slots
        local pool = self._slotPool
        for i = #slots, 1, -1 do
            local slot = slots[i]
            slot.Visible = false
            slot.Parent = nil
            pool[#pool + 1] = slot
            slots[i] = nil
        end
    end

    function Library.InventoryView:Initialize()
        self.GUI = Library:Create('ScreenGui', {
            Parent = CoreGui,
            Name = 'InventoryViewGui',
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true,
            Enabled = false
        })

        self.Inventory = Library:Create('Frame', {
            Parent = self.GUI,
            Name = 'Inventory',
            BorderColor3 = rgb(0, 0, 0),
            AnchorPoint = vec2(0.5, 0),
            BackgroundTransparency = 1,
            Position = dim2(0.49465715885162354, 0, 0.1596534699201584, 0),
            Size = dim2(0, 1, 0, 99),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        local Header = Library:Create('Frame', {
            Parent = self.Inventory,
            Name = 'Header',
            BorderColor3 = rgb(0, 0, 0),
            AnchorPoint = vec2(0.5, 0),
            Position = dim2(0.5, 0, 0, 0),
            Size = dim2(1, 1, 0, 12),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(0, 0, 0)
        })

        self.PlayerName = Library:Create('TextLabel', {
            Parent = Header,
            Name = '',
            FontFace = Font.new('rbxassetid://12187365364', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Players.LocalPlayer.Name,
            TextStrokeTransparency = 0,
            AnchorPoint = vec2(0.5, 0.5),
            Size = dim2(0, 1, 0, 1),
            BackgroundTransparency = 1,
            Position = dim2(0.5, 0, 0.5, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        self.Holder = Library:Create('Frame', {
            Parent = self.Inventory,
            Name = 'Holder',
            BorderColor3 = rgb(0, 0, 0),
            BackgroundTransparency = 1,
            Position = dim2(-0.0019417476141825318, 0, 0.13131313025951385, 0),
            Size = dim2(0, 1, 0, 89),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(255, 255, 255)
        })

        Library:Create('UIListLayout', {
            Parent = self.Holder,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Library:Create('UIListLayout', {
            Parent = self.Inventory,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Library:Draggify(self.Inventory)

        self.Inventory.Visible = false
        self.GUI.Enabled = false
    end

    function Library.InventoryView:CreateItem(parent, imageId, amount, isSelected)
        local Item = self:_AcquireSlot()
        Item.Parent = parent

        local c = self._slotCache[Item]
        c.img.Image = imageId

        if (amount ~= nil) then
            c.amt.Text = tostring(amount)
            c.amt.Visible = true
        else
            c.amt.Visible = false
        end

        local sel = (isSelected == true)
        c.selBg.Visible = sel
        c.inlineL.Visible = sel
        c.inlineR.Visible = sel

        self.Slots[#self.Slots + 1] = Item
    end

    function Library.InventoryView:SetItems(armor, gun, secondary, username)
        if (not self.Config.Enabled) then
            return
        end

        if (username and self.PlayerName) then
            self.PlayerName.Text = username
        end

        self:_ReleaseAllSlots()

        if armor then
            for _, item in ipairs(armor) do
                local img = item and item.Image
                if img then
                    self:CreateItem(self.Holder, 'rbxassetid://' .. tostring(img), nil, false)
                end
            end
        end

        if (gun and gun ~= 'None' and GunTable) then
            local t = GunTable[gun]
            local img = t and t.Default
            if img then
                self:CreateItem(self.Holder, img, nil, true)
            end
        end

        if (secondary and secondary ~= 'None' and GunTable) then
            local t = GunTable[secondary]
            local img = t and t.Default
            if img then
                self:CreateItem(self.Holder, img, nil, false)
            end
        end
    end

    function Library.InventoryView:Toggle(enabled)
        if (enabled == self.Config.Enabled) then
            return
        end

        self.Config.Enabled = enabled

        if enabled then
            self.GUI.Enabled = true
            self.Inventory.Visible = true
        else
            self.Inventory.Visible = false
            self.GUI.Enabled = false
        end
    end

    Library.InventoryView:Initialize()

    -- Library element functions
        function Library:Window(properties)
            local Cfg = {
                Name = properties.Name or "Nebula";
                Size = properties.Size or dim2(0, 620, 0, 585);
                LibraryIcon = properties.LibraryIcon or "rbxassetid://71350099335838";
                TabInfo;
                Items = {};
            }
            
            -- Store library icon globally for notifications
            Library.LibraryIcon = Cfg.LibraryIcon
            
            Library.Items = Library:Create( "ScreenGui" , {
                Parent = CoreGui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            });
            
            Library.Other = Library:Create( "ScreenGui" , {
                Parent = CoreGui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            local Items = Cfg.Items; do
                -- Window
                    Items.Window = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Name = "\0";
                        Visible = false;
                        Position = dim2(0.5, -Cfg.Size.X.Offset / 2, 0.5, -Cfg.Size.Y.Offset / 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = Cfg.Size;
                        BorderSizePixel = 0;
                        ClipsDescendants = true;
                        BackgroundColor3 = rgb(11, 10, 12)
                    }); Items.Window.Position = dim2(0, Items.Window.AbsolutePosition.X, 0, Items.Window.AbsolutePosition.Y);

                    Library:Draggify(Items.Window)
                    Library:Resizify(Items.Window)

                    Library:Create( "UICorner" , {
                        Parent = Items.Window;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Window;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.accent,
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Parent = Items.Inline;
                        Name = "\0";
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 14, 0, 11);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); Library:Themify(Items.Title, "accent", "TextColor3")

                    Items.TopBar = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Inline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 40);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.TopBar;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Fill = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Items.Line = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.TabButtonHolder = Library:Create( "Frame" , {
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(1, -4, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = Items.TabButtonHolder;
                        Padding = dim(0, 15);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Items.Page = Library:Create( "Frame" , {
                        Parent = Items.Inline;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0, 44);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -8, 1, -77);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = Items.Page;
                        Padding = dim(0, 4);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        VerticalFlex = Enum.UIFlexAlignment.Fill
                    });

                    Items.Bottom = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.Inline;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 29);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Bottom;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Fill = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Bottom;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Items.Line = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Bottom;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.Game = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.accent;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name;
                        Parent = Items.Bottom;
                        AnchorPoint = vec2(0, 0.5);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); Library:Themify(Items.Game, "accent", "TextColor3")

                    Items.MenuKey = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = rgb(75, 75, 76);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Menu: Insert";
                        Parent = Items.Bottom;
                        AnchorPoint = vec2(1, 0.5);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -10, 0.5, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                -- Watermark
                    Items.Watermark = Library:Create( "Frame" , {
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        Position = dim2(0.008904719725251198, 0, 0.017326733097434044, 0);
                        Size = dim2(0, -10, 0, 1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = rgb(6, 1, 6);
                        Parent = Library.Items;
                        Visible = true;
                    });
                    
                    -- Store reference globally for config system
                    Library.UIElements = Library.UIElements or {}
                    Library.UIElements.Watermark = Items.Watermark

                    Library:Create( "UICorner" , {
                        CornerRadius = dim(0, 4);
                        Parent = Items.Watermark
                    });

                    Items.WatermarkLineHolder = Library:Create( "Frame" , {
                        Name = "\0";
                        BackgroundTransparency = 1;
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 8, 0, 46);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        Parent = Items.Watermark
                    });

                    Items.WatermarkInline = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 0.5);
                        Name = "\0";
                        Position = dim2(-0.3499999940395355, 0, 0.5, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 8, 0.5, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent;
                        Parent = Items.WatermarkLineHolder
                    }); Library:Themify(Items.WatermarkInline, "accent", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.WatermarkInline
                    });

                    Items.WatermarkLabelHolder = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0.14351852238178253, 0, 0, 0);
                        Size = dim2(0, 31, 1, 1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        BackgroundColor3 = rgb(255, 255, 255);
                        Parent = Items.Watermark
                    });

                    Items.WatermarkLabel = Library:Create( "TextLabel" , {
                        RichText = true;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name .. " | Menu: ...";
                        Name = "\0";
                        Size = dim2(0, 1, 0, 1);
                        AnchorPoint = vec2(0.5, 0.5);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(1.080645203590393, 0, 0.5869565010070801, 0);
                        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255);
                        Parent = Items.WatermarkLabelHolder
                    });

                    Library:Create( "UIListLayout" , {
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = Items.WatermarkLabelHolder
                    });

                    Library:Create( "UIPadding" , {
                        PaddingTop = dim(0, 14);
                        Parent = Items.WatermarkLabelHolder
                    });

                    Library:Create( "UIListLayout" , {
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal;
                        Parent = Items.Watermark
                    });

                    Library:Create( "UIPadding" , {
                        PaddingRight = dim(0, 12);
                        Parent = Items.Watermark
                    });

                    Library:Create( "UIStroke" , {
                        Color = rgb(13, 13, 13);
                        Parent = Items.Watermark
                    });

                    Library:Draggify(Items.Watermark)
                -- 

                -- Keybind list
                    Items.Outline = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Size = dim2(0, 200, 0, 0);
                        Name = "\0";
                        Visible = false;
                        Position = dim2(0, 10, 0, 600);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.Outline
                    }); Library:Draggify(Items.Outline); Library:Themify(Items.Outline, "Outline", "BackgroundColor3")
                    
                    -- Store reference globally for config system
                    Library.UIElements.Keybinds = Items.Outline

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.TopBar = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Inline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        ClipsDescendants = true;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Items.InlineHolder = Library:Create( "Frame" , {
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BackgroundTransparency = 1;
                        AnchorPoint = vec2(0, 0.5);
                        Position = dim2(0, 0, 0.5, 0);
                        Name = "InlineHolder";
                        Size = dim2(0, 15, 0, 52);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        Parent = Items.TopBar
                    });

                    Library:Create( "UICorner" , {
                        CornerRadius = dim(0, 4);
                        Parent = Items.InlineHolder
                    });

                    Items.InlineAccent = Library:Create( "Frame" , {
                        Name = "Inline";
                        AnchorPoint = vec2(0, 0.5);
                        Position = dim2(0, -4, 0.5, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 8, 0.3, 1);
                        BorderSizePixel = 0;

                        BackgroundColor3 = themes.preset.accent;
                        Parent = Items.InlineHolder
                    }); Library:Themify(Items.InlineAccent, "accent", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.InlineAccent
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.TopBar;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Fill = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Items.Line = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.KeybindsLabel = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.accent;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "Keybinds";
                            AnchorPoint = vec2(0, 0.5);
                            Parent = Items.TopBar;
                            BackgroundTransparency = 1;
                            Position = dim2(0, 15, 0.5, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 18;
                            BackgroundColor3 = themes.preset.accent
                        });	Library:Themify(Items.KeybindsLabel, "accent", "TextColor3")
                
                    --KEYBIND ICON
                    --   Items.KeybindsIcon = Library:Create( "ImageLabel" , {
                    --         ImageColor3 = themes.preset.accent;
                    --         BorderColor3 = rgb(0, 0, 0);
                    --         Parent = Items.TopBar;
                    --         Image = "rbxassetid://89224403789635";
                    --         BackgroundTransparency = 1;
                    --         Position = dim2(0, 5, 0, 5);
                    --         Size = dim2(0, 22, 0, 22);
                    --         BorderSizePixel = 0;
                    --         BackgroundColor3 = themes.preset.accent
                    --     });	Library:Themify(Items.KeybindsIcon, "accent", "ImageColor3")

                    --     Library:Create( "UIGradient" , {
                    --         Color = rgbseq{rgbkey(0, rgb(163, 163, 163)), rgbkey(1, rgb(163, 163, 163))};
                    --         Parent = Items.KeybindsIcon
                    --     });

                        Items.Elements = Library:Create( "Frame" , {
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = Items.Inline;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 4, 0, 34);
                            Size = dim2(1, -8, 0, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.Y;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); Library.Elements = Items.Elements

                        Library:Create( "UIListLayout" , {
                            Parent = Items.Elements;
                            Padding = dim(0, 8);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Library:Create( "UIPadding" , {
                            PaddingBottom = dim(0, 10);
                            Parent = Items.Elements
                        });


                    -- 
                end

                function Cfg.ChangeWindowTitle(text)
                    Items.Title.Text = text
                end

                function Cfg.ToggleMenu(bool) 
                    if Cfg.Tweening then 
                        return 
                    end 

                    Cfg.Tweening = true 

                    if bool then 
                        Items.Window.Visible = true
                    end

                    local Children = Items.Window:GetDescendants()
                    table.insert(Children, Items.Window)

                    local Tween;
                    for _,obj in Children do
                        local Index = Library:GetTransparency(obj)

                        if not Index then 
                            continue 
                        end

                        if type(Index) == "table" then
                            for _,prop in Index do
                                Tween = Library:Fade(obj, prop, bool)
                            end
                        else
                            Tween = Library:Fade(obj, Index, bool)
                        end
                    end

                    Library:Connection(Tween.Completed, function()
                        Cfg.Tweening = false
                        Items.Window.Visible = bool
                    end)
                end 
                
                function Cfg.ToggleList(bool)
                    Items.Outline.Visible = bool
                end
                
                -- Show initial notification after window is fully created
                task.spawn(function()
                    task.wait(1)
                    Library:Notification({
                        Title = Cfg.Name;
                        Description = "Successfully Injected";
                        Duration = 4;
                    })
                end)
                
                -- Create executor popup if needed, parented to the main window
                if Library.CreateExecutorPopup then
                    Library.CreateExecutorPopup(Items.Window)
                end

                return setmetatable(Cfg, Library)
            end 

            function Library:Tab(properties)
                local Cfg = {
                    Name = properties.name or properties.Name or "visuals"; 
                    Items = {};

                    Tween = nil;
                }

                local Items = Cfg.Items; do 
                    -- Tab buttons 
                        Items.Button = Library:Create( "TextButton" , {
                            Active = false;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = self.Items.TabButtonHolder;
                            Name = "\0";
                            Size = dim2(0, 0, 1, 0);
                            BackgroundTransparency = 1;
                            Selectable = false;
                            BorderSizePixel = 0;
                            TextTransparency = 1;
                            AutomaticSize = Enum.AutomaticSize.X;
                            BackgroundColor3 = themes.preset.accent
                        });	Library:Themify(Items.Button, "accent", "BackgroundColor3")

                        Items.ButtonTitle = Library:Create( "TextLabel" , {
                            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                            TextColor3 = themes.preset.SecondaryColor;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = Cfg.Name;
                            AnchorPoint = vec2(0, 0.5);
                            Parent = Items.Button;
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 0.5, 0);
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 18;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Items.AccentLine = Library:Create( "Frame" , {
                            Parent = Items.Button;
                            Name = "\0";
                            BackgroundTransparency = 1;
                            Position = dim2(0, 0, 1, -1);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        });	Library:Themify(Items.AccentLine, "accent", "BackgroundColor3")

                        Items.Gradient = Library:Create( "UIGradient" , {
                            Rotation = 90;
                            Transparency = numseq{numkey(0, 0), numkey(0.002, 1), numkey(0.591, 1), numkey(0.988, 0.6812499761581421), numkey(0.998, 0.006249964237213135), numkey(0.999, 0), numkey(1, 0), numkey(1, 0)};
                            Parent = Items.Button
                        });
                    -- 

                    -- Page Directory
                        Items.Page = Library:Create( "Frame" , {
                            Parent = Library.Other; -- Items.Window
                            Name = "\0";
                            Visible = false;
                            BackgroundTransparency = 1;
                            Position = dim2(0, 4, 0, 44);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, -8, 1, -77);
                            BorderSizePixel = 0;
                            ClipsDescendants = true;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIListLayout" , {
                            FillDirection = Enum.FillDirection.Horizontal;
                            HorizontalFlex = Enum.UIFlexAlignment.Fill;
                            Parent = Items.Page;
                            Padding = dim(0, 4);
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            VerticalFlex = Enum.UIFlexAlignment.Fill
                        });

                        Items.Left = Library:Create( "Frame" , {
                            Parent = Items.Page;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 100, 0, 100);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIListLayout" , {
                            Parent = Items.Left;
                            Padding = dim(0, 7);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Library:Create( "UIPadding" , {
                            PaddingBottom = dim(0, 7);
                            Parent = Items.Left
                        });

                        Items.Right = Library:Create( "Frame" , {
                            Parent = Items.Page;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 100, 0, 100);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIListLayout" , {
                            Parent = Items.Right;
                            Padding = dim(0, 7);
                            SortOrder = Enum.SortOrder.LayoutOrder
                        });

                        Library:Create( "UIPadding" , {
                            PaddingBottom = dim(0, 7);
                            Parent = Items.Right
                        });


                    -- 
                end 

                function Cfg.OpenTab()
                    local Tab = self.TabInfo

                    if Tab == Cfg then 
                        return 
                    end 
                    
                    if Tab then
                        Library:Tween(Tab.Items.Button, {BackgroundTransparency = 1})
                        Library:Tween(Tab.Items.ButtonTitle, {TextColor3 = themes.preset.SecondaryColor, Position = dim2(0, 0, 0.5, 0)})
                        Library:Tween(Tab.Items.AccentLine, {BackgroundTransparency = 1})
                        Tab.Tween(false)
                        
                        if themes.utility.accent and themes.utility.accent.TextColor3 then
                            for i, obj in pairs(themes.utility.accent.TextColor3) do
                                if obj == Tab.Items.ButtonTitle then
                                    table.remove(themes.utility.accent.TextColor3, i)
                                    break
                                end
                            end
                        end
                    end

                    Items.Button.BackgroundTransparency = 0
                    Items.ButtonTitle.TextColor3 = themes.preset.accent
                    Items.ButtonTitle.Position = dim2(0, 0, 0.5, -3)
                    Items.AccentLine.BackgroundTransparency = 0
                    
                    Library:Tween(Items.Button, {BackgroundTransparency = 0})
                    Library:Tween(Items.ButtonTitle, {TextColor3 = themes.preset.accent, Position = dim2(0, 0, 0.5, -3)})
                    Library:Tween(Items.AccentLine, {BackgroundTransparency = 0})
                    Cfg.Tween(true)
                    
                    Library:Themify(Items.ButtonTitle, "accent", "TextColor3")
                    
                    self.TabInfo = Cfg
                end

                function Cfg.Tween(bool) 
                    if Cfg.Tweening then 
                        return 
                    end 

                    Items.Page.Parent = bool and self.Items.Window or Library.Other

                    Cfg.Tweening = true 

                    if bool then 
                        Items.Page.Visible = true
                        Items.Page.Position = dim2(0, -30, 0, 44)
                    end

                    local Children = Items.Page:GetDescendants()
                    table.insert(Children, Items.Holder)

                    local Tween;
                    for _,obj in Children do
                        local Index = Library:GetTransparency(obj)

                        if not Index then 
                            continue 
                        end

                        if type(Index) == "table" then
                            for _,prop in Index do
                                Tween = Library:Fade(obj, prop, bool)
                            end
                        else
                            Tween = Library:Fade(obj, Index, bool)
                        end
                    end

                    if bool then
                        Tween = Library:Tween(Items.Page, {Position = dim2(0, 4, 0, 44)})
                    end

                    Library:Connection(Tween.Completed, function()
                        Cfg.Tweening = false
                    end)
                end 

                Items.Button.MouseButton1Down:Connect(function()
                    if Cfg.Tweening or self.TabInfo.Tweening then
                        return 
                    end 

                    Cfg.OpenTab()
                end)

                if not self.TabInfo then
                    self.TabInfo = Cfg
                    task.defer(function()
                        Items.Button.BackgroundTransparency = 0
                        Items.ButtonTitle.TextColor3 = themes.preset.accent
                        Items.ButtonTitle.Position = dim2(0, 0, 0.5, -3)
                        Items.AccentLine.BackgroundTransparency = 0
                        Library:Themify(Items.ButtonTitle, "accent", "TextColor3")
                        
                        Items.Page.Parent = self.Items.Window
                        Items.Page.Visible = true
                        Items.Page.Position = dim2(0, 4, 0, 44)
                    end)
                end

                return setmetatable(Cfg, Library)
            end

            function Library:Section(properties)
                local Cfg = {
                    Name = properties.name or properties.Name or "Section"; 
                    Side = properties.side or properties.Side or "Left";

                    -- Fill settings 
                    Fill = properties.Fill or properties.fill or 1;
                    Size = properties.Size or properties.size or nil;

                    -- Other
                    Items = {};
                };
                
                local Items = Cfg.Items; do
                    Items.Outline = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = self.Items[Cfg.Side];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, Cfg.Fill, Cfg.Size);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.TopBar = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Inline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.TopBar;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Fill = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 3);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Background
                    });

                    Items.Line = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0, 1);
                        Parent = Items.TopBar;
                        Name = "\0";
                        Position = dim2(0, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.TextLabel = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.accent;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.TopBar;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 9, 0.5, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                    });	Library:Themify(Items.TextLabel, "accent", "TextColor3")

                    Items.ScrollingFrame = Library:Create( "ScrollingFrame" , {
                        ScrollBarImageColor3 = themes.preset.accent;
                        MidImage = "rbxassetid://80154988326407";
                        Active = true;
                        AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        ScrollBarThickness = 4;
                        Parent = Items.Inline;
                        Size = dim2(1, 0, 1, -30);
                        BorderColor3 = rgb(0, 0, 0);
                        TopImage = "rbxassetid://80154988326407";
                        Position = dim2(0, 0, 0, 30);
                        BackgroundTransparency = 1;
                        BottomImage = "rbxassetid://80154988326407";
                        BorderSizePixel = 0;
                        CanvasSize = dim2(0, 0, 0, 0)
                    });	Library:Themify(Items.ScrollingFrame, "accent", "ScrollBarImageColor3")

                    Items.Elements = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.ScrollingFrame;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0, 4);
                        Size = dim2(1, -18, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        Parent = Items.Elements;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = Items.Elements
                    });
                end 

                Items.ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
                    local Scrolling = Items.ScrollingFrame.AbsoluteCanvasSize.Y > Items.Inline.AbsoluteSize.Y - 30
                    Items.Elements.Size = dim2(1, Scrolling and -18 or -8, 0, 0)
                end)
                
                return setmetatable(Cfg, Library)
            end  

            function Library:Toggle(properties) 
                local Cfg = {
                    Name = properties.Name or "Toggle";
                    Flag = properties.Flag or properties.Name or "Toggle";
                    Enabled = properties.Default or false;
                    Callback = properties.Callback or function() end;

                    -- Sub / Group Section
                    Folding = properties.Folding or false;
                    Collapsable = properties.Collapsing or true;

                    Items = {};
                }

                local Items = Cfg.Items; do
                    Items.Toggle = Library:Create( "TextButton" , {
                        Parent = self.Items.Elements;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Outline = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Toggle;
                        Position = dim2(0, 0, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 18, 0, 18);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3") 

                    Items.Accent = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        AnchorPoint = vec2(0.5, 0.5);
                        Position = dim2(0.5, 0, 0.5, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Accent;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Tick = Library:Create( "ImageLabel" , {
                        ImageTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Accent;
                        Image = "rbxassetid://106815062818967";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        AnchorPoint = vec2(0.5, 0.5);
                        Position = dim2(0.5, 0, 0.5, 0);
                        Size = dim2(1, 0, 1, 0);
                        ZIndex = 555;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });
                    
                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.Toggle;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 23, 0.5, 1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    })

                    Items.Components = Library:Create( "Frame" , {
                        Parent = Items.Toggle;
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = Items.Components;
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                end 

                function Cfg.Set(bool)
                    Flags[Cfg.Flag] = bool

                    Library:Tween(Items.Title, {TextColor3 = bool and themes.preset.ActiveText or themes.preset.SecondaryColor})
                    Library:Tween(Items.Tick, {ImageTransparency = bool and 0 or 1})
                    Library:Tween(Items.Accent, {BackgroundTransparency = bool and 0 or 1})

                    Cfg.Callback(bool)                  
                end 
                
                Items.Toggle.MouseButton1Click:Connect(function()
                    Cfg.Enabled = not Cfg.Enabled
                    Cfg.Set(Cfg.Enabled)
                end)
                
                Cfg.Set(Cfg.Enabled)

                ConfigFlags[Cfg.Flag] = Cfg.Set

                return setmetatable(Cfg, Library)
            end 
            
            function Library:Slider(properties) 
                local Cfg = {
                    Name = properties.Name,
                    Suffix = properties.Suffix or "",
                    Flag = properties.Flag or properties.Name or "Slider",
                    Callback = properties.Callback or function() end, 

                    -- Value Settings
                    Min = properties.Min or 0,
                    Max = properties.Max or 100,
                    Intervals = properties.Decimal or properties.Decimals or 1,
                    Value = properties.Default or 10, 

                    -- Other
                    Dragging = false,
                    Items = {}
                } 

                local Items = Cfg.Items; do
                    Items.Slider = Library:Create( "Frame" , {
                        Parent = self.Items.Elements;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 32);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Title = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = Cfg.Name;
                        Parent = Items.Slider;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Title, "SecondaryColor", "TextColor3")

                    Items.Components = Library:Create( "Frame" , {
                        Parent = Items.Slider;
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Library:Create( "UIListLayout" , {
                        Parent = Items.Components;
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Items.Value = Library:Create( "TextBox" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "90%";
                        BackgroundTransparency = 1;
                        Parent = Items.Components;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.Value, "SecondaryColor", "TextColor3")

                    Items.Outline = Library:Create( "TextButton" , {
                        Active = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Slider;
                        Name = "\0";
                        Position = dim2(0, 0, 0, 27);
                        Selectable = false;
                        Size = dim2(1, 0, 0, 4);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Accent = Library:Create( "Frame" , {
                        Name = "\0";
                        Parent = Items.Outline;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0.5, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.accent
                    });	Library:Themify(Items.Accent, "accent", "BackgroundColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Accent;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Circle = Library:Create( "Frame" , {
                        AnchorPoint = vec2(0.5, 0.5);
                        Parent = Items.Accent;
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 10, 0, 10);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 25)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Circle;
                        CornerRadius = dim(0, 999)
                    });
                end 

                function Cfg.Set(value)
                    Cfg.Value = math.clamp(Library:Round(value, Cfg.Intervals), Cfg.Min, Cfg.Max)

                    Items.Value.Text = tostring(Cfg.Value) .. Cfg.Suffix

                    Library:Tween(Items.Accent, 
                        {Size = dim2((Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min), 0, 1, 0)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Library:Tween(Items.Value, 
                        {TextColor3 = rgb(245, 245, 245)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Library:Tween(Items.Title, 
                        {TextColor3 = rgb(245, 245, 245)
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    Flags[Cfg.Flag] = Cfg.Value
                    Cfg.Callback(Flags[Cfg.Flag])
                end
                
                Items.Outline.MouseButton1Down:Connect(function()
                    Cfg.Dragging = true 
                end)

                Library:Connection(InputService.InputChanged, function(input)
                    if Cfg.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                        local Size = (input.Position.X - Items.Outline.AbsolutePosition.X) / Items.Outline.AbsoluteSize.X
                        local Value = ((Cfg.Max - Cfg.Min) * Size) + Cfg.Min
                        Cfg.Set(Value)
                    end
                end)

                Library:Connection(InputService.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Cfg.Dragging = false

                        Library:Tween(Items.Value, 
                            {TextColor3 = rgb(91, 91, 92)
                        }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                        Library:Tween(Items.Title, 
                            {TextColor3 = rgb(91, 91, 92)
                        }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                    end 
                end)

                Items.Value.Focused:Connect(function()
                    if Items.Text then 
                        Library:Tween(Items.Text, 
                            {TextColor3 = rgb(245, 245, 245),
                        }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                    end 

                    Library:Tween(Items.Value,
                        {TextColor3 = rgb(245, 245, 245),
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                end)

                Items.Value.FocusLost:Connect(function()
                    if Items.Text then 
                        Library:Tween(Items.Text,
                            {TextColor3 = rgb(91, 91, 92),
                        }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))
                    end 

                    Library:Tween(Items.Value,
                        {TextColor3 = rgb(91, 91, 92),
                    }, TweenInfo.new(Library.DraggingSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0))

                    pcall(function()
                        Cfg.Set(Items.Value.Text)
                    end)
                end)

                Cfg.Set(Cfg.Value)
                ConfigFlags[Cfg.Flag] = Cfg.Set

                return setmetatable(Cfg, Library)
            end 

            function Library:Dropdown(properties) 
                local Cfg = {
                    Name = properties.Name or nil;
                    Flag = properties.Flag or properties.Name or "Dropdown";
                    Options = properties.Options or {""};
                    Callback = properties.Callback or function() end;
                    Multi = properties.Multi or false;
                    Scrolling = properties.Scrolling or false;

                    -- Ignore these 
                    Open = false;
                    OptionInstances = {};
                    MultiItems = {};
                    Items = {};
                    Tweening = nil;
                    Ignore = properties.Ignore or false;
                }   

                Cfg.Default = properties.Default or (Cfg.Multi and {Cfg.Items[1]}) or Cfg.Items[1] or "None"
                Flags[Cfg.Flag] = Cfg.Default
                
                local Items = Cfg.Items; do 
                    -- Element
                        Items.Dropdown = Library:Create( "Frame" , {
                            Parent = self.Items.Elements;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(1, 0, 0, 48);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        
                        Items.Title = Library:Create( "TextLabel" , {
                            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                            TextColor3 = themes.preset.SecondaryColor;
                            BorderColor3 = rgb(0, 0, 0);
                            Text = Cfg.Name;
                            Parent = Items.Dropdown;
                            BackgroundTransparency = 1;
                            Name = "\0";
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 18;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });	Library:Themify(Items.Title, "SecondaryColor", "TextColor3")

                        Items.Components = Library:Create( "Frame" , {
                            Parent = Items.Dropdown;
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 0, 1, 0);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });

                        Library:Create( "UIListLayout" , {
                            Parent = Items.Components;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            HorizontalAlignment = Enum.HorizontalAlignment.Right
                        });

                        Items.Outline = Library:Create( "TextButton" , {
                            Active = false;
                            BorderColor3 = rgb(0, 0, 0);
                            Parent = Items.Dropdown;
                            Name = "\0";
                            Position = dim2(0, 0, 0, 23);
                            Selectable = false;
                            Size = dim2(1, 0, 0, 25);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Outline
                    });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3")

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.InnerText = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Head, Chest, Stomach, Pelvis";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = Items.Inline;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0.5, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });	Library:Themify(Items.InnerText, "SecondaryColor", "TextColor3")

                    Items.DropdownIcon = Library:Create( "ImageLabel" , {
                        ImageColor3 = themes.preset.Outline;
                        BorderColor3 = rgb(0, 0, 0);
                        Image = "rbxassetid://94444153569673";
                        BackgroundTransparency = 1;
                        Parent = Items.Inline;
                        AnchorPoint = vec2(1, 0.5);
                        Position = dim2(1, -6, 0.5, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        ScaleType = Enum.ScaleType.Stretch;
                        ClipsDescendants = false
                    });	Library:Themify(Items.DropdownIcon, "Outline", "ImageColor3")

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });
                --  
                
                -- Element Holder
                    Items.DropdownElements = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Size = dim2(0, 293, 0, 0);
                        Name = "\0";
                        Visible = false;
                        ZIndex = 100;
                        Position = dim2(0, 20, 0, 23);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.DropdownElements;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(15, 15, 15)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Library:Create( "UIListLayout" , {
                        Parent = Items.Inline;
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.DropdownElements;
                        CornerRadius = dim(0, 4)
                    });
                -- 
            end 

            function Cfg.RenderOption(text)       
                local Button = Library:Create( "TextButton" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.SecondaryColor;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = Items.Inline;
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 4, 0.5, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                    ZIndex = 1000;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); Button.Text = text

                Library:Create( "UIPadding" , {
                    PaddingTop = dim(0, 3);
                    PaddingBottom = dim(0, 3);
                    Parent = Button;
                    PaddingRight = dim(0, 3);
                    PaddingLeft = dim(0, 3)
                });

                table.insert(Cfg.OptionInstances, Button)

                return Button
            end
            
            function Cfg.SetVisible(bool)                
                if Library.OpenElement ~= Cfg then 
                    Library:CloseElement(Cfg)
                end
                
                Items.DropdownElements.Position = dim2(0, Items.Outline.AbsolutePosition.X, 0, Items.Outline.AbsolutePosition.Y + 90)
                Items.DropdownElements.Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, 0)
                
                Cfg.Tween(bool)
                
                Library.OpenElement = Cfg
            end
            
            function Cfg.Set(value)
                local Selected = {}
                local IsTable = type(value) == "table"

                for _,option in Cfg.OptionInstances do 
                    if option.Text == value or (IsTable and table.find(value, option.Text)) then 
                        table.insert(Selected, option.Text)
                        Cfg.MultiItems = Selected
                        option.TextColor3 = themes.preset.accent
                        Library:Themify(option, "accent", "TextColor3")
                        Library:Tween(option:FindFirstChildOfClass("UIPadding"), {PaddingLeft = dim(0, 13)})
                    else
                        option.TextColor3 = rgb(91, 91, 92)
                        if themes.utility.accent and themes.utility.accent.TextColor3 then
                            for i, obj in pairs(themes.utility.accent.TextColor3) do
                                if obj == option then
                                    table.remove(themes.utility.accent.TextColor3, i)
                                    break
                                end
                            end
                        end
                        Library:Tween(option:FindFirstChildOfClass("UIPadding"), {PaddingLeft = dim(0, 3)})
                    end
                end

                Items.InnerText.Text = (IsTable and table.concat(Selected, ", ")) or Selected[1] or ''
                Flags[Cfg.Flag] = (IsTable and Selected) or Selected[1]

                Cfg.Callback(Flags[Cfg.Flag]) 
            end
            
            function Cfg.RefreshOptions(options) 
                for _,option in Cfg.OptionInstances do 
                    option:Destroy() 
                end
                
                Cfg.OptionInstances = {} 

                for _,option in options do
                    local Button = Cfg.RenderOption(option)
                    
                    Button.MouseButton1Down:Connect(function()
                        if Cfg.Multi then 
                            local Selected = table.find(Cfg.MultiItems, Button.Text)
                            
                            if Selected then 
                                table.remove(Cfg.MultiItems, Selected)
                            else
                                table.insert(Cfg.MultiItems, Button.Text)
                            end
                            
                            Cfg.Set(Cfg.MultiItems) 				
                        else 
                            Cfg.SetVisible(false)
                            Cfg.Open = false
                            
                            Cfg.Set(Button.Text)
                        end
                    end)
                end
            end

            function Cfg.Tween(bool) 
                if Cfg.Tweening == true then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.DropdownElements.Visible = true
                    Items.DropdownElements.Parent = Library.Items
                    Items.DropdownElements.ClipsDescendants = true
                    
                    local targetHeight = Items.DropdownElements.AbsoluteSize.Y
                    Items.DropdownElements.Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, 0)
                    
                    task.wait()
                    
                    local SizeTween = TweenService:Create(Items.DropdownElements, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, targetHeight)
                    })
                    SizeTween:Play()
                    
                    Library:Connection(SizeTween.Completed, function()
                        Items.DropdownElements.ClipsDescendants = false
                        Cfg.Tweening = false
                    end)
                else
                    Items.DropdownElements.ClipsDescendants = true
                    
                    local SizeTween = TweenService:Create(Items.DropdownElements, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                        Size = dim_offset(Items.Outline.AbsoluteSize.X + 1, 0)
                    })
                    SizeTween:Play()
                    
                    Library:Connection(SizeTween.Completed, function()
                        Items.DropdownElements.Visible = false
                        Items.DropdownElements.ClipsDescendants = false
                        Cfg.Tweening = false
                    end)
                end
            end

            Items.Outline.MouseButton1Click:Connect(function()
                if Cfg.Tweening then 
                    return 
                end 

                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)
            
            Library:Connection(InputService.InputBegan, function(input, game_event)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Library:Hovering({Items.DropdownElements, Items.Outline}) then
                        Cfg.SetVisible(false)
                        Cfg.Open = false
                    end 
                end 
            end)

            Flags[Cfg.Flag] = {} 
            ConfigFlags[Cfg.Flag] = Cfg.Set
            
            Cfg.RefreshOptions(Cfg.Options)
            Cfg.Set(Cfg.Default)
                
            return setmetatable(Cfg, Library)
        end

        function Library:Label(properties)
            if type(properties) == "string" then
                properties = {Name = properties}
            end
            local Cfg = {
                Name = properties.Name or "Label",

                -- Other
                Items = {};
            }

            local Items = Cfg.Items; do 
                Items.Label = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 18);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Text = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.SecondaryColor;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    AnchorPoint = vec2(0, 0.5);
                    Parent = Items.Label;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0.5, 1);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Text, "SecondaryColor", "TextColor3")

                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Label;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = Items.Components;
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end 

            function Cfg.Set(Text)
                Items.Text.Text = Text
            end 

            return setmetatable(Cfg, Library)
        end
        
        function Library:Colorpicker(properties) 
            local Cfg = {
                Name = properties.Name or "Color", 
                Flag = properties.Flag or properties.Name or "Colorpicker",
                Callback = properties.Callback or function() end,

                Color = properties.Color or properties.Default or color(1, 1, 1), -- Default to white color if not provided
                Alpha = properties.Alpha or properties.Transparency or 1,
                
                -- Other
                Open = false;
                Mode = properties.Mode or "Animation";
                Items = {};
            }

            local Picker = self:Keypicker(Cfg)

            local Items = Picker.Items; do
                Cfg.Items = Items
                Cfg.Set = Picker.Set
            end;
            
            Cfg.Set(Cfg.Color, Cfg.Alpha)
            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end 

        function Library:Textbox(properties) 
            local Cfg = {
                Name = properties.Name or "TextBox",
                PlaceHolder = properties.PlaceHolder or properties.PlaceHolderText or properties.Holder or properties.HolderText or "Type here...",
                Default = properties.Default or "",
                Flag = properties.Flag or properties.Name or "TextBox",
                Callback = properties.Callback or function() end,
                
                Items = {};
            }

            Flags[Cfg.Flag] = Cfg.default

            local Items = Cfg.Items; do 
                Items.Textbox = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 48);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Title = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.SecondaryColor;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Textbox;
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Title, "SecondaryColor", "TextColor3")

                Items.Components = Library:Create( "Frame" , {
                    Parent = Items.Textbox;
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Library:Create( "UIListLayout" , {
                    Parent = Items.Components;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right
                });

                Items.Outline = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Textbox;
                    Name = "\0";
                    Position = dim2(0, 0, 0, 23);
                    Selectable = false;
                    Size = dim2(1, 0, 0, 25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.Outline
                });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3")

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.Liner
                });	Library:Themify(Items.Inline, "Liner", "BackgroundColor3")

                Library:Create( "UICorner" , {
                    Parent = Items.Inline;
                    CornerRadius = dim(0, 4)
                });

                Items.Input = Library:Create( "TextBox" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.SecondaryColor;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "Head, Chest, Stomach, Pelvis";
                    Parent = Items.Inline;
                    Name = "\0";
                    Size = dim2(1, 0, 1, 0);
                    Selectable = false;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Active = false;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Input, "SecondaryColor", "TextColor3")

                Library:Create( "UICorner" , {
                    Parent = Items.Outline;
                    CornerRadius = dim(0, 4)
                });
            end 
            
            function Cfg.Set(text) 
                Flags[Cfg.Flag] = text

                Items.Input.Text = text or ""

                Cfg.Callback(text)
            end 
            
            Items.Input:GetPropertyChangedSignal("Text"):Connect(function()
                Cfg.Set(Items.Input.Text) 
            end) 

            if Cfg.Default then 
                Cfg.Set(Cfg.Default) 
            end

            ConfigFlags[Cfg.Flag] = Cfg.Set

            return setmetatable(Cfg, Library)
        end

        function Library:Keybind(properties) 
            local Cfg = {
                Flag = properties.Flag or properties.Name;
                Callback = properties.Callback or function() end;
                Name = properties.Name or nil; 

                Key = properties.Key or properties.Default or nil;
                Mode = properties.Mode or "Toggle";
                Active = properties.Default == true; 
                
                Show = properties.ShowInList or true;

                Open = false;
                Binding;
                Ignore = false;
                Tweening = nil;

                Items = {}
            }

            Flags[Cfg.Flag] = {
                mode = Cfg.Mode,
                key = Cfg.Key, 
                active = false
            }

            local Items = Cfg.Items; do 
                -- Component
                    Items.Key = Library:Create( "TextButton" , {
                        Parent = self.Items.Components;
                        Name = "\0";
                        Size = dim2(0, 18, 0, 18);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Key;
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = themes.preset.Liner
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Keybind = Library:Create( "TextButton" , {
                        Parent = Items.Inline;
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        Name = "\0";
                        ZIndex = 100;
                        BorderColor3 = rgb(0, 0, 0);
                        AnchorPoint = vec2(0, 0.5);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0.5, 1);
                        TextColor3 = themes.preset.ActiveText;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); Items.Keybind.Text = "[...]"; Library:Themify(Items.Keybind, "ActiveText", "TextColor3")

                    Library:Create( "UIPadding" , {
                        Parent = Items.Keybind;
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 3)
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Key;
                        CornerRadius = dim(0, 4)
                    });
                -- 
                
                -- Mode holder
                    Items.Outline = Library:Create( "Frame" , {
                        Parent = Library.Items;
                        Visible = false;
                        Size = dim2(0, 293, 0, 25);
                        Name = "\0";
                        Position = dim2(0, 20, 0, 23);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        ZIndex = 2;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.Outline
                    });

                    Items.Inline = Library:Create( "Frame" , {
                        Parent = Items.Outline;
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = themes.preset.Liner
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Inline;
                        CornerRadius = dim(0, 4)
                    });

                    Items.Elements = Library:Create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = Items.Inline;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 4, 0, 4);
                        Size = dim2(1, -8, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    local Self = setmetatable(Cfg, Library)
                    Items.Dropdown = Self:Dropdown({Name = "Modes", Options = {"Toggle", "Hold", "Always"}, Default = Cfg.Mode, Callback = function(option)
                        if Cfg.Set then 
                            Cfg.Set(option)
                        end
                    end})
                    Items.Toggle = Self:Toggle({Name = "Show in list", Default = true, Flag = Cfg.Flag .. "_LIST", Callback = function(bool)
                        if Items.Holder then 
                            Items.Holder.Visible = bool
                        end 
                    end})

                    Library:Create( "UIListLayout" , {
                        Parent = Items.Elements;
                        Padding = dim(0, 6);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    Library:Create( "UIPadding" , {
                        PaddingBottom = dim(0, 10);
                        Parent = Items.Elements
                    });

                    Library:Create( "UICorner" , {
                        Parent = Items.Outline;
                        CornerRadius = dim(0, 4)
                    });
                --

                -- Element
                    Items.Holder = Library:Create( "Frame" , {
                        Parent = Library.Elements;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 0, 18);
                        BorderSizePixel = 0;
                        Visible = false;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.Info = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "(LCTRL) - Speed";
                        Parent = Items.Holder;
                        AnchorPoint = vec2(0, 0.5);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0.5, 1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    Items.HoldValue = Library:Create( "TextLabel" , {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                        TextColor3 = themes.preset.SecondaryColor;
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "[Hold]";
                        Parent = Items.Holder;
                        AnchorPoint = vec2(1, 0.5);
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(1, 0, 0.5, 1);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 18;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                --
            end 

            function Cfg.SetMode(mode) 
                Cfg.Mode = mode 

                if mode == "Always" then
                    Cfg.Set(true)
                elseif mode == "Hold" then
                    Cfg.Set(false)
                end

                Flags[Cfg.Flag].Mode = mode
            end

            function Cfg.Set(input)
                if type(input) == "boolean" then 
                    Cfg.Active = input

                    if Cfg.Mode == "Always" then 
                        Cfg.Active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    Cfg.Key = input or "NONE"	
                elseif table.find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        Cfg.Active = true 
                    end 

                    Cfg.Mode = input
                    Cfg.SetMode(Cfg.Mode) 
                elseif type(input) == "table" then
                    if type(input.key) == "string" and input.key ~= "NONE" and input.key ~= "nil" then
                        input.Key = Library:ConvertEnum(input.key)
                    else
                        input.Key = input.key
                    end
                    input.Key = input.Key == Enum.KeyCode.Escape and "NONE" or input.Key

                    Cfg.Key = input.Key or "NONE"
                    Cfg.Mode = input.mode or "Toggle"

                    if input.active then
                        Cfg.Active = input.active
                    end
                    Cfg.SetMode(Cfg.Mode) 
                end 

                Cfg.Callback(Cfg.Active)

                local text = (tostring(Cfg.Key) ~= "Enums" and (Keys[Cfg.Key] or tostring(Cfg.Key):gsub("Enum.", "")) or nil)
                local __text = text and tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "")

                Items.Keybind.Text = __text

                if Items.Holder.Visible then
                    Library:Tween(Items.Info, {TextColor3 = Cfg.Active and themes.preset.accent or rgb(91, 91, 92)})
                    Library:Tween(Items.HoldValue, {TextColor3 = Cfg.Active and themes.preset.accent or rgb(91, 91, 92)})
                end 

                Items.Info.Text = string.format("(%s): - %s", __text, Cfg.Name or Cfg.Flag or "Key")
                Items.HoldValue.Text = string.format("[%s]", Cfg.Mode)

                Flags[Cfg.Flag] = {
                    mode = Cfg.Mode,
                    key = Cfg.Key, 
                    active = Cfg.Active
                }
            end

            function Cfg.SetVisible(bool)
                if Cfg.Tweening then 
                    return 
                end 

                Items.Outline.Position = dim2(0, Items.Key.AbsolutePosition.X, 0, Items.Key.AbsolutePosition.Y + 79)
                Cfg.Tween(bool)
            end
                        
            Items.Keybind.MouseButton1Down:Connect(function()
                task.wait()
                Items.Key.Text = "..."	
                
                Library:Tween(Items.Key, {Size = dim2(0, 16, 0, 16)})
                task.wait(0.1)
                Library:Tween(Items.Key, {Size = dim2(0, 18, 0, 18)})

                Cfg.Binding = Library:Connection(InputService.InputBegan, function(keycode, game_event)  
                    Cfg.Set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    Cfg.Binding:Disconnect() 
                    Cfg.Binding = nil
                end)
            end)

            Items.Keybind.MouseButton2Down:Connect(function()
                Cfg.Open = not Cfg.Open 

                Cfg.SetVisible(Cfg.Open)
            end)

            Library:Connection(InputService.InputBegan, function(input, game_event) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not (Library:Hovering(Items.Dropdown.Items.DropdownElements) or Library:Hovering(Items.Outline)) then 
                        Items.Dropdown.SetVisible(false)
                        Items.Dropdown.Visible = false

                        Cfg.SetVisible(false)
                        Cfg.Open = false;
                    end 
                end 
                
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == Cfg.Key then 
                        if Cfg.Mode == "Toggle" then 
                            Cfg.Active = not Cfg.Active
                            Cfg.Set(Cfg.Active)
                        elseif Cfg.Mode == "Hold" then 
                            Cfg.Set(true)
                        end
                    end
                end
            end)    

            Library:Connection(InputService.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == Cfg.Key then
                    if Cfg.Mode == "Hold" then 
                        Cfg.Set(false)
                    end
                end
            end)

            function Cfg.Tween(bool)
                if Cfg.Tweening then 
                    return 
                end 

                Cfg.Tweening = true 

                if bool then 
                    Items.Outline.Visible = true
                end

                local Children = Items.Outline:GetDescendants()
                table.insert(Children, Items.Outline)

                local Tween;
                for _,obj in Children do
                    local Index = Library:GetTransparency(obj)

                    if not Index then 
                        continue 
                    end

                    if type(Index) == "table" then
                        for _,prop in Index do
                            Tween = Library:Fade(obj, prop, bool)
                        end
                    else
                        Tween = Library:Fade(obj, Index, bool)
                    end
                end

                Library:Connection(Tween.Completed, function()
                    Cfg.Tweening = false
                    Items.Outline.Visible = bool
                end)
            end 

            Cfg.Set({mode = Cfg.Mode, active = Cfg.Active, key = Cfg.Key})           
            ConfigFlags[Cfg.Flag] = Cfg.Set
            Items.Dropdown.Set(Cfg.Mode)

            return setmetatable(Cfg, Library)
        end
        
        function Library:Button(properties) 
            local Cfg = {
                Name = properties.Name or "TextBox",
                Callback = properties.Callback or function() end,
                
                -- Other
                Items = {};
            }

            local Items = Cfg.Items; do
                Items.Button = Library:Create( "Frame" , {
                    Parent = self.Items.Elements;
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                Items.Outline = Library:Create( "TextButton" , {
                    Active = false;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = Items.Button;
                    Name = "\0";
                    Selectable = false;
                    Size = dim2(0, 0, 0, 25);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = themes.preset.Outline
                });	Library:Themify(Items.Outline, "Outline", "BackgroundColor3")

                Library:Create( "UICorner" , {
                    Parent = Items.Outline;
                    CornerRadius = dim(0, 4)
                });

                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.Outline;
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.Liner
                });

                Items.Name = Library:Create( "TextLabel" , {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextColor3 = themes.preset.SecondaryColor;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = Cfg.Name;
                    Parent = Items.Inline;
                    AnchorPoint = vec2(0, 0.5);
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0.5, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                    BackgroundColor3 = rgb(255, 255, 255)
                });	Library:Themify(Items.Name, "SecondaryColor", "TextColor3")

                Library:Create( "UIPadding" , {
                    Parent = Items.Name;
                    PaddingRight = dim(0, 9);
                    PaddingLeft = dim(0, 2)
                });
            end 

            Items.Outline.MouseButton1Click:Connect(function()
                Items.Name.TextColor3 = rgb(245, 245, 245)
                Library:Tween(Items.Name, {TextColor3 = rgb(91, 91, 92)})

                Cfg.Callback()
            end)
            
            return setmetatable(Cfg, Library)
        end
        
        function Library:Notification(properties)
            local Cfg = {
                Title = properties.Title or "Notification";
                Description = properties.Description or "";
                Duration = properties.Duration or 3;
                Icon = properties.Icon or Library.LibraryIcon or "rbxassetid://71350099335838";
                Items = {};
            }
            
            local Items = Cfg.Items; do
                Items.Notification = Library:Create( "Frame" , {
                    Parent = Library.NotificationHolder;
                    Name = "Notifcation";
                    ClipsDescendants = true;
                    Size = dim2(0, 1, 0, 52);
                    AutomaticSize = Enum.AutomaticSize.X;
                    BackgroundColor3 = rgb(6, 1, 6);
                    BackgroundTransparency = 1;
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.Notification;
                    CornerRadius = dim(0, 6)
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.Notification;
                    FillDirection = Enum.FillDirection.Horizontal;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Items.IconHolder = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Name = "IconHolder";
                    BackgroundTransparency = 1;
                    Size = dim2(0, 49, 0, 52);
                });
                
                Items.LibraryIcon = Library:Create( "ImageLabel" , {
                    Parent = Items.IconHolder;
                    Name = "LibaryIcon";
                    AnchorPoint = vec2(0.5, 0.5);
                    Position = dim2(0.5, 0, 0.5, 0);
                    Size = dim2(0, 25, 0, 25);
                    BackgroundTransparency = 1;
                    Image = Cfg.Icon;
                });
                
                Items.Holder = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Name = "Holder";
                    BackgroundTransparency = 1;
                    Size = dim2(0, 18, 0, 52);
                    AutomaticSize = Enum.AutomaticSize.X;
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.Holder;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Library:Create( "UIPadding" , {
                    Parent = Items.Holder;
                    PaddingTop = dim(0, 7);
                });
                
                Items.TitleFrame = Library:Create( "Frame" , {
                    Parent = Items.Holder;
                    BackgroundTransparency = 1;
                    Size = dim2(0, 95, 0, 25);
                    AutomaticSize = Enum.AutomaticSize.X;
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.TitleFrame;
                    FillDirection = Enum.FillDirection.Horizontal;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Items.TitleHolder = Library:Create( "Frame" , {
                    Parent = Items.TitleFrame;
                    Name = "TextHolder";
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 0, 0.5, 0);
                    Size = dim2(0, 1, 0, 25);
                    AutomaticSize = Enum.AutomaticSize.X;
                });
                
                Library:Create( "UIPadding" , {
                    Parent = Items.TitleHolder;
                    PaddingTop = dim(0, 1);
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.TitleHolder;
                    FillDirection = Enum.FillDirection.Horizontal;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Items.TitleLabel = Library:Create( "TextLabel" , {
                    Parent = Items.TitleHolder;
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
                    TextColor3 = rgb(255, 255, 255);
                    Text = Cfg.Title;
                    AnchorPoint = vec2(0.5, 0.5);
                    Position = dim2(0.5, 0, 0.5, 0);
                    Size = dim2(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                });
                
                Items.DescriptionFrame = Library:Create( "Frame" , {
                    Parent = Items.Holder;
                    BackgroundTransparency = 1;
                    Size = dim2(0, 1, 0, 25);
                    AutomaticSize = Enum.AutomaticSize.X;
                });
                
                Items.DescriptionHolder = Library:Create( "Frame" , {
                    Parent = Items.DescriptionFrame;
                    Name = "TextHolder";
                    BackgroundTransparency = 1;
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 0, 0.36428558826446533, 0);
                    Size = dim2(0, 1, 0, 25);
                    AutomaticSize = Enum.AutomaticSize.X;
                });
                
                Library:Create( "UIListLayout" , {
                    Parent = Items.DescriptionHolder;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                });
                
                Library:Create( "UIPadding" , {
                    Parent = Items.DescriptionHolder;
                });
                
                Items.DescriptionLabel = Library:Create( "TextLabel" , {
                    Parent = Items.DescriptionHolder;
                    Name = "Descirption";
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
                    TextColor3 = rgb(43, 40, 43);
                    Text = Cfg.Description;
                    AnchorPoint = vec2(0.5, 0.5);
                    Position = dim2(0.5, 0, 0.2946428656578064, 0);
                    Size = dim2(0, 1, 0, 16);
                    BackgroundTransparency = 1;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 18;
                });
                
                Items.InlineHolder = Library:Create( "Frame" , {
                    Parent = Items.Notification;
                    Name = "InlineHolder";
                    ClipsDescendants = true;
                    BackgroundTransparency = 1;
                    Size = dim2(0, 15, 0, 52);
                });
                
                Library:Create( "UICorner" , {
                    Parent = Items.InlineHolder;
                    CornerRadius = dim(0, 4)
                });
                
                Items.Inline = Library:Create( "Frame" , {
                    Parent = Items.InlineHolder;
                    Name = "Inline";
                    AnchorPoint = vec2(1, 0.5);
                    Position = dim2(1, 3, 0.5, 0);
                    Size = dim2(0, 8, 0.5, 1);
                    BackgroundColor3 = themes.preset.accent;
                }); Library:Themify(Items.Inline, "accent", "BackgroundColor3")
                
                Library:Create( "UICorner" , {
                    Parent = Items.Inline;
                });
            end
            
            -- Slide in animation
            task.spawn(function()
                -- Wait for AutomaticSize to calculate
                task.wait(0.1)
                local targetSize = Items.Notification.AbsoluteSize.X
                
                -- Start from 0 width
                Items.Notification.Size = dim2(0, 0, 0, 52)
                Items.Notification.AutomaticSize = Enum.AutomaticSize.None
                
                task.wait()
                
                local SizeTween = TweenService:Create(Items.Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = dim2(0, targetSize, 0, 52),
                    BackgroundTransparency = 0
                })
                SizeTween:Play()
                
                -- Wait for duration then slide out
                task.wait(Cfg.Duration)
                
                local FadeOutTween = TweenService:Create(Items.Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Size = dim2(0, 0, 0, 52),
                    BackgroundTransparency = 1
                })
                FadeOutTween:Play()
                
                Library:Connection(FadeOutTween.Completed, function()
                    Items.Notification:Destroy()
                end)
            end)
            
            return setmetatable(Cfg, Library)
        end

        function Library:Configs(window) 
            local Text;
            local ConfigText;
            local windowName = window.Items.Title.Text

            local Tab = window:Tab({Name = "Settings"})

            local Section = Tab:Section({Name = "Configs", Side = "Left", Fill = 1})
            ConfigHolder = Section:Dropdown({Name = "Configs", Options = {"Report", "This", "Error", "To", "Finobe"}, Callback = function(option) if Text then Text.Set(option) end end, Flag = "config_Name_list"}); Library:UpdateConfigList()
            window.Tweening = true
            Text = Section:Textbox({Name = "Config Name:", Flag = "config_Name_text", Callback = function(text)
                ConfigText = text
            end})
            window.Tweening = false
            Section:Button({Name = "Save", Callback = function() 
                writefile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg", Library:GetConfig())
                Library:UpdateConfigList()
                Library:Notification({
                    Title = windowName;
                    Description = "Config '" .. ConfigText .. "' saved successfully";
                    Duration = 3;
                })
            end})

            Section:Button({Name = "Load", Callback = function() 
                if not isfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg") then
                    Library:Notification({
                        Title = windowName;
                        Description = "Config '" .. ConfigText .. "' does not exist";
                        Duration = 3;
                    })
                    return
                end

                Library:LoadConfig(readfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg"))  
                Library:UpdateConfigList()
                Library:Notification({
                    Title = windowName;
                        Description = "Config '" .. ConfigText .. "' loaded successfully";
                    Duration = 3;
                })
            end})

            Section:Button({Name = "Delete", Callback = function() 
                delfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg")  
                Library:UpdateConfigList()
                Library:Notification({
                    Title = windowName;
                    Description = "Config '" .. ConfigText .. "' deleted successfully";
                    Duration = 3;
                })
            end})
            
            window.Tweening = true
            local Section = Tab:Section({Name = "Settings", Side = "Right", Fill = 1})

            local l = Section:Label({Name = "Menu Bind"})
            l:Keybind({Name = "Menu Bind", Flag = "Menu Bind", Default = Enum.KeyCode.Insert, ShowInList = false, Callback = function(bool) 
                if window.Tweening then
                    return 
                end 
                local keyName = tostring(Library.Flags["Menu Bind"].key):gsub("Enum.KeyCode.", "")
                window.Items.MenuKey.Text = 'Menu: ' .. keyName
                window.Items.WatermarkLabel.Text = windowName .. " | Menu: " .. keyName
                window.ToggleMenu(bool) 
            end})
            Section:Label({Name = "Accent Color"}):Colorpicker({Name = "Accent Color", Flag = "Accent Color", Default = rgb(255, 25, 25), Callback = function(color, a) 
                Library:RefreshTheme('accent', color) 
            end})

            Section:Label({Name = "Active Text"}):Colorpicker({Name = "Active Text", Flag = "Active Text", Default = rgb(246, 246, 246), Callback = function(color, a) 
                Library:RefreshTheme('ActiveText', color) 
            end})

            Section:Label({Name = "Secondary Color"}):Colorpicker({Name = "Secondary Color", Flag = "Secondary Color", Default = rgb(91, 91, 92), Callback = function(color, a) 
                Library:RefreshTheme('SecondaryColor', color) 
            end})

            Section:Label({Name = "Outline"}):Colorpicker({Name = "Outline", Flag = "Outline", Default = rgb(16, 15, 16), Callback = function(color, a) 
                Library:RefreshTheme('Outline', color) 
            end})

            Section:Label({Name = "Liner"}):Colorpicker({Name = "Liner", Flag = "Liner", Default = rgb(7, 5, 7), Callback = function(color, a) 
                Library:RefreshTheme('Liner', color) 
            end})

            Section:Label({Name = "Background"}):Colorpicker({Name = "Background", Flag = "Background", Default = rgb(10, 9, 10), Callback = function(color, a) 
                Library:RefreshTheme('Background', color) 
            end})

            Section:Toggle({Name = "Watermark", Flag = "Watermark", Default = true, Callback = function(bool)
                window.Items.Watermark.Visible = bool
            end})

            Section:Toggle({Name = "Keybinds List", Flag = "Keybinds List", Default = true, Callback = function(bool)
                window.ToggleList(bool)
            end})

            -- Section:Toggle({Name = "Inventory View", Flag = "Inventory View", Default = false, Callback = function(bool)
            --     Library.InventoryView:Toggle(bool)
            -- end})

            task.wait()
            local keyName = tostring(Library.Flags["Menu Bind"].key):gsub("Enum.KeyCode.", "")
            window.Items.MenuKey.Text = 'Menu: ' .. keyName
            window.Items.WatermarkLabel.Text = windowName .. " | Menu: " .. keyName

            window.Tweening = false
        end
    --
-- 
    
return Library
-- ==========================================
-- (Make sure 'Library' is the variable name used by the Disconnect source)

-- ==========================================
-- THE BRIDGE TRANSLATOR (PASTE THIS NEXT)
-- ==========================================
local OldLibraryBridge = {}
OldLibraryBridge.Flags = Library.Flags -- Links the flag tables together

function OldLibraryBridge:CreateWindow(options)
    -- Translates 'CreateWindow' to Disconnect's 'Window'
    local RealWindow = Library:Window({
        Name = options.Name or "Aether to Disconnect",
        Size = UDim2.new(0, 620, 0, 585)
    })
    
    local PageBridge = {}
    
    function PageBridge:AddPage(pageOptions)
        -- Translates 'AddPage' to Disconnect's 'Tab'
        local RealTab = RealWindow:Tab({ Name = pageOptions.Name })
        local SectionBridge = {}
        
        function SectionBridge:AddSection(sectionOptions)
            -- Translates 'AddSection' to Disconnect's layout handle
            local RealSection = RealTab:Label({ Name = sectionOptions.Name })
            local ElementBridge = {}
            
            -- BRIDGE FOR TOGGLES
            function ElementBridge:AddToggle(toggleOptions)
                RealSection:Toggle({
                    Name = toggleOptions.Name,
                    Flag = toggleOptions.Flag,
                    Default = toggleOptions.Default or false,
                    Callback = toggleOptions.Callback
                })
            end
            
            -- BRIDGE FOR SLIDERS
            function ElementBridge:AddSlider(sliderOptions)
                RealSection:Slider({
                    Name = sliderOptions.Name,
                    Flag = sliderOptions.Flag,
                    Min = sliderOptions.Min or 0,
                    Max = sliderOptions.Max or 100,
                    Default = sliderOptions.Default or sliderOptions.Min or 0,
                    Decimals = sliderOptions.Decimals or 1,
                    Callback = sliderOptions.Callback
                })
            end

            -- BRIDGE FOR DROPDOWNS
            function ElementBridge:AddDropdown(dropdownOptions)
                RealSection:Dropdown({
                    Name = dropdownOptions.Name,
                    Flag = dropdownOptions.Flag,
                    List = dropdownOptions.List or {},
                    Default = dropdownOptions.Default or "",
                    Callback = dropdownOptions.Callback
                })
            end

            -- BRIDGE FOR KEYBINDS
            function ElementBridge:AddKeybind(keybindOptions)
                RealSection:Keybind({
                    Name = keybindOptions.Name,
                    Flag = keybindOptions.Flag,
                    Default = keybindOptions.Default,
                    Callback = keybindOptions.Callback
                })
            end
            
            return ElementBridge
        end
        return SectionBridge
    end
    return PageBridge
end

-- ==========================================
-- THE MAGIC TRICK
-- ==========================================
-- Overwrite the global environment so your old script targets our translator!
local Library = OldLibraryBridge 

-- ==========================================
-- YOUR 5,000 LINES OF MAIN LOGIC SITS BELOW HERE
-- ==========================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library do 
	Library = {
        Theme =  { },
        espfont = nil,

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "Aether",
            Configs = "Aether/Configs",
            Assets = "Aether/Assets",
			Sounds = "Aether/Sounds",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        KeyList = nil,

        Font = nil,
        CopiedColor = nil,
		Fonts = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages
end


gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local FromRGB = Color3.fromRGB
local FromHSV = Color3.fromHSV
local FromHex = Color3.fromHex

local RGBSequence = ColorSequence.new
local RGBSequenceKeypoint = ColorSequenceKeypoint.new
local NumSequence = NumberSequence.new
local NumSequenceKeypoint = NumberSequenceKeypoint.new

local UDim2New = UDim2.new
local UDimNew = UDim.new
local UDim2FromOffset = UDim2.fromOffset
local Vector2New = Vector2.new
local Vector3New = Vector3.new

local MathClamp = math.clamp
local MathFloor = math.floor
local MathAbs = math.abs
local MathSin = math.sin

local TableInsert = table.insert
local TableFind = table.find
local TableRemove = table.remove
local TableConcat = table.concat
local TableClone = table.clone
local TableUnpack = table.unpack

local StringFormat = string.format
local StringFind = string.find
local StringGSub = string.gsub
local StringLower = string.lower
local StringLen = string.len

local InstanceNew = Instance.new

local RectNew = Rect.new

local Keys = {
    ["Unknown"]           = "Unknown",
    ["Backspace"]         = "Back",
    ["Tab"]               = "Tab",
    ["Clear"]             = "Clear",
    ["Return"]            = "Return",
    ["Pause"]             = "Pause",
    ["Escape"]            = "Escape",
    ["Space"]             = "Space",
    ["QuotedDouble"]      = '"',
    ["Hash"]              = "#",
    ["Dollar"]            = "$",
    ["Percent"]           = "%",
    ["Ampersand"]         = "&",
    ["Quote"]             = "'",
    ["LeftParenthesis"]   = "(",
    ["RightParenthesis"]  = " )",
    ["Asterisk"]          = "*",
    ["Plus"]              = "+",
    ["Comma"]             = ",",
    ["Minus"]             = "-",
    ["Period"]            = ".",
    ["Slash"]             = "`",
    ["Three"]             = "3",
    ["Seven"]             = "7",
    ["Eight"]             = "8",
    ["Colon"]             = ":",
    ["Semicolon"]         = ";",
    ["LessThan"]          = "<",
    ["GreaterThan"]       = ">",
    ["Question"]          = "?",
    ["Equals"]            = "=",
    ["At"]                = "@",
    ["LeftBracket"]       = "LeftBracket",
    ["RightBracket"]      = "RightBracked",
    ["BackSlash"]         = "BackSlash",
    ["Caret"]             = "^",
    ["Underscore"]        = "_",
    ["Backquote"]         = "`",
    ["LeftCurly"]         = "{",
    ["Pipe"]              = "|",
    ["RightCurly"]        = "}",
    ["Tilde"]             = "~",
    ["Delete"]            = "Delete",
    ["End"]               = "End",
    ["KeypadZero"]        = "Keypad0",
    ["KeypadOne"]         = "Keypad1",
    ["KeypadTwo"]         = "Keypad2",
    ["KeypadThree"]       = "Keypad3",
    ["KeypadFour"]        = "Keypad4",
    ["KeypadFive"]        = "Keypad5",
    ["KeypadSix"]         = "Keypad6",
    ["KeypadSeven"]       = "Keypad7",
    ["KeypadEight"]       = "Keypad8",
    ["KeypadNine"]        = "Keypad9",
    ["KeypadPeriod"]      = "KeypadP",
    ["KeypadDivide"]      = "KeypadD",
    ["KeypadMultiply"]    = "KeypadM",
    ["KeypadMinus"]       = "KeypadM",
    ["KeypadPlus"]        = "KeypadP",
    ["KeypadEnter"]       = "KeypadE",
    ["KeypadEquals"]      = "KeypadE",
    ["Insert"]            = "Insert",
    ["Home"]              = "Home",
    ["PageUp"]            = "PageUp",
    ["PageDown"]          = "PageDown",
    ["RightShift"]        = "RightShift",
    ["LeftShift"]         = "LeftShift",
    ["RightControl"]      = "RightControl",
    ["LeftControl"]       = "LeftControl",
    ["LeftAlt"]           = "LeftAlt",
    ["RightAlt"]          = "RightAlt"
}

local Themes = {
    ["Preset"] = {
        ["Window Outline"] = FromRGB(60, 65, 75),

        ["Accent"] = FromRGB(140, 180, 255),

        ["Background 1"] = FromRGB(18,18,19),
        ["Background 2"] = FromRGB(10,10,12),

        ["Inline"] = FromRGB(12,12,14),
        ["Element"] = FromRGB(18,18,20),

        ["Border"] = FromRGB(60, 65, 75),

        ["Text"] = FromRGB(220,220,220),
        ["Inactive Text"] = FromRGB(170,170,170)
    }
}

Library.Theme = TableClone(Themes["Preset"])

-- Folders
for Index, Value in Library.Folders do 
    if not isfolder(Value) then
        makefolder(Value)
    end
end

-- Tweening
local Tween = { } do
    Tween.__index = Tween

    Tween.Create = function(self, Item, Info, Goal, IsRawItem)
        Item = IsRawItem and Item or Item.Instance
        Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

        local NewTween = {
            Tween = TweenService:Create(Item, Info, Goal),
            Info = Info,
            Goal = Goal,
            Item = Item
        }

        NewTween.Tween:Play()

        setmetatable(NewTween, Tween)

        return NewTween
    end

    Tween.GetProperty = function(self, Item)
        Item = Item or self.Item 

        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
        local Item = Item or self.Item 

        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Tween.Get = function(self)
        if not self.Tween then 
            return
        end

        return self.Tween, self.Info, self.Goal
    end

    Tween.Pause = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Pause()
    end

    Tween.Play = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Play()
    end

    Tween.Clean = function(self)
        if not self.Tween then 
            return
        end

        Tween:Pause()
        self = nil
    end
end

-- Instances
Instances = { } do
    Instances.__index = Instances

    Instances.Create = function(self, Class, Properties)
        local NewItem = {
            Instance = InstanceNew(Class),
            Properties = Properties,
            Class = Class
        }

        setmetatable(NewItem, Instances)

        for Property, Value in NewItem.Properties do
            NewItem.Instance[Property] = Value
        end

        return NewItem
    end

    Instances.FadeItem = function(self, Visibility, Speed)
        local Item = self.Instance

        if Visibility == true then 
            Item.Visible = true
        end

        local Descendants = Item:GetDescendants()
        TableInsert(Descendants, Item)

        local NewTween

        for Index, Value in Descendants do 
            local TransparencyProperty = Tween:GetProperty(Value)

            if not TransparencyProperty then 
                continue
            end

            if type(TransparencyProperty) == "table" then 
                for _, Property in TransparencyProperty do 
                    NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                end
            else
                NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
            end
        end
    end

    Instances.AddToTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:AddToTheme(self, Properties)
    end

    Instances.ChangeItemTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:ChangeItemTheme(self, Properties)
    end

    Instances.Connect = function(self, Event, Callback, Name)
        if not self.Instance then 
            return
        end

        if not self.Instance[Event] then 
            return
        end

        return Library:Connect(self.Instance[Event], Callback, Name)
    end

    Instances.Tween = function(self, Info, Goal)
        if not self.Instance then 
            return
        end

        return Tween:Create(self, Info, Goal)
    end

    Instances.Disconnect = function(self, Name)
        if not self.Instance then 
            return
        end

        return Library:Disconnect(Name)
    end

    Instances.Clean = function(self)
        if not self.Instance then 
            return
        end

        self.Instance:Destroy()
        self = nil
    end

    Instances.MakeDraggable = function(self)
        if not self.Instance then 
            return
        end
    
        local Gui = self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
        end
    
        local InputChanged
    
        self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Instances.MakeResizeable = function(self, Minimum, Maximum)
        if not self.Instance then 
            return
        end

        local Gui = self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Instances:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = FromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2New(0, 0, 0, 0), 
                UDim2New(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2New(1, -EdgeThickness, 0, 0), 
                UDim2New(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2New(0, 0, 0, 0), 
                UDim2New(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2New(0, 0, 1, -EdgeThickness), 
                UDim2New(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            -- store offsets, not absolute screen pos
            StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
        end)
    end

    Instances.OnHover = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseEnter, Function)
    end

    Instances.OnHoverLeave = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseLeave, Function)
    end
end

-- Custom font
local CustomFont = { } do
    function CustomFont:New(Name, Weight, Style, Data)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
            writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
        end

        local FontData = {
            name = Name,
            faces = { {
                name = "Regular",
                weight = Weight,
                style = Style,
                assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
            } }
        }

        writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
        return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
    end

    function CustomFont:Get(Name)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end
    end

    CustomFont:New("Verdana", 400, "Regular", {
        Id = "Verdana",
        Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"
    })

    CustomFont:New("SmallestPixel", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/smallest_pixel-7.ttf"})
    CustomFont:New("ProggyClean", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/proggy-clean.ttf"})
    CustomFont:New("TahomaXP", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/windows-xp-tahoma.ttf"})
    CustomFont:New("MinecraftiaRegular", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/minecraftia-regular.ttf"})
    CustomFont:New("Monaco", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/Monaco.ttf"})
    CustomFont:New("Verdana", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"})
    CustomFont:New("TeachersPet", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/teachers-pet.ttf"})
--     CustomFont:New("FSTahoma", 400, "Regular", {Url = "https://github.com/sametexe001/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"})

    Library.Fonts["Smallest Pixel"] = CustomFont:Get("SmallestPixel")
    Library.Fonts["Proggy Clean"] = CustomFont:Get("ProggyClean")
    Library.Fonts["Tahoma XP"] = CustomFont:Get("TahomaXP")
    Library.Fonts["Minecraftia"] = CustomFont:Get("MinecraftiaRegular")
    Library.Fonts["Monaco"] = CustomFont:Get("Monaco")
    Library.Fonts["Verdana"] = CustomFont:Get("Verdana")
    Library.Fonts["Teachers Pet"] = CustomFont:Get("TeachersPet")
--     Library.Fonts['FSTahoma'] = CustomFont:Get("FSTahoma")
    Library.Fonts['Gotham SSm'] = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.ExtraBold)

    Library.Font = CustomFont:Get("Verdana")
    Library.espfont = Library.Fonts["Tahoma XP"]
end

Library.Holder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 2,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

Library.UnusedHolder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    Enabled = false,
    ResetOnSpawn = false
})

Library.NotifHolder = Instances:Create("Frame", {
    Parent = Library.Holder.Instance,
    Name = "\0",
    BorderColor3 = FromRGB(0, 0, 0),
    AnchorPoint = Vector2New(1, 0),
    BackgroundTransparency = 1,
    Position = UDim2New(1, 0, 0, 0),
    Size = UDim2New(0, 0, 1, 0),
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = FromRGB(255, 255, 255)
})

Instances:Create("UIListLayout", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDimNew(0, 8)
})

Instances:Create("UIPadding", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    PaddingTop = UDimNew(0, 15),
    PaddingBottom = UDimNew(0, 15),
    PaddingRight = UDimNew(0, 15),
    PaddingLeft = UDimNew(0, 15)
})

Library.Unload = function(self)
    for Index, Value in self.Connections do 
        Value.Connection:Disconnect()
    end

    for Index, Value in self.Threads do 
        coroutine.close(Value)
    end

    if self.Holder then 
        self.Holder:Clean()
    end

    Library = nil 
    getgenv().Library = nil
end

Library.GetImage = function(self, Image)
    local ImageData = self.Images[Image]

    if not ImageData then 
        return
    end

    return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
end

Library.Round = function(self, Number, Float)
    local Multiplier = 1 / (Float or 1)
    return MathFloor(Number * Multiplier) / Multiplier
end

Library.Thread = function(self, Function)
    local NewThread = coroutine.create(Function)
    
    coroutine.wrap(function()
        coroutine.resume(NewThread)
    end)()

    TableInsert(self.Threads, NewThread)
    return NewThread
end

Library.SafeCall = function(self, Function, ...)
    local Arguements = { ... }
    local Success, Result = pcall(Function, TableUnpack(Arguements))

    if not Success then
        LocalPlayer:Kick("Aether Callback Error: " .. tostring(Result))
        return false
    end

    return Success
end

Library.Connect = function(self, Event, Callback, Name)
    Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

    local NewConnection = {
        Event = Event,
        Callback = Callback,
        Name = Name,
        Connection = nil
    }

    Library:Thread(function()
        NewConnection.Connection = Event:Connect(Callback)
    end)

    TableInsert(self.Connections, NewConnection)
    return NewConnection
end

Library.Disconnect = function(self, Name)
    for _, Connection in self.Connections do 
        if Connection.Name == Name then
            Connection.Connection:Disconnect()
            break
        end
    end
end

Library.EscapePattern = function(self, String)
    local ShouldEscape = false 

    if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
        ShouldEscape = true
    end

    if ShouldEscape then
        return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    end

    return String
end

Library.NextFlag = function(self)
    local FlagNumber = self.UnnamedFlags + 1
    return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
end

Library.AddToTheme = function(self, Item, Properties)
    Item = Item.Instance or Item 

    local ThemeData = {
        Item = Item,
        Properties = Properties,
    }

    for Property, Value in ThemeData.Properties do
        if type(Value) == "string" then
            Item[Property] = self.Theme[Value]
        else
            Item[Property] = Value()
        end
    end

    TableInsert(self.ThemeItems, ThemeData)
    self.ThemeMap[Item] = ThemeData
end

Library.GetConfig = function(self)
    local Config = {}

    local Success, Result = Library:SafeCall(function()

        -- Save normal flags
        for Index, Value in Library.Flags do
            if type(Value) == "table" and Value.Key then
                Config[Index] = {
                    Key = tostring(Value.Key),
                    Mode = Value.Mode,
                    Toggled = Value.Toggled
                }

            elseif type(Value) == "table" and Value.Color then
                Config[Index] = {
                    Color = "#" .. Value.HexValue,
                    Alpha = Value.Alpha
                }

            else
                Config[Index] = Value
            end
        end

        -- Save widget positions
        Config.WidgetPositions = {}

        if Library.KeybindListInstance and Library.KeybindListInstance.GetPosition then
            Config.WidgetPositions.KeybindList = Library.KeybindListInstance:GetPosition()
        end

        if Library.ArmorViewerInstance and Library.ArmorViewerInstance.GetPosition then
            Config.WidgetPositions.ArmorViewer = Library.ArmorViewerInstance:GetPosition()
        end

        if Library.ModeratorListInstance and Library.ModeratorListInstance.GetPosition then
            Config.WidgetPositions.ModeratorList = Library.ModeratorListInstance:GetPosition()
        end

        if Library.WatermarkInstance and Library.WatermarkInstance.GetPosition then
            Config.WidgetPositions.Watermark = Library.WatermarkInstance:GetPosition()
        end

        if Library.TargetHudInstance and Library.TargetHudInstance.GetPosition then
            Config.WidgetPositions.TargetHud = Library.TargetHudInstance:GetPosition()
        end

    end)

    return HttpService:JSONEncode(Config)
end


Library.LoadConfig = function(self, Config)
    local Decoded = HttpService:JSONDecode(Config)

    local Success, Result = Library:SafeCall(function()

        for Index, Value in Decoded do
            if Index == "WidgetPositions" then
                continue
            end

            local SetFunction = Library.SetFlags[Index]

            if not SetFunction then
                continue
            end

            if type(Value) == "table" and Value.Key then
                SetFunction(Value)

            elseif type(Value) == "table" and Value.Color then
                SetFunction(Value.Color, Value.Alpha)

            else
                SetFunction(Value)
            end
        end

        -- Restore widget positions
        if Decoded.WidgetPositions then

            if Decoded.WidgetPositions.KeybindList
            and Library.KeybindListInstance
            and Library.KeybindListInstance.SetPosition then
                Library.KeybindListInstance:SetPosition(
                    Decoded.WidgetPositions.KeybindList
                )
            end

            if Decoded.WidgetPositions.ArmorViewer
            and Library.ArmorViewerInstance
            and Library.ArmorViewerInstance.SetPosition then
                Library.ArmorViewerInstance:SetPosition(
                    Decoded.WidgetPositions.ArmorViewer
                )
            end

            if Decoded.WidgetPositions.ModeratorList
            and Library.ModeratorListInstance
            and Library.ModeratorListInstance.SetPosition then
                Library.ModeratorListInstance:SetPosition(
                    Decoded.WidgetPositions.ModeratorList
                )
            end

            if Decoded.WidgetPositions.Watermark
            and Library.WatermarkInstance
            and Library.WatermarkInstance.SetPosition then
                Library.WatermarkInstance:SetPosition(
                    Decoded.WidgetPositions.Watermark
                )
            end

            if Decoded.WidgetPositions.TargetHud
            and Library.TargetHudInstance
            and Library.TargetHudInstance.SetPosition then
                Library.TargetHudInstance:SetPosition(
                    Decoded.WidgetPositions.TargetHud
                )
            end
        end

    end)

    return Success, Result
end


Library.DeleteConfig = function(self, Config)

    if isfile(Library.Folders.Configs .. "/" .. Config) then
        delfile(Library.Folders.Configs .. "/" .. Config)
    end

end

Library.RefreshConfigsList = function(self, Element)

    local List = {}
    local ReturnList = {}

    List = listfiles(Library.Folders.Configs)

    for Index = 1, #List do
        local File = List[Index]

        if File:sub(-5) == ".json" then

            local Position = File:find(".json", 1, true)
            local StartPosition = Position

            local Character = File:sub(Position, Position)

            while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                Position = Position - 1
                Character = File:sub(Position, Position)
            end

            if Character == "/" or Character == "\\" then
                TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
            end
        end
    end

    Element:Refresh(ReturnList)

end

Library.ChangeItemTheme = function(self, Item, Properties)
    Item = Item.Instance or Item

    if not self.ThemeMap[Item] then 
        return
    end

    self.ThemeMap[Item].Properties = Properties
    self.ThemeMap[Item] = self.ThemeMap[Item]
end

Library.ChangeTheme = function(self, Theme, Color)
    self.Theme[Theme] = Color

    for _, Item in self.ThemeItems do
        for Property, Value in Item.Properties do
            if type(Value) == "string" and Value == Theme then
                Item.Item[Property] = Color
            elseif type(Value) == "function" then
                Item.Item[Property] = Value()
            end
        end
    end
end

Library.IsMouseOverFrame = function(self, Frame)
    Frame = Frame.Instance

    local MousePosition = Vector2New(Mouse.X, Mouse.Y)

    return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
    and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
end

Library.GetLighterColor = function(self, Color, Increment)
    local Hue, Saturation, Value = Color:ToHSV()
    return FromHSV(Hue, Saturation, Value * Increment)
end

do 
    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            IsOpen = false,
            IsOpen2 = false,

            Color = FromRGB(0, 0, 0),
            HexValue = "000000",

            Flag = Data.Flag
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(152, 152, 152))}
            })                

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 1032, 0, 123),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 232, 0, 265),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.699999988079071,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Color = FromRGB(94, 213, 213),
                LineJoinMode = Enum.LineJoinMode.Miter
            }):AddToTheme({Color = "Accent"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 1, -35),
                Size = UDim2New(1, -16, 0, 10),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = "http://www.roblox.com/asset/?id=18274452449",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 1, 0),
                Position = UDim2New(0, 8, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                Position = UDim2New(1, -7, 0, 8),
                Size = UDim2New(0, 10, 1, -59),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = -0.009999999776482582,
                Position = UDim2New(0, 0, 0, 8),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -31, 1, -59),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 0, 2),
                Position = UDim2New(0, 8, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HexInput"] = Instances:Create("TextBox", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                ClearTextOnFocus = false,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, -16, 0, 20),
                PlaceholderColor3 = FromRGB(255, 255, 255),
                Position = UDim2New(0, 8, 1, -7),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["HexInput"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["HexInput"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})            
            
            Items["ColorpickerWindow2"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 50, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48),
                AutomaticSize = Enum.AutomaticSize.Y
            })  Items["ColorpickerWindow2"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIListLayout", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        local AddButton = function(Name, Callback)
            local NewButton = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  NewButton:AddToTheme({TextColor3 = "Text"})

            NewButton:Connect("MouseButton1Down", function()
                Callback()
                Colorpicker:SetOpen2(false)
            end)

            return NewButton
        end

        AddButton("Copy", function()
            local Red = MathFloor(Colorpicker.Color.R * 255)
            local Green = MathFloor(Colorpicker.Color.G * 255)
            local Blue = MathFloor(Colorpicker.Color.B * 255)

            setclipboard(Red .. ", " .. Green .. ", " .. Blue)
            Library.CopiedColor = Red .. ", " .. Green .. ", " .. Blue
        end)
        AddButton("Paste", function()
            if Library.CopiedColor then 
                local Red, Green, Blue = Library.CopiedColor:match("(%d+),%s*(%d+),%s*(%d+)")
                Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

                Colorpicker:Set({Red, Green, Blue}, Colorpicker.Alpha)
            end
        end)

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local Debounce = false
        local RenderStepped  

        local RenderStepped2

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Alpha
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Colorpicker.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 65)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Colorpicker then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Colorpicker] = Colorpicker 
            else
                if Library.OpenFrames[Colorpicker] then 
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Colorpicker.IsOpen and 104 or 1
                    Items["Glow"].Instance.ZIndex = Colorpicker.IsOpen and 103 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:SetOpen2(Bool)
            Colorpicker.IsOpen2 = Bool
            if Bool then
                Items["ColorpickerWindow2"].Instance.Visible = true 
                Items["ColorpickerWindow2"].Instance.Parent = Library.Holder.Instance

                RenderStepped2 = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow2"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + Items["ColorpickerButton"].Instance.AbsoluteSize.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 65)
                end)
            else
                if RenderStepped2 then 
                    RenderStepped2:Disconnect()
                    RenderStepped2 = nil
                end

                Items["ColorpickerWindow2"].Instance.Visible = false
                Items["ColorpickerWindow2"].Instance.Parent = Library.UnusedHolder.Instance
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end
            
            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

            Colorpicker.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.99)

            Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
            Colorpicker:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Alpha = Colorpicker.Alpha,
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue,
                Transparency = 1 - Colorpicker.Alpha
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            Items["HexInput"].Instance.Text = "#"..Colorpicker.HexValue

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end 

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
            Colorpicker.Alpha = Alpha or 0  

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

            local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.99)
                
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.99)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
            Colorpicker:Update(false)
        end

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
            end
        end)
        
        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)

        Items["HueInline"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
            end
        end)
        
        Items["HueInline"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
            end
        end)
        
        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)
        
        Items["HexInput"]:Connect("FocusLost", function()
            Colorpicker:Set(tostring(Items["HexInput"].Instance.Text), Colorpicker.Alpha)
        end)

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["ColorpickerButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                Colorpicker.IsOpen = not IsClipped(Items["ColorpickerWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                elseif SlidingHue then
                    Colorpicker:SlideHue(Input)
                elseif SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(Items["ColorpickerWindow2"]) then
                    return
                end

                Colorpicker:SetOpen(false)
                Colorpicker:SetOpen2(false)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
            Colorpicker:SetOpen2(not Colorpicker.IsOpen2)
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker, Items 
    end
    
    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            IsOpen = false,

            Key = "",
            Toggled = false,
            Mode = "",

            Flag = Data.Flag,

            Picking = false,
            Value = ""
        }

        local KeyListItem 
        if Library.KeyList then 
            KeyListItem = Library.KeyList:Add("", "")
        end

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "Unbound",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["KeybindWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 114, 0, 35),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                Size = UDim2New(0, 78, 0, 66),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 2, 0, 2),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Toggle"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["ToggleStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["ToggleStroke"]:AddToTheme({Color = "Border"})

            Items["ToggleLiner"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["ToggleLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["ToggleText"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutomaticSize = Enum.AutomaticSize.X,
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ToggleText"]:AddToTheme({TextColor3 = "Text"})

            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 22),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Hold"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["HoldStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["HoldStroke"]:AddToTheme({Color = "Border"})

            Items["HoldLiner"] = Instances:Create("Frame", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["HoldLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["HoldText"] = Instances:Create("TextLabel", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Hold",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["HoldText"]:AddToTheme({TextColor3 = "Text"})

            Items["AlwaysOn"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 44),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })

            Instances:Create("UIGradient", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["AlwaysOnStroke"] = Instances:Create("UIStroke", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["AlwaysOnStroke"]:AddToTheme({Color = "Border"})

            Items["AlwaysOnLiner"] = Instances:Create("Frame", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["AlwaysOnLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["AlwaysOnText"] = Instances:Create("TextLabel", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Always On",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["AlwaysOnText"]:AddToTheme({TextColor3 = "Text"})

            Items["KeyButton"]:OnHover(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)

            Items["KeyButton"]:OnHoverLeave(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        local Update = function()
            if KeyListItem then
                KeyListItem:SetText(Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled)
            end
        end

        local Modes = {
            ["Toggle"] = {Items["Toggle"], Items["ToggleText"], Items["ToggleStroke"], Items["ToggleLiner"]},
            ["Hold"] = {Items["Hold"], Items["HoldText"], Items["HoldStroke"], Items["HoldLiner"]},
            ["Always On"] = {Items["AlwaysOn"], Items["AlwaysOnText"], Items["AlwaysOnStroke"], Items["AlwaysOnLiner"]}
        }

        function Keybind:Get()
            return Keybind.Mode, Keybind.Key, Keybind.Toggled
        end

        local Debounce = false
        local RenderStepped  

        function Keybind:SetOpen(Bool)
            if Debounce then 
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true 

            if Keybind.IsOpen then 
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 65)
                end)

                if not Debounce then 
                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Keybind then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                end
            else
                if not Debounce then 
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled,
                    active = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                if Key.Toggled then 
                    Keybind:Press(Key.Toggled, true)
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Keybind.Mode)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "boolean" then  
                Keybind:Press(Key)
            end

            Keybind.Picking = false
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then 
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then 
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then
                    Value[1]:Tween(nil, {BackgroundTransparency = 0})
                    Value[4]:Tween(nil, {BackgroundTransparency = 0})
                    Value[2]:Tween(nil, {TextTransparency = 0})
                    Value[3]:Tween(nil, {Transparency = 0})
                else
                    Value[1]:Tween(nil, {BackgroundTransparency = 1})
                    Value[4]:Tween(nil, {BackgroundTransparency = 1})
                    Value[2]:Tween(nil, {TextTransparency = 0.4})
                    Value[3]:Tween(nil, {Transparency = 1})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["KeyButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Keybind.IsOpen then
                Keybind.IsOpen = not IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
            end
        end)

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true 

            Items["KeyButton"].Instance.Text = "."
            Library:Thread(function()
                local Count = 1

                while true do 
                    if not Keybind.Picking then 
                        break
                    end

                    if Count == 4 then
                        Count = 1
                    end

                    Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                    Count += 1
                    task.wait(0.4)
                end
            end)

            local InputBegan
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if UserInputService:GetFocusedTextBox() then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if UserInputService:GetFocusedTextBox() then
                return
            end

            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if UserInputService:GetFocusedTextBox() then
                return
            end

            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["AlwaysOn"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always On")
        end)

        if Data.Default then
            Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle", Toggled = Data.Toggled})
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind, Items 
    end

Library.Watermark = function(self, Name)
    local RunService = game:GetService("RunService")

    local Watermark = { }
    local fps = 0
    local frames = 0
    local lastUpdate = tick()

    local Items = { } do 
        Items["Watermark"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0),
            Position = UDim2New(0.5, 0, 0, 25),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(0, 180, 0, 30),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(17, 21, 27),
            ZIndex = 5,
        })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background 1"})

        Items["Watermark"]:MakeDraggable()

        Items["UIStroke"] = Instances:Create("UIStroke", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            Color = FromRGB(94, 213, 213),
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })  Items["UIStroke"]:AddToTheme({Color = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Items["UIStroke"].Instance,
            Name = "\0",
            Rotation = 90,
            Transparency = NumSequence{
                NumSequenceKeypoint(0, 0),
                NumSequenceKeypoint(0.696, 0.2749999761581421),
                NumSequenceKeypoint(0.84, 0.574999988079071),
                NumSequenceKeypoint(1, 1)
            }
        })

        Items["Glow"] = Instances:Create("ImageLabel", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            ImageColor3 = FromRGB(94, 213, 213),
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.5,
            BorderColor3 = FromRGB(0, 0, 0),
            BackgroundColor3 = FromRGB(255, 255, 255),
            Size = UDim2New(1, 25, 1, 25),
            AnchorPoint = Vector2New(0.5, 0.5),
            Image = "rbxassetid://18245826428",
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            ZIndex = 4,
            BorderSizePixel = 0,
            SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
        })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Items["Glow"].Instance,
            Name = "\0",
            Rotation = 90,
            Transparency = NumSequence{
                NumSequenceKeypoint(0, 0),
                NumSequenceKeypoint(1, 1)
            }
        })

        Items["Text"] = Instances:Create("TextLabel", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = Name,
            AnchorPoint = Vector2New(0.5, 0.5),
            Size = UDim2New(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            BorderSizePixel = 0,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
    end

    function Watermark:SetText(Text)
        Text = tostring(Text)
        Items["Text"].Instance.Text = Text
        Items["Watermark"]:Tween(nil, {
            Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 20, 0, 30)
        })
    end

    function Watermark:SetVisibility(Bool)
        Items["Watermark"].Instance.Visible = Bool
    end

    function Watermark:GetPosition()
        local Position = Items["Watermark"].Instance.Position
        return {
            XScale = Position.X.Scale,
            XOffset = Position.X.Offset,
            YScale = Position.Y.Scale,
            YOffset = Position.Y.Offset
        }
    end

    function Watermark:SetPosition(Position)
        if not Position then
            return
        end

        Items["Watermark"].Instance.Position = UDim2New(
            Position.XScale or 0,
            Position.XOffset or 0,
            Position.YScale or 0,
            Position.YOffset or 0
        )
    end

    Watermark:SetText(Name)

    Library.WatermarkInstance = Watermark

    RunService.RenderStepped:Connect(function()
        frames += 1

        if tick() - lastUpdate >= 1 then
            fps = frames
            frames = 0
            lastUpdate = tick()

            local now = os.date("*t")
            local dateText = string.format("%02d/%02d/%04d", now.day, now.month, now.year)
            local timeText = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)

            Watermark:SetText(string.format(
                "Fallen Survival | %s | %s | %d FPS",
                dateText,
                timeText,
                fps
            ))
        end
    end)

    return Watermark
end

Library.KeybindList = function(self)
    local KeybindList = {}

    Library.KeyList = KeybindList
    self.KeyList = KeybindList

    local Items = {}

    Items["KeybindList"] = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 20, 0.5, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Color3.fromRGB(10,12,16),
        ClipsDescendants = false
    })

    -- Top blue line
    Items["TopLine"] = Instances:Create("Frame", {
        Parent = Items["KeybindList"].Instance,
        Position = UDim2.new(0,-1,0,-1),
        Size = UDim2.new(1,2,0,2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(90,190,255),
        ZIndex = 5
    })

    Instances:Create("UIStroke", {
        Parent = Items["KeybindList"].Instance,
        Color = Color3.fromRGB(35,40,48),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    Items["Inner"] = Instances:Create("Frame", {
        Parent = Items["KeybindList"].Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,1),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0
    })

    Instances:Create("UIPadding", {
        Parent = Items["Inner"].Instance,
        PaddingTop = UDim.new(0,6),
        PaddingBottom = UDim.new(0,6),
        PaddingLeft = UDim.new(0,10),
        PaddingRight = UDim.new(0,10)
    })

    -- Dragging
    do
        local frame = Items["KeybindList"].Instance
        local UIS = game:GetService("UserInputService")

        local dragging = false
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        frame.InputBegan:Connect(function(input)
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

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end

    Items["Title"] = Instances:Create("TextLabel", {
        Parent = Items["Inner"].Instance,
        FontFace = Library.Font,
        Text = "Keybinds",
        TextColor3 = Color3.fromRGB(235,235,235),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0,80,0,14),
        TextSize = 13
    })

    Items["Divider"] = Instances:Create("Frame", {
        Parent = Items["Inner"].Instance,
        Position = UDim2.new(0,0,0,18),
        Size = UDim2.new(1,0,0,1),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30,34,40)
    })

    Items["Content"] = Instances:Create("Frame", {
        Parent = Items["Inner"].Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,22),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0
    })

    Instances:Create("UIListLayout", {
        Parent = Items["Content"].Instance,
        Padding = UDim.new(0,2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function KeybindList:SetVisibility(Bool)
        Items["KeybindList"].Instance.Visible = Bool
    end

    function KeybindList:GetPosition()
        local p = Items["KeybindList"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function KeybindList:SetPosition(Pos)
        if typeof(Pos) == "UDim2" then
            Items["KeybindList"].Instance.Position = Pos
            return
        end

        Items["KeybindList"].Instance.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
    end

    function KeybindList:Add(Name, Key, Mode)
        Mode = Mode or "Toggle"

        local Row = Instances:Create("Frame", {
            Parent = Items["Content"].Instance,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X
        })

        local Check = Instances:Create("Frame", {
            Parent = Row.Instance,
            BackgroundColor3 = Color3.fromRGB(55,60,68),
            BorderSizePixel = 0,
            Size = UDim2.new(0,8,0,8),
            Position = UDim2.new(0,0,0,4)
        })

        local CheckStroke = Instances:Create("UIStroke", {
            Parent = Check.Instance,
            Color = Color3.fromRGB(80,85,95),
            Thickness = 1
        })

        local MainText = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = Library.Font,
            Text = string.format("[%s] %s", Key, Name),
            TextColor3 = Color3.fromRGB(220,220,220),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,14,0,0),
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 13
        })

        local Suffix = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = Library.Font,
            Text = " ("..Mode..")",
            TextColor3 = Color3.fromRGB(120,120,120),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,14,0,0),
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 13
        })

        local CurrentMode = Mode

        local function UpdateSuffix()
            Suffix.Instance.Position =
                UDim2.new(0,14 + MainText.Instance.TextBounds.X + 2,0,0)
        end

        UpdateSuffix()

        function Row:SetText(NewName, NewKey, NewMode)
            Name = NewName or Name
            Key = NewKey or Key
            CurrentMode = NewMode or CurrentMode

            MainText.Instance.Text = string.format("[%s] %s", Key, Name)
            Suffix.Instance.Text = " ("..CurrentMode..")"
            UpdateSuffix()
        end

        function Row:SetStatus(Bool)
            if Bool then
                Check.Instance.BackgroundColor3 = Color3.fromRGB(110,200,255)
                CheckStroke.Instance.Color = Color3.fromRGB(150,220,255)

                MainText.Instance.TextColor3 = Color3.fromRGB(140,210,255)
                Suffix.Instance.TextColor3 = Color3.fromRGB(140,210,255)
            else
                Check.Instance.BackgroundColor3 = Color3.fromRGB(55,60,68)
                CheckStroke.Instance.Color = Color3.fromRGB(80,85,95)

                MainText.Instance.TextColor3 = Color3.fromRGB(220,220,220)
                Suffix.Instance.TextColor3 = Color3.fromRGB(120,120,120)
            end
        end

        return Row
    end

    return KeybindList
end
									
Library.ModeratorList = function(self)
    local ModList = {}
    local Moderators = {}
    local UserButtons = {}
    local StartTime = os.time()

    local Items = {} do
        -- Main Container Window (Staff List)
        Items["ModList"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "__ModeratorList",
            AnchorPoint = Vector2New(0, 0.5),
            Position = UDim2New(1, -290, 0, 80),
            BorderSizePixel = 0,
            Size = UDim2New(0, 270, 0, 180),
            BackgroundColor3 = FromRGB(12, 12, 12)
        })
        Items["ModList"]:AddToTheme({BackgroundColor3 = "Background 2"})
        Items["ModList"]:MakeDraggable()
        Items["ModList"].Instance.ClipsDescendants = false

        -- Top Bar Drag Handle
        Items["TopBar"] = Instances:Create("Frame", {
            Parent = Items["ModList"].Instance,
            Position = UDim2New(0, 0, 0, 0),
            Size = UDim2New(1, 0, 0, 35),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(18, 18, 18)
        })
        Items["TopBar"].Instance.ZIndex = 60

        -- Status Dot
        Items["StatusDot"] = Instances:Create("Frame", {
            Parent = Items["TopBar"].Instance,
            Position = UDim2New(0, 12, 0, 13),
            Size = UDim2New(0, 8, 0, 8),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(0, 200, 100)
        })
        Items["StatusDot"].Instance.ZIndex = 61
        Instances:Create("UICorner", {Parent = Items["StatusDot"].Instance, CornerRadius = UDimNew(1, 0)})
        Instances:Create("UICorner", {Parent = Items["TopBar"].Instance, CornerRadius = UDimNew(0, 8)})

        -- Title
        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["TopBar"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            Text = "Staff List",
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2New(0, 28, 0, 0),
            Size = UDim2New(0, 70, 1, 0),
            TextSize = 13
        })
        Items["Title"].Instance.ZIndex = 61

        -- Player Count Label
        Items["PlayerCount"] = Instances:Create("TextLabel", {
            Parent = Items["TopBar"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            Text = "[0/0]",
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2New(0, 92, 0, 0),
            Size = UDim2New(0, 75, 1, 0),
            TextSize = 13
        })
        Items["PlayerCount"].Instance.ZIndex = 61

        -- Session Timer Label
        Items["Timer"] = Instances:Create("TextLabel", {
            Parent = Items["TopBar"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(200, 200, 200),
            Text = "00:00:00",
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2New(0, 168, 0, 0),
            Size = UDim2New(0, 65, 1, 0),
            TextSize = 13
        })
        Items["Timer"].Instance.ZIndex = 61

        -- Toggle Button
        Items["ProfileBtn"] = Instances:Create("TextButton", {
            Parent = Items["TopBar"].Instance,
            Position = UDim2New(1, -32, 0, 5),
            Size = UDim2New(0, 24, 0, 24),
            BackgroundTransparency = 1,
            Text = ""
        })
        Items["ProfileBtn"].Instance.ZIndex = 62

        local headIcon = Instances:Create("Frame", {
            Parent = Items["ProfileBtn"].Instance,
            Position = UDim2New(0, 7, 0, 2),
            Size = UDim2New(0, 10, 0, 10),
            BackgroundColor3 = FromRGB(220, 220, 220)
        })
        headIcon.Instance.ZIndex = 63
        Instances:Create("UICorner", {Parent = headIcon.Instance, CornerRadius = UDimNew(1, 0)})

        local torsoIcon = Instances:Create("Frame", {
            Parent = Items["ProfileBtn"].Instance,
            Position = UDim2New(0, 3, 0, 13),
            Size = UDim2New(0, 18, 0, 9),
            BackgroundColor3 = FromRGB(220, 220, 220)
        })
        torsoIcon.Instance.ZIndex = 63
        Instances:Create("UICorner", {Parent = torsoIcon.Instance, CornerRadius = UDimNew(0, 4)})

        -- Content Frame
        Items["Content"] = Instances:Create("ScrollingFrame", {
            Parent = Items["ModList"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 10, 0, 40),
            Size = UDim2New(1, -25, 1, -45),
            CanvasSize = UDim2New(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Items["Content"].Instance.ScrollBarThickness = 10
        Items["Content"].Instance.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        Items["Content"].Instance.ZIndex = 51

        -- FIXED: Added explicit AnchorPoint to prevent offset math breaking on drag updates
        -- FIXED: Corrected initial Position to sit right next to ModList (UserPanel Width: 360 + 10px Gap = -370px from ModList position)
        Items["UserPanel"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "__ServerUserPanel",
            AnchorPoint = Vector2New(0, 0.5),
            Size = UDim2New(0, 360, 0, 260),
            Position = UDim2New(1, -660, 0, 80),
            BackgroundColor3 = FromRGB(15, 15, 15),
            BorderSizePixel = 0
        })
        Items["UserPanel"].Instance.Visible = false
        Items["UserPanel"].Instance.Active = true
        Instances:Create("UICorner", {Parent = Items["UserPanel"].Instance, CornerRadius = UDimNew(0, 8)})

        local userTopBar = Instances:Create("Frame", {
            Parent = Items["UserPanel"].Instance,
            Size = UDim2New(1, 0, 0, 35),
            BackgroundColor3 = FromRGB(22, 22, 22)
        })
        Instances:Create("UICorner", {Parent = userTopBar.Instance, CornerRadius = UDimNew(0, 8)})

        local userTitle = Instances:Create("TextLabel", {
            Parent = userTopBar.Instance,
            Position = UDim2New(0, 12, 0, 0),
            Size = UDim2New(1, -20, 1, 0),
            BackgroundTransparency = 1,
            Text = "Server Users (Click to Copy Profile)",
            TextColor3 = FromRGB(255, 255, 255),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Items["UserContent"] = Instances:Create("ScrollingFrame", {
            Parent = Items["UserPanel"].Instance,
            Position = UDim2New(0, 10, 0, 40),
            Size = UDim2New(1, -25, 1, -45),
            BackgroundTransparency = 1,
            CanvasSize = UDim2New(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Items["UserContent"].Instance.ScrollBarThickness = 10
        Items["UserContent"].Instance.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

        Instances:Create("UIListLayout", {
            Parent = Items["UserContent"].Instance,
            Padding = UDimNew(0, 5)
        })

        Instances:Create("UICorner", {
            Parent = Items["ModList"].Instance,
            CornerRadius = UDimNew(0, 8)
        })
    end

    -- Clock tick handling loop
    task.spawn(function()
        while task.wait(1) do
            local elapsed = os.time() - StartTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            Items["Timer"].Instance.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        end
    end)

    -- FIXED: Fixed alignment math to match the layout sizes perfectly
    local function syncUserPanelPosition()
        local mainPos = Items["ModList"].Instance.Position
        Items["UserPanel"].Instance.Position = UDim2.new(mainPos.X.Scale, mainPos.X.Offset - 370, mainPos.Y.Scale, mainPos.Y.Offset)
    end

    -- Toggle operation connection
    Items["ProfileBtn"].Instance.MouseButton1Click:Connect(function()
        Items["UserPanel"].Instance.Visible = not Items["UserPanel"].Instance.Visible
        if Items["UserPanel"].Instance.Visible then
            syncUserPanelPosition()
        end
    end)

    -- Automatically sync user panel layout when main panel is dragged
    Items["ModList"].Instance:GetPropertyChangedSignal("Position"):Connect(function()
        if Items["UserPanel"].Instance.Visible then
            syncUserPanelPosition()
        end
    end)

    --// ADDED CONFIGURATION SUPPORT METHODS
    function ModList:GetPosition()
        local p = Items["ModList"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function ModList:SetPosition(Pos)
        if not Pos then return end
        Items["ModList"].Instance.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
        -- Sync user sub-panel coordinate mapping automatically
        syncUserPanelPosition()
    end

    --// API CONTROLLERS
    function ModList:SetVisibility(Bool)
        Items["ModList"].Instance.Visible = Bool
        if not Bool then Items["UserPanel"].Instance.Visible = false end
    end

    function ModList:Toggle()
        Items["ModList"].Instance.Visible = not Items["ModList"].Instance.Visible
        if not Items["ModList"].Instance.Visible then Items["UserPanel"].Instance.Visible = false end
    end

    function ModList:add_mod(UserId, Username, Role)
        if Moderators[UserId] then ModList:remove_mod(UserId) end
        Role = Role or "Moderator"

        local ModFrame = Instances:Create("Frame", {
            Parent = Items["Content"].Instance,
            BackgroundTransparency = 1,
            Size = UDim2New(1, 0, 0, 28),
            BorderSizePixel = 0
        })

        local Line = Instances:Create("TextLabel", {
            Parent = ModFrame.Instance,
            FontFace = Library.Font,
            RichText = true,
            TextColor3 = FromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2New(1, 0, 1, 0),
            Text = string.format("<font color='#00aaff' size='16'>%s</font> <font color='#ffffff' size='13'>(@%s)</font> <font color='#ffaa00' size='16'> %s</font>", Username, Username, Role)
        })
        Line.Instance.ZIndex = 53

        Moderators[UserId] = { Frame = ModFrame, Label = Line }
        local count = 0 for _ in pairs(Moderators) do count += 1 end
        Items["StatusDot"].Instance.BackgroundColor3 = (count > 0) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
        return Moderators[UserId]
    end

    function ModList:remove_mod(UserId)
        local ModData = Moderators[UserId]
        if ModData then
            ModData.Frame:Clean()
            Moderators[UserId] = nil
        end
        local count = 0 for _ in pairs(Moderators) do count += 1 end
        Items["StatusDot"].Instance.BackgroundColor3 = (count > 0) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
    end

    function ModList:add_server_user(player)
        if UserButtons[player.UserId] then return end
        Items["PlayerCount"].Instance.Text = string.format("[%d/%d]", #game:GetService("Players"):GetPlayers(), game:GetService("Players").MaxPlayers)

        local btn = Instances:Create("TextButton", {
            Parent = Items["UserContent"].Instance,
            Size = UDim2New(1, 0, 0, 28),
            BackgroundColor3 = FromRGB(22, 22, 22),
            BorderSizePixel = 0,
            Text = ""
        })
        Instances:Create("UICorner", {Parent = btn.Instance, CornerRadius = UDimNew(0, 4)})

        local txt = Instances:Create("TextLabel", {
            Parent = btn.Instance,
            Size = UDim2New(1, -10, 1, 0),
            Position = UDim2New(0, 8, 0, 0),
            BackgroundTransparency = 1,
            RichText = true,
            Text = string.format("<font color='#00aaff'>%s</font> <font color='#ffffff'> (@%s) | ID: %d</font>", player.DisplayName, player.Name, player.UserId),
            TextColor3 = FromRGB(255, 255, 255),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        btn.Instance.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/profile")
                local old = txt.Instance.Text
                txt.Instance.Text = "<font color='#55ff55'>Copied Profile Link!</font>"
                task.delay(1.5, function() txt.Instance.Text = old end)
            end
        end)

        UserButtons[player.UserId] = btn
    end

    function ModList:remove_server_user(player)
        Items["PlayerCount"].Instance.Text = string.format("[%d/%d]", #game:GetService("Players"):GetPlayers(), game:GetService("Players").MaxPlayers)
        if UserButtons[player.UserId] then
            UserButtons[player.UserId]:Clean()
            UserButtons[player.UserId] = nil
        end
    end

    Items["PlayerCount"].Instance.Text = string.format("[%d/%d]", #game:GetService("Players"):GetPlayers(), game:GetService("Players").MaxPlayers)
    Library.ModeratorListInstance = ModList
    return ModList
end

Library.ArmorViewer = function(self)
    local Viewer = {
        Items = { }
    }

    local Items = { }
    local Layout

    local MinWidth = 240
    local MaxWidth = 9999
    local BarHeight = 140
    local ItemSize = 82
    local Gap = 8
    local PadL, PadR = 10, 10
    local PadT, PadB = 10, 10
    local HeaderH = 45

    local function Clamp(x, a, b)
        if (x < a) then return a end
        if (x > b) then return b end
        return x
    end

    local function CountItems()
        local n = 0
        for _, c in ipairs(Items["RealHolder"].Instance:GetChildren()) do
            if (c:IsA("Frame")) then
                n += 1
            end
        end
        return n
    end

    local function UpdateBarSize()
        if (not Items["ArmorViewer"]) then
            return
        end

        local n = CountItems()
        local contentW

        if (n <= 0) then
            contentW = PadL + PadR
        else
            contentW = PadL + PadR + (n * ItemSize) + ((n - 1) * Gap)
        end

        local outerW = contentW + 24
        local w = Clamp(outerW, MinWidth, MaxWidth)

        Items["ArmorViewer"].Instance.Size = UDim2New(0, w, 0, BarHeight)
        Items["Holder"].Instance.Size = UDim2New(1, -24, 1, -(HeaderH + 12))
        Items["RealHolder"].Instance.Size = UDim2New(1, 0, 1, 0)
        Items["RealHolder"].Instance.CanvasSize = UDim2New(0, math.max(0, contentW), 0, 0)
    end

    do
        -- Root Box Window Component Container (Now with AnchorPoint fixed to dead center layout)
        Items["ArmorViewer"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            Position = UDim2New(0.5, 0, 0.5, 0),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(0, MinWidth, 0, BarHeight),
            BorderSizePixel = 0,
            ZIndex = 8,
            BackgroundColor3 = FromRGB(24, 28, 36),
            AnchorPoint = Vector2New(0.5, 0.5)
        }) Items["ArmorViewer"]:AddToTheme({BackgroundColor3 = "Background 2"})

        Items["ArmorViewer"]:MakeDraggable()

        -- Title text label container block built safely into your factory creation system
        Items["TitleBox"] = Instances:Create("Frame", {
            Parent = Items["ArmorViewer"].Instance,
            Name = "\0",
            Position = UDim2New(0.5, 0, 0, 4),
            AnchorPoint = Vector2New(0.5, 0), -- Center-anchored horizontally
            Size = UDim2New(0, 130, 0, 24),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = FromRGB(15, 18, 24),
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 12
        })

        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 6)
        TitleCorner.Parent = Items["TitleBox"].Instance

        local TitlePadding = Instance.new("UIPadding")
        TitlePadding.PaddingLeft = UDim.new(0, 12)
        TitlePadding.PaddingRight = UDim.new(0, 12)
        TitlePadding.Parent = Items["TitleBox"].Instance

        -- Center-locked Text Title element wrapped safely into the custom plate container
        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["TitleBox"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "Armor",
            Size = UDim2New(1, 0, 1, 0),
            Position = UDim2New(0, 0, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center, -- Hard-locked to middle
            BorderSizePixel = 0,
            ZIndex = 14,
            TextSize = 13,
            BackgroundColor3 = FromRGB(255, 255, 255)
        }) Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["Holder"] = Instances:Create("Frame", {
            Parent = Items["ArmorViewer"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2New(0, 12, 0, HeaderH),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, -24, 1, -(HeaderH + 12)),
            BorderSizePixel = 0,
            ZIndex = 8,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        Items["RealHolder"] = Instances:Create("ScrollingFrame", {
            Parent = Items["Holder"].Instance,
            Name = "\0",
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            BorderSizePixel = 0,
            CanvasSize = UDim2New(0, 0, 0, 0),
            ScrollBarImageColor3 = FromRGB(46, 52, 61),
            MidImage = "rbxassetid://93024691806056",
            BorderColor3 = FromRGB(0, 0, 0),
            ScrollBarThickness = 0,
            Size = UDim2New(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Position = UDim2New(0, 0, 0, 0),
            ZIndex = 8,
            BottomImage = "rbxassetid://93024691806056",
            TopImage = "rbxassetid://93024691806056",
            BackgroundColor3 = FromRGB(255, 255, 255),
            ScrollingDirection = Enum.ScrollingDirection.X
        }) Items["RealHolder"]:AddToTheme({ScrollBarImageColor3 = "Border"})

        -- Grid Layout Engine to automatically distribute multiple elements side-by-side cleanly
        local Grid = Instance.new("UIGridLayout")
        Grid.SortOrder = Enum.SortOrder.LayoutOrder
        Grid.CellSize = UDim2New(0, ItemSize, 0, ItemSize)
        Grid.CellPadding = UDim2New(0, Gap, 0, 0)
        Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Forces items to cluster tightly in the center
        Grid.VerticalAlignment = Enum.VerticalAlignment.Center
        Grid.Parent = Items["RealHolder"].Instance

        Instances:Create("UIPadding", {
            Parent = Items["RealHolder"].Instance,
            Name = "\0",
            PaddingTop = UDimNew(0, PadT),
            PaddingBottom = UDimNew(0, PadB),
            PaddingRight = UDimNew(0, PadR),
            PaddingLeft = UDimNew(0, PadL)
        })

        Items["RealHolder"].Instance.ChildAdded:Connect(function()
            UpdateBarSize()
        end)

        Items["RealHolder"].Instance.ChildRemoved:Connect(function()
            UpdateBarSize()
        end)

        UpdateBarSize()
    end

    function Viewer:Add(Name, Icon)
        local NewItemTable = { }

        -- Slot background box plate integrated cleanly via creation factory
        local ArmorBackBox = Instances:Create("Frame", {
            Parent = Items["RealHolder"].Instance,
            Name = "\0",
            BackgroundColor3 = FromRGB(20, 24, 32),
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 8,
            Size = UDim2New(1, 0, 1, 0)
        })

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 8)
        BoxCorner.Parent = ArmorBackBox.Instance

        local NewItem = Instances:Create("Frame", {
            Parent = ArmorBackBox.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = 9,
            Size = UDim2New(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        Instances:Create("ImageLabel", {
            Parent = NewItem.Instance,
            Name = "\0",
            BorderColor3 = FromRGB(0, 0, 0),
            AnchorPoint = Vector2New(0.5, 0.5),
            ZIndex = 11,
            Image = Icon,
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(0, 58, 0, 58),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        function NewItemTable:Remove()
            ArmorBackBox:Clean()
            NewItem:Clean()
            Viewer.Items[Name] = nil
            UpdateBarSize()
        end

        Viewer.Items[Name] = NewItemTable
        UpdateBarSize()
        return NewItemTable
    end

    function Viewer:ClearAllItems()
        for _, Value in Viewer.Items do
            if (not Value or not Value.Remove) then
                continue
            end
            Value:Remove()
        end
        UpdateBarSize()
    end

    function Viewer:SetVisibility(Bool)
        Items["ArmorViewer"].Instance.Visible = Bool
    end

    function Viewer:SetTitle(Name)
        Items["Title"].Instance.Text = Name
    end

    function Viewer:SetText(Name)
        Viewer:SetTitle(Name)
    end

    function Viewer:GetPosition()
        local p = Items["ArmorViewer"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function Viewer:SetPosition(Position)
        if not Position then return end
        if typeof(Position) == "UDim2" then
            Items["ArmorViewer"].Instance.Position = Position
            return
        end
        Items["ArmorViewer"].Instance.Position = UDim2New(
            Position.XScale or 0,
            Position.XOffset or 0,
            Position.YScale or 0,
            Position.YOffset or 0
        )
    end

    function Viewer:SetSizeLimits(Min, Max)
        MinWidth = Min or MinWidth
        MaxWidth = Max or MaxWidth
        UpdateBarSize()
    end

    function Viewer:SetBarHeight(H)
        BarHeight = H or BarHeight
        Items["ArmorViewer"].Instance.Size = UDim2New(0, Items["ArmorViewer"].Instance.Size.X.Offset, 0, BarHeight)
        UpdateBarSize()
    end

    return Viewer
end

    Library.Notification = function(self, Name, Duration)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = self.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 20, 0, 20),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 7),
                PaddingBottom = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7),
                PaddingLeft = UDimNew(0, 7)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        local Size = Items["Notification"].Instance.AbsoluteSize

        for Index, Value in Items do 
            if Value.Instance:IsA("Frame") then
                Value.Instance.BackgroundTransparency = 1
            elseif Value.Instance:IsA("TextLabel") then 
                Value.Instance.TextTransparency = 1
            end
        end 

        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

        Library:Thread(function()
            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value:Tween(nil, {BackgroundTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") then 
                    Value:Tween(nil, {TextTransparency = 0})
                end
            end

            Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, Size.Y)})

            task.delay(Duration + 0.1, function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 1})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                
                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.TargetHud = function(self)
        local TargetHud = { }

        local Items = { } do 
            Items["TargetHud"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Size = UDim2New(0, 295, 0, 21),
                Position = UDim2New(0, 0, 0.8, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })  Items["TargetHud"]:AddToTheme({BackgroundColor3 = "Background 1"})

            Items["TargetHud"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Target Hud",
                Size = UDim2New(0, 0, 0, 15),
                Position = UDim2New(0, 8, 0, 8),
                BackgroundTransparency = 1,
                ZIndex = 6,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 6,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.5,
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 6,
                BackgroundColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(1, 8, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Position = UDim2New(0, 8, 0, 32),
                Size = UDim2New(1, -16, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Avatar"] = Instances:Create("ImageLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
                BackgroundTransparency = 1,
                ZIndex = 6,
                Size = UDim2New(0, 70, 0, 70),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })           
            
            Items["Username"] = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "-- (@--)",
                Size = UDim2New(1, -77, 0, 15),
                ZIndex = 6,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 77, 0, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Username"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["TargetHud"].Instance,
                Name = "\0",
                PaddingBottom = UDimNew(0, 8)
            })
            
            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 9),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 9),
                PaddingLeft = UDimNew(0, 9)
            })

            Items["Bars"] = Instances:Create("Frame", {
                Parent = Items["Content"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 77, 1, 0),
                Size = UDim2New(1, -77, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 6,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Instances:Create("UIListLayout", {
                Parent = Items["Bars"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        function TargetHud:AddBar(Color)
            local NewBar = { }

            local NewBarBackground = Instances:Create("Frame", {
                Parent = Items["Bars"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                ZIndex = 6,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 77, 1, 0),
                Size = UDim2New(1, 0, 0, 12),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            local BarAccent = Instances:Create("Frame", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.8999999761581421, 0, 1, 0),
                ZIndex = 6,
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            })
            
            Instances:Create("UIGradient", {
                Parent = BarAccent.Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(153, 153, 153))}
            })
            
            local BarValue = Instances:Create("TextLabel", {
                Parent = NewBarBackground.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                ZIndex = 6,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "90",
                Size = UDim2New(0, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, -1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  BarValue:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = BarValue.Instance,
                Name = "\0"
            })

            function NewBar:SetPercentage(Percentage)
                local RealPercentage = 1 / 100 * Percentage
    
                if BarAccent and NewBarBackground then 
                    BarAccent:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(RealPercentage, 0, 1, 0)})
                    BarValue.Instance.Text = math.floor(Percentage)
                end
            end

            function NewBar:Remove()
                NewBarBackground:Clean()
                NewBar = nil
            end

            return NewBar
        end
        
        function TargetHud:SetPlayer(Player)
            local AvatarContent = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            Items["Avatar"].Instance.Image = AvatarContent
            Items["Username"].Instance.Text = Player.DisplayName .. " (@"..Player.Name..")"
        end

        function TargetHud:SetVisibility(Bool)
            Items["TargetHud"].Instance.Visible = Bool
        end

        function TargetHud:SetPosition(Position)
            Items["TargetHud"].Instance.Position = Position
        end

        return TargetHud 
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Logo = Data.Logo or Data.logo or "90363697817722",
            
            Pages = { },
            Items = { },
            IsOpen = false
        }

local Items = { } do
    Items["MainFrame"] = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2New(0.5, 0.5),
        Position = UDim2New(0.5, 0, 0.5, 0),
        BorderColor3 = FromRGB(60, 65, 75),
        Size = UDim2New(0, 730, 0, 470),
        BorderSizePixel = 1,
        BackgroundColor3 = FromRGB(6, 6, 8)
    })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background 1"})

    Items["MainFrame"]:MakeDraggable()
    Items["MainFrame"]:MakeResizeable(Vector2New(730, 470), Vector2New(9999, 9999))

    Instances:Create("UIStroke", {
        Parent = Items["MainFrame"].Instance,
        Name = "\0",
        Color = FromRGB(60, 65, 75),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})

    Items["Inline"] = Instances:Create("Frame", {
        Parent = Items["MainFrame"].Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2New(0, 1, 0, 1),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2New(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    Instances:Create("UIStroke", {
        Parent = Items["Inline"].Instance,
        Name = "\0",
        Color = FromRGB(60, 65, 75),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Window Outline"})

    -- header divider
    Items["HeaderLine"] = Instances:Create("Frame", {
        Parent = Items["Inline"].Instance,
        Name = "\0",
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(60, 65, 75),
        Position = UDim2New(0, 8, 0, 31),
        Size = UDim2New(1, -16, 0, 1)
    })  Items["HeaderLine"]:AddToTheme({BackgroundColor3 = "Border"})

    Items["Logo"] = Instances:Create("ImageLabel", {
        Parent = Items["Inline"].Instance,
        Name = "\0",
        ImageColor3 = FromRGB(140, 180, 255),
        BorderColor3 = FromRGB(0, 0, 0),
        Image = "rbxassetid://" .. Window.Logo,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 8, 0, 8),
        Size = UDim2New(0, 14, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })  Items["Logo"]:AddToTheme({ImageColor3 = "Accent"})

    Items["Title"] = Instances:Create("TextLabel", {
        Parent = Items["Inline"].Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(220, 220, 220),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = Window.Name,
        Size = UDim2New(0, 0, 0, 14),
        BackgroundTransparency = 1,
        Position = UDim2New(0, 28, 0, 8),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 13,
        BackgroundColor3 = FromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

    Items["Content"] = Instances:Create("Frame", {
        Parent = Items["Inline"].Instance,
        Name = "\0",
        BorderColor3 = FromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(0, 8, 0, 39),
        ClipsDescendants = true,
        Size = UDim2New(1, -16, 1, -47),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    Instances:Create("UIStroke", {
        Parent = Items["Content"].Instance,
        Name = "\0",
        Color = FromRGB(60, 65, 75),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})

    Items["Pages"] = Instances:Create("Frame", {
        Parent = Items["Content"].Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Position = UDim2New(0, 0, 0, 0),
        Size = UDim2New(1, 0, 0, 28),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })

    -- line under tabs
    Items["PagesLine"] = Instances:Create("Frame", {
        Parent = Items["Content"].Instance,
        Name = "\0",
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(60, 65, 75),
        Position = UDim2New(0, 0, 0, 28),
        Size = UDim2New(1, 0, 0, 1)
    })  Items["PagesLine"]:AddToTheme({BackgroundColor3 = "Border"})

    Instances:Create("UIListLayout", {
        Parent = Items["Pages"].Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Padding = UDimNew(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Window.Items = Items
end

        local Debounce = false

        function Window:SetCenter()
            local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
            task.wait()
            Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

            Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
        end

        function Window:SetOpen(Bool)
            for Index, Value in Library.OpenFrames do
                Value:SetOpen(false)
            end

            if Debounce then 
                return
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Window.IsOpen then 
                Items["MainFrame"].Instance.Visible = true 
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["MainFrame"].Instance.Visible = Window.IsOpen
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window:SetCenter()
        task.wait()
        Window:SetOpen(true)
        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            Items = { },
            ColumnsData = { },
            Active = false
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Items["Pages"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["Liner"].Instance,
                Name = "\0",
                Visible = false,
                ImageTransparency = 0.5,
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
                ScaleType = Enum.ScaleType.Slice,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ImageColor3 = FromRGB(94, 213, 213),
                Size = UDim2New(1, 8, 1, 8),
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Page.Name,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0.5, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                
            Items["TextGlow"] = Instances:Create("ImageLabel", {
                Parent = Items["Text"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 8, 1, 8),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 3),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["TextGlow"]:AddToTheme({ImageColor3 = "Text"})
            
            Instances:Create("UIGradient", {
                Parent = Items["TextGlow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 1, 1),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background 1"})

            Items["Page"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 80),
                BorderColor3 = FromRGB(0, 0, 0),
                Visible = false,
                Size = UDim2New(1, 0, 1, -35),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Page"].Instance,
                Name = "\0",
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            })
            
            for Index = 1, Page.Columns do 
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 5),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[Index] = NewColumn
            end                                    

            Page.Items = Items
        end

        local Debounce = false

function Page:Turn(Bool)
    if Debounce then
        return
    end

    Page.Active = Bool
    Debounce = true

    if Items["Page"] and Items["Page"].Instance then
        Items["Page"].Instance.Visible = Bool
        Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance
    end

    if Page.Active then
        if Items["Liner"] and Items["Liner"].Tween then
            Items["Liner"]:Tween(
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0, Size = UDim2New(1, 0, 0, 1)}
            )
        end

        if Items["TextGlow"] and Items["TextGlow"].Tween then
            Items["TextGlow"]:Tween(nil, {ImageTransparency = 0.7})
        end

        if Items["Text"] and Items["Text"].Tween then
            Items["Text"]:Tween(nil, {TextTransparency = 0})
        end

        if Items["Hide"] and Items["Hide"].Tween then
            Items["Hide"]:Tween(nil, {BackgroundTransparency = 0})
        end

        if Items["Page"] and Items["Page"].Tween then
            Items["Page"]:Tween(
                TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = UDim2New(0, 0, 0, 35)}
            )
        end
    else
        if Items["Liner"] and Items["Liner"].Tween then
            Items["Liner"]:Tween(
                TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 1)}
            )
        end

        if Items["TextGlow"] and Items["TextGlow"].Tween then
            Items["TextGlow"]:Tween(nil, {ImageTransparency = 1})
        end

        if Items["Text"] and Items["Text"].Tween then
            Items["Text"]:Tween(nil, {TextTransparency = 0.4})
        end

        if Items["Hide"] and Items["Hide"].Tween then
            Items["Hide"]:Tween(nil, {BackgroundTransparency = 1})
        end

        if Items["Page"] and Items["Page"].Tween then
            Items["Page"]:Tween(
                TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = UDim2New(0, 0, 0, 80)}
            )
        end
    end

    Debounce = false
end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do 
                if Value == Page and Page.Active then
                    return
                end

                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

Library.Pages.Section = function(self, Data)
    Data = Data or {}

    local Section = {
        Window = self.Window,
        Page = self,

        Name = Data.Name or Data.name or "Section",
        Side = Data.Side or Data.side or 1,

        Items = {}
    }

    local Items = {} do

        -- Main section box
        Items["Section"] = Instances:Create("Frame", {
            Parent = Section.Page.ColumnsData[Section.Side].Instance,
            Name = "\0",
            Size = UDim2New(1, 0, 0, 32),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = FromRGB(14,14,16)
        })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})

        Instances:Create("UIStroke", {
            Parent = Items["Section"].Instance,
            Color = FromRGB(55,60,68),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})


        -- Topbar (section header)
        Items["Topbar"] = Instances:Create("Frame", {
            Parent = Items["Section"].Instance,
            Size = UDim2New(1, 0, 0, 20),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(14,14,16)
        })  Items["Topbar"]:AddToTheme({BackgroundColor3 = "Inline"})


        -- Accent line
        Items["Liner"] = Instances:Create("Frame", {
            Parent = Items["Section"].Instance,
            Size = UDim2New(1, 0, 0, 1),
            Position = UDim2New(0, 0, 0, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(120,170,255)
        })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})


        -- Section title
        Items["Text"] = Instances:Create("TextLabel", {
            Parent = Items["Topbar"].Instance,
            FontFace = Library.Font,
            Text = Section.Name,
            TextSize = 13,
            TextColor3 = FromRGB(220,220,220),
            BackgroundTransparency = 1,
            Position = UDim2New(0,8,0.5,0),
            AnchorPoint = Vector2New(0,0.5),
            AutomaticSize = Enum.AutomaticSize.X
        })  Items["Text"]:AddToTheme({TextColor3 = "Text"})


        -- Content area
        Items["Content"] = Instances:Create("Frame", {
            Parent = Items["Section"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0,8,0,26),
            Size = UDim2New(1,-16,0,0),
            AutomaticSize = Enum.AutomaticSize.Y
        })


        -- Layout for controls
        Instances:Create("UIListLayout", {
            Parent = Items["Content"].Instance,
            Padding = UDimNew(0,4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })


        -- Bottom padding
        Instances:Create("UIPadding", {
            Parent = Items["Section"].Instance,
            PaddingBottom = UDim.new(0,6)
        })


        Section.Items = Items
    end

    return setmetatable(Section, Library.Sections)
end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["IndicatorOutline"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 12, 0, 12),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["IndicatorOutline"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["IndicatorOutline"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["IndicatorInline"] = Instances:Create("Frame", {
                Parent = Items["IndicatorOutline"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5 ,0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, -2, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["IndicatorInline"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Toggle.Name,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 20, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 0, 1, 0),
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["SubElements"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Toggle"]:OnHover(function()
                -- if Toggle.Value then return end 
                Items["IndicatorOutline"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["Toggle"]:OnHoverLeave(function()
                -- if Toggle.Value then return end 
                Items["IndicatorOutline"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Toggle:Get()
            return Toggle.Value 
        end

        function Toggle:Set(Value)
            Toggle.Value = Value 
            Library.Flags[Toggle.Flag] = Value 

            if Toggle.Value then 
                Items["IndicatorInline"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(1, -2, 1, -2)})
            else
                Items["IndicatorInline"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2New(0, -2, 0, -2)})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = Toggle.Window,
                Page = Toggle.Page,
                Section = Toggle.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Alpha = Data.Alpha or Data.alpha or 0,
                Callback = Data.Callback or Data.callback or function() end
            }

            local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                Parent = Items["SubElements"],
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Section = Colorpicker.Section,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = Toggle.Window,
                Page = Toggle.Page,
                Section = Toggle.Section,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle"
            }

            local NewKeybind, Items = Library:CreateKeybind({
                Name = Toggle.Name,
                Parent = Items["SubElements"],
                Flag = Keybind.Flag,
                Section = Keybind.Section,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        function Toggle:SetVisibility(Bool)
            Items["Toggle"].Instance.Visible = Bool 
        end

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle:Set(Toggle.Default)

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle 
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Button",
            Callback = Data.Callback or Data.callback or function() end
        }

        local Items = { } do
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Items["Content"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(199, 199, 199))}
            })                

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Button:SetVisibility(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        function Button:Press()
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            Library:SafeCall(Button.Callback)
            task.wait(0.1)
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }
        
        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Decimals = Data.Decimals or Data.decimals or 1,
            Suffix = Data.Suffix or Data.suffix or "",
            Max = Data.Max or Data.max or 100,
            Default = Data.Default or Data.Default or 0,
            Callback = Data.Callback or Data.callback or function() end,

            Value = 0,
            Sliding = false
        }

local Items = { } do 
    Items["Slider"] = Instances:Create("Frame", {
        Parent = Slider.Section.Items["Content"].Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2New(1, 0, 0, 28),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Items["Text"] = Instances:Create("TextLabel", {
        Parent = Items["Slider"].Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(255, 255, 255),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = Slider.Name,
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 0, 14),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 13,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
    
    Items["RealSlider"] = Instances:Create("TextButton", {
        Parent = Items["Slider"].Instance,
        Name = "\0",
        FontFace = Library.Font,
        TextColor3 = FromRGB(0, 0, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2New(0, 1),
        Position = UDim2New(0, 0, 1, -1),
        Size = UDim2New(1, 0, 0, 8),
        BorderSizePixel = 0,
        TextSize = 13,
        BackgroundColor3 = FromRGB(32, 38, 48)
    })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
    
    Instances:Create("UIStroke", {
        Parent = Items["RealSlider"].Instance,
        Name = "\0",
        Color = FromRGB(46, 52, 61),
        LineJoinMode = Enum.LineJoinMode.Miter,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }):AddToTheme({Color = "Border"})
    
    Items["Accent"] = Instances:Create("Frame", {
        Parent = Items["RealSlider"].Instance,
        Name = "\0",
        Position = UDim2New(0, 1, 0, 1),
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2New(0.5, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(94, 213, 213)
    })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
    
    Items["Value"] = Instances:Create("TextBox", {
        Parent = Items["Slider"].Instance,
        Name = "\0",
        FontFace = Library.Font,
        Active = false,
        TextTransparency = 0.2,
        AnchorPoint = Vector2New(1, 0),
        TextSize = 13,
        Size = UDim2New(0, 0, 0, 14),
        TextColor3 = FromRGB(255, 255, 255),
        BorderColor3 = FromRGB(0, 0, 0),
        Text = "50s",
        Selectable = false,
        BackgroundTransparency = 1,
        Position = UDim2New(1, 0, 0, 0),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })  Items["Value"]:AddToTheme({TextColor3 = "Text"})      

    Items["RealSlider"]:OnHover(function()
        Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.15)})
    end)
    
    Items["RealSlider"]:OnHoverLeave(function()
        Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
    end)
end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)
            Library.Flags[Slider.Flag] = Slider.Value

            Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -2, 1, -2)})
            Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

            if Slider.Value <= Slider.Min then 
                Items["Accent"].Instance.Visible = false
            else
                Items["Accent"].Instance.Visible = true
            end

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        Items["RealSlider"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = true

                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then 
                if Slider.Sliding then
                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)
                end
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or Data.Options or Data.options or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            MaxSize = Data.MaxSize or Data.maxsize or 75,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Options = { },
            Value = { },
            IsOpen = false
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 45),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["RealDropdown"] = Instances:Create("TextButton", {
                Parent = Items["Dropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "-",
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(1, -16, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0.5, 0),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Items["OptionHolder"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                Visible = false,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 130),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Search"] = Instances:Create("TextBox", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "",
                Size = UDim2New(1, -8, 0, 15),
                Position = UDim2New(0, 4, 0, 4),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = "Search..",
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Search"]:AddToTheme({TextColor3 = "Text"})
            
            Items["Holder"] = Instances:Create("ScrollingFrame", {
                Parent = Items["OptionHolder"].Instance,
                Name = "\0",
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(46, 52, 61),
                MidImage = "rbxassetid://93024691806056",
                BorderColor3 = FromRGB(0, 0, 0),
                ScrollBarThickness = 4,
                Size = UDim2New(1, -4, 1, -26),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 22),
                BottomImage = "rbxassetid://93024691806056",
                TopImage = "rbxassetid://93024691806056",
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 6)
            })                

            Instances:Create("UIListLayout", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)
            
            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:Set(Option)
            if Data.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option
                Library.Flags[Dropdown.Flag] = Option

                for Index, Value in Option do
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then
                        continue
                    end

                    OptionData.Selected = true 
                    OptionData:Toggle("Active")
                end

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = Option
                Library.Flags[Dropdown.Flag] = Option

                for Index, Value in Dropdown.Options do
                    if Value ~= OptionData then
                        Value.Selected = false 
                        Value:Toggle("Inactive")
                    else
                        Value.Selected = true 
                        Value:Toggle("Active")
                    end
                end

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then   
                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end
        end

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["RealDropdown"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Dropdown.IsOpen then
                Dropdown.IsOpen = not IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
            end
        end)

        local Debounce = false 
        local RenderStepped 

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return
            end 

            Dropdown.IsOpen = Bool
            Debounce = true

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["OptionHolder"].Instance.Position = UDim2New(
                        0, 
                        Items["RealDropdown"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 65
                    )

                    Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, Dropdown.MaxSize)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Dropdown then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Dropdown] = Dropdown
            else
                if RenderStepped then
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end

                if Library.OpenFrames[Dropdown] then 
                    Library.OpenFrames[Dropdown] = nil
                end
            end

            local AllInstances = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(AllInstances, Items["OptionHolder"].Instance)
            
            local NewTween

            for Index, Value in AllInstances do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Dropdown.IsOpen and 10 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, 0.2)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, 0.2)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                task.wait(0.2)
                Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Dropdown:Add(Option)
            local IsFirstOption = #Dropdown.Options == 0
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["Holder"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  OptionButton:AddToTheme({BackgroundColor3 = "Element"})
            
            Instances:Create("UIGradient", {
                Parent = OptionButton.Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })
            
            local OptionStroke = Instances:Create("UIStroke", {
                Parent = OptionButton.Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  OptionStroke:AddToTheme({Color = "Border"})
            
            local OptionLiner = Instances:Create("Frame", {
                Parent = OptionButton.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  OptionLiner:AddToTheme({BackgroundColor3 = "Accent"})
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = Option,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  OptionText:AddToTheme({TextColor3 = "Text"})

            local OptionData = {
                Button = OptionButton,
                Selected = false,
                Name = Option,
                Text = OptionText,
                IsFirstOption = IsFirstOption,
                Liner = OptionLiner,
                Stroke = OptionStroke
            }

            function OptionData:Toggle(Status)
                if Status == "Active" then 
                    OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    OptionData.Text:Tween(nil, {TextTransparency = 0})
                    OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                    OptionData.Stroke:Tween(nil, {Transparency = 0})
                else
                    OptionData.Liner:Tween(nil, {BackgroundTransparency = 1})
                    OptionData.Text:Tween(nil, {TextTransparency = 0.4})
                    OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                    OptionData.Stroke:Tween(nil, {Transparency = 1})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Data.Multi then 
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then 
                        Dropdown.Value = OptionData.Name
                        Library.Flags[Dropdown.Flag] = OptionData.Name

                        OptionData.Selected = true
                        OptionData:Toggle("Active")

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then
                                Value.Selected = false 
                                Value:Toggle("Inactive")
                            end
                        end

                        Items["Value"].Instance.Text = OptionData.Name
                    else
                        Dropdown.Value = nil
                        Library.Flags[Dropdown.Flag] = nil

                        OptionData.Selected = false
                        OptionData:Toggle("Inactive")

                        Items["Value"].Instance.Text = "-"
                    end
                end

                if Dropdown.Callback then
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionData.Button:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[OptionData.Name] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            local OptionData = Dropdown.Options[Option]
            if OptionData then
                OptionData.Button:Clean()
                Dropdown.Options[Option] = nil
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["RealDropdown"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Dropdown.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                    return
                end

                Dropdown:SetOpen(false)
            end
        end)

        local SearchStepped 
        
        Items["Search"]:Connect("Focused", function()
            SearchStepped = RunService.RenderStepped:Connect(function()
                for Index, Value in Dropdown.Options do
                    if Items["Search"].Instance.Text ~= "" then
                        if StringFind(StringLower(Value.Name), Library:EscapePattern(StringLower(Items["Search"].Instance.Text))) then
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    else
                        Value.Button.Instance.Visible = true
                    end
                end
            end)
        end)

        Items["Search"]:Connect("FocusLost", function()
            if SearchStepped then
                SearchStepped:Disconnect()
                SearchStepped = nil
            end
        end)

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)
        end

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        else
            for Index, Value in Dropdown.Options do 
                if Value.IsFirstOption then
                    Dropdown:Set(Index)
                end
            end
        end

        return Dropdown 
    end

    Library.Sections.Label = function(self, Name)
        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Name or "Label"
        }

        local Items = { } do
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 15),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["SubElements"] = Instances:Create("Frame", {
                Parent = Items["Label"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                Size = UDim2New(0, 0, 1, 0),
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["SubElements"].Instance,
                Name = "\0",
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })                
        end

        function Label:SetText(Text)
            Text = tostring(Text)
            Items["Text"].Instance.Text = Text
        end

        function Label:SetVisibility(Bool)
            Items["Label"].Instance.Visible = Bool
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = Label.Window,
                Page = Label.Page,
                Section = Label.Section,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Alpha = Data.Alpha or Data.alpha or 0,
                Callback = Data.Callback or Data.callback or function() end
            }

            local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                Parent = Items["SubElements"],
                Page = Colorpicker.Page,
                Flag = Colorpicker.Flag,
                Section = Colorpicker.Section,
                Default = Colorpicker.Default,
                Alpha = Colorpicker.Alpha,
                Callback = Colorpicker.Callback,
            })

            return NewColorpicker
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = Label.Window,
                Page = Label.Page,
                Section = Label.Section,

                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                Callback = Data.Callback or Data.callback or function() end,
                Mode = Data.Mode or Data.mode or "Toggle"
            }

            local NewKeybind, Items = Library:CreateKeybind({
                Name = Keybind.Name,
                Parent = Items["SubElements"],
                Flag = Keybind.Flag,
                Section = Keybind.Section,
                Default = Keybind.Default,
                Mode = Keybind.Mode,
                Callback = Keybind.Callback
            })

            return NewKeybind
        end

        return Label 
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Finished = Data.Finished or Data.finished or false,
            Numeric = Data.Numeric or Data.numeric or false,

            Value = ""
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Items["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["Input"] = Instances:Create("TextBox", {
                Parent = Items["Textbox"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                CursorPosition = -1,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Size = UDim2New(0.6000000238418579, 0, 1, 0),
                BorderSizePixel = 0,
                PlaceholderColor3 = FromRGB(185, 185, 185),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Input"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Input"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 6)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Items["Input"]:OnHover(function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)

            Items["Input"]:OnHoverLeave(function()
                Items["Input"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            if Textbox.Numeric then
                if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                    Value = Textbox.Value
                end
            end

            Textbox.Value = Value
            Items["Input"].Instance.Text = Value
            Library.Flags[Textbox.Flag] = Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end
        
        if Textbox.Finished then 
            Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                if PressedEnterQuestionMark then
                    Textbox:Set(Items["Input"].Instance.Text)
                end
            end)
        else
            Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                Textbox:Set(Items["Input"].Instance.Text)
            end)
        end

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end

Library.CreateSettingsPage = function(self, Window, KeybindList, Watermark, ModeratorList)
    local SettingsPage = Window:Page({Name = "Settings", Columns = 2})
    local SettingsSection = SettingsPage:Section({Name = "Settings", Side = 1}) do
        SettingsSection:Button({
            Name = "Unload",
            Callback = function()
                Library:Unload()
            end
        })

        SettingsSection:Toggle({
            Name = "Watermark",
            Flag = "Watermark",
            Default = true,
            Callback = function(Value)
                Watermark:SetVisibility(Value)
            end
        })

        SettingsSection:Toggle({
            Name = "Keybind List",
            Flag = "Keybind list",
            Default = true,
            Callback = function(Value)
                KeybindList:SetVisibility(Value)
            end
        })

        SettingsSection:Toggle({
            Name = "Moderator List",
            Flag = "Moderator list",
            Default = true,
            Callback = function(Value)
                if ModeratorList then
                    ModeratorList:SetVisibility(Value)
                end
            end
        })

        SettingsSection:Toggle({
            Name = "Target HUD",
            Flag = "TargetHudEnabled",
            Default = true,
            Callback = function(Value)
                local Hud = Library.TargetHudInstance
                if Hud and Hud.SetVisibility then
                    Hud:SetVisibility(Value)
                end
            end
        })

        SettingsSection:Label("Menu Keybind"):Keybind({
            Name = "Menu Keybind",
            Flag = "MenuKeybind",
            Default = Library.MenuKeybind,
            Mode = "Toggle",
            Callback = function()
                Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
            end
        })

        SettingsSection:Slider({
            Name = "Tween Speed",
            Default = 0.2,
            Flag = "Tween Speed",
            Decimals = 0.01,
            Suffix = "s",
            Max = 10,
            Min = 0,
            Callback = function(Value)
                Library.Tween.Time = Value
            end
        })

        SettingsSection:Dropdown({
            Name = "Tween Style",
            Flag = "Tween style",
            MaxSize = 200,
            Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
            Default = "Quint",
            Callback = function(Value)
                if not Value then Value = "Quint" end
                Library.Tween.Style = Enum.EasingStyle[Value]
            end
        })

        SettingsSection:Dropdown({
            Name = "Tween Direction",
            Flag = "Tween direction",
            Items = { "In", "Out", "InOut" },
            Default = "Out",
            Callback = function(Value)
                if not Value then Value = "Out" end
                Library.Tween.Direction = Enum.EasingDirection[Value]
            end
        })
    end
        
        local ConfigsSection = SettingsPage:Section({Name = "Configs", Side = 2}) do
            local ConfigName 
            local ConfigSelected
            
            local ConfigsSearchbox = ConfigsSection:Dropdown({
                Name = "Profiles list",
                Flag = "Profiles list",
                Multi = false,
                Items = { },
                Callback = function(Value)
                    ConfigSelected = Value
                end
            })

            ConfigsSection:Textbox({
                Name = "Config name", 
                Default = "", 
                Flag = "ConfigName", 
                Placeholder = "...", 
                Callback = function(Value)
                    ConfigName = Value
                end
            })

            ConfigsSection:Button({
                Name = "Create",
                Callback = function()
                    if ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsSearchbox)
                            Library:Notification("Created config " .. ConfigName .. ".json", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Delete",
                Callback = function()
                    if ConfigSelected ~= nil then
                        delfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
                        Library:RefreshConfigsList(ConfigsSearchbox)
                        Library:Notification("Deleted config " .. ConfigSelected .. ".json", 5, FromRGB(255, 0, 0))
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Load",
                Callback = function()
                    if ConfigSelected ~= nil then
                        local Success, Result = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"))
                        if Success then
                            Library:Notification("Loaded config " .. ConfigSelected .. ".json", 5)
                        else
                            Library:Notification("Failed to load config " .. ConfigSelected .. ".json", 5)
                        end
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Save",
                Callback = function()
                    if ConfigSelected ~= nil then
                        writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
                        Library:Notification("Saved config " .. ConfigSelected .. ".json", 5)
                    end
                end
            })

            ConfigsSection:Button({
                Name = "Refresh",
                Callback = function()
                    Library:RefreshConfigsList(ConfigsSearchbox)
                end
            })

            Library:RefreshConfigsList(ConfigsSearchbox)
        end

        local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2}) do
            for Index, Value in Library.Theme do 
                ThemingSection:Label(Index):Colorpicker({
                    Flag = Index,
                    Default = Value,
                    Callback = function(Value)
                        Library.Theme[Index] = Value
                        Library:ChangeTheme(Index, Value)
                    end
                })
            end
        end
    end
end

Library.TargetHud = function(self)
    local TargetHud = {}
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local flags = Library.Flags

    local thumbnailCache = {}
    local renderConn = nil

    local function getInstance(Object)
        return Object and (Object.Instance or Object)
    end

    local function safeAddToTheme(Object, ThemeTable)
        if Object and Object.AddToTheme then
            Object:AddToTheme(ThemeTable)
        end
    end

    local function safeClean(Object)
        if Object and Object.Clean then
            Object:Clean()
        elseif Object and Object.Instance then
            Object.Instance:Destroy()
        end
    end

    local function isEnabled()
        if flags and flags.TargetHudEnabled ~= nil then
            return flags.TargetHudEnabled
        end
        return true
    end

    local Items = {}

    Items["TargetHud"] = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "__TargetHud",
        AnchorPoint = Vector2New(0.5, 0.5),
        Position = UDim2New(0.5, 0, 0.75, 0),
        Size = UDim2New(0, 360, 0, 145),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(18, 18, 22),
        Visible = true
    })
    safeAddToTheme(Items["TargetHud"], {BackgroundColor3 = "Background 2"})

    local Frame = getInstance(Items["TargetHud"])

    Instances:Create("UICorner", {
        Parent = Frame,
        CornerRadius = UDim.new(0, 4)
    })

    Instances:Create("UIStroke", {
        Parent = Frame,
        Color = FromRGB(125, 190, 255),
        Thickness = 1.2,
        Transparency = 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    Items["Title"] = Instances:Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 10, 0, 4),
        Size = UDim2New(1, -20, 0, 20),
        FontFace = Library.Font,
        Text = "Target Hud",
        TextSize = 14,
        TextColor3 = FromRGB(240, 240, 240),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    safeAddToTheme(Items["Title"], {TextColor3 = "Text"})

    Items["TopLine"] = Instances:Create("Frame", {
        Parent = Frame,
        Position = UDim2New(0, 8, 0, 28),
        Size = UDim2New(1, -16, 0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(125, 190, 255)
    })

    Items["Inner"] = Instances:Create("Frame", {
        Parent = Frame,
        Position = UDim2New(0, 8, 0, 34),
        Size = UDim2New(1, -16, 1, -42),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(10, 10, 14)
    })
    local Inner = getInstance(Items["Inner"])

    Instances:Create("UIStroke", {
        Parent = Inner,
        Color = FromRGB(70, 80, 100),
        Thickness = 1,
        Transparency = 0.45
    })

    Items["Avatar"] = Instances:Create("ImageLabel", {
        Parent = Inner,
        Position = UDim2New(0, 12, 0, 10),
        Size = UDim2New(0, 70, 0, 70),
        BackgroundColor3 = FromRGB(230, 230, 230),
        BorderSizePixel = 0,
        Image = ""
    })
    local Avatar = getInstance(Items["Avatar"])

    Items["NameLabel"] = Instances:Create("TextLabel", {
        Parent = Inner,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 90, 0, 10),
        Size = UDim2New(1, -100, 0, 20),
        FontFace = Library.Font,
        Text = "No target",
        TextSize = 14,
        TextColor3 = FromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    safeAddToTheme(Items["NameLabel"], {TextColor3 = "Text"})
    local NameLabel = getInstance(Items["NameLabel"])

    Items["DistanceLabel"] = Instances:Create("TextLabel", {
        Parent = Inner,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 90, 0, 32),
        Size = UDim2New(1, -100, 0, 16),
        FontFace = Library.Font,
        Text = "Distance: N/A",
        TextSize = 12,
        TextColor3 = FromRGB(200, 200, 200),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    safeAddToTheme(Items["DistanceLabel"], {TextColor3 = "Text"})
    local DistanceLabel = getInstance(Items["DistanceLabel"])

    Items["VisibleLabel"] = Instances:Create("TextLabel", {
        Parent = Inner,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 90, 0, 48),
        Size = UDim2New(1, -100, 0, 16),
        FontFace = Library.Font,
        Text = "Visible: false",
        TextSize = 12,
        TextColor3 = FromRGB(180, 180, 180),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    safeAddToTheme(Items["VisibleLabel"], {TextColor3 = "Text"})
    local VisibleLabel = getInstance(Items["VisibleLabel"])

    Items["AccountAgeLabel"] = Instances:Create("TextLabel", {
        Parent = Inner,
        BackgroundTransparency = 1,
        Position = UDim2New(0, 90, 0, 64),
        Size = UDim2New(1, -100, 0, 16),
        FontFace = Library.Font,
        Text = "Account Age: N/A",
        TextSize = 12,
        TextColor3 = FromRGB(180, 180, 180),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    safeAddToTheme(Items["AccountAgeLabel"], {TextColor3 = "Text"})
    local AccountAgeLabel = getInstance(Items["AccountAgeLabel"])

    Items["HealthBarBg"] = Instances:Create("Frame", {
        Parent = Inner,
        Position = UDim2New(0, 90, 0, 88),
        Size = UDim2New(1, -140, 0, 10),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(30, 30, 35)
    })
    local HealthBarBg = getInstance(Items["HealthBarBg"])

    Instances:Create("UICorner", {
        Parent = HealthBarBg,
        CornerRadius = UDim.new(0, 2)
    })

    Items["HealthBar"] = Instances:Create("Frame", {
        Parent = HealthBarBg,
        Size = UDim2New(0, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(55, 220, 95)
    })
    local HealthBar = getInstance(Items["HealthBar"])

    Instances:Create("UICorner", {
        Parent = HealthBar,
        CornerRadius = UDim.new(0, 2)
    })

    Items["HealthValue"] = Instances:Create("TextLabel", {
        Parent = Inner,
        BackgroundTransparency = 1,
        Position = UDim2New(1, -45, 0, 84),
        Size = UDim2New(0, 40, 0, 18),
        FontFace = Library.Font,
        Text = "0/0",
        TextSize = 11,
        TextColor3 = FromRGB(230, 230, 230),
        TextXAlignment = Enum.TextXAlignment.Right
    })
    safeAddToTheme(Items["HealthValue"], {TextColor3 = "Text"})
    local HealthValue = getInstance(Items["HealthValue"])

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function updateDrag(input)
        if not dragStart or not startPos or not Frame then
            return
        end

        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateDrag(input)
        end
    end)

    local function setHealthColor(percent)
        if percent > 0.6 then
            HealthBar.BackgroundColor3 = FromRGB(55, 220, 95)
        elseif percent > 0.3 then
            HealthBar.BackgroundColor3 = FromRGB(255, 200, 90)
        else
            HealthBar.BackgroundColor3 = FromRGB(255, 90, 90)
        end
    end

    local function setEmpty()
        if not isEnabled() then
            Frame.Visible = false
            return
        end

        Frame.Visible = true
        Avatar.Image = ""
        NameLabel.Text = "No target"
        DistanceLabel.Text = "Distance: N/A"
        VisibleLabel.Text = "Visible: false"
        AccountAgeLabel.Text = "Account Age: N/A"
        HealthBar.Size = UDim2New(0, 0, 1, 0)
        HealthValue.Text = "0/0"
    end

    local function getTarget()
        local targeting = Library.Targeting
        local character = targeting and targeting.TargetCharacter

        if not character then
            return nil, nil, nil
        end

        if typeof(character) ~= "Instance" or not character:IsA("Model") then
            return nil, nil, nil
        end

        if character == LocalPlayer.Character then
            return nil, nil, nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not rootPart then
            return nil, nil, nil
        end

        if humanoid.Health <= 0 then
            return nil, nil, nil
        end

        local player = Players:GetPlayerFromCharacter(character)
        if not player then
            return nil, nil, nil
        end

        return player, humanoid, rootPart
    end

    local function setAvatarForPlayer(player)
        if not player then
            Avatar.Image = ""
            return
        end

        local cached = thumbnailCache[player.UserId]
        if cached then
            Avatar.Image = cached
            return
        end

        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)

        if ok and image then
            thumbnailCache[player.UserId] = image
            Avatar.Image = image
        else
            Avatar.Image = ""
        end
    end

    function TargetHud:SetVisibility(Bool)
        Bool = Bool and true or false
        if flags then
            flags.TargetHudEnabled = Bool
        end

        if Bool then
            setEmpty()
        else
            Frame.Visible = false
        end
    end

    function TargetHud:GetPosition()
        local p = Frame.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function TargetHud:SetPosition(Pos)
        if not Pos then
            return
        end

        Frame.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
    end

    function TargetHud:Destroy()
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end

        if Items["TargetHud"] then
            safeClean(Items["TargetHud"])
        end
    end

    if flags and flags.TargetHudEnabled == nil then
        flags.TargetHudEnabled = true
    end

    setEmpty()

    local debounceTime = 0.15
    local gracePeriod = 0.45
    local lastUpdateTime = 0
    local lastSeenTime = 0

    renderConn = RunService.RenderStepped:Connect(function()
        if not isEnabled() then
            Frame.Visible = false
            return
        end

        local now = tick()
        if now - lastUpdateTime < debounceTime then
            return
        end
        lastUpdateTime = now

        local ok, player, humanoid, rootPart = pcall(getTarget)

        if not ok or not player or not humanoid or not rootPart then
            lastSeenTime = lastSeenTime == 0 and now or lastSeenTime

            if now - lastSeenTime >= gracePeriod then
                setEmpty()
            end
            return
        end

        lastSeenTime = 0
        Frame.Visible = true

        setAvatarForPlayer(player)

        if player.DisplayName ~= player.Name then
            NameLabel.Text = string.format("%s (@%s)", player.DisplayName, player.Name)
        else
            NameLabel.Text = player.Name
        end

        local localCharacter = LocalPlayer.Character
        local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

        if localRoot and localRoot.Parent and rootPart and rootPart.Parent then
            local okDistance, distance = pcall(function()
                return (localRoot.Position - rootPart.Position).Magnitude
            end)

            if okDistance and distance then
                DistanceLabel.Text = string.format("Distance: %.0f", distance)
            else
                DistanceLabel.Text = "Distance: N/A"
            end
        else
            DistanceLabel.Text = "Distance: N/A"
        end

        VisibleLabel.Text = "Visible: true"

        if player and player.AccountAge then
            local totalDays = player.AccountAge
            local years = math.floor(totalDays / 365)
            local remainingDays = totalDays % 365
            local months = math.floor(remainingDays / 30)
            local days = remainingDays % 30

            AccountAgeLabel.Text = string.format(
                "Account Age: %dy %dm %dd",
                years,
                months,
                days
            )
        else
            AccountAgeLabel.Text = "Account Age: N/A"
        end

        local health = humanoid and humanoid.Health
        local maxHealth = humanoid and humanoid.MaxHealth

        if type(health) == "number" and type(maxHealth) == "number" and maxHealth > 0 then
            local percent = math.clamp(health / maxHealth, 0, 1)
            HealthBar.Size = UDim2New(percent, 0, 1, 0)
            HealthValue.Text = string.format("%d/%d", math.floor(health), math.floor(maxHealth))
            setHealthColor(percent)
        else
            HealthBar.Size = UDim2New(0, 0, 1, 0)
            HealthValue.Text = "0/0"
        end
    end)

    Library.TargetHudInstance = TargetHud
    return TargetHud
end

return Library

--[[NEVERWIN v1.8 -- FULL BUILD]]
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local RS=game:GetService("ReplicatedStorage")
local HttpService=game:GetService("HttpService")
local Camera=workspace.CurrentCamera
local LP=Players.LocalPlayer
local Parent=gethui and gethui() or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
if Parent:FindFirstChild("NeverwinUI") then Parent.NeverwinUI:Destroy() end
local hasDrawing=pcall(function() return Drawing.new end)
local hasMeta=pcall(function() return getrawmetatable end)
local hasHook=pcall(function() return hookmetamethod end)
local hasNamecall=pcall(function() return getnamecallmethod end)
local hasCheck=pcall(function() return checkcaller end)
local RFT=Enum.RaycastFilterType
local FE=RFT.Exclude or RFT.Blacklist
local Conn={}
local Alive=true
local function AddC(c) table.insert(Conn,c); return c end
local function KillAll() Alive=false; for _,c in ipairs(Conn) do pcall(function() c:Disconnect() end) end; Conn={} end
local function IsCaller() if hasCheck then local ok,r=pcall(checkcaller); return ok and r end return true end
local function SD(c) if not hasDrawing then return nil end local ok,o=pcall(function() return Drawing.new(c) end) return ok and o or nil end
local function SR(o) if o then pcall(function() o:Remove() end) end end
local function Ping() local ok,p=pcall(function() return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end) return ok and p or 0 end
local Cfg={
    Rage={Enabled=false,SilentAim=false,AutoFire=false,Wallbang=false,FOV=120,HitChance=100,Prediction=0.165,HitPart="Head",AutoDiscover=true,UsePing=true,VisibleCheck=false,Lock=true,LockTimeout=0.3,_lockTarget=nil,_lockTime=0,_remote=nil},
    ESP={Enabled=false,TeamCheck=true,MaxDistance=500,Name=true,NameColor=Color3.fromRGB(255,255,255),Health=true,HealthText=true,Distance=true,Weapon=true,Skeleton=true,SkeletonColor=Color3.fromRGB(255,255,255),Flags={Enabled=true,Money=true,Kit=true,HK=true,Armor=true}},
    Chams={Enabled=false,Color=Color3.fromRGB(100,255,100),Transparency=0.4,TeamCheck=true},
    Skins={Enabled=false,Current="Default",AutoApply=true},
    Move={BHop=false,BHopMode="Always",Strafe=false,StrafeSpeed=5},
    TP={Enabled=false,Distance=8,Height=2,Smoothness=10},
    AA={Enabled=false,Pitch=false,PitchMode="Down",Yaw=false,YawMode="Backwards",SpinSpeed=15},
    View={FOV=70,ApplyFOV=false,RemoveBlur=false},
    Inventory={FastDrop=false,AutoReload=false},
    Ind={Enabled=true},
    Sec={Enabled=true,Rotation=true,RotationInterval=8,SpoofDebug=true,BlockKick=true,FilterAC=true,_lastRot=0},
    Beh={Enabled=true,Miss=5,Jitter=1.5,Skip=3,MaxShots=12,AAJitter=4,AAInterval=0.02,_shots={}},
}
local function SkipShot() if not Cfg.Beh.Enabled then return false end if math.random(1,100)<=Cfg.Beh.Skip then return true end local now=os.clock() local f={} for _,t in ipairs(Cfg.Beh._shots) do if now-t<1 then table.insert(f,t) end end Cfg.Beh._shots=f if #f>=Cfg.Beh.MaxShots then return true end table.insert(f,now) return false end
local function Miss() return Cfg.Beh.Enabled and math.random(1,100)<=Cfg.Beh.Miss end
local function Jitter(p) if not Cfg.Beh.Enabled or Cfg.Beh.Jitter<=0 then return p end local j=math.rad(Cfg.Beh.Jitter) return p+Vector3.new((math.random()*2-1)*j,(math.random()*2-1)*j,(math.random()*2-1)*j)*4 end
if hasMeta then pcall(function() local mt=getrawmetatable(game) setreadonly(mt,false) local old=mt.__namecall mt.__namecall=newcclosure(function(self,...) local m=getnamecallmethod() if not IsCaller() and m=="Kick" and self==LP then return end if not IsCaller() and (m=="InvokeServer" or m=="FireServer") then local ok,n=pcall(function() return self.Name end) if ok and n and (n:find("AntiCheat") or n:find("Report") or n:find("Flag") or n:find("Verify")) then return end end return old(self,...) end) setreadonly(mt,true) end) end
local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="NeverwinUI"
ScreenGui.ResetOnSpawn=false
ScreenGui.DisplayOrder=10
ScreenGui.Parent=Parent
local Main=Instance.new("Frame")
Main.Size=UDim2.new(0,880,0,720)
Main.Position=UDim2.new(0.5,-440,0.5,-360)
Main.BackgroundColor3=Color3.fromRGB(10,15,22)
Main.BorderSizePixel=0
Main.ClipsDescendants=true
Main.Active=true
Main.Parent=ScreenGui
local MC=Instance.new("UICorner"); MC.CornerRadius=UDim.new(0,8); MC.Parent=Main
local MS=Instance.new("UIStroke"); MS.Color=Color3.fromRGB(22,32,48); MS.Parent=Main
local Accent=Instance.new("Frame"); Accent.Size=UDim2.new(1,0,0,2); Accent.BackgroundColor3=Color3.fromRGB(0,170,255); Accent.BorderSizePixel=0; Accent.Parent=Main
local AG=Instance.new("UIGradient"); AG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(0,100,200)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,200,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,0,255))}; AG.Parent=Accent
local drag,dStart,dPos
AddC(Main.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; dStart=i.Position; dPos=Main.Position end end))
AddC(Main.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end))
AddC(UIS.InputChanged:Connect(function(i) if not drag then return end if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end local d=i.Position-dStart Main.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end))
local Sidebar=Instance.new("Frame"); Sidebar.Size=UDim2.new(0,210,1,-2); Sidebar.Position=UDim2.new(0,0,0,2); Sidebar.BackgroundColor3=Color3.fromRGB(13,19,28); Sidebar.BorderSizePixel=0; Sidebar.Parent=Main
local Logo=Instance.new("TextLabel"); Logo.Size=UDim2.new(1,0,0,65); Logo.BackgroundTransparency=1; Logo.Text="NEVERWIN"; Logo.TextColor3=Color3.fromRGB(0,200,255); Logo.TextSize=24; Logo.Font=Enum.Font.GothamBold; Logo.Parent=Sidebar
local Menu=Instance.new("ScrollingFrame"); Menu.Size=UDim2.new(1,0,1,-140); Menu.Position=UDim2.new(0,0,0,65); Menu.BackgroundTransparency=1; Menu.BorderSizePixel=0; Menu.ScrollBarThickness=0; Menu.CanvasSize=UDim2.new(0,0,0,0); Menu.AutomaticCanvasSize=Enum.AutomaticSize.Y; Menu.Parent=Sidebar
local ML=Instance.new("UIListLayout"); ML.Padding=UDim.new(0,2); ML.Parent=Menu
local MP=Instance.new("UIPadding"); MP.PaddingLeft=UDim.new(0,10); MP.PaddingRight=UDim.new(0,10); MP.Parent=Menu
local Prof=Instance.new("Frame"); Prof.Size=UDim2.new(1,0,0,60); Prof.Position=UDim2.new(0,0,1,-60); Prof.BackgroundTransparency=1; Prof.Parent=Sidebar
local Av=Instance.new("ImageLabel"); Av.Size=UDim2.new(0,38,0,38); Av.Position=UDim2.new(0,14,0.5,-19); Av.BackgroundColor3=Color3.fromRGB(20,30,45); Av.BorderSizePixel=0; Av.Parent=Prof
local AvC=Instance.new("UICorner"); AvC.CornerRadius=UDim.new(1,0); AvC.Parent=Av
task.spawn(function() pcall(function() Av.Image=Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420) end) end)
local UN=Instance.new("TextLabel"); UN.Size=UDim2.new(1,-65,0,18); UN.Position=UDim2.new(0,60,0,12); UN.BackgroundTransparency=1; UN.Text=LP.Name; UN.TextColor3=Color3.fromRGB(255,255,255); UN.TextSize=13; UN.Font=Enum.Font.GothamBold; UN.TextXAlignment=Enum.TextXAlignment.Left; UN.Parent=Prof
local US=Instance.new("TextLabel"); US.Size=UDim2.new(1,-65,0,16); US.Position=UDim2.new(0,60,0,30); US.BackgroundTransparency=1; US.Text="Premium"; US.TextColor3=Color3.fromRGB(0,200,100); US.TextSize=11; US.Font=Enum.Font.Gotham; US.TextXAlignment=Enum.TextXAlignment.Left; US.Parent=Prof
local Content=Instance.new("Frame"); Content.Size=UDim2.new(1,-210,1,-2); Content.Position=UDim2.new(0,210,0,2); Content.BackgroundColor3=Color3.fromRGB(8,12,19); Content.BorderSizePixel=0; Content.Parent=Main
local CScroll=Instance.new("ScrollingFrame"); CScroll.Size=UDim2.new(1,-24,1,-24); CScroll.Position=UDim2.new(0,12,0,12); CScroll.BackgroundTransparency=1; CScroll.BorderSizePixel=0; CScroll.ScrollBarThickness=3; CScroll.ScrollBarImageColor3=Color3.fromRGB(0,140,220); CScroll.CanvasSize=UDim2.new(0,0,0,0); CScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; CScroll.Parent=Content
local CL=Instance.new("UIListLayout"); CL.Padding=UDim.new(0,8); CL.Parent=CScroll
local CP=Instance.new("UIPadding"); CP.PaddingRight=UDim.new(0,8); CP.Parent=CScroll
local WM=Instance.new("Frame"); WM.Size=UDim2.new(0,340,0,26); WM.Position=UDim2.new(1,-350,0,10); WM.BackgroundColor3=Color3.fromRGB(10,15,22); WM.BackgroundTransparency=0.15; WM.BorderSizePixel=0; WM.Parent=ScreenGui
local WMC=Instance.new("UICorner"); WMC.CornerRadius=UDim.new(0,4); WMC.Parent=WM
local WMS=Instance.new("UIStroke"); WMS.Color=Color3.fromRGB(0,140,220); WMS.Transparency=0.5; WMS.Parent=WM
local WMT=Instance.new("TextLabel"); WMT.Size=UDim2.new(1,-10,1,0); WMT.Position=UDim2.new(0,8,0,0); WMT.BackgroundTransparency=1; WMT.TextColor3=Color3.fromRGB(220,225,235); WMT.Font=Enum.Font.GothamMedium; WMT.TextSize=11; WMT.TextXAlignment=Enum.TextXAlignment.Left; WMT.Parent=WM
local WT=0
AddC(RunService.RenderStepped:Connect(function() if not Alive then return end if os.clock()-WT<0.5 then return end WT=os.clock() WMT.Text=string.format("neverwin v1.8 | %s | %dms | %s",LP.Name,Ping(),os.date("%H:%M:%S")) end))
local IGu=Instance.new("Frame"); IGu.Size=UDim2.new(0,150,0,200); IGu.Position=UDim2.new(0,20,0.5,-100); IGu.BackgroundTransparency=1; IGu.Parent=ScreenGui
local IGL=Instance.new("UIListLayout"); IGL.Padding=UDim.new(0,4); IGL.Parent=IGu
local IF={}
local function MkInd(n,c) local f=Instance.new("Frame"); f.Size=UDim2.new(0,130,0,22); f.BackgroundColor3=Color3.fromRGB(10,15,22); f.BackgroundTransparency=0.2; f.BorderSizePixel=0; f.Visible=false; f.Parent=IGu; local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(0,4); fc.Parent=f; local fs=Instance.new("UIStroke"); fs.Color=c; fs.Transparency=0.4; fs.Parent=f; local b=Instance.new("Frame"); b.Size=UDim2.new(0,3,1,0); b.BackgroundColor3=c; b.BorderSizePixel=0; b.Parent=f; local t=Instance.new("TextLabel"); t.Size=UDim2.new(1,-10,1,0); t.Position=UDim2.new(0,8,0,0); t.BackgroundTransparency=1; t.Text=n; t.TextColor3=c; t.Font=Enum.Font.GothamBold; t.TextSize=11; t.TextXAlignment=Enum.TextXAlignment.Left; t.Parent=f; IF[n]=f end
MkInd("RAGE",Color3.fromRGB(255,80,80))
MkInd("LEGIT",Color3.fromRGB(80,255,120))
MkInd("AA",Color3.fromRGB(80,180,255))
MkInd("BOMB",Color3.fromRGB(255,200,80))
AddC(RunService.Heartbeat:Connect(function() if not Alive then return end if not Cfg.Ind.Enabled then for _,f in pairs(IF) do f.Visible=false end return end IF["RAGE"].Visible=Cfg.Rage.Enabled IF["LEGIT"].Visible=false IF["AA"].Visible=Cfg.AA.Enabled IF["BOMB"].Visible=false end))
local FovC=SD("Circle")
if FovC then FovC.Visible=false FovC.Thickness=1 FovC.Color=Color3.fromRGB(0,170,255) FovC.Transparency=1 FovC.Filled=false end
AddC(RunService.RenderStepped:Connect(function() if not FovC then return end FovC.Visible=(Cfg.Rage.Enabled and Cfg.Rage.SilentAim) if FovC.Visible then local mp=UIS:GetMouseLocation() FovC.Position=Vector2.new(mp.X,mp.Y) FovC.Radius=Cfg.Rage.FOV end end))
local Tabs={}
local ActiveBtn,ActiveTxt=nil,nil
local Dropdowns,Sliders={},{}
local function ClearContent() for _,c in ipairs(CScroll:GetChildren()) do if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end end Dropdowns,Sliders={},{} end
local function Section(t) local s=Instance.new("TextLabel"); s.Size=UDim2.new(1,0,0,22); s.BackgroundTransparency=1; s.Text=string.upper(t); s.TextColor3=Color3.fromRGB(0,170,255); s.Font=Enum.Font.GothamBold; s.TextSize=11; s.TextXAlignment=Enum.TextXAlignment.Left; s.Parent=CScroll end
local function Toggle(text,def,cb) local st=def or false local h=Instance.new("Frame") h.Size=UDim2.new(1,0,0,34) h.BackgroundColor3=Color3.fromRGB(13,20,30) h.BorderSizePixel=0 h.Parent=CScroll local hc=Instance.new("UICorner") hc.CornerRadius=UDim.new(0,4) hc.Parent=h local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-60,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1 l.Text=text l.TextColor3=Color3.fromRGB(210,215,225) l.Font=Enum.Font.Gotham l.TextSize=13 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=h local btn=Instance.new("TextButton") btn.Size=UDim2.new(0,38,0,20) btn.Position=UDim2.new(1,-50,0.5,-10) btn.BackgroundColor3=st and Color3.fromRGB(0,170,255) or Color3.fromRGB(30,42,58) btn.Text="" btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=h local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(1,0) bc.Parent=btn local ci=Instance.new("Frame") ci.Size=UDim2.new(0,16,0,16) ci.Position=st and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8) ci.BackgroundColor3=Color3.fromRGB(255,255,255) ci.BorderSizePixel=0 ci.Parent=btn local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(1,0) cc.Parent=ci btn.MouseButton1Click:Connect(function() st=not st local ti=TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out) TweenService:Create(btn,ti,{BackgroundColor3=st and Color3.fromRGB(0,170,255) or Color3.fromRGB(30,42,58)}):Play() TweenService:Create(ci,ti,{Position=st and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play() if cb then cb(st) end end) end
local function Slider(text,mn,mx,def,cb) local v=def or mn local h=Instance.new("Frame") h.Size=UDim2.new(1,0,0,44) h.BackgroundColor3=Color3.fromRGB(13,20,30) h.BorderSizePixel=0 h.Parent=CScroll local hc=Instance.new("UICorner") hc.CornerRadius=UDim.new(0,4) hc.Parent=h local l=Instance.new("TextLabel") l.Size=UDim2.new(0.6,0,0,20) l.Position=UDim2.new(0,12,0,3) l.BackgroundTransparency=1 l.Text=text l.TextColor3=Color3.fromRGB(210,215,225) l.Font=Enum.Font.Gotham l.TextSize=13 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=h local vl=Instance.new("TextLabel") vl.Size=UDim2.new(0.3,0,0,20) vl.Position=UDim2.new(0.7,-12,0,3) vl.BackgroundTransparency=1 vl.Text=tostring(v) vl.TextColor3=Color3.fromRGB(0,170,255) vl.Font=Enum.Font.GothamBold vl.TextSize=12 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=h local bar=Instance.new("Frame") bar.Size=UDim2.new(1,-24,0,4) bar.Position=UDim2.new(0,12,0,30) bar.BackgroundColor3=Color3.fromRGB(30,42,58) bar.BorderSizePixel=0 bar.Parent=h local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(1,0) bc.Parent=bar local fill=Instance.new("Frame") fill.Size=UDim2.new((v-mn)/(mx-mn),0,1,0) fill.BackgroundColor3=Color3.fromRGB(0,170,255) fill.BorderSizePixel=0 fill.Parent=bar local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(1,0) fc.Parent=fill local knob=Instance.new("Frame") knob.Size=UDim2.new(0,10,0,10) knob.Position=UDim2.new((v-mn)/(mx-mn),-5,0.5,-5) knob.BackgroundColor3=Color3.fromRGB(255,255,255) knob.BorderSizePixel=0 knob.Parent=bar local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=knob table.insert(Sliders,{bar=bar,fill=fill,knob=knob,label=vl,mn=mn,mx=mx,value=v,cb=cb}) end
AddC(UIS.InputChanged:Connect(function(i) if i.UserInputType~=Enum.UserInputType.MouseMovement then return end if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end for _,s in ipairs(Sliders) do if s.bar and s.bar.Parent then local mp=UIS:GetMouseLocation() local bp=s.bar.AbsolutePosition local bs=s.bar.AbsoluteSize if mp.X>=bp.X-10 and mp.X<=bp.X+bs.X+10 and mp.Y>=bp.Y-8 and mp.Y<=bp.Y+bs.Y+8 then local p=math.clamp((mp.X-bp.X)/bs.X,0,1) local nv=math.floor(s.mn+(s.mx-s.mn)*p) s.value=nv s.fill.Size=UDim2.new(p,0,1,0) s.knob.Position=UDim2.new(p,-5,0.5,-5) s.label.Text=tostring(nv) if s.cb then s.cb(nv) end break end end end end))
local function Dropdown(text,opts,def,cb) local sel=def or opts[1] local h=Instance.new("Frame") h.Size=UDim2.new(1,0,0,36) h.BackgroundColor3=Color3.fromRGB(13,20,30) h.BorderSizePixel=0 h.ClipsDescendants=false h.Parent=CScroll local hc=Instance.new("UICorner") hc.CornerRadius=UDim.new(0,4) hc.Parent=h local l=Instance.new("TextLabel") l.Size=UDim2.new(0.5,0,1,0) l.Position=UDim2.new(0,12,0,0) l.BackgroundTransparency=1 l.Text=text l.TextColor3=Color3.fromRGB(210,215,225) l.Font=Enum.Font.Gotham l.TextSize=13 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=h local btn=Instance.new("TextButton") btn.Size=UDim2.new(0.4,0,0,26) btn.Position=UDim2.new(0.6,-12,0.5,-13) btn.BackgroundColor3=Color3.fromRGB(20,30,45) btn.Text=sel btn.TextColor3=Color3.fromRGB(210,215,225) btn.Font=Enum.Font.Gotham btn.TextSize=12 btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=h local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(0,4) bc.Parent=btn local list=Instance.new("Frame") list.Size=UDim2.new(0.4,0,0,#opts*26) list.Position=UDim2.new(0.6,-12,1,2) list.BackgroundColor3=Color3.fromRGB(15,22,33) list.BorderSizePixel=0 list.Visible=false list.ZIndex=10 list.Parent=h local lc=Instance.new("UICorner") lc.CornerRadius=UDim.new(0,4) lc.Parent=list local ll=Instance.new("UIListLayout") ll.Parent=list local data={list=list,open=false} table.insert(Dropdowns,data) for _,o in ipairs(opts) do local ob=Instance.new("TextButton") ob.Size=UDim2.new(1,0,0,26) ob.BackgroundColor3=Color3.fromRGB(15,22,33) ob.Text=o ob.TextColor3=Color3.fromRGB(200,205,215) ob.Font=Enum.Font.Gotham ob.TextSize=12 ob.BorderSizePixel=0 ob.AutoButtonColor=false ob.ZIndex=11 ob.Parent=list ob.MouseButton1Click:Connect(function() sel=o btn.Text=o list.Visible=false data.open=false if cb then cb(o) end end) end btn.MouseButton1Click:Connect(function() for _,d in ipairs(Dropdowns) do if d~=data then d.list.Visible=false d.open=false end end data.open=not data.open list.Visible=data.open end) end
local function Button(text,cb) local b=Instance.new("TextButton") b.Size=UDim2.new(1,0,0,32) b.BackgroundColor3=Color3.fromRGB(13,20,30) b.Text=text b.TextColor3=Color3.fromRGB(210,215,225) b.Font=Enum.Font.GothamBold b.TextSize=12 b.BorderSizePixel=0 b.AutoButtonColor=false b.Parent=CScroll local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(0,4) bc.Parent=b b.MouseButton1Click:Connect(function() if cb then cb() end end) end
local function GetWeapon(p) if not p.Character then return nil end for _,t in ipairs(p.Character:GetChildren()) do if t:IsA("Tool") then return t.Name end end end
local function IsValid(p) if p==LP then return false end if Cfg.ESP.TeamCheck and p.Team==LP.Team then return false end if not p.Character then return false end local h=p.Character:FindFirstChildOfClass("Humanoid") return h and h.Health>0 end
local ESPCache={}
local SkelBones={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local function GetFlags(p)
    local out={}
    if not p.Character then return out end
    if Cfg.ESP.Flags.Money then local m local ls=p:FindFirstChild("leaderstats") if ls then for _,v in ipairs(ls:GetChildren()) do if v.Name:lower():find("money") or v.Name:lower():find("cash") then m=v.Value break end end end if not m then m=p:GetAttribute("Money") end if m then table.insert(out,{text="$"..tostring(m),color=Color3.fromRGB(80,220,80)}) end end
    if Cfg.ESP.Flags.Kit then local h=p:GetAttribute("HasKit") if not h then for _,t in ipairs(p.Character:GetChildren()) do if t:IsA("Tool") and t.Name:lower():find("kit") then h=true break end end end if h then table.insert(out,{text="KIT",color=Color3.fromRGB(255,170,60)}) end end
    if Cfg.ESP.Flags.HK then local h=p:GetAttribute("HK") if h then table.insert(out,{text="HK",color=Color3.fromRGB(80,160,255)}) end end
    if Cfg.ESP.Flags.Armor then local a=p:GetAttribute("Armor") if a and a>0 then table.insert(out,{text=a>=100 and "AP" or "K",color=Color3.fromRGB(150,200,255)}) end end
    return out
end
local function CreateESP(p)
    if p==LP or ESPCache[p] then return end
    local c={}
    c.Name=SD("Text") if c.Name then c.Name.Size=13 c.Name.Center=true c.Name.Outline=true c.Name.Visible=false end
    c.HB=SD("Line") c.HBg=SD("Line")
    if c.HB then c.HB.Thickness=2 c.HB.Visible=false end
    if c.HBg then c.HBg.Thickness=4 c.HBg.Color=Color3.new(0,0,0) c.HBg.Visible=false end
    c.HT=SD("Text") if c.HT then c.HT.Size=12 c.HT.Outline=true c.HT.Visible=false end
    c.D=SD("Text") if c.D then c.D.Size=12 c.D.Center=true c.D.Outline=true c.D.Visible=false end
    c.W=SD("Text") if c.W then c.W.Size=12 c.W.Center=true c.W.Outline=true c.W.Visible=false end
    c.Flags={}
    for i=1,6 do local t=SD("Text") if t then t.Size=12 t.Outline=true t.Visible=false table.insert(c.Flags,t) end end
    c.R=SD("Line") if c.R then c.R.Thickness=2 c.R.Visible=false end
    c.S={}
    for i=1,14 do local l=SD("Line") if l then l.Thickness=1 l.Color=Color3.fromRGB(255,255,255) l.Visible=false table.insert(c.S,l) end end
    ESPCache[p]=c
end
local function RemoveESP(p) local c=ESPCache[p] if not c then return end SR(c.Name) SR(c.HB) SR(c.HBg) SR(c.HT) SR(c.D) SR(c.W) SR(c.R) for _,f in ipairs(c.Flags) do SR(f) end for _,l in ipairs(c.S) do SR(l) end ESPCache[p]=nil end
local ET=0
AddC(RunService.RenderStepped:Connect(function()
    if not Alive or not hasDrawing then return end
    if not Cfg.ESP.Enabled then for _,c in pairs(ESPCache) do if c.Name then c.Name.Visible=false end if c.HB then c.HB.Visible=false end if c.HBg then c.HBg.Visible=false end if c.HT then c.HT.Visible=false end if c.D then c.D.Visible=false end if c.W then c.W.Visible=false end if c.R then c.R.Visible=false end for _,f in ipairs(c.Flags) do f.Visible=false end for _,l in ipairs(c.S) do l.Visible=false end end return end
    local upd=false if os.clock()-ET>0.1 then ET=os.clock() upd=true end
    for _,p in ipairs(Players:GetPlayers()) do
        if not IsValid(p) then if ESPCache[p] then RemoveESP(p) end continue end
        local hum=p.Character:FindFirstChildOfClass("Humanoid")
        local root=p.Character:FindFirstChild("HumanoidRootPart")
        local head=p.Character:FindFirstChild("Head")
        if not hum or not root or not head then continue end
        if hum.Health<=0 then continue end
        local d=(root.Position-Camera.CFrame.Position).Magnitude
        if d>Cfg.ESP.MaxDistance then continue end
        if not ESPCache[p] then CreateESP(p) end
        local c=ESPCache[p] if not c then continue end
        local tp,o1=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))
        local bp,o2=Camera:WorldToViewportPoint(root.Position-Vector3.new(0,3,0))
        if not (o1 and o2) then if c.Name then c.Name.Visible=false end if c.HB then c.HB.Visible=false end if c.HBg then c.HBg.Visible=false end if c.HT then c.HT.Visible=false end if c.D then c.D.Visible=false end if c.W then c.W.Visible=false end if c.R then c.R.Visible=false end for _,f in ipairs(c.Flags) do f.Visible=false end for _,l in ipairs(c.S) do l.Visible=false end continue end
        local h=math.abs(bp.Y-tp.Y) local cx=(tp.X+bp.X)/2 local barX=cx-h*0.25-6 local hpPct=math.clamp(hum.Health/hum.MaxHealth,0,1)
        if c.Name then c.Name.Text=p.Name c.Name.Position=Vector2.new(cx,tp.Y-16) c.Name.Color=Cfg.ESP.NameColor c.Name.Visible=Cfg.ESP.Name end
        if c.HB and c.HBg then c.HBg.From=Vector2.new(barX,tp.Y) c.HBg.To=Vector2.new(barX,bp.Y) c.HBg.Visible=Cfg.ESP.Health c.HB.From=Vector2.new(barX,bp.Y-h*hpPct) c.HB.To=Vector2.new(barX,bp.Y) local col if hpPct>0.66 then col=Color3.fromRGB(80,220,80) elseif hpPct>0.33 then col=Color3.fromRGB(230,200,60) else col=Color3.fromRGB(230,60,60) end c.HB.Color=col c.HB.Visible=Cfg.ESP.Health end
        if c.HT then if upd then c.HT.Text=tostring(math.floor(hum.Health)) end c.HT.Position=Vector2.new(barX-20,bp.Y-h*hpPct-6) c.HT.Color=Color3.fromRGB(255,255,255) c.HT.Visible=Cfg.ESP.HealthText end
        if c.R then c.R.From=Vector2.new(barX-2,bp.Y+2) c.R.To=Vector2.new(barX+22,bp.Y+2) c.R.Color=Color3.fromHSV(os.clock()*0.3%1,0.85,1) c.R.Visible=Cfg.ESP.Health end
        if c.D then if upd then c.D.Text=string.format("<%dm>",math.floor(d)) end c.D.Position=Vector2.new(cx,bp.Y+6) c.D.Color=Color3.fromRGB(220,220,220) c.D.Visible=Cfg.ESP.Distance end
        if c.W then if upd then local w=GetWeapon(p) if w then c.W.Text=w c.W.Visible=Cfg.ESP.Weapon else c.W.Visible=false end end c.W.Position=Vector2.new(cx,bp.Y+22) c.W.Color=Color3.fromRGB(255,255,255) end
        if Cfg.ESP.Flags.Enabled then if upd then local flags=GetFlags(p) for i=1,#c.Flags do local f=c.Flags[i] local fd=flags[i] if fd then f.Text=fd.text f.Color=fd.color f.Position=Vector2.new(cx+h*0.3+8,tp.Y+(i-1)*14) f.Visible=true else f.Visible=false end end else for i,f in ipairs(c.Flags) do if f.Visible then f.Position=Vector2.new(cx+h*0.3+8,tp.Y+(i-1)*14) end end end else for _,f in ipairs(c.Flags) do f.Visible=false end end
        if Cfg.ESP.Skeleton then local idx=1 for _,bone in ipairs(SkelBones) do local p1=p.Character:FindFirstChild(bone[1]) local p2=p.Character:FindFirstChild(bone[2]) local l=c.S[idx] if p1 and p2 and l then local s1,oo1=Camera:WorldToViewportPoint(p1.Position) local s2,oo2=Camera:WorldToViewportPoint(p2.Position) if oo1 and oo2 then l.From=Vector2.new(s1.X,s1.Y) l.To=Vector2.new(s2.X,s2.Y) l.Color=Cfg.ESP.SkeletonColor l.Visible=true else l.Visible=false end elseif l then l.Visible=false end idx=idx+1 end else for _,l in ipairs(c.S) do l.Visible=false end end
    end
end))
AddC(Players.PlayerRemoving:Connect(RemoveESP))
local ChamsC={}
local function CreateChams(p) if p==LP or ChamsC[p] then return end if not p.Character then return end if Cfg.Chams.TeamCheck and p.Team==LP.Team then return end local hl=Instance.new("Highlight") hl.Name="NW_Chams" hl.FillColor=Cfg.Chams.Color hl.OutlineColor=Color3.fromRGB(255,255,255) hl.FillTransparency=Cfg.Chams.Transparency hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.Adornee=p.Character hl.Parent=p.Character ChamsC[p]=hl end
local function RemoveChams(p) if ChamsC[p] then ChamsC[p]:Destroy() ChamsC[p]=nil end end
local ChT=0
AddC(RunService.Heartbeat:Connect(function() if not Alive then return end if not Cfg.Chams.Enabled then for p in pairs(ChamsC) do RemoveChams(p) end return end if os.clock()-ChT<0.2 then return end ChT=os.clock() for _,p in ipairs(Players:GetPlayers()) do if p==LP then continue end if Cfg.Chams.TeamCheck and p.Team==LP.Team then if ChamsC[p] then RemoveChams(p) end continue end if not p.Character then if ChamsC[p] then RemoveChams(p) end continue end if not ChamsC[p] then CreateChams(p) else pcall(function() ChamsC[p].FillColor=Cfg.Chams.Color end) end end end))
AddC(Players.PlayerRemoving:Connect(RemoveChams))
local sDir,sFlip=1,0
AddC(RunService.RenderStepped:Connect(function() if not Alive then return end local ch=LP.Character if not ch then return end local hum=ch:FindFirstChildOfClass("Humanoid") local root=ch:FindFirstChild("HumanoidRootPart") if not hum or not root or hum.Health<=0 then return end if Cfg.Move.BHop then local st=hum:GetState() if st==Enum.HumanoidStateType.Running or st==Enum.HumanoidStateType.RunningNoPhysics or st==Enum.HumanoidStateType.Landed then if Cfg.Move.BHopMode=="Always" or (Cfg.Move.BHopMode=="OnJump" and UIS:IsKeyDown(Enum.KeyCode.Space)) then hum.Jump=true end end end if Cfg.Move.Strafe and hum:GetState()==Enum.HumanoidStateType.Freefall then if hum.MoveDirection.Magnitude>0.1 then if os.clock()-sFlip>0.1 then sDir=sDir*-1 sFlip=os.clock() end local v=root.Velocity local vh=Vector3.new(v.X,0,v.Z) local cr=Camera.CFrame.RightVector local crh=Vector3.new(cr.X,0,cr.Z).Unit local sv=crh*Cfg.Move.StrafeSpeed*sDir if vh.Magnitude<60 then root.Velocity=Vector3.new(v.X+sv.X*0.5,v.Y,v.Z+sv.Z*0.5) end end end end))
AddC(RunService:BindToRenderStep("NW_TP",Enum.RenderPriority.Camera.Value,function() if not Alive or not Cfg.TP.Enabled then return end local ch=LP.Character if not ch then return end local hum=ch:FindFirstChildOfClass("Humanoid") local root=ch:FindFirstChild("HumanoidRootPart") if not hum or not root or hum.Health<=0 then return end Camera.CameraType=Enum.CameraType.Custom Camera.CameraSubject=hum local lv=Camera.CFrame.LookVector local target=root.Position+Vector3.new(0,Cfg.TP.Height,0)-lv*Cfg.TP.Distance local pr=RaycastParams.new() pr.FilterDescendantsInstances={ch,Camera} pr.FilterType=FE local o=root.Position+Vector3.new(0,Cfg.TP.Height,0) local r=workspace:Raycast(o,target-o,pr) if r then target=r.Position+r.Normal*0.5 end local a=math.clamp(1/Cfg.TP.Smoothness,0.05,1) Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(target,target+lv),a) end))
local AA={Angle=CFrame.new(),Last=0,Phase=0}
local function InstallAA() if not hasMeta then return end pcall(function() local mt=getrawmetatable(game) local oldNI,oldI=mt.__newindex,mt.__index setreadonly(mt,false) mt.__newindex=newcclosure(function(self,key,value) if not IsCaller() and Cfg.AA.Enabled and typeof(self)=="Instance" and self.Name=="HumanoidRootPart" and self.Parent==LP.Character and key=="CFrame" then AA.Angle=value return end return oldNI(self,key,value) end) mt.__index=newcclosure(function(self,key) if not IsCaller() and Cfg.AA.Enabled and typeof(self)=="Instance" and self.Name=="HumanoidRootPart" and self.Parent==LP.Character and key=="CFrame" then return AA.Angle end return oldI(self,key) end) setreadonly(mt,true) end) end
InstallAA()
AddC(RunService.Heartbeat:Connect(function() if not Alive or not Cfg.AA.Enabled then return end local ch=LP.Character if not ch then return end local hum=ch:FindFirstChildOfClass("Humanoid") if hum and hum.AutoRotate then hum.AutoRotate=false end local now=os.clock() if now-AA.Last<0.02 then return end AA.Last=now local root=ch:FindFirstChild("HumanoidRootPart") if not root or not hum or hum.Health<=0 then return end local pitch,yaw=0,0 if Cfg.AA.Pitch then if Cfg.AA.PitchMode=="Down" then pitch=math.rad(89) elseif Cfg.AA.PitchMode=="Up" then pitch=-math.rad(89) end end if Cfg.AA.Yaw then if Cfg.AA.YawMode=="Backwards" then yaw=math.rad(180) elseif Cfg.AA.YawMode=="Spin" then AA.Phase=AA.Phase+Cfg.AA.SpinSpeed*0.02 yaw=AA.Phase elseif Cfg.AA.YawMode=="Jitter" then yaw=math.rad(math.random(-180,180)) end end local tgt=CFrame.new(root.Position)*CFrame.Angles(pitch,yaw,0) AA.Angle=AA.Angle:Lerp(tgt,0.4) end))
local function Discover() if Cfg.Rage._remote and Cfg.Rage._remote.Parent then return Cfg.Rage._remote end for _,obj in ipairs(RS:GetDescendants()) do if obj:IsA("RemoteEvent") then local n=obj.Name:lower() if n=="mainremoteevent" or n=="mainremote" then Cfg.Rage._remote=obj return obj end end end end
task.spawn(function() for i=1,10 do if Discover() then print("[NW] Remote:",Cfg.Rage._remote:GetFullName()) break end task.wait(1) end end)
local SA={Target=nil,Last=0}
local function PredPos(part) if not part then return nil end local vel=part.Velocity vel=Vector3.new(vel.X,math.clamp(vel.Y,-50,50),vel.Z) local p=Cfg.Rage.Prediction if Cfg.Rage.UsePing then p=p+Ping()/1000*0.5 end return part.Position+vel*p end
local function Vis(tp) if not Cfg.Rage.VisibleCheck then return true end if not tp or not LP.Character then return false end local pr=RaycastParams.new() pr.FilterType=FE pr.FilterDescendantsInstances={LP.Character,Camera} local r=workspace:Raycast(Camera.CFrame.Position,tp.Position-Camera.CFrame.Position,pr) if not r then return true end return r.Instance:IsDescendantOf(tp.Parent) or r.Instance==tp end
local HB={"Head","UpperTorso","HumanoidRootPart","LowerTorso"}
local function GetHB(p) if not p.Character then return nil end for _,n in ipairs(HB) do local x=p.Character:FindFirstChild(n) if x and Vis(x) then return x end end return p.Character:FindFirstChild("Head") end
local function FindSA() local mp=UIS:GetMouseLocation() local now=os.clock() if Cfg.Rage.Lock and Cfg.Rage._lockTarget then local lp=Cfg.Rage._lockTarget if IsValid(lp) and now-Cfg.Rage._lockTime<Cfg.Rage.LockTimeout then local part=GetHB(lp) if part then local pos=PredPos(part) if pos then local sp,on=Camera:WorldToViewportPoint(pos) if on then local d=(Vector2.new(sp.X,sp.Y)-Vector2.new(mp.X,mp.Y)).Magnitude if d<=Cfg.Rage.FOV*1.3 then Cfg.Rage._lockTime=now return {part=part,pos=pos,player=lp} end end end end end Cfg.Rage._lockTarget=nil end local best,bd=nil,math.huge for _,p in ipairs(Players:GetPlayers()) do if not IsValid(p) then continue end local part=GetHB(p) if not part then continue end local pos=PredPos(part) if not pos then continue end local sp,on=Camera:WorldToViewportPoint(pos) if not on then continue end local d=(Vector2.new(sp.X,sp.Y)-Vector2.new(mp.X,mp.Y)).Magnitude if d<bd and d<=Cfg.Rage.FOV then bd=d best=p end end if best then local part=GetHB(best) local pos=part and PredPos(part) if pos then Cfg.Rage._lockTarget=best Cfg.Rage._lockTime=now return {part=part,pos=pos,player=best} end end end
local function InstallSA()
    if not hasHook or not hasNamecall then return end
    pcall(function()
        local mt=getrawmetatable(game)
        setreadonly(mt,false)
        local prev=mt.__namecall
        mt.__namecall=newcclosure(function(self,...)
            local m=getnamecallmethod()
            if m~="FireServer" then return prev(self,...) end
            if not (Cfg.Rage.Enabled and Cfg.Rage.SilentAim and SA.Target) then return prev(self,...) end
            local isShot=false
            if Cfg.Rage._remote then isShot=(self==Cfg.Rage._remote) else local ok,c=pcall(function() return self.Name=="MainRemoteEvent" and self.Parent and self.Parent.Name=="MainRemotes" end) isShot=ok and c end
            if not isShot then return prev(self,...) end
            local args={...}
            if args[1]~="ShootGun" then return prev(self,...) end
            if SkipShot() then return prev(self,...) end
            if math.random(1,100)>Cfg.Rage.HitChance then return prev(self,...) end
            local tp=SA.Target.player.Character:FindFirstChild(Cfg.Rage.HitPart)
            if not tp then tp=GetHB(SA.Target.player) end
            if not tp then return prev(self,...) end
            local hp=PredPos(tp) or tp.Position
            if Cfg.Rage.VisibleCheck and not Vis(tp) then return prev(self,...) end
            if Miss() then local off=Vector3.new(math.random(-4,4),math.random(-2,6),math.random(-4,4)) return prev(self,args[1],args[2],args[3],hp+off,tp,Vector3.new(0,-1,0)) end
            hp=Jitter(hp)
            return prev(self,args[1],args[2],args[3],hp,tp,Vector3.new(0,-1,0))
        end)
        setreadonly(mt,true)
    end)
end
InstallSA()
AddC(RunService.RenderStepped:Connect(function() if not Alive then return end local now=os.clock() if now-SA.Last<0.03 then return end SA.Last=now SA.Target=(Cfg.Rage.Enabled and Cfg.Rage.SilentAim) and FindSA() or nil end))
AddC(RunService.RenderStepped:Connect(function() if not Alive then return end if Cfg.Rage.Enabled and Cfg.Rage.AutoFire and SA.Target then Camera.CFrame=CFrame.new(Camera.CFrame.Position,SA.Target.pos) end end))
local function Reg(n,f) Tabs[n]=f end
Reg("Ragebot",function()
    Section("Main")
    Toggle("Enabled",Cfg.Rage.Enabled,function(v) Cfg.Rage.Enabled=v end)
    Toggle("Silent Aim",Cfg.Rage.SilentAim,function(v) Cfg.Rage.SilentAim=v end)
    Toggle("Auto Fire",Cfg.Rage.AutoFire,function(v) Cfg.Rage.AutoFire=v end)
    Section("Target")
    Dropdown("Hit Part",{"Head","HumanoidRootPart","UpperTorso"},Cfg.Rage.HitPart,function(v) Cfg.Rage.HitPart=v end)
    Slider("FOV",0,500,Cfg.Rage.FOV,function(v) Cfg.Rage.FOV=v end)
    Slider("Hit Chance",0,100,Cfg.Rage.HitChance,function(v) Cfg.Rage.HitChance=v end)
    Slider("Prediction x100",0,50,Cfg.Rage.Prediction*100,function(v) Cfg.Rage.Prediction=v/100 end)
    Toggle("Use Ping",Cfg.Rage.UsePing,function(v) Cfg.Rage.UsePing=v end)
    Toggle("Visibility Check",Cfg.Rage.VisibleCheck,function(v) Cfg.Rage.VisibleCheck=v end)
    Toggle("Lock Target",Cfg.Rage.Lock,function(v) Cfg.Rage.Lock=v end)
end)
Reg("Anti Aim",function()
    Section("AA")
    Toggle("Enabled",Cfg.AA.Enabled,function(v) Cfg.AA.Enabled=v end)
    Toggle("Pitch",Cfg.AA.Pitch,function(v) Cfg.AA.Pitch=v end)
    Dropdown("Pitch Mode",{"Down","Up"},Cfg.AA.PitchMode,function(v) Cfg.AA.PitchMode=v end)
    Toggle("Yaw",Cfg.AA.Yaw,function(v) Cfg.AA.Yaw=v end)
    Dropdown("Yaw Mode",{"Backwards","Spin","Jitter"},Cfg.AA.YawMode,function(v) Cfg.AA.YawMode=v end)
    Slider("Spin Speed",1,50,Cfg.AA.SpinSpeed,function(v) Cfg.AA.SpinSpeed=v end)
end)
Reg("Players",function()
    Section("ESP")
    Toggle("Enabled",Cfg.ESP.Enabled,function(v) Cfg.ESP.Enabled=v end)
    Toggle("Team Check",Cfg.ESP.TeamCheck,function(v) Cfg.ESP.TeamCheck=v end)
    Slider("Max Distance",50,1000,Cfg.ESP.MaxDistance,function(v) Cfg.ESP.MaxDistance=v end)
    Toggle("Name",Cfg.ESP.Name,function(v) Cfg.ESP.Name=v end)
    Toggle("Health Bar",Cfg.ESP.Health,function(v) Cfg.ESP.Health=v end)
    Toggle("Health Text",Cfg.ESP.HealthText,function(v) Cfg.ESP.HealthText=v end)
    Toggle("Distance",Cfg.ESP.Distance,function(v) Cfg.ESP.Distance=v end)
    Toggle("Weapon",Cfg.ESP.Weapon,function(v) Cfg.ESP.Weapon=v end)
    Toggle("Skeleton",Cfg.ESP.Skeleton,function(v) Cfg.ESP.Skeleton=v end)
    Section("Flags")
    Toggle("Flags",Cfg.ESP.Flags.Enabled,function(v) Cfg.ESP.Flags.Enabled=v end)
    Toggle("Money",Cfg.ESP.Flags.Money,function(v) Cfg.ESP.Flags.Money=v end)
    Toggle("KIT",Cfg.ESP.Flags.Kit,function(v) Cfg.ESP.Flags.Kit=v end)
    Toggle("HK",Cfg.ESP.Flags.HK,function(v) Cfg.ESP.Flags.HK=v end)
    Toggle("Armor",Cfg.ESP.Flags.Armor,function(v) Cfg.ESP.Flags.Armor=v end)
    Section("Chams")
    Toggle("Chams",Cfg.Chams.Enabled,function(v) Cfg.Chams.Enabled=v end)
end)
Reg("World",function()
    Section("Thirdperson")
    Toggle("Enabled",Cfg.TP.Enabled,function(v) Cfg.TP.Enabled=v end)
    Slider("Distance",2,30,Cfg.TP.Distance,function(v) Cfg.TP.Distance=v end)
    Slider("Height",-2,10,Cfg.TP.Height,function(v) Cfg.TP.Height=v end)
    Slider("Smoothness",1,30,Cfg.TP.Smoothness,function(v) Cfg.TP.Smoothness=v end)
end)
Reg("Main",function()
    Section("Movement")
    Toggle("BHop",Cfg.Move.BHop,function(v) Cfg.Move.BHop=v end)
    Dropdown("BHop Mode",{"Always","OnJump"},Cfg.Move.BHopMode,function(v) Cfg.Move.BHopMode=v end)
    Toggle("Auto Strafe",Cfg.Move.Strafe,function(v) Cfg.Move.Strafe=v end)
    Slider("Strafe Speed",1,20,Cfg.Move.StrafeSpeed,function(v) Cfg.Move.StrafeSpeed=v end)
    Section("UI")
    Toggle("Indicators",Cfg.Ind.Enabled,function(v) Cfg.Ind.Enabled=v end)
    Section("Behavior")
    Toggle("Randomizer",Cfg.Beh.Enabled,function(v) Cfg.Beh.Enabled=v end)
    Slider("Miss %",0,25,Cfg.Beh.Miss,function(v) Cfg.Beh.Miss=v end)
    Slider("Jitter",0,10,Cfg.Beh.Jitter,function(v) Cfg.Beh.Jitter=v end)
end)
local function Cat(n) local l=Instance.new("TextLabel") l.Size=UDim2.new(1,0,0,24) l.BackgroundTransparency=1 l.Text=n l.TextColor3=Color3.fromRGB(65,85,110) l.TextSize=11 l.Font=Enum.Font.GothamBold l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=Menu end
local function Item(name,key)
    local b=Instance.new("TextButton")
    b.Name=key.."Tab"
    b.Size=UDim2.new(1,0,0,34)
    b.BackgroundColor3=Color3.fromRGB(20,40,65)
    b.BackgroundTransparency=1
    b.Text=""
    b.AutoButtonColor=false
    b.BorderSizePixel=0
    b.Parent=Menu
    local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(0,6) bc.Parent=b
    local txt=Instance.new("TextLabel") txt.Size=UDim2.new(1,-20,1,0) txt.Position=UDim2.new(0,14,0,0) txt.BackgroundTransparency=1 txt.Text=name txt.TextColor3=Color3.fromRGB(120,135,155) txt.TextSize=13 txt.Font=Enum.Font.GothamMedium txt.TextXAlignment=Enum.TextXAlignment.Left txt.Parent=b
    b.MouseButton1Click:Connect(function()
        if ActiveBtn then TweenService:Create(ActiveBtn,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play() TweenService:Create(ActiveTxt,TweenInfo.new(0.2),{TextColor3=Color3.fromRGB(120,135,155)}):Play() end
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
        TweenService:Create(txt,TweenInfo.new(0.2),{TextColor3=Color3.fromRGB(255,255,255)}):Play()
        ActiveBtn,ActiveTxt=b,txt
        ClearContent()
        if Tabs[key] then Tabs[key]() end
    end)
end
Cat("Aimbot")
Item("Ragebot","Ragebot")
Item("Anti Aim","Anti Aim")
Cat("Visuals")
Item("Players","Players")
Item("World","World")
Cat("Misc")
Item("Main","Main")
for _,c in ipairs(Menu:GetChildren()) do if c.Name=="MainTab" then c.BackgroundTransparency=0 c.TextLabel.TextColor3=Color3.fromRGB(255,255,255) ActiveBtn=c ActiveTxt=c.TextLabel break end end
ClearContent()
Tabs["Main"]()
AddC(UIS.InputBegan:Connect(function(i,gp) if gp then return end if i.KeyCode==Enum.KeyCode.Insert or i.KeyCode==Enum.KeyCode.RightShift then Main.Visible=not Main.Visible end if i.KeyCode==Enum.KeyCode.V then Cfg.TP.Enabled=not Cfg.TP.Enabled end end))
ScreenGui.Destroying:Connect(function() KillAll() for p in pairs(ESPCache) do RemoveESP(p) end for p in pairs(ChamsC) do RemoveChams(p) end end)
print("[NEVERWIN v1.8] Loaded.")

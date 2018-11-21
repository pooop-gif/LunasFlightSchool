--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"

ENT.PrintName = "basescript"
ENT.Author = "Blu"
ENT.Information = ""
ENT.Category = "[LFS]"

ENT.Spawnable		= false
ENT.AdminSpawnable  = false

ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH 
ENT.Editable = true

ENT.LFS = true

ENT.MDL = "error.mdl"

ENT.AITEAM = 0

ENT.Mass = 2000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 0

ENT.SeatPos = Vector(32,0,67.5)
ENT.SeatAng = Angle(0,-90,0)

ENT.WheelMass = 400
ENT.WheelRadius = 15
ENT.WheelPos_L = Vector(0,50,0)
ENT.WheelPos_R = Vector(0,-50,0)

ENT.IdleRPM = 300
ENT.MaxRPM = 1200
ENT.LimitRPM = 2000

ENT.RotorPos = Vector(80,0,0)
ENT.WingPos = Vector(40,0,0)
ENT.ElevatorPos = Vector(-40,0,0)
ENT.RudderPos = Vector(-40,0,15)

ENT.MaxVelocity = 2500

ENT.MaxThrust = 500

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 300
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 2600

ENT.MaxHealth = 1000

ENT.MaxPrimaryAmmo = -1
ENT.MaxSecondaryAmmo = -1

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Driver" )
	self:NetworkVar( "Entity",1, "DriverSeat" )
	self:NetworkVar( "Entity",2, "Gunner" )
	self:NetworkVar( "Entity",3, "GunnerSeat" )
	
	self:NetworkVar( "Bool",0, "Active" )
	self:NetworkVar( "Bool",1, "EngineActive" )
	self:NetworkVar( "Bool",2, "AI",	{ KeyName = "aicontrolled",	Edit = { type = "Boolean",	order = 1,	category = "AI"} } )
	self:NetworkVar( "Int",2, "AITEAM", { KeyName = "aiteam", Edit = { type = "Int", order = 2,min = 0, max = 2, category = "AI"} } )
	
	self:NetworkVar( "Float",0, "LGear" )
	self:NetworkVar( "Float",1, "RGear" )
	self:NetworkVar( "Float",2, "RPM" )
	self:NetworkVar( "Float",3, "RotPitch" )
	self:NetworkVar( "Float",4, "RotYaw" )
	self:NetworkVar( "Float",5, "RotRoll" )
	self:NetworkVar( "Float",6, "HP", { KeyName = "health", Edit = { type = "Float", order = 2,min = 0, max = self.MaxHealth, category = "Misc"} } )
	
	self:NetworkVar( "Int",0, "AmmoPrimary", { KeyName = "primaryammo", Edit = { type = "Int", order = 3,min = 0, max = self.MaxPrimaryAmmo, category = "Weapons"} } )
	self:NetworkVar( "Int",1, "AmmoSecondary", { KeyName = "secondaryammo", Edit = { type = "Int", order = 4,min = 0, max = self.MaxSecondaryAmmo, category = "Weapons"} } )

	
	
	if SERVER then
		self:NetworkVarNotify( "AI", self.OnToggleAI )
		
		self:SetAITEAM( self.AITEAM )
		self:SetHP( self.MaxHealth )
		self:SetAmmoPrimary( self:GetMaxAmmoPrimary() )
		self:SetAmmoSecondary( self:GetMaxAmmoSecondary() )
	end
end

function ENT:GetMaxAmmoPrimary()
	return self.MaxPrimaryAmmo
end

function ENT:GetMaxAmmoSecondary()
	return self.MaxSecondaryAmmo
end

function ENT:GetMaxHP()
	return self.MaxHealth
end

function ENT:GetIdleRPM()
	return self.IdleRPM
end

function ENT:GetMaxRPM()
	return self.MaxRPM
end

function ENT:GetLimitRPM()
	return self.LimitRPM
end

function ENT:GetMaxVelocity()
	return self.MaxVelocity
end

function ENT:GetMaxTurnSpeed()
	return  {p = self.MaxTurnPitch, y = self.MaxTurnYaw, r = self.MaxTurnRoll }
end

function ENT:GetMaxPerfVelocity()
	return self.MaxPerfVelocity
end

function ENT:GetMaxThrust()
	return self.MaxThrust
end

function ENT:GetRotorPos()
	return self:LocalToWorld( self.RotorPos )
end

function ENT:GetWingPos()
	return self:LocalToWorld( self.WingPos )
end

function ENT:GetWingUp()
	return self:GetUp()
end

function ENT:GetElevatorUp()
	return self:GetUp()
end

function ENT:GetRudderUp()
	return self:GetRight()
end

function ENT:GetElevatorPos()
	return self:LocalToWorld( self.ElevatorPos )
end

function ENT:GetRudderPos()
	return self:LocalToWorld( self.RudderPos )
end

sound.Add( {
	name = "LFS_PLANE_EXPLOSION",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	pitch = {75, 120},
	sound = "^lfs/plane_explosion.wav"
} )
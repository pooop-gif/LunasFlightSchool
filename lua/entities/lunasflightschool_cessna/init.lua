--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	for _, Pos in pairs( { Vector(5,-8,38), Vector(-35,-8,38), Vector(-35,8,38) } ) do
		local Pod = ents.Create( "prop_vehicle_prisoner_pod" )
		
		if IsValid( Pod ) then
			Pod:SetMoveType( MOVETYPE_NONE )
			Pod:SetModel( "models/nova/airboat_seat.mdl" )
			Pod:SetKeyValue( "vehiclescript","scripts/vehicles/prisoner_pod.txt" )
			Pod:SetKeyValue( "limitview", 0 )
			Pod:SetPos( self:LocalToWorld( Pos ) )
			Pod:SetAngles( self:LocalToWorldAngles( self.SeatAng ) )
			Pod:SetOwner( self )
			Pod:Spawn()
			Pod:Activate()
			Pod:SetParent( self )
			Pod:SetNotSolid( true )
			Pod:SetNoDraw( true )
			Pod:DrawShadow( false )
			Pod.DoNotDuplicate = true
			
			self:DeleteOnRemove( Pod )
			self:dOwner( Pod )
			
			local DSPhys = Pod:GetPhysicsObject()
			if IsValid( DSPhys ) then
				DSPhys:EnableDrag( false ) 
				DSPhys:EnableMotion( false )
				DSPhys:SetMass( 1 )
			end
		end
	end
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:InitWheels()
	local PObj = self:GetPhysicsObject()
	
	if IsValid( PObj ) then 
		PObj:EnableMotion( true )
	end
end

function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyReload = Driver:KeyDown( IN_RELOAD )
		
		if self.OldKeyReload ~= KeyReload then
			self.OldKeyReload = KeyReload
			if KeyReload then
				self:ToggleEngine()
			end
		end
	end
	
	local TVal = (self:GetStability() > 0.3) and 0 or 1
	local Speed = FrameTime()
	
	self:SetLGear( self:GetLGear() + math.Clamp(TVal - self:GetLGear(),-Speed,Speed) )
end

function ENT:ToggleLandingGear()
end

function ENT:RaiseLandingGear()
end

function ENT:HandleWeapons(Fire1, Fire2)
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/cessna/start.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/cessna/stop.wav" )
end

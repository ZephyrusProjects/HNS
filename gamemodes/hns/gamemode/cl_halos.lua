  
--Draws the glow around entities when using the physgun.
 
local physgun_halo = CreateConVar( "physgun_halo", "1", { FCVAR_ARCHIVE }, "Draw the physics gun halo?" )
local PhysgunHalos = {}


function GM:DrawPhysgunBeam( ply, weapon, bOn, target, boneid, pos )
	if ( physgun_halo:GetInt() == 0 ) then return true end

	if ( IsValid( target ) ) then
		PhysgunHalos[ ply ] = target
	end
	return true
end


hook.Add( "PreDrawHalos", "AddPhysgunHalos", function()
	if ( !PhysgunHalos || table.Count( PhysgunHalos ) == 0 ) then return end

	for k, v in pairs( PhysgunHalos ) do

		if ( !IsValid( k ) ) then continue end

		local size = math.random( 1, 2 )
		local colr = k:GetWeaponColor() + VectorRand() * 0.3
		halo.Add( PhysgunHalos, Color( colr.x * 255, colr.y * 255, colr.z * 255 ), size, size, 1, true, false )
	end

	PhysgunHalos = {}
end)

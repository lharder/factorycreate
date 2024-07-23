local Events = require( "events.events" )

Events.FACTORY_CREATED = Events.create( "factorycreated" )


local function exec( ctx, fn, params )
	local me = lua_script_instance.Get()

	lua_script_instance.Set( ctx )
	fn( ctx, params )

	lua_script_instance.Set( me )
end


local function factorycreate( facturl, pos, rot, attrs, scale )
	local evHandler = Events.FACTORY_CREATED:subscribe( function( newObjCtx, fnInit ) 
		if newObjCtx == nil then return end  
		exec( newObjCtx, fnInit, attrs )
	end )

	local id = factory.create( facturl, pos, rot, nil, scale )

	Events.FACTORY_CREATED:unsubscribe( evHandler )

	return id
end


return factorycreate


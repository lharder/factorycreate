# factorycreate

This is a small utility for the Defold game engine.

Defold is an awesome engine but does not allow arbitrary parameters to be passed to a newly created gameobject. 

To the standard funtion, you can pass in properties, but only those of a few given types, none of which can be used to pass in complex data structures or even something comparatively simple like strings:

## Standard Defold way

```lua
-- standard Defold way to create an object:
local props = {}
props.foo = 1
props.bar = vmath.vector( 1, 2, 3 )
local id = factory.create( factoryurl, pos, rot, props, scale ) 

-- this, however does NOT work:
local props = {}
props.foo = "Max"
props.bar = { health = 100,  power = 12,  type = "spaceship" }
local id = factory.create( factoryurl, pos, rot, props, scale ) 
```

## Better with events

There are workarounds for this problem, but they lead to cumbersome code. It has kept bugging me, so, with this little library, it is easy to provide new gameobjects with any type of initialization parameters that may be needed.

factorycreate relies on these two libraries as dependencies. You need to include them in your game.project:

https://github.com/DanEngelbrecht/LuaScriptInstance/archive/refs/heads/master.zip
https://github.com/lharder/events/archive/refs/heads/main.zip


## Any parameters on initialization
Instead of factory.create, you would write:

```lua
-- use factorycreate() instead of factory.create()
require( "factorycreate.factorycreate" )

-- events module as provided by the library
local Events = require( "events.events" )

-- factorycreate defines an event that must get triggered 
-- every time a new gameobject is instantiated:
-- Events.FACTORY_CREATED = Events.create( "factorycreated" )
-- You need to use that event in the gameobject scripts.

local props = {}
props.foo = "Max"
props.bar = { health = 100,  power = 12,  type = "spaceship" }
local id = factorycreate( factoryurl, pos, rot, props, scale ) 
```

To receive the initialization parameters, the newly created gameobject must trigger the FACTORY_CREATED event provided by the library in its init() method. In the trigger callback method, you receive the parameters and can use them in any way you see fit:

```lua
-- inside the gameobject script:
local Events = require( "events.events" )

function init( self )
	-- trigger the FACTORY_CREATED event and provide a callback
	-- method. The parameters get passed in as a variable:
	Events.FACTORY_CREATED:trigger( self, function( self, params ) 
		self.attrs = params
		pprint( params ) 
	end )
end

function update( self, dt )
	pprint( self.attrs.foo )
end

```

factorycreate internally subscribes to the FACTORY_CREATED event and passes in the params to the callback method of the newly initiated gameobject. By switching the scripting context, the complex data reaches the new gameobject.

note
	description:
		"Viewers of EV_MODEL_WORLDs."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "projector, world, figure"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_MODEL_PROJECTOR

inherit
	ANY
		export
			{EV_ANY_HANDLER} default_create
		end

feature {NONE} -- Initialization

	make_with_world (a_world: like world)
			-- Create with `a_world'.
		require
			a_world_not_void: a_world /= Void
		do
			set_world (a_world)
		ensure
			world_assigned: world = a_world
		end

feature -- Status setting

	set_world (a_world: like world)
			-- Set `world' to `a_world'.
		require
			a_world_exists: a_world /= Void
		do
			world := a_world
		ensure
			world_assigned: world = a_world
		end

feature -- Access

	world: EV_MODEL_WORLD
			-- Figure-world that will be projected.

invariant
	world_exists: world /= Void

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_MODEL_PROJECTOR


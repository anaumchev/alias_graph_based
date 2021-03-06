note
	description: "Eiffel Vision menu bar. Cocoa implementation."
	author: "Daniel Furrer"

class
	EV_MENU_BAR_IMP

inherit
	EV_MENU_BAR_I
		redefine
			interface
		end

	EV_MENU_ITEM_LIST_IMP
		redefine
			interface
		end

	EV_ANY_IMP
		redefine
			interface
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Create and initialize `Current'.
		do
			create menu.make
			initialize_item_list
		end

feature -- Measurement

	x_position: INTEGER
			-- Horizontal offset relative to parent `x_position' in pixels.
		do
		end

	y_position: INTEGER
			-- Vertical offset relative to parent `y_position' in pixels.
		do
		end

	screen_x: INTEGER
			-- Horizontal offset relative to screen.
		do
		end

	screen_y: INTEGER
			-- Vertical offset relative to screen.
		do
		end

	width: INTEGER
			-- Horizontal size in pixels.
		do
		end

	height: INTEGER
			-- Vertical size in pixels.
		do
		end

	minimum_width: INTEGER
			-- Minimum horizontal size in pixels.
		do
		end

	minimum_height: INTEGER
			-- Minimum vertical size in pixels.
		do
		end

	is_sensitive: BOOLEAN = True
			-- `Current' is always sensitive as it cannot be disabled in the interface.

feature {EV_WINDOW_IMP} -- Implementation

	set_parent_window_imp (a_wind: EV_WINDOW_IMP)
			-- Set `parent_window' to `a_wind'.
		require
			a_wind_not_void: a_wind /= Void
		do
			parent_imp := a_wind
		end

	parent: detachable EV_WINDOW
			-- Parent window of Current.
		do
			if attached parent_imp as p_imp then
				Result := p_imp.attached_interface
			end
		end

	remove_parent_window
			-- Set `parent_window' to Void.
		do
			parent_imp := Void
		end

	parent_imp: detachable EV_WINDOW_IMP

feature {EV_ANY_I} -- Implementation

	menu: NS_MENU

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_MENU_BAR note option: stable attribute end;

end -- class EV_MENU_BAR_IMP

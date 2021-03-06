note
	description:
		"Action sequences for EV_COMBO_BOX."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date"
	revision: "$Revision"

deferred class
	 EV_COMBO_BOX_ACTION_SEQUENCES

inherit
	EV_ACTION_SEQUENCES

feature {NONE} -- Implementation

	implementation: EV_COMBO_BOX_ACTION_SEQUENCES_I
		deferred
		end

feature -- Event handling


	drop_down_actions: EV_NOTIFY_ACTION_SEQUENCE
		obsolete "Use `list_shown_actions' instead. [2017-05-31]"
			-- Actions to be performed when drop down list is displayed.
		do
			Result := implementation.drop_down_actions
		ensure
			not_void: Result /= Void
		end

	list_shown_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when drop down list is shown.
		do
			Result := implementation.drop_down_actions
		ensure
			not_void: Result /= Void
		end

	list_hidden_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when drop down list is hidden.
		do
			Result := implementation.list_hidden_actions
		ensure
			not_void: Result /= Void
		end

note
	copyright:	"Copyright (c) 1984-2014, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end


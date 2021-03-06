note
	description: "[
			[Alias Analysis] Test suite main class.

			To run the test suite:
			- Add the directory of this class as a cluster to your Eiffel project.
			- Reference this class somewhere in your code. E.g.:
			  dummy: detachable ALIAS_ANALYSIS_TESTSUITE
			- Click on the "TS" button in the Alias Analysis view.
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2015-11-20 15:11:03 +0300 (Fri, 20 Nov 2015) $"
	revision: "$Revision: 98125 $"

class
	ALIAS_ANALYSIS_TESTSUITE

feature {NONE}

	-- Add all classes with tests here:
	c1: detachable AAT_BASIC
	c2: detachable AAT_QUALIFIED
	c3: detachable AAT_OVER_OPER_A
	c4: detachable AAT_STRING_ARG
	c5: detachable AAT_BASIC_CHECKS

;note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end

note
	description: "[AAT_BASIC_CHECKS] basic tests."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2015-11-23 14:59:42 +0300 (Mon, 23 Nov 2015) $"
	revision: "$Revision: 98134 $"

class
	AAT_BASIC_CHECKS

create
	make

feature

	make
		do
				a := ""
				b := ""
		end

	a, b: STRING_8

	test_simple_alias
		note
			aliasing:
				"[
					{AAT_BASIC_CHECKS}.a, {AAT_BASIC_CHECKS}.b
					{AAT_BASIC_CHECKS}.a.{STRING_8}.area, {AAT_BASIC_CHECKS}.b.{STRING_8}.area
					{AAT_BASIC_CHECKS}.a.{STRING_8}.internal_hash_code, {AAT_BASIC_CHECKS}.b.{STRING_8}.internal_hash_code
				]"
		do
			a := "a"
			b := a
			b.append ("something else")
		end

	test_simple_alias2
		note
			aliasing: "{AAT_BASIC_CHECKS}.a, {AAT_BASIC_CHECKS}.b"
		do
			make
			b := a
		end

note
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

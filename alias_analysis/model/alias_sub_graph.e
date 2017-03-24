note
	description: "[
		This class managing sub-alias-graph when need it: the main the functionality to add/delete/restore the Alias graph when the 
		analysis enters in structures such as conditionals, loops, recursions or handling 'dynamic binding'
		This class provides mechanisms to manipulate the graph and to restore it. Also mechanismos to subsume nodes.

	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: (Fri, 07 Oct 2016) $"
	revision: "$Revision: 98127 $"

deferred class
	ALIAS_SUB_GRAPH

inherit

	TRACING

feature {NONE} -- Initialiasation

	make
			-- Initialises an {ALIAS_SUB_GRAPH} and descendants
		do
			create indexes.make
			create additions.make
			create deletions.make
		end

feature -- Updating

	stop2 (n:INTEGER)
		do
			if tracing then
				print (n)
				io.new_line
			end
		end

	updating_A_D (target_name, source_name: STRING; target_object, source_object: TWO_WAY_LIST [ALIAS_OBJECT]; target_path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]; routine_name: STRING)
			-- updates the sets `additions' and `deletions' accordingly:
			--	additions -> [`target_name': (`source_name', `source_object', `target_path')]
			--  deletions -> [`target_name': (`source_name', `source_object', `target_path')]
			-- `routine_name' is needed to identified local variables from different features inside the same the class
		require
			is_in_structure
		local
			tup: TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]]
			obj: TWO_WAY_LIST [ALIAS_OBJECT]
		do
			stop2 (0)
			if tracing then
				io.new_line
				print ("target_path: ")
				across
					target_path as pa
				loop
					print ("[")
					across
						pa.item as p
					loop
						print (p.item)
						print (", ")
					end
					print ("],")
				end
				io.new_line
				io.new_line
				io.new_line
			end
			stop2 (7)
			create tup
			tup.abs_name := ""
			stop2 (8)
			across
				target_path as abs
			loop
				stop2 (1)
				if abs.item.count = 0 then
					tup.abs_name := tup.abs_name + "Current."
				elseif abs.item.count = 1 then
					tup.abs_name := tup.abs_name + abs.item.first + "."
				else
					tup.abs_name := tup.abs_name + "["
					across
						abs.item as sub
					loop
						tup.abs_name := tup.abs_name + sub.item + ","
					end
					tup.abs_name := tup.abs_name + "]."
				end
			end
			stop2 (9)
			if target_name ~ "Result" then
				stop2 (10)
				tup.abs_name := tup.abs_name + routine_name + target_name
			else
				stop2 (11)
				tup.abs_name := tup.abs_name + target_name
			end
			if attached source_name as sn then
				tup.name := sn
			else
				tup.name := "Void"
			end
			tup.path := target_path.twin
			create obj.make
			stop2 (12)
			if attached source_object as so then
				across
					so as s
				loop
					obj.force (s.item)
				end
			else
				obj.force (create {ALIAS_OBJECT}.make_void)
			end
			stop2 (2)
			tup.obj := obj
			if target_name ~ "Result" then
				additions.last.force (tup, routine_name + target_name)
			else
				additions.last.force (tup, target_name)
			end

				--if attached target_object as target then
				-- An example of Void target: Result
			create tup
			tup.abs_name := ""
			across
				target_path as abs
			loop
				stop2 (3)
				if abs.item.count = 0 then
					tup.abs_name := tup.abs_name + "Current."
				elseif abs.item.count = 1 then
					tup.abs_name := tup.abs_name + abs.item.first + "."
				else
					tup.abs_name := tup.abs_name + "["
					across
						abs.item as sub
					loop
						tup.abs_name := tup.abs_name + sub.item + ","
					end
					tup.abs_name := tup.abs_name + "]."
				end
			end
			if target_name ~ "Result" then
				tup.abs_name := tup.abs_name + routine_name + target_name
			else
				tup.abs_name := tup.abs_name + target_name
			end
			tup.name := target_name
			tup.path := target_path.twin
			create obj.make
			stop2 (4)
			if attached target_object as target then
				across
					target as t
				loop
					obj.force (t.item)
				end
			end
			tup.obj := obj
			if target_name ~ "Result" then
				deletions.last.force (tup, routine_name + target_name)
			else
				deletions.last.force (tup, target_name)
			end
			stop2 (5)
			if tracing then
				printing_vars (1)
			end
		end

	deleting_local_vars (function_name: STRING; locals: ARRAY [STRING])
			-- updates the sets `additions and `deletions' deleting local variables that will no be of
			-- any used outside a feature
		do
			if tracing then
				printing_vars (1)
			end
				-- local var Result
			if additions.count > 0 then
				additions.last.remove (function_name + "_Result")
			end

			if deletions.count > 0 then
				deletions.last.remove (function_name + "_Result")
			end


				-- other local variables
			across
				locals as l
			loop
				if tracing then
					print (l.item)
					io.new_line
				end

				if not (l.item ~ "Result") then
					if additions.count > 0 then
						additions.last.remove (l.item)
					end

					if deletions.count > 0 then
						deletions.last.remove (l.item)
					end


				end
			end
		end

feature -- Managing Branches

	is_in_structure: BOOLEAN
			-- is the alias graph currently analysing a structure: eg. conditional branch, loop iteration, recursion?
		deferred
		end

	initialising
			-- initialises the counter of steps
		do
			indexes.force (create {TUPLE [index_add, index_del: INTEGER]})
			indexes.last.index_add := additions.count + 1
			indexes.last.index_del := deletions.count + 1
		ensure
			is_in_structure
		end

	step
			-- initialises a step of a structure: e.g. a conditional branch
		require
			is_in_structure
		do
			additions.force (create {HASH_TABLE [TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]], STRING]}.make (0))
			deletions.force (create {HASH_TABLE [TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]], STRING]}.make (0))
		end

	finalising (root, current_routine: ALIAS_ROUTINE)
			-- it consists of two actions:
			--	i) inserts the union of elements in `additions'
			--	ii) deletes the intersection of elements in `deletions'
			--to `current_alias_routine'
		require
			is_in_structure
		deferred
		end

feature -- Managing merging nodes (for loops and recursion)

	subsume (root: ALIAS_ROUTINE)
			-- subsumes nodes if needed
		do
			if tracing then
				print ("%N===================================================%N")
				printing_vars (1)
			end
			across
				additions.last as added
					--additions.at (additions.count) as added
			loop
				if tracing then
					io.new_line
					print (added.key)
					io.new_line
				end
				if added.item.obj.count = additions.at (additions.count - 1).at (added.key).obj.count
					and not across added.item.obj as obj all additions.at (additions.count - 1).at (added.key).obj.has (obj.item) end
				then
					--TODO mark1 go through all elements in additions.at (add.index) .. addition.last adding thing to cond
					across
						added.item.obj as n2
					loop
							-- n1 subsumed by n2
						across
							additions.at (additions.count - 1).at (added.key).obj as n1
						loop
							subsume_nodes (n2.item, n1.item, root)
						end
					end
				else
					print ("No Subsume%N")
						-- nodes did not reach N fixed point
				end
			end
		end

	subsume_nodes (n2, n1: ALIAS_OBJECT; root: ALIAS_ROUTINE)
			-- subsumes node `n2' by `n1' in the graph
			-- it comprises 3 steps
			-- i. for_all i | i \in Nodes and i /= 2 and n_2 -->_t n_i then n_1 -->_t n_i
			-- ii. for_all i | i \in Nodes and i /= 2 and n_i -->_t n_2 then n_i -->_t n_1
			-- iii. for_all n_2 -->_t n_2 then n_1 -->_t n_1
		do
			subsume_from_n2 (n2, n1)
				-- including from n2 to itself

			reset (root.current_object.attributes)
			n2.visited := True
			subsume_to_n2 (root.current_object.attributes, n1, n2)
			reset (root.current_object.attributes)
		end

	subsume_from_n2 (n2, n1: ALIAS_OBJECT)
			-- subsumes node `n2' by `n1' in the graph
			-- it comprises 2 steps (steps (i) and (iii))
			-- i. for_all i | i \in Nodes and i /= 2 and n_2 -->_t n_i then n_1 -->_t n_i
			-- (NO) ii. for_all i | i \in Nodes and i /= 2 and n_i -->_t n_2 then n_i -->_t n_1
			-- iii. for_all n_2 -->_t n_2 then n_1 -->_t n_1
		local
			item_to_be_added: ALIAS_OBJECT
		do
			across
				n2.attributes as v2
			loop
				if not n1.attributes.has (v2.key) then
					n1.attributes.force (create {TWO_WAY_LIST [ALIAS_OBJECT]}.make, v2.key)
				end
				across
					v2.item as objs
				loop
					if objs.item = n2 then
						item_to_be_added := n1
					else
						item_to_be_added := objs.item
					end
					if not n1.attributes.at (v2.key).has (item_to_be_added) then
						n1.attributes.at (v2.key).force (item_to_be_added)
					end
				end
			end
		end

	subsume_to_n2 (v: HASH_TABLE [TWO_WAY_LIST [ALIAS_OBJECT], STRING]; n1, n2: ALIAS_OBJECT)
			-- subsumes node `n2' by `n1' in the graph
			-- it comprises 1 step (steps (ii))
			-- (NO) i. for_all i | i \in Nodes and i /= 2 and n_2 -->_t n_i then n_1 -->_t n_i
			-- ii. for_all i | i \in Nodes and i /= 2 and n_i -->_t n_2 then n_i -->_t n_1
			-- (NO) iii. for_all n_2 -->_t n_2 then n_1 -->_t n_1
		require
			v /= Void
			n2.visited
		do
			if not v.is_empty then
				across
					v as values
				loop
					from
						values.item.start
					until
						values.item.after
					loop
						if values.item.item = n2 then
							if not values.item.has (n1) then
								values.item.put_right (n1)
							end
							values.item.remove
						end

						if not values.item.after and not values.item.item.visited then
							values.item.item.visited := True
							subsume_to_n2 (values.item.item.attributes, n1, n2)
						end

						if not values.item.after then
							values.item.forth
						end

					end
				end
			end
		end

	add_deleted_links (root, current_routine: ALIAS_ROUTINE)
			-- restore the graph by given back the deleted links
		local
			objs: ALIAS_OBJECT
		do
			if tracing then
				printing_vars (1)
			end
			if indexes.last.index_del <= deletions.count then
					-- Inserting deleted links
				from
					deletions.go_i_th (indexes.last.index_del)
				until
					deletions.after
				loop
					across
						deletions.item as values
					loop
						restore_deleted (root.current_object, current_routine, values.key, values.item.path, 1, values.item.obj)
					end
					deletions.forth
				end
				indexes.finish
				indexes.remove
			end
		end

	restore_deleted (current_object: ALIAS_OBJECT; current_routine: ALIAS_ROUTINE name_entity: STRING; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]; index: INTEGER; old_object: TWO_WAY_LIST [ALIAS_OBJECT])
			-- adds in `current_object'.`path' the deleted object: `old_object'
			-- This command is used to restore the state of the graph on exit of the structure
		local
			c_objs: TWO_WAY_LIST [ALIAS_OBJECT]
		do
			if index > path.count then
				if tracing then
					across
						current_object.attributes as aa
					loop
						print (aa.key)
						print (": ")
						across
							aa.item as bb
						loop
							print (bb.item.out2)
							print (", ")
						end
						io.new_line
						io.new_line
					end
				end

				if tracing then
					print_atts_depth (current_object.attributes)
					io.new_line
					print (name_entity)
					io.new_line
					if current_object.attributes.at (name_entity) = Void then
						io.new_line
						print ("Void")
					end
				end

					-- the variable should exist (no need to check)
				if name_entity.ends_with ("_Result") then
					c_objs := current_routine.locals.at ("Result")
				elseif current_routine.locals.has (name_entity) then
					c_objs := current_routine.locals.at (name_entity)
				elseif current_object.attributes.has (name_entity) then
					c_objs := current_object.attributes.at (name_entity)
				else
--				elseif current_routine.current_object.attributes.has (name_entity) then
--					c_objs := current_routine.current_object.attributes.at (name_entity)
--				else

				end
				across
					old_object as o_o
				loop
					if not c_objs.has (o_o.item) then
						c_objs.force (o_o.item)
					end
				end
			else
				across
					path.at (index) as paths
				loop
					if current_object.attributes.has (paths.item) then
						c_objs := current_object.attributes.at (paths.item)
					elseif current_routine.locals.has_key (paths.item) then
						c_objs := current_routine.locals [paths.item]
					end
					across
						c_objs as objs
					loop
						restore_deleted (objs.item, current_routine, name_entity, path, index + 1, old_object)
					end
				end
			end
		end

feature -- Access
	--TODO: to create a class with this structure

	additions: TWO_WAY_LIST [HASH_TABLE [TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]], STRING]]
			-- stores the edges added by a step (A_i in the def): the key is the name of the entity to be added (it contains all path)
			-- `name': name of the entity to point at
			-- `obj': object that `name' is pointing at
			-- `path': path of the entity e.g. Current.v.[w,x]...

	deletions: TWO_WAY_LIST [HASH_TABLE [TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]], STRING]]
			-- stores the edges deleted by a step (D_i in the def): the key is the name of the entity to be deleted (it contains all path)
			-- `name': name of the entity it was pointing at
			-- `obj': object that `name' it was pointing at
			-- `path': path of the entity e.g. Current.v.[w,x]...

	indexes: TWO_WAY_LIST [TUPLE [index_add, index_del: INTEGER]]
			-- stores for each step index: the number of additions and deletions

feature --{NONE} -- To Delete

	print_atts_depth (c: HASH_TABLE [TWO_WAY_LIST [ALIAS_OBJECT], STRING_8])
		do
			if tracing then
				print ("Atts Deep%N")
				print_atts_depth_help (c, 1)
				reset (c)
				print ("-------------------------------------------------%N")
			end
		end

	reset (in: HASH_TABLE [TWO_WAY_LIST [ALIAS_OBJECT], STRING_8])
		do
			across
				in as links
			loop
				across
					links.item as vals
				loop
					if vals.item.visited then
						vals.item.visited := false
						reset (vals.item.attributes)
					end
				end
			end
		end

	print_atts_depth_help (in: HASH_TABLE [TWO_WAY_LIST [ALIAS_OBJECT], STRING_8]; i: INTEGER)
		local
			tab: STRING
		do
			if tracing then
				create tab.make_filled (' ', i)
				across
					in as links
				loop
					print (tab)
					print (links.key + ": [")
					across
						links.item as vals
					loop
						print (vals.item.out2)
						print (":")
						io.new_line
						if not vals.item.visited then
							vals.item.visited := true
							print_atts_depth_help (vals.item.attributes, i + 2)
						end
					end
					print (tab)
					print ("]")
					io.new_line
					io.new_line
				end
			end
		end

	printing_vars (va: INTEGER)
			-- va
			--		(1): additions and deletions
			--      (2): deletions
			--		(3): additions
			--		(4): nothing
		require
			va = 1 or va = 2 or va = 3 or va = 4
		local
			ttt: TWO_WAY_LIST [HASH_TABLE [TUPLE [name, abs_name: STRING; obj: TWO_WAY_LIST [ALIAS_OBJECT]; path: TWO_WAY_LIST [TWO_WAY_LIST [STRING]]], STRING]]
		do
			if tracing then
				if va = 4 then
				else
					if va = 1 or va = 3 then
						print ("%N%NAditions%N%N")
						ttt := additions
					else
						print ("%N%NDeletions%N%N")
						ttt := deletions
					end
					across
						ttt as added
					loop
						print ("--%N")
						across
							added.item as pair_add
						loop
							print (pair_add.key)
							print (": ")
							print (pair_add.item.name)
							print (" -[")
							across
								pair_add.item.obj as obj_add
							loop
								if attached obj_add.item as oo then
									print (oo.out2)
								else
									print ("Void")
								end

								if obj_add.after then
									print (", ")
								end
							end
							print ("] path: [")
							across
								pair_add.item.path as path_add
							loop
								print ("[")
								across
									path_add.item as p
								loop
									print (p.item)
									if p.after then
										print (",")
									end
								end
								print ("]")
								if path_add.after then
									print (", ")
								end
							end

							print ("] abs_name: ")
							print (pair_add.item.abs_name)
							print ("%N")
						end
					end
					if va = 1 then
						printing_vars (2)
					elseif va = 2 or va = 3 then
						printing_vars (4)
					end
				end
			end
		end

feature {NONE}

	n_fixpoint: INTEGER = 2
			-- `n_fixpoint' is a fix number: upper bound for loops and rec

invariant
	additions /= Void
	deletions /= Void
	indexes /= void
	indexes.count = 0 implies (additions.count + deletions.count = 0)

note
	copyright: "Copyright (c) 1984-2017, Eiffel Software"
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
" Syntax highlighting for Gama language
" https://gama-platform.github.io

if exists('b:current_syntax')
    finish
endif


setlocal iskeyword+=\#
setlocal iskeyword+=\:
setlocal commentstring=//%s
setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4

syn keyword gamlTodo Name Author Tags Todo TODO Description
            \ Name: Author: Tags: Todo: TODO: Description:


syn keyword gamlImport model import
syn keyword gamlKeyword global init create
            \ experiment display permanent
            \ output chart aspect reflex
            \ nil


syn match gamlFacet "\v<\w+\:>"


" @OPERATORS


syn match gamlSingleOperator "-"
syn match gamlSingleOperator "::"
syn match gamlSingleOperator "!"
syn match gamlSingleOperator "!="
syn match gamlSingleOperator "?"
syn match gamlSingleOperator "/"
syn match gamlSingleOperator "\."
syn match gamlSingleOperator "^"
syn match gamlSingleOperator "@"
syn match gamlSingleOperator "\*"
syn match gamlSingleOperator "+"
syn match gamlSingleOperator "<"
syn match gamlSingleOperator "<="
syn match gamlSingleOperator "="
syn match gamlSingleOperator ">"
syn match gamlSingleOperator ">="
syn match gamlSingleOperator "<-"
syn match gamlSingleOperator "+"
syn match gamlSingleOperator "-"
syn match gamlSingleOperator "::"

syn keyword gamlOperator 
            \ abs accumulate acos action add_3Dmodel add_days
            \ add_edge add_geometry add_hours add_icon add_minutes add_months
            \ add_ms add_node add_point add_seconds add_values add_weeks
            \ add_years adjacency after agent agent_closest_to agent_farthest_to
            \ agent_from_geometry agents_at_distance agents_inside agents_overlapping all_indexes_of all_match
            \ all_pairs_shortest_path all_verify alpha_index among and and
            \ angle_between any any_location_in any_point_in append_horizontally append_vertically
            \ arc around as as_4_grid as_distance_graph as_driving_graph
            \ as_edge_graph as_grid as_hexagonal_grid as_int as_intersection_graph as_map
            \ as_matrix as_path asin at at_distance at_location
            \ atan atan2 attributes auto_correlation BDIPlan before
            \ beta beta_index between betweenness_centrality biggest_cliques_of binomial
            \ binomial_coeff binomial_complemented binomial_sum blend bool box
            \ brewer_colors brewer_palettes buffer build ceil centroid
            \ char chi_square chi_square_complemented choose circle clean
            \ clean_network closest_points_with closest_to collect column_at columns_list
            \ command cone cone3D connected_components_of connectivity_index container
            \ contains[] contains_all contains_any contains_edge contains_key contains_node
            \ contains_value contains_vertex conversation convex_hull copy copy_between
            \ copy_to_clipboard corR correlation cos cos_rad count
            \ covariance covers create_map cross crosses crs
            \ CRS_transform csv_file cube curve cylinder date
            \ dbscan dead degree_of dem det determinant
            \ diff diff2 directed direction_between direction_to disjoint_from
            \ distance_between distance_to distinct distribution_of distribution2d_of div
            \ dnorm dtw durbin_watson dxf_file edge edge_between
            \ edge_betweenness edges eigenvalues electre_DM ellipse elliptical_arc
            \ emotion empty enlarged_by enter envelope eval_gaml
            \ eval_when evaluate_sub_model even every every_cycle evidence_theory_DM
            \ exp fact farthest_point_to farthest_to file file_exists
            \ first first_of first_with flip float floor
            \ folder folder_exists font frequency_of from fuzzy_choquet_DM
            \ fuzzy_kappa fuzzy_kappa_sim gaml_file gaml_type gamma gamma_density
            \ gamma_distribution gamma_distribution_complemented gamma_index gamma_rnd gamma_trunc_rnd gauss
            \ gauss_rnd generate_barabasi_albert generate_complete_graph generate_watts_strogatz geojson_file geometric_mean
            \ geometry geometry_collection get get_about get_agent get_agent_cause
            \ get_belief_op get_belief_with_name_op get_beliefs_op get_beliefs_with_name_op get_current_intention_op get_decay
            \ get_desire_op get_desire_with_name_op get_desires_op get_desires_with_name_op get_dominance get_familiarity
            \ get_ideal_op get_ideal_with_name_op get_ideals_op get_ideals_with_name_op get_intensity get_intention_op
            \ get_intention_with_name_op get_intentions_op get_intentions_with_name_op get_lifetime get_liking get_modality
            \ get_obligation_op get_obligation_with_name_op get_obligations_op get_obligations_with_name_op get_plan_name get_predicate
            \ get_solidarity get_strength get_super_intention get_trust get_truth get_uncertainties_op
            \ get_uncertainties_with_name_op get_uncertainty_op get_uncertainty_with_name_op get_values gif_file gini
            \ gml_file graph grayscale grid_at grid_cells_to_graph grid_file
            \ group_by harmonic_mean has_belief_op has_belief_with_name_op has_desire_op has_desire_with_name_op
            \ has_ideal_op has_ideal_with_name_op has_intention_op has_intention_with_name_op has_obligation_op has_obligation_with_name_op
            \ has_uncertainty_op has_uncertainty_with_name_op hexagon hierarchical_clustering horizontal hsb
            \ hypot IDW image_file in in_degree_of in_edges_of
            \ incomplete_beta incomplete_gamma incomplete_gamma_complement indented_by index_by index_of
            \ inside int inter interleave internal_at internal_integrated_value
            \ intersection intersects inverse inverse_distance_weighting inverse_rotation is
            \ is_csv is_dxf is_error is_finite is_gaml is_geojson
            \ is_gif is_gml is_grid is_image is_json is_number
            \ is_obj is_osm is_pgm is_property is_R is_saved_simulation
            \ is_shape is_skill is_svg is_text is_threeds is_warning
            \ is_xml json_file kappa kappa_sim kmeans kml
            \ kurtosis kurtosis last last_index_of last_of last_with
            \ layout_circle layout_force layout_grid length lgamma line
            \ link list list_with ln load_graph_from_file load_shortest_paths
            \ load_sub_model log log_gamma lognormal_density lognormal_rnd lognormal_trunc_rnd
            \ lower_case main_connected_component map masked_by material matrix
            \ matrix_with max max_flow_between max_of maximal_cliques_of mean
            \ mean_deviation mean_of meanR median mental_state message
            \ milliseconds_between min min_of minus_days minus_hours minus_minutes
            \ minus_months minus_ms minus_seconds minus_weeks minus_years mod
            \ moment months_between moran mul nb_cycles neighbors_at
            \ neighbors_of new_emotion new_folder new_mental_state new_predicate new_social_link
            \ node nodes none_matches none_verifies norm Norm
            \ normal_area normal_density normal_inverse normalized_rotation not not
            \ obj_file of of_generic_species of_species one_matches one_of
            \ one_verifies open_simplex_generator or or osm_file out_degree_of
            \ out_edges_of overlapping overlaps pair partially_overlaps path
            \ path_between path_to paths_between pbinom pchisq percent_absolute_deviation
            \ percentile pgamma pgm_file plan plus_days plus_hours
            \ plus_minutes plus_months plus_ms plus_seconds plus_weeks plus_years
            \ pnorm point points_along points_at points_on poisson
            \ polygon polyhedron polyline polyplan predecessors_of predicate
            \ predict product product_of promethee_DM property_file pValue_for_fStat
            \ pValue_for_tStat pyramid quantile quantile_inverse R_correlation R_file
            \ R_mean range rank_interpolated read rectangle reduced_by
            \ regression remove_duplicates remove_node_from replace replace_regex restore_simulation
            \ restore_simulation_from_file reverse rewire_n rgb rgb rms
            \ rnd rnd_choice rnd_color rotated_by rotation_composition round
            \ row_at rows_list sample Sanction save_simulation saved_simulation_file
            \ scaled_by scaled_to select serialize serialize_agent set_about
            \ set_agent set_agent_cause set_decay set_dominance set_familiarity set_intensity
            \ set_lifetime set_liking set_modality set_predicate set_solidarity set_strength
            \ set_trust set_truth set_z shape_file shuffle signum
            \ simple_clustering_by_distance simple_clustering_by_envelope_distance simplex_generator simplification sin sin_rad
            \ since skeletonize skew skew_gauss skewness skill
            \ smooth social_link solid sort sort_by source_of
            \ spatial_graph species species_of sphere split split_at
            \ split_geometry split_in split_lines split_using split_with sqrt
            \ square squircle stack standard_deviation step_sub_model strahler
            \ string student_area student_t_inverse subtract_days subtract_hours subtract_minutes
            \ subtract_months subtract_ms subtract_seconds subtract_weeks subtract_years successors_of
            \ sum sum_of svg_file tan tan_rad tanh
            \ target_of teapot text_file TGauss threeds_file to
            \ to_GAMA_CRS to_gaml to_rectangles to_segments to_squares to_sub_geometries
            \ to_triangles tokenize topology topology touches towards
            \ trace transformed_by translated_by translated_to transpose triangle
            \ triangulate truncated_gauss type_of undirected union unknown
            \ until upper_case use_cache user_input using variance
            \ variance variance_of vertical voronoi weibull_density weibull_rnd
            \ weibull_trunc_rnd weight_of weighted_means_DM where with_max_of with_min_of
            \ with_optimizer_type with_precision with_values with_weights without_holes writable
            \ xml_file xor years_between


" @ACTIONS


syn keyword gamlAction init step isConnected close timeStamp connect
            \ testConnection select executeUpdate getParameter setParameter insert
            \ update_outputs compact_memory related_to compute_forces advanced_follow_driving is_ready_next_road
            \ test_next_road compute_path path_from_nodes drive_random drive external_factor_impact
            \ speed_choice lane_choice die follow_driving goto_driving start_conversation
            \ send reply accept_proposal agree cancel cfp
            \ end_conversation failure inform propose query refuse
            \ reject_proposal request subscribe timeStamp testConnection select
            \ send wander move follow goto move
            \ execute connect fetch_message has_more_message join_group leave_group
            \ simulate_step update_lanes register unregister timeStamp getCurrentDateTime
            \ getDateOffset testConnection executeUpdate insert select list2Matrix


" @STATEMENTS

syn keyword gamlStatement = action add agents annealing ask
            \ aspect assert benchmark break camera capture
            \ catch chart conscious_contagion coping create data
            \ datalist default diffuse display display_grid display_population
            \ do draw else emotional_contagion enforcement enter
            \ equation error event exhaustive exit experiment
            \ focus focus_on genetic graphics highlight hill_climbing
            \ if image inspect law layout let
            \ light loop match migrate monitor norm
            \ output output_file overlay parameter perceive permanent
            \ plan put reactive_tabu reflex release remove
            \ return rule rule run sanction save
            \ set setup simulate socialize solve species
            \ start_simulation state status switch tabu task
            \ test trace transition try unconscious_contagion user_command
            \ user_init user_input user_panel using Variable_container Variable_number
            \ Variable_regular warn write


" @CONSTANTS

syn keyword gamlConstant #µm #micrometer #micrometers #AdamsBashforth #AdamsMoulton #aliceblue #antiquewhite
            \ #aqua #aquamarine #azure #beige #bisque #black
            \ #blanchedalmond #blue #blueviolet #bold #bottom_center #bottom_left
            \ #bottom_right #brown #burlywood #cadetblue #camera_location #camera_orientation
            \ #camera_target #center #chartreuse #chocolate #cl #centiliter #centiliters
            \ #cm #centimeter #centimeters #coral #cornflowerblue #cornsilk #crimson
            \ #current_error #custom #cyan #cycle #cycles  #darkblue #darkcyan
            \ #darkgoldenrod #darkgray #darkgreen #darkgrey #darkkhaki #darkmagenta
            \ #darkolivegreen #darkorange #darkorchid #darkred #darksalmon #darkseagreen
            \ #darkslateblue #darkslategray #darkslategrey #darkturquoise #darkviolet #day #days
            \ #deeppink #deepskyblue #dimgray #dimgrey #display_height #display_width
            \ #dl #deciliter #deciliters #dm #decimeter #decimeters #dodgerblue #DormandPrince54
            \ #dp853 #e #epoch #Euler #firebrick #flat
            \ #floralwhite #foot #feet #ft #forestgreen #fuchsia #gainsboro
            \ #ghostwhite #Gill #gold #goldenrod #GraggBulirschStoer #gram #grams
            \ #gray #green #greenyellow #grey #h #hour #hours
            \ #HighamHall54 #hl #hectoliter #hectoliters #honeydew #horizontal #hotpink
            \ #inch #inches  #indianred #indigo #infinity #iso_local #iso_offset
            \ #iso_zoned #italic #ivory #kg #kilo #kilogram#kilos
            \ #khaki #km #kilometer #kilometers #l #liter #liters #dm3
            \ #lavender #lavenderblush #lawngreen #left_center #lemonchiffon #lightblue
            \ #lightcoral #lightcyan #lightgoldenrodyellow #lightgray #lightgreen #lightgrey
            \ #lightpink #lightsalmon #lightseagreen #lightskyblue #lightslategray #lightslategrey
            \ #lightsteelblue #lightyellow #lime #limegreen #linen #longton #lton
            \ #Luther #m #meter #meters #m2 #m3 #magenta
            \ #maroon #max_float #max_int #mediumaquamarine #mediumblue #mediumorchid
            \ #mediumpurple #mediumseagreen #mediumslateblue #mediumspringgreen #mediumturquoise #mediumvioletred
            \ #midnightblue #Midpoint #mile #miles  #min_float #min_int #mintcream
            \ #minute #minutes #mn #mistyrose #mm #milimeter #milimeters #moccasin
            \ #month #months  #msec #millisecond #milliseconds#ms #nan #navajowhite
            \ #navy #nm #nanometer #nanometers #none #now #oldlace
            \  #olive #olivedrab #orange #orangered #orchid #ounce #oz
            \ #ounces #palegoldenrod #palegreen #paleturquoise #palevioletred #papayawhip
            \ #peachpuff #peru #pi #pink #pixels #px  #plain
            \ #plum #pound #lb #pounds#lbm #powderblue #purple
            \ #red #right_center #rk4 #rosybrown #round #royalblue
            \  #saddlebrown #salmon #sandybrown #seagreen #seashell #sec #second
            \ #seconds#s #shortton #ston  #sienna #silver #skyblue
            \ #slateblue #slategray #slategrey #snow #split #springgreen
            \ #sqft #square_foot #square_feet #sqin #square_inch #square_inches #sqmi #square_mile #square_miles
            \ #square #stack #steelblue #stone #st  #tan #teal
            \ #thistle #ThreeEighthes #to_deg #to_rad #tomato #ton #tons
            \ #top_center #top_left #top_right #transparent #turquoise #user_location
            \ #vertical #violet #week #weeks  #wheat #white #whitesmoke
            \ #yard #yards  #year #years #y #yellow #yellowgreen #zoom

syn keyword gamlDataType action agent attributes BDIPlan bool container
            \ conversation date emotion file float font
            \ gaml_type geometry graph int kml list
            \ map material matrix mental_state message Norm
            \ pair path point predicate regression rgb
            \ Sanction skill social_link species string topology
            \ unknown agent AgentDB base_edge experiment graph_edge
            \ graph_node physical_world world


" @STRINGS


syn region gamlString start=/"/ end=/"/
syn region gamlString start=/'/ end=/'/


" @NUMBERS


syn match gamlNumber "\v<\d+>"
syn match gamlNumber "\v<\d+\.\d+>"
syn match gamlNumber "\v<\d*\.?\d+([Ee]-?)?\d+>"
syn match gamlNumber "\v<0x\x+([Pp]-?)?\x+>"


" @COMMENTS


syn match gamlLineComment "//.*" contains=gamlTodo
syn region gamlComment matchgroup=gamlComment start="/\*" end="\*/" contains=gamlTodo,gamlComment

hi default link gamlKeyword Keyword
hi default link gamlDataType Type
hi default link gamlSpecies Type
hi default link gamlAction Function
hi default link gamlOperator Function
hi default link gamlSingleOperator Operator
hi default link gamlFacet Keyword
hi default link gamlString String
hi default link gamlImport Include
hi default link gamlLineComment Comment
hi default link gamlComment Comment
hi default link gamlNumber Number
hi default link gamlStatement Statement
hi default link gamlConstant Number
hi default link gamlTodo Todo

let b:current_syntax = 1
[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  file = psuedo_nlssi_4x.e
  partitioner = parmetis
  allow_renumbering = false
  patch_update_strategy = iteration
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[AuxVariables]
  [./slip_mag]
    order = FIRST
    family = LAGRANGE
  [../]
  [./slip_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./slip_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./slip_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./slip_accum]
    order = FIRST
    family = LAGRANGE
  [../]
  [./force_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./force_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./force_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./norm_force_mag]
    order = FIRST
    family = LAGRANGE
  [../]
  [./norm_force_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./norm_force_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./norm_force_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_force_mag]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_force_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_force_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_force_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./friction_energy]
    order = FIRST
    family = LAGRANGE
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  # Set up kernels for the soil
  [./soil_stress_x]
    type = DynamicStressDivergenceTensors
    variable = disp_x
    component = 0
    zeta = 0.001227
    block = soil
    use_displaced_mesh = true
    static_initialization = true
  [../]
  [./soil_stress_y]
    type = DynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    zeta = 0.001227
    block = soil
    use_displaced_mesh = true
    static_initialization = true
  [../]
  [./soil_stress_z]
    type = DynamicStressDivergenceTensors
    variable = disp_z
    component = 2
    zeta = 0.001227
    block = soil
    use_displaced_mesh = true
    static_initialization = true
  [../]

  # Set up kernels for the reactor
  [./reactor_stress_x]
    type = DynamicStressDivergenceTensors
    variable = disp_x
    component = 0
    zeta = 1.7684e-4
    block = reactor
    use_displaced_mesh = true
    static_initialization = true
  [../]
  [./reactor_stress_y]
    type = DynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    zeta = 1.7684e-4
    block = reactor
    use_displaced_mesh = true
    static_initialization = true
  [../]
  [./reactor_stress_z]
    type = DynamicStressDivergenceTensors
    variable = disp_z
    component = 2
    zeta = 1.7684e-4
    block = reactor
    use_displaced_mesh = true
    static_initialization = true
  [../]

  # apply gravity with static_initialization
  [./gravity]
    type = Gravity
    value = -9.81
    variable = disp_z
  [../]
[]

[AuxKernels]
  # set up auxillary kernels for contact variables
  [./slip_mag]
    type = PenetrationAux
    variable = slip_mag
    quantity = incremental_slip_magnitude
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./slip_x]
    type = PenetrationAux
    variable = slip_x
    quantity = incremental_slip_x
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./slip_y]
    type = PenetrationAux
    variable = slip_y
    quantity = incremental_slip_y
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./slip_z]
    type = PenetrationAux
    variable = slip_z
    quantity = incremental_slip_z
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./slip_accum]
    type = PenetrationAux
    variable = slip_accum
    quantity = accumulated_slip
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./force_x]
    type = PenetrationAux
    variable = force_x
    quantity = force_x
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./force_y]
    type = PenetrationAux
    variable = force_y
    quantity = force_y
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./force_z]
    type = PenetrationAux
    variable = force_z
    quantity = force_z
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./norm_force_mag]
    type = PenetrationAux
    variable = norm_force_mag
    quantity = normal_force_magnitude
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./norm_force_x]
    type = PenetrationAux
    variable = norm_force_x
    quantity = normal_force_x
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./norm_force_y]
    type = PenetrationAux
    variable = norm_force_y
    quantity = normal_force_y
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./norm_force_z]
    type = PenetrationAux
    variable = norm_force_z
    quantity = normal_force_z
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./tang_force_mag]
    type = PenetrationAux
    variable = tang_force_mag
    quantity = tangential_force_magnitude
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./tang_force_x]
    type = PenetrationAux
    variable = tang_force_x
    quantity = tangential_force_x
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./tang_force_y]
    type = PenetrationAux
    variable = tang_force_y
    quantity = tangential_force_y
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./tang_force_z]
    type = PenetrationAux
    variable = tang_force_z
    quantity = tangential_force_z
    boundary = reactor_bottom
    paired_boundary = top
  [../]
  [./friction_energy]
    type = PenetrationAux
    variable = friction_energy
    quantity = frictional_energy
    boundary = reactor_bottom
    paired_boundary = top
  [../]

  # Set up auxillary kernels for stress-strain tensors
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 1
    index_j = 0
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 2
    index_j = 1
  [../]
  [./stress_zx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zx
    index_i = 0
    index_j = 2
  [../]
  [./strain_xy]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = stress_xy
    index_i = 1
    index_j = 0
  [../]
  [./strain_yz]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yz
    index_i = 2
    index_j = 1
  [../]
  [./strain_zx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_zx
    index_i = 0
    index_j = 2
  [../]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_yy]
    type = RankTwoAux
    rank_two_tensor =total_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./strain_zz]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_zz
    index_i = 2
    index_j = 2
  [../]
[]

[Materials]
  [./soil_elastic_moduli]
    type = ComputeIsotropicElasticityTensor
    shear_modulus = 1.4615e7
    poissons_ratio = 0.3
    block = soil
    use_displaced_mesh = true
  [../]
  [./concrete_elastic_moduli]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 3.800e10
    poissons_ratio = 0.15
    block = reactor
    use_displaced_mesh = true
  [../]
  [./strain_tensor]
    type = ComputeFiniteStrain
  [../]
  [./stress_tensor]
    type = ComputeFiniteStrainElasticStress
  [../]
  [./soil_density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2.0700e3
    block = soil
    use_displaced_mesh = true
  [../]
  [./concrete_density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2402.7695 # approx 150pcf (normalweight concrete)
    block = reactor
    use_displaced_mesh = true
  [../]
[]

[BCs]
  [./fix_bottom_y]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
    use_displaced_mesh = true
  [../]
  [./fix_bottom_z]
    type = PresetBC
    variable = disp_z
    boundary = bottom
    value = 0.0
    use_displaced_mesh = true
  [../]
  [./fix_bottom_x]
    type = PresetBC
    variable = disp_x
    boundary = bottom
    value = 0.0
    use_displaced_mesh = true
  [../]
  [./Periodic]
    [./x_dir]
      variable = 'disp_x disp_y disp_z'
      primary = left
      secondary = right
      translation = '28.8 0.0 0.0'
    [../]
    [./y_dir]
      variable = 'disp_x disp_y disp_z'
      primary = front
      secondary = back
      translation = '0.0 28.8 0.0'
    [../]
  [../]
[]

[Contact]
  [./ssi_contact]
    slave = reactor_bottom
    master = top # make coarser mesh the master
    model = coulomb
    friction_coefficient = 0.5
    formulation = penalty
    penalty = 1.0e8
    normalize_penalty = true
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-6
  l_tol = 1e-8
  l_max_its = 250
  num_steps = 1
  line_search = contact
  contact_line_search_ltol = 1e-6
  contact_line_search_allowed_lambda_cuts = 3
  petsc_options = '-snes_ksp_ew -snes_monitor -snes_linesearch_monitor -snes_converged_reason'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = ' 201                hypre    boomeramg      4'
[]

[Outputs]
  perf_graph = true
  [./exodus]
    type = Exodus
    file_base = ../../../../../../../scratch/wongchri/efe/psuedo_models/psuedo_nlssi_4x/gravity_out # write to scratch storage
  [../]
  [./initialize]
    type = Checkpoint
  [../]
[]

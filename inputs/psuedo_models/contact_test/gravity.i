[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  file = contact_test.e
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
    use_displaced_mesh = true
  [../]
[]

[AuxKernels]
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
  [../]
  [./concrete_elastic_moduli]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 3.800e10
    poissons_ratio = 0.15
    block = reactor
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
  [../]
  [./concrete_density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2402.7695 # approx 150pcf (normalweight concrete)
    block = reactor
  [../]
[]

[BCs]
  [./fix_bottom_y]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
  [./fix_bottom_z]
    type = PresetBC
    variable = disp_z
    boundary = bottom
    value = 0.0
  [../]
  [./fix_bottom_x]
    type = PresetBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  [../]
  [./Periodic]
    [./x_dir]
      variable = 'disp_x disp_y disp_z'
      primary = left
      secondary = right
      translation = '2.4 0.0 0.0'
    [../]
    [./y_dir]
      variable = 'disp_x disp_y disp_z'
      primary = front
      secondary = back
      translation = '0.0 2.4 0.0'
    [../]
  [../]
[]

[Contact]
  [./ssi_contact]
    slave = reactor_bottom
    master = top # make coarser mesh the master
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
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
  start_time = 0.0
  end_time = 0.001
  dt = 0.001
  timestep_tolerance = 1e-6
  line_search = default
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       superlu_dist'
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
  [./initialize]
    type = Checkpoint
    num_files = 1
  [../]
[]

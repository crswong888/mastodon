[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  file = psuedo_ssi_2x.e
  partitioner = parmetis
  allow_renumbering = false
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
  [./vel_x]
  [../]
  [./accel_x]
  [../]
  [./vel_y]
  [../]
  [./accel_y]
  [../]
  [./vel_z]
  [../]
  [./accel_z]
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
    static_initialization = true
    block = soil
  [../]
  [./soil_stress_y]
    type = DynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    zeta = 0.001227
    static_initialization = true
    block = soil
  [../]
  [./soil_stress_z]
    type = DynamicStressDivergenceTensors
    variable = disp_z
    component = 2
    zeta = 0.001227
    static_initialization = true
    block = soil
  [../]

  [./soil_inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    eta = 0.7267
    block = soil
  [../]
  [./soil_inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    eta = 0.7267
    block = soil
  [../]
  [./soil_inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    eta = 0.7267
    block = soil
  [../]

  # Set up kernels for the reactor
  [./reactor_stress_x]
    type = DynamicStressDivergenceTensors
    variable = disp_x
    component = 0
    zeta = 1.7684e-4
    static_initialization = true
    block = reactor
  [../]
  [./reactor_stress_y]
    type = DynamicStressDivergenceTensors
    variable = disp_y
    component = 1
    zeta = 1.7684e-4
    static_initialization = true
    block = reactor
  [../]
  [./reactor_stress_z]
    type = DynamicStressDivergenceTensors
    variable = disp_z
    component = 2
    zeta = 1.7684e-4
    static_initialization = true
    block = reactor
  [../]

  [./reactor_inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]
  [./reactor_inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]
  [./reactor_inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]

  # apply gravity with static_initialization
  [./gravity]
    type = Gravity
    value = -9.81
    variable = disp_z
  [../]
[]

[AuxKernels]
  # Set up dynamic auxillary kernels
  [./accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = timestep_end
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

[Functions]
  [./vel_input]
    type = PiecewiseLinear
    data_file = ../10hz.csv # IF(t<1.025, .03*2*pi*f*cos(2*pi*f*t), 0)
    format = columns
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
    type = ComputeSmallStrain
  [../]
  [./stress_tensor]
    type = ComputeLinearElasticStress
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
  [./apply_vel_x]
    type = PresetVelocity
    variable = disp_x
    boundary = bottom
    function = vel_input
  [../]
  [./Periodic]
    [./x_dir]
      variable = 'disp_x disp_y disp_z'
      primary = left
      secondary = right
      translation = '14.4 0.0 0.0'
    [../]
    [./y_dir]
      variable = 'disp_x disp_y disp_z'
      primary = front
      secondary = back
      translation = '0.0 14.4 0.0'
    [../]
  [../]

  # BC to be enabled during gravity initialization to prevent displacement
  # due to Poisson's effect and the PeriodicBC
  [./initial_fix_x]
    type = PresetBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  [../]
[]

[Controls] # turns off inertial terms for the first time step
  [./initialize_gravity]
    type = TimePeriod
    enable_objects = '*/initial_fix_x'
    disable_objects = '*/vel_x */vel_y */vel_z */accel_x */accel_y */accel_z
    */soil_inertia_x */soil_inertia_y */soil_inertia_z */reactor_inertia_x
    */reactor_inertia_y */reactor_inertia_z'
    start_time = 0.0
    end_time = 0.001
  [../]
[../]

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
  end_time = 2.5
  dt = 0.001
  timestep_tolerance = 1e-6
  line_search = none
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  petsc_options_value = ' 201                hypre    boomeramg'
[]

[Postprocessors]
  # Set up postprocessors for the soil
  [./soil_bottom_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = bottom
  [../]
  [./soil_bottom_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = bottom
  [../]
  [./soil_bottom_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = bottom
  [../]

  [./soil_top_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = top
  [../]
  [./soil_top_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = top
  [../]
  [./soil_top_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = top
  [../]

  [./soil_relative_disp_x]
    type = DifferencePostprocessor
    value1 = soil_top_disp_x
    value2 = soil_bottom_disp_x
  [../]
  [./soil_relative_vel_x]
    type = DifferencePostprocessor
    value1 = soil_top_vel_x
    value2 = soil_bottom_vel_x
  [../]
  [./soil_relative_accel_x]
    type = DifferencePostprocessor
    value1 = soil_top_accel_x
    value2 = soil_bottom_accel_x
  [../]

  # Set up postprocessors for the reactor
  [./reactor_bottom_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = reactor_bottom
  [../]
  [./reactor_bottom_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = reactor_bottom
  [../]
  [./reactor_bottom_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = reactor_bottom
  [../]

  [./reactor_top_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = reactor_top
  [../]
  [./reactor_top_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = reactor_top
  [../]
  [./reactor_top_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = reactor_top
  [../]

  [./reactor_relative_disp_x]
    type = DifferencePostprocessor
    value1 = reactor_top_disp_x
    value2 = reactor_bottom_disp_x
  [../]
  [./reactor_relative_vel_x]
    type = DifferencePostprocessor
    value1 = reactor_top_vel_x
    value2 = reactor_bottom_vel_x
  [../]
  [./reactor_relative_accel_x]
    type = DifferencePostprocessor
    value1 = reactor_top_accel_x
    value2 = reactor_bottom_accel_x
  [../]
[]

[VectorPostprocessors]
  # Set up response spectrum calculator for the soil
  [./soil_accel_hist]
    type = ResponseHistoryBuilder
    variables = accel_x
    nodes = '47879 47898 168 55483 64215 25821' # corner, edge, and center at the top and middle
  [../]
  [./soil_spectrum]
    type = ResponseSpectraCalculator
    vectorpostprocessor = soil_accel_hist
    regularize_dt = 0.001
    end_frequency = 30.0
    num_frequencies = 3.0E3
    outputs = soil_spectrum
    damping_ratio = 0.06
  [../]

  # Set up the response spectrum calculator for the reactor
  [./reactor_accel_hist]
    type = ResponseHistoryBuilder
    variables = accel_x
    nodes = '123577 128381 123535 123924 123602' # top front/center/right and mid front/right
  [../]
  [./reactor_spectrum]
    type = ResponseSpectraCalculator
    vectorpostprocessor = reactor_accel_hist
    regularize_dt = 0.001
    end_frequency = 100
    num_frequencies = 1.0E4
    outputs = reactor_spectrum
    damping_ratio = 0.04
  [../]
[]

[Outputs]
  exodus = true
  perf_graph = true
  [./screen]
    type = Console
    interval = 10
    hide = 'soil_relative_disp_x soil_relative_vel_x soil_relative_accel_x
    reactor_relative_disp_x reactor_relative_vel_x reactor_relative_accel_x'
  [../]
  [./soil_history]
    type = CSV
    file_base = ./spreadsheets/10hz_soil_history
    show = 'soil_bottom_disp_x soil_bottom_vel_x soil_bottom_accel_x
    soil_top_disp_x soil_top_vel_x soil_top_accel_x soil_relative_disp_x
    soil_relative_vel_x soil_relative_accel_x'
    execute_vector_postprocessors_on = NONE
  [../]
  [./reactor_history]
    type = CSV
    file_base = ./spreadsheets/10hz_reactor_history
    show = 'reactor_bottom_disp_x reactor_bottom_vel_x reactor_bottom_accel_x
    reactor_top_disp_x reactor_top_vel_x reactor_top_accel_x
    reactor_relative_disp_x reactor_relative_vel_x reactor_relative_accel_x'
    execute_vector_postprocessors_on = NONE
  [../]
  [./soil_spectrum]
    type = CSV
    file_base = ./spreadsheets/10hz
    show = soil_spectrum
    execute_on = FINAL
    execute_postprocessors_on = NONE
  [../]
  [./reactor_spectrum]
    type = CSV
    file_base = ./spreadsheets/10hz_
    show = reactor_spectrum
    execute_on = FINAL
    execute_postprocessors_on = NONE
  [../]
[]

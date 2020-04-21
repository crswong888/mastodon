[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  file = psuedo_reactor.e
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
[]

[Kernels]
  [./DynamicTensorMechanics]
    zeta = 1.7684e-4
    block = reactor
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]
  [./inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    eta = 5.5851
    block = reactor
  [../]
[]

[AuxKernels]
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
[]

[Functions]
  [./vel_input]
    type = PiecewiseLinear
    data_file = ../9hz.csv # IF(t<2.25, .05*2*pi*f*cos(2*pi*f*t), 0)
    format = columns
  [../]
[]

[Materials]
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
  [./concrete_density]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2402.7695 # approx 150pcf (normalweight concrete)
    block = reactor
  [../]
[]

[BCs]
  [./fixx]
    type = PresetBC
    variable = disp_x
    value = 0.0
    boundary = reactor_bottom
  [../]
  [./fixy]
    type = PresetBC
    variable = disp_y
    value = 0.0
    boundary = reactor_bottom
  [../]
  [./fixz]
    type = PresetBC
    variable = disp_z
    value = 0.0
    boundary = reactor_bottom
  [../]
  [./apply_vel_x]
    type = PresetVelocity
    variable = disp_x
    displacements = disp_x
    boundary = reactor_bottom
    function = vel_input
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
  solve_type = NEWTON
  nl_abs_tol = 1e-6
  l_tol = 1e-8
  start_time = 0.0
  end_time = 5.0
  dt = 0.01
  timestep_tolerance = 1e-6
  line_search = none
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type'
  petsc_options_value = ' 201                hypre    boomeramg'
  scheme = explicit-euler
[]

[Postprocessors]
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
  [./reactor_accel_hist]
    type = ResponseHistoryBuilder
    variables = accel_x
    nodes = '1554 6863 1512 1901 1579' # top front/center/right and mid front/right
  [../]
  [./reactor_spectrum]
    type = ResponseSpectraCalculator
    vectorpostprocessor = reactor_accel_hist
    regularize_dt = 0.01
    end_frequency = 50.0
    num_frequencies = 5.0E3
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
    hide = 'reactor_relative_disp_x reactor_relative_vel_x
    reactor_relative_accel_x'
  [../]
  [./reactor_history]
    type = CSV
    file_base = ./spreadsheets/9hz_reactor_history
    hide = 'reactor_accel_hist reactor_spectrum'
  [../]
  [./reactor_spectrum]
    type = CSV
    file_base = ./spreadsheets/9hz
    show = reactor_spectrum
    execute_on = FINAL
  [../]
[]

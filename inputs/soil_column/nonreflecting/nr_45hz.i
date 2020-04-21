# NOTE: There is a NonReflectingBC at the top surface

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  file = ../isolated_column.e
[]

[MeshModifiers]
  [./boundaries]
    type = AddAllSideSetsByNormals
  [../]
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
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
  [../]
  [./inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
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
    data_file = ../45hz.csv # IF(t<2.05, 2*pi*f*cos(2*pi*f*t), 0)
    format = columns
  [../]
[]

[BCs]
  [./fix_bottom_y]
    type = PresetBC
    variable = disp_y
    boundary = 6
    value = 0.0
  [../]
  [./fix_bottom_z]
    type = PresetBC
    variable = disp_z
    boundary = 6
    value = 0.0
  [../]
  [./apply_vel_x]
    type = PresetVelocity
    function = vel_input
    variable = disp_x
    displacements = 'disp_x'
    boundary = 6
  [../]
  [./Periodic]
    [./x_dir]
      variable = 'disp_x disp_y disp_z'
      primary = 1
      secondary = 4
      translation = '14.1309814453 0.0 0.0'
    [../]
    [./y_dir]
      variable = 'disp_x disp_y disp_z'
      primary = 3
      secondary = 2
      translation = '0.0 11.9489746094 0.0'
    [../]
  [../]
  [./NonReflectingBC]
    [./top]
      p_wave_speed = 21944.65
      shear_wave_speed = 12972.15
      density = 5.1418e-3
      beta = 0.25
      gamma = 0.5
      boundary = 5
      displacements = 'disp_x disp_y disp_z'
      velocities = 'vel_x vel_y vel_z'
      accelerations = 'accel_x accel_y accel_z'
    [../]
  [../]
[]

[Materials]
  [./all_soil_material]
    type = ComputeIsotropicElasticityTensor
    shear_modulus = '784505.46'
    poissons_ratio = '0.268182'
  [../]
  [./all_soil_strain]
    type = ComputeSmallStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./all_soil_stress]
    type = ComputeLinearElasticStress
  [../]
  [./soil_density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '5.1418e-3'
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
  dt = 0.001
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  l_tol = 1e-8
  start_time = 0.0
  end_time = 3.0
  timestep_tolerance = 1e-6
  line_search = 'none'
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = ' 201                hypre    boomeramg      4'
[]

[Postprocessors]
  [./bottom_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = 6
  [../]
  [./bottom_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = 6
  [../]
  [./bottom_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = 6
  [../]

  [./top_disp_x]
    type = NodalMaxValue
    variable = disp_x
    boundary = 5
  [../]
  [./top_vel_x]
    type = NodalMaxValue
    variable = vel_x
    boundary = 5
  [../]
  [./top_accel_x]
    type = NodalMaxValue
    variable = accel_x
    boundary = 5
  [../]

  [./relative_disp_x]
    type = DifferencePostprocessor
    value1 = top_disp_x
    value2 = bottom_disp_x
  [../]
  [./relative_vel_x]
    type = DifferencePostprocessor
    value1 = top_vel_x
    value2 = bottom_vel_x
  [../]
  [./relative_accel_x]
    type = DifferencePostprocessor
    value1 = top_accel_x
    value2 = bottom_accel_x
  [../]
[]

[VectorPostprocessors]
  [./accel_hist]
    type = ResponseHistoryBuilder
    variables = accel_x
    nodes = '50 105' # one near the mid-point and one at the very top
  [../]
  [./spectrum]
    type = ResponseSpectraCalculator
    vectorpostprocessor = accel_hist
    regularize_dt = 0.001
    outputs = spectrum
    damping_ratio = 1E-12
  [../]
[]

[Outputs]
  exodus = true
  perf_graph = true
  [./screen]
    type = Console
    interval = 10
    hide = 'relative_disp_x relative_vel_x relative_accel_x'
  [../]
  [./history]
    type = CSV
    file_base = ./spreadsheets/nr_45hz_history
    hide = 'accel_hist spectrum'
  [../]
  [./spectrum]
    type = CSV
    file_base = ./spreadsheets/nr_45hz
    show = spectrum
    execute_on = FINAL
  [../]
[]

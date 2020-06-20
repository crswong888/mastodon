[Mesh]
  type = FileMesh
  file = solidbottom_1layer_overlap_bar.e
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./rot_x]
    block = '2'
  [../]
  [./rot_y]
    block = '2'
  [../]
  [./rot_z]
    block = '2'
  [../]
[]

[AuxVariables]
  [./vel_x]
  [../]
  [./vel_y]
  [../]
  [./vel_z]
  [../]
  [./accel_x]
  [../]
  [./accel_y]
  [../]
  [./accel_z]
  [../]
  [./rot_vel_x]
    block = '2'
  [../]
  [./rot_vel_y]
    block = '2'
  [../]
  [./rot_vel_z]
    block = '2'
  [../]
  [./rot_accel_x]
    block = '2'
  [../]
  [./rot_accel_y]
    block = '2'
  [../]
  [./rot_accel_z]
    block = '2'
  [../]
  [./layer_id]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]

[Kernels]
  [./DynamicTensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    zeta = 0     # stiffness proportional damping
    block = 1
  [../]
  [./inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    eta = 0      # Mass proportional Rayleigh damping
    block = 1
  [../]
  [./inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    eta = 0     # Mass proportional Rayleigh damping
    block = 1
  [../]
  [./inertia_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    eta = 0      # Mass proportional Rayleigh damping
    block = 1
  [../]
[]

[AuxKernels]
  [./accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = 'timestep_end'
  [../]
  [./vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = 'timestep_end'
  [../]
  [./accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = 'timestep_end'
  [../]
  [./vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = 'timestep_end'
  [../]
  [./accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = 'timestep_end'
  [../]
  [./vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = 'timestep_end'
  [../]
  [./layer_id]
     type = UniformLayerAuxKernel
     variable = layer_id
     block = 1
     interfaces = '1 2 3 4 5'
     direction = '0.0 0.0 1.0'
     execute_on = initial
  [../]

[]

[Modules/TensorMechanics/LineElementMaster]
#    add_variables = true
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'

    # dynamic simulation using consistent mass/inertia matrix
    dynamic_consistent_inertia = true

    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'

    beta = 0.25 # Newmark time integration parameter
    gamma = 0.5 # Newmark time integration parameter

    [./block_2]
        block = 2
        area = 1400
        Iy = 2.8e6
        Iz = 2.8e6
        density = 0.493
        y_orientation = '0.0 1.0 0.0'
    [../]
[]

[Materials]
  [./elasticity_beam]
    type = ComputeElasticityBeam
    youngs_modulus = 6.9e5
    poissons_ratio = 0.278
    shear_coefficient = 0.5
    block = '2'
  [../]
  [./stress_beam]
    type = ComputeBeamResultants
    block = '2'
  [../]
  [./linear]
      type = ComputeIsotropicElasticityTensorSoil
      block = 1
      layer_variable = layer_id
      layer_ids = '0 1 2 3 4'
      density = '0.00367 0.00367 0.00367 0.00367 0.00367'
      shear_modulus = '46058.28      45635.44      45261.62        44876.52        44479.33'
      poissons_ratio = '0.3 0.3 0.3 0.3 0.3'
  [../]
  [./strain_1]
    type = ComputeSmallStrain
    block = 1
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./stress_1]
    type = ComputeLinearElasticStress
    block = 1
  [../]
[]

[BCs]
  [./disp_x]
    type = PresetAcceleration
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    function = accel_x
    boundary = '100'
  [../]
  [./disp_y]
    type = PresetAcceleration
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    function = accel_y
    boundary = '100'
  [../]
  [./disp_z]
    type = PresetAcceleration
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    function = accel_z
    boundary = '100'
  [../]
  [./rot_x]
    type = DirichletBC
    boundary = '1002'
    variable = rot_x
    value = 0.0
  [../]
  [./rot_y]
    type = DirichletBC
    boundary = '1002'
    variable = rot_y
    value = 0.0
  [../]
  [./rot_z]
    type = DirichletBC
    boundary = '1002'
    variable = rot_z
    value = 0.0
  [../]
[]

[Functions]
  [./accel_x]
    type = PiecewiseLinear
    data_file = 'accel_x.csv'
    format = columns
  [../]
  [./accel_y]
    type = PiecewiseLinear
    data_file = 'accel_y.csv'
    format = columns
  [../]
  [./accel_z]
    type = PiecewiseLinear
    data_file = 'accel_z.csv'
    format = columns
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'
  end_time = 5.0
  dt = 0.005
  dtmin = 0.001
  nl_abs_tol = 1e-06
  nl_rel_tol = 1e-06
  l_tol = 1e-06
  l_max_its = 20
  timestep_tolerance = 1e-06
[]

[Postprocessors]
[]

[VectorPostprocessors]
[]

[Outputs]
  [./out]
    type = CSV
    execute_on = 'final'
    file_base = matfoundation_response
  [../]
  exodus = true
  [./console]
    type = Console
    max_rows = 1
  [../]

[]

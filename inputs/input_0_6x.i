[Mesh]
  type = FileMesh
  # file = SSI_model.e
  file = 0_6x.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  # [./rot_x]
  # [../]
  # [./rot_y]
  # [../]
  # [./rot_z]
  # [../]
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
  [./stress_xx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = FIRST
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = FIRST
    family = MONOMIAL
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
  [./velocity_x]
    type = PiecewiseLinear
    data_file = 'input_vel_x.csv'
    format = columns
    scale_factor = '1'
  [../]
  [./velocity_y]
    type = PiecewiseLinear
    data_file = 'input_vel_y.csv'
    format = columns
    scale_factor = '1'
  [../]
  [./velocity_z]
    type = PiecewiseLinear
    data_file = 'input_vel_z.csv'
    format = columns
    scale_factor = '1'
  [../]
[]

[BCs]
 #  [./NonReflectingBC]
 #   [./back]
 #     displacements = 'disp_x disp_y disp_z'
 #     velocities = 'vel_x vel_y vel_z'
 #     accelerations = 'accel_x accel_y accel_z'
 #     beta = 0.25
 #     gamma = 0.5
 #     boundary = '1'
 #     shear_wave_speed = 3.0930e05  #784505.46/(2*(1+0.268182))
 #     p_wave_speed = 1.6921e06 #(784505.46*(1+0.268182))/((1+0.268182)*(1-2*0.268182))
 #     density = 5.1418e-3
 #   [../]
 # [../]
 [./Periodic]
   [./y_dir]
     variable = 'disp_y'
     primary = '2'
     secondary = '3'
     translation = '0 2400 0'
   [../]
   [./x_dir]
     variable = 'disp_x'
     primary = '5'
     secondary = '4'
     translation = '2100 0 0'
   [../]
 [../]
 [./motion_x]
     type = PresetVelocity
     variable = disp_x
     boundary = '1'
     function = velocity_x
  [../]
  [./motion_y]
      type = PresetVelocity
      variable = disp_y
      boundary = '1'
      function = velocity_y
  [../]
  [./motion_z]
     type = PresetVelocity
     variable = disp_z
     boundary = '1'
     function = velocity_z
  [../]
#  [./disp_y]
#    type = DirichletBC
#    boundary = '1'
#    variable = disp_y
#    value = 0.0
#  [../]
#  [./disp_z]
#    type = DirichletBC
#    boundary = '1'
#    variable = disp_z
#    value = 0.0
#  [../]
[]

# [Contact]
#   [./soil_structure]
#     slave = 'SSI_STRUCT'
#     master = 'SSI_SOIL'
#     system = constraint
#     normalize_penalty = true
#     tangential_tolerance = 1e-3
#     penalty = 1e+9
#     model = 'glued'
#     formulation = 'kinematic'
#   [../]
# []

[Materials]
  [./all_soil_material]
    type = ComputeIsotropicElasticityTensor
    block = '4 5'
    shear_modulus = '784505.46'
    poissons_ratio = '0.268182'
  [../]
  [./all_soil_strain]
    type = ComputeSmallStrain
    block = '4 5'
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./all_soil_stress]
    type = ComputeLinearElasticStress
    block = '4 5'
  [../]
  [./soil_density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '5.1418e-3'
    block = '4 5'
  [../]

  [./concrete_material]
    type = ComputeIsotropicElasticityTensor
    block = '1 2 3'
    shear_modulus = '2.391e5'
    poissons_ratio = '0.17'
  [../]
  [./concrete_strain]
    type = ComputeSmallStrain
    block = '1 2 3'
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./concrete_stress]
    type = ComputeLinearElasticStress
    block = '1 2 3'
  [../]
  [./concrete_density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '0.004662'
    block = '1 2 3'
  [../]

  # [./concrete_beam_material]
  #   type = ComputeElasticityBeam
  #   youngs_modulus = '2.391e5'
  #   poissons_ratio = '0.17'
  #   shear_coefficient = 1.0
  #   block = '3'
  # [../]
  # [./concrete_beam_density]
  #   type = GenericConstantMaterial
  #   prop_names = 'density'
  #   prop_values = '0.004662'
  #   block = '3'
  # [../]
  #
  # [./heat_exch_material]
  #   type = ComputeElasticityBeam
  #   youngs_modulus = 2.79900e07
  #   poissons_ratio = 0.25
  #   shear_coefficient = 1.0
  #   block = '4'
  # [../]
  # [./heat_exch_density]
  #   type = GenericConstantMaterial
  #   prop_names = 'density'
  #   prop_values = '0.015'
  #   block = '4'
  # [../]
  #
  # [./reactor_material]
  #   type = ComputeElasticityBeam
  #   youngs_modulus = 2.79900e07
  #   poissons_ratio = 0.25
  #   shear_coefficient = 1.0
  #   block = '5'
  # [../]
  # [./reactor_density]
  #   type = GenericConstantMaterial
  #   prop_names = 'density'
  #   prop_values = '0.015'
  #   block = '5'
  # [../]
[]

# [Modules/TensorMechanics/LineElementMaster]
#   # parameters common to all blocks
#   add_variables = true
#   displacements = 'disp_x disp_y disp_z'
#   rotations = 'rot_x rot_y rot_z'
#   # [./BEAM4] #rectangle
#   #   y_orientation = '0 0 1'
#   #   area = 125 #50*2.5
#   #   Iy = 65.1 #50*2.5^3*(1/12)
#   #   Iz = 2.6042e+04 #50^3*2.5*(1/12)
#   #   block = 3
#   # [../]
#   [./BEAM400] #pipe
#     y_orientation = '0 0 1'
#     area = 87.1792 #pi*(10^2-(10-1.5)^2)
#     Iy = 3.7542e+03 #pi*(10^4-(10-1.5)^4)*(1/4)
#     Iz = 3.7542e+03 #pi*(10^4-(10-1.5)^4)*(1/4)
#     block = 3
#   [../]
#   [./BEAM4_1] #Pipe
#     y_orientation = '0 1 0'
#     area = 62.0465 #pi*(20^2-(20-.5)^2)
#     Iy = 1.2103e+04 #pi*(20^4-(20-.5)^4)*(1/4)
#     Iz = 1.2103e+04 #pi*(20^4-(20-.5)^4)*(1/4)
#     block = 4
#   [../]
#   [./BEAM4_2] #Pipe
#     y_orientation = '0 1 0'
#     area = 18.6532 #pi*(12^2-(12-.25)^2)
#     Iy = 1.3153e+03 #pi*(12^4-(12-.25)^4)*(1/4)
#     Iz = 1.3153e+03 #pi*(12^4-(12-.25)^4)*(1/4)
#     block = 5
#   [../]
# []

[VectorPostprocessors]
  [./displacements]
    type = ResponseHistoryBuilder
    variables = 'disp_x disp_y disp_z'
    nodes = '921227 410356 410355 545588 578992 594555 16096 5009 6094 22340 21252 20873 22459 21267'
  [../]
  [./velocities]
    type = ResponseHistoryBuilder
    variables = 'vel_x vel_y vel_z'
    nodes = '921227 410356 410355 545588 578992 594555 16096 5009 6094 22340 21252 20873 22459 21267'
  [../]
  [./accelerations]
    type = ResponseHistoryBuilder
    variables = 'accel_x accel_y accel_z'
    nodes = '921227 410356 410355 545588 578992 594555 16096 5009 6094 22340 21252 20873 22459 21267'
  [../]
  [./accel_spec]
    type = ResponseSpectraCalculator
    vectorpostprocessor = accelerations
    regularize_dt = 0.005
    outputs = out
  [../]
[]

[Preconditioning]
  [precon]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  dt = 0.005
  dtmin = .0025
  l_max_its = 100
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  l_tol = 1e-10
  end_time = 40.955
  line_search = 'none'
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = ' 201                hypre    boomeramg      4'
[]

[Outputs]
  perf_graph = true
  [./out1]
    type = Exodus
    interval = 40
  [../]
  [./out]
    type = CSV
    execute_on = 'final'
  [../]
[]

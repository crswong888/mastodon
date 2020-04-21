# Checks the mesh sensitivity of the reactor model by applying two
# arbitrary point loads and measuring the deflections at various
# locations

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  type = FileMesh
  #file = default.e
  #file = split1.e
  #file = split2.e
  #file = split3.e #this mesh is simply too coarse for memory purposes
  partitioner = parmetis
  allow_renumbering = false
[]

[MeshModifiers]
  [./left_node]
    type = AddExtraNodeset
    new_boundary = left_node
    coord = '-3.6 0 4.8'
    tolerance = 1e-12
  [../]
  [./center_node]
    type = AddExtraNodeset
    new_boundary = center_node
    coord = '0 0 4.8'
    tolerance = 1e-12
  [../]
  [./right_node]
    type = AddExtraNodeset
    new_boundary = right_node
    coord = '3.6 0 4.8'
    tolerance = 1e-12
  [../]
  [./mid_left_node]
    type = AddExtraNodeset
    new_boundary = mid_left_node
    coord = '-3.6 0 0'
    tolerance = 1e-12
  [../]
  [./mid_right_node]
    type = AddExtraNodeset
    new_boundary = mid_right_node
    coord = '3.6 0 0'
    tolerance = 1e-12
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    add_variables = true
  [../]
[]

[Functions]
  [./point_load_left]
    type = ConstantFunction
    value = 1.0e5
  [../]
  [./point_load_right]
    type = ConstantFunction
    value = 1.5e5
  [../]
[]

[NodalKernels]
  [./load_left_x]
    type = UserForcingFunctionNodalKernel
    variable = disp_x
    function = point_load_left
    boundary = left_node
  [../]
  [./load_right_x]
    type = UserForcingFunctionNodalKernel
    variable = disp_x
    function = point_load_right
    boundary = right_node
  [../]
[]

[Materials]
  [./elastic_moduli]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 3.800e10
    poissons_ratio = 0.15
  [../]
  [./stress_tensor]
    type = ComputeLinearElasticStress
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
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -snes_atol -snes_rtol
                     -snes_max_it -ksp_atol -ksp_rtol -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm lu 1E-8 1E-8 25 1E-8 1E-8 NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = explicit-euler
  num_steps = 1
[]

[Postprocessors]
  [./displacement_top_left]
    type = NodalMaxValue
    variable = disp_x
    boundary = left_node
  [../]
  [./displacement_top_center]
    type = NodalMaxValue
    variable = disp_x
    boundary = center_node
  [../]
  [./displacement_top_right]
    type = NodalMaxValue
    variable = disp_x
    boundary = right_node
  [../]
  [./displacement_mid_left]
    type = NodalMaxValue
    variable = disp_x
    boundary = mid_left_node
  [../]
  [./displacement_mid_right]
    type = NodalMaxValue
    variable = disp_x
    boundary = mid_right_node
  [../]
[]

[Outputs]
  exodus = true
  perf_graph = true
[]

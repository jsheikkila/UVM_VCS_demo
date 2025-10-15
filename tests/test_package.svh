`ifndef __TEST_PACKAGE_SV__
 `define __TEST_PACKAGE_SV__

 package test_package;

  import uvm_pkg::*;
  import tb_package::*;

  `include "uvm_macros.svh"

`include "test1.svh"
`include "test2.svh"


endpackage: test_package
`endif

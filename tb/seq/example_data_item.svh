// This is the base transaction object that will be used
// in the environment to initiate new transactions and
// capture transactions at DUT interface
`include "tb_package.svh"
`ifndef __example_data_item_SV__
 `define __example_data_item_SV__
class example_data_item extends uvm_sequence_item;
  rand bit [7:0]  	addr;
  rand bit [15:0] 	data;
  bit [7:0] 		addr_a;
  bit [15:0] 		data_a;
  constraint c2 { addr inside {[250:255]}; }

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(example_data_item)
  	`uvm_field_int (addr, UVM_DEFAULT)
  	`uvm_field_int (data, UVM_DEFAULT)
  	`uvm_field_int (addr_a, UVM_DEFAULT)
  	`uvm_field_int (data_a, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "example_data_item");
    super.new(name);
  endfunction
endclass
`endif

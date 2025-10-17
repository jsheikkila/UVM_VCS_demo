import uvm_pkg::*;
import tb_package::*;

`include "uvm_macros.svh"

class test1 extends uvm_test;
  // All classes derived directly from uvm_object or uvm_transaction require them to be registered using `uvm_object_utils macro
  `uvm_component_utils(test1)
  // Creates a new uvm_object
  function new(string name = "test1", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  env env0;
  virtual reg_bank_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env0 = env::type_id::create("env0", this);
    if (!uvm_config_db#(virtual reg_bank_if)::get(this, "", "mem_vif", vif))
      `uvm_fatal("TEST", "Did not get vif")

      uvm_config_db#(virtual reg_bank_if)::set(this, "env0.agent0.*", "mem_vif", vif);
  endfunction

  virtual task run_phase(uvm_phase phase);
    example_seq0 seq = example_seq0::type_id::create("seq");
    phase.raise_objection(this);
    apply_reset();

    seq.randomize();
    seq.start(env0.agent0.sequencer0);
    phase.drop_objection(this);
  endtask
  
  virtual function void end_of_elaboration_phase (uvm_phase phase) ;
    uvm_top.print_topology();
  endfunction
  
  virtual task apply_reset();
    vif.reset <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.reset <= 0;
    repeat(10) @ (posedge vif.clk);
  endtask
endclass

import uvm_pkg::*;
`include "uvm_macros.svh"

`ifndef __EXAMPLE_AGENT_SV__
 `define __EXAMPLE_AGENT_SV__

class agent extends uvm_agent;
  // All classes derived directly from uvm_object or uvm_transaction require them to be registered using `uvm_object_utils macro
  `uvm_component_utils(agent)
  function new(string name="agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  driver driver0; 		// Driver handle
  monitor	monitor0; 		// Monitor handle
  uvm_sequencer #(example_data_item)	sequencer0; 		// Sequencer Handle

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer0 = uvm_sequencer#(example_data_item)::type_id::create("sequencer0", this);
    driver0 = driver::type_id::create("driver0", this);
    monitor0 = monitor::type_id::create("monitor0", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver0.seq_item_port.connect(sequencer0.seq_item_export);
  endfunction
endclass

`endif 

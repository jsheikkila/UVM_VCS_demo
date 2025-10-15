import uvm_pkg::*;
`include "uvm_macros.svh"
class env extends uvm_env;

  // All classes derived directly from uvm_object or uvm_transaction require them to be registered using `uvm_object_utils macro
  `uvm_component_utils(env)
  function new(string name="env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  agent 		agent0; 		// Agent handle
  scoreboard	scoreboard0; 		// Scoreboard handle

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent0 = agent::type_id::create("agent0", this);
    scoreboard0 = scoreboard::type_id::create("scoreboard0", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent0.monitor0.mon_analysis_port.connect(scoreboard0.m_analysis_imp);
  endfunction
endclass

import uvm_pkg::*;
`include "uvm_macros.svh"
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(example_data_item, scoreboard) m_analysis_imp;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp = new("m_analysis_imp", this);
  endfunction

  virtual function write(example_data_item item);
      if (item.addr inside {[0:'hffff]}) begin
        if (item.addr_a != item.addr | item.data_a != item.data)
          `uvm_error("SCBD", $sformatf("ERROR! Mismatch addr=0x%0h data=0x%0h addr_a=0x%0h data_a=0x%0h", item.addr, item.data, item.addr_a, item.data_a))
        else
          `uvm_info("SCBD", $sformatf("PASS! Match addr=0x%0h data=0x%0h addr_a=0x%0h data_a=0x%0h", item.addr, item.data, item.addr_a, item.data_a), UVM_LOW)

      end else begin
          `uvm_error("SCBD", $sformatf("ERROR! Address addr=0x%0h out of valid range", item.addr))
      end
  endfunction
endclass

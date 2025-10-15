import uvm_pkg::*;
`include "uvm_macros.svh"
import tb_package::*;

`ifndef __MONITOR_SV__
 `define __MONITOR_SV__

class monitor extends uvm_monitor;
  // All classes derived directly from uvm_object or uvm_transaction require them to be registered using `uvm_object_utils macro
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(example_data_item) mon_analysis_port;
  virtual reg_bank_if vif;
  semaphore sema4;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual reg_bank_if)::get(this, "", "switch_vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    mon_analysis_port = new ("mon_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      sample_port("Thread0");
    join
  endtask

  virtual task sample_port(string tag="");
    // This task monitors the interface for a complete
    // transaction and pushes into the mailbox when the
    // transaction is complete
    forever begin
      @(posedge vif.clk);
      if (~vif.reset & vif.rw) begin
        example_data_item item = new;
        item.addr = vif.address;
        item.addr_a = vif.address;
        item.data = vif.data_in;
        `uvm_info("MON", $sformatf("T=%0t [Monitor] %s Write detected, storing write address and data", $time, tag), UVM_LOW)
        @(posedge vif.clk);
        @(posedge vif.clk);
        item.data_a = vif.data_out;
        mon_analysis_port.write(item);
        `uvm_info("MON", $sformatf("T=%0t [Monitor] %s Following read cycle, storing read address and data:", $time, tag), UVM_LOW)
        item.print();
      end
    end
  endtask
endclass
`endif 

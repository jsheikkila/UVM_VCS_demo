`ifndef __DRIVER_SV__
 `define __DRIVER_SV__

 class driver extends uvm_driver #(example_data_item);
  // All classes derived directly from uvm_object or uvm_transaction require them to be registered using `uvm_object_utils macro
  `uvm_component_utils(driver)
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual reg_bank_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual reg_bank_if)::get(this, "", "switch_vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      example_data_item driver_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(driver_item);
      drive_item(driver_item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(example_data_item driver_item);
  	vif.rw 	<= 1;
    vif.address 	<= driver_item.addr;
    vif.data_in   <= driver_item.data;
    @ (posedge vif.clk);
    vif.rw 	<= 0;
    @ (posedge vif.clk);
  endtask
endclass
`endif

/*
interface reg_bank_if(input logic clk, input logic reset);
    logic [7:0] address;       // 8-bit input address
    logic [15:0] data_in;      // 16-bit input data
    logic rw;                  // Read/Write control (1 for write, 0 for read)
    logic [15:0] data_out;     // 16-bit output data
endinterface
*/

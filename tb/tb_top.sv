`include "tb_package.svh"
`include "reg_bank_if.sv"
// Testbench module
module tb_top;
  import uvm_pkg::*;
  import test_package::*;    

  // Clock and reset signals
    logic clk;

    // Instantiate the interface
    reg_bank_if reg_if(clk, reset);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10ns
    end

    // Instantiate the VHDL register bank
    RegisterBank reg_bank_inst(
        .clk(reg_if.clk),
        .reset(reg_if.reset),
        .address(reg_if.address),
        .data_in(reg_if.data_in),
        .rw(reg_if.rw),
        .data_out(reg_if.data_out)
    );

    initial begin
      uvm_config_db#(virtual reg_bank_if)::set(uvm_root::get(), "*", "reg_if", reg_if);
      uvm_config_db#(virtual reg_bank_if)::set(uvm_root::get(), "*", "switch_vif", reg_if);
      run_test();
    end

    // Testbench logic
    initial begin

        // Write data to register at address 0x01
        reg_if.address = 8'h0;
        reg_if.data_in = 16'h0;
        reg_if.rw = 0; // Write operation
       $display("Interface initialized");

        // End simulation
        //$finish;
    end
endmodule


// Define the SystemVerilog interface
interface reg_bank_if(input logic clk, input logic reset);
    logic [7:0] address;       // 8-bit input address
    logic [15:0] data_in;      // 16-bit input data
    logic rw;                  // Read/Write control (1 for write, 0 for read)
    logic [15:0] data_out;     // 16-bit output data
endinterface

// Testbench module
module tb_top;
    // Clock and reset signals
    logic clk;
    logic reset;

    // Instantiate the interface
    reg_bank_if reg_if(clk, reset);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10ns
    end

    // Reset generation
    initial begin
        reset = 1;
        #20 reset = 0; // Deassert reset after 20ns
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

    // Testbench logic
    initial begin
        // Wait for reset to deassert
        @(negedge reset);

        // Write data to register at address 0x01
        reg_if.address = 8'h01;
        reg_if.data_in = 16'hABCD;
        reg_if.rw = 1; // Write operation
        @(posedge clk);

        // Read data from register at address 0x01
        reg_if.rw = 0; // Read operation
        @(posedge clk);

        // Display the read data
        $display("Read data from address 0x01: %h", reg_if.data_out);

        // Write data to register at address 0x02
        reg_if.address = 8'h02;
        reg_if.data_in = 16'h1234;
        reg_if.rw = 1; // Write operation
        @(posedge clk);

        // Read data from register at address 0x02
        reg_if.rw = 0; // Read operation
        @(posedge clk);

        // Display the read data
        $display("Read data from address 0x02: %h", reg_if.data_out);

        // End simulation
        $finish;
    end
endmodule

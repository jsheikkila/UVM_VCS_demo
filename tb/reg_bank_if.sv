
// Define the SystemVerilog interface
interface reg_bank_if(input logic clk, output logic reset);
    logic [7:0] address;       // 8-bit input address
    logic [15:0] data_in;      // 16-bit input data
    logic rw;                  // Read/Write control (1 for write, 0 for read)
    logic [15:0] data_out;     // 16-bit output data

// Reset generation
    initial begin
        reset = 1;
        #20 reset = 0; // Deassert reset after 20ns
    end

 endinterface



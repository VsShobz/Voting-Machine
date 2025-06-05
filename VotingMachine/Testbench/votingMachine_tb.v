`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 15:01:29
// Design Name: 
// Module Name: votingMachine_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module votingMachine_tb;

    // Declare inputs as regs
    reg clk, reset, cand1, cand2, cand3, cand4, mode;

    // Declare output as wire
    wire [7:0] led;

    // Instantiate the Unit Under Test (UUT)
    votingMachine uut (
        .clk(clk),
        .reset(reset),
        .cand1(cand1),
        .cand2(cand2),
        .cand3(cand3),
        .cand4(cand4),
        .mode(mode),
        .led(led)
    );

    // Clock generation: 10ps clock period
    always #5 clk = ~clk;

    initial begin
        // Monitor important internal signals
        $monitor("T=%0t | cand3=%b | valid3=%b | count3=%d | led=%h", $time, cand3, uut.valid3, uut.count3, led);

    end

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        mode = 0;
        cand1 = 0; cand2 = 0; cand3 = 0; cand4 = 0;

        #20 reset = 0;

        // Candidate 1 votes
        cand1 = 1; #100; cand1 = 0;
        #100;

        // Candidate 2 votes
        cand2 = 1; #100; cand2 = 0;
        #100;
        // Candidate 3 votes
        cand3 = 1; #100; cand3 = 0;
        #100;
        // Candidate 4 votes
        cand4 = 1; #100; cand4 = 0;
        #100;

        // Switch to tallying mode
        mode = 1; 
        #100;

        // Check tallying for each candidate
        cand1 = 1; #100; cand1 = 0;
        cand2 = 1; #100; cand2 = 0;
        cand3 = 1; #100; cand3 = 0;
        cand4 = 1; #100; cand4 = 0;

        #500;

        $finish;
    end

endmodule




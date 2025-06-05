`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 12:40:04
// Design Name: 
// Module Name: votingMachine
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

module buttonCheck(input clk, reset, candButton , output reg valid);

reg[31:0] counter;
always@(posedge clk)begin
    if(reset) begin
        valid <= 0;
        counter <= 0;
    end
    else begin
        valid<=0;
        if(candButton) begin
            if(counter<5) counter<=counter+1;
            else if(counter==5) begin
                counter<=6; // gets stucked at 6 if this pressed for longer duration, and would just send the valid signal once
                valid<=1;
            end
        end
        else counter <= 0;
    end
    
end

endmodule

// MODE = 0 -> Vote counts
module voteLogger(input clk, reset, candButton, mode, output reg[7:0] count );

    always@(posedge clk)begin
        if(reset) count <= 0;
        else if(candButton && !mode) count <= count + 1;
    end
endmodule

module display(input clk, reset, candButton1,candButton2,candButton3,candButton4, mode, [7:0] count1,[7:0] count2,[7:0] count3,[7:0]count4, output reg[7:0] led);
 
    wire valid = candButton1 | candButton2 | candButton3 | candButton4;
    reg [31:0] timer;
    always@(posedge clk)begin
        if(reset) timer <= 0;
        else if(valid || (timer>0 && timer <5)) timer <= timer + 1;
        else timer <= 0;
    end
    
    always@(posedge clk)begin
        if(reset) led <= 0;
        else if(!mode && timer  > 0 ) led <= 8'b11111111;
        else if(mode && candButton1) led <= count1;
        else if(mode && candButton2) led <= count2;
        else if(mode && candButton3) led <= count3;
        else if(mode && candButton4) led <= count4;
        else led <= 0;
    end

endmodule

module votingMachine( input clk,reset,cand1,cand2,cand3,cand4,mode, output [7:0] led); 

wire valid , valid1 , valid2 , valid3 , valid4;
wire [7:0] count1, count2, count3, count4;
buttonCheck button1(.clk(clk), .reset(reset), .candButton(cand1),.valid(valid1));
buttonCheck button2(.clk(clk), .reset(reset), .candButton(cand2),.valid(valid2));
buttonCheck button3(.clk(clk), .reset(reset), .candButton(cand3),.valid(valid3));
buttonCheck button4(.clk(clk), .reset(reset), .candButton(cand4),.valid(valid4));

voteLogger log1(.clk(clk), .reset(reset), .candButton(valid1),.mode(mode),.count(count1));
voteLogger log2(.clk(clk), .reset(reset), .candButton(valid2),.mode(mode),.count(count2));
voteLogger log3(.clk(clk), .reset(reset), .candButton(valid3),.mode(mode),.count(count3));
voteLogger log4(.clk(clk), .reset(reset), .candButton(valid4),.mode(mode),.count(count4));
 
display tally1(.clk(clk), .reset(reset), .candButton1(valid1),.candButton2(valid2), .candButton3(valid3),.candButton4(valid4),.mode(mode),.count1(count1),.count2(count2),.count3(count3),.count4(count4),.led(led)); 


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2024 02:26:04
// Design Name: 
// Module Name: module42
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


module module42p#(
parameter i1=3,f1=2,
parameter i2=4,f2=2,
parameter out_i=5,out_f=3
)(input clk,
input [i1+f1-1:0]a,
input [i2+f2-1:0]b,
output  [out_i+out_f-1:0]out,
output  reg overflow,
output  reg underflow

    );
    localparam i=i1+i2;
    localparam f=f1+f2;
    reg [i+f-1:0]temp_out;
    reg [out_i-1:0]temp_outi;
    reg [out_f-1:0]temp_outf;
    always@(posedge clk)
    begin
    temp_out=$signed(a)*$signed(b);
    end
    
  always@(posedge clk)
    begin

    begin
    if(out_i>i)
    overflow=0;
    else 
    begin
    if(temp_out[i+f-1]==0)
    overflow=|temp_out[(i+f)-1:(i+f-1)-(i-out_i)];
    else if(temp_out[i+f-1]==1)
    overflow=(~(&temp_out[(i+f)-1:(i+f-1)-(i-out_i)]));
    else
    overflow=0;
    end
    end
    end
  
    always@(posedge clk)
    begin
 
    begin
    if(overflow)
    begin
    if(temp_out[i+f-1]==0)
    //out= {{temp_out[i+f-1]},{(out_i-1){1'b1}},{temp_out[f-1:0]}};
    temp_outi={{temp_out[i+f-1]},{(out_i-1){1'b1}}};
    else if(temp_out[i+f-1]==1)
    //out={{temp_out[i+f-1]},{(out_i-1){1'b0}},{temp_out[f-1:0]}};
    temp_outi={{temp_out[i+f-1]},{(out_i-1){1'b0}}};
    end
    else
    temp_outi={{temp_out[i+f-1:f]}};
    end
    end
    
    
    always@(posedge clk)
    begin
    
    begin
    if(out_f>=f)
    underflow=0;
    else 
    if(temp_out[i+f-1]==0)
    underflow=|temp_out[f-out_f-1:0];
    else
    underflow=(~(&temp_out[f-out_f-1:0]));
    end
    end
    
    
    always@(posedge clk)
    begin
    begin
    if(underflow)
    begin
    if(temp_out[i+f-1]==0)
   
    temp_outf={{temp_out[f-1:f-out_f+1]},{1'b1}};
    else if(temp_out[i+f-1]==1)
  
    temp_outf={{temp_out[f-1:f-out_f+1]},{1'b0}};
    end
    else
    temp_outf=temp_out[f:f-out_f];
    end
   
    end
   assign out={{temp_outi},{temp_outf}}; 
   
endmodule

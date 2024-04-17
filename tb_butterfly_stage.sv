`timescale 1ns / 1ps

module tb_butterfly();

logic  [49:0] signal_tb      [7:0];
logic  [49:0] final_stage_tb [7:0];
logic         clk;
logic         rst;

parameter CLK_PERIOD = 20; 
// always begin
//     #10 clk_i = ~clk_i;
// end

initial begin
  clk = 0;
  forever #(CLK_PERIOD / 2) clk = ~clk;
end

butterfly_stage butterfly_inst(
.clk_i( clk ),
.rst_i( rst ),
.signal( signal_tb ),
.final_stage( final_stage_tb )
);

initial 
begin
rst = 1;

#20
rst = 0;

#20
signal_tb[0] = 50'b00000000000000000000000010000000000000000000000001;
signal_tb[1] = 50'b00000000000000000000000010000000000000000000000000;
signal_tb[2] = 50'b00000000000000000000000000000000000000000000000001;
signal_tb[3] = 50'b00000000000000000000000000000000000000000000000000;
signal_tb[4] = 50'b00000000000000000000000110000000000000000000000000;
signal_tb[5] = 50'b10000000000000000000000110000000000000000000000001;
signal_tb[6] = 50'b00000000000000000000000010000000000000000000000000;
signal_tb[7] = 50'b00000000000000000000000101000000000000000000000010;



end



endmodule

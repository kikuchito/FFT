`timescale 1ns / 1ps

module tb_butterfly();

logic [49:0] signal_store_tb      [7:0];
logic [49:0] final_stage_store_tb [7:0];
logic [49:0] signal_tb;
logic [ 2:0] num_of_signal_tb;
logic [49:0] final_stage_tb;
logic [2:0]  final_num_tb;
logic        clk;
logic        rst;
logic        tready_tb;
logic        tvalid_tb;
logic        tlast_tb;

parameter CLK_PERIOD = 20; 
parameter SIGNAL_COUNT = 7;
parameter SIGNAL_SIZE = 50;
parameter FILE_PATH_IN = "C:/Users/Yslavinsky/FFTmem_in.txt";
parameter FILE_PATH_OUT = "C:/Users/Yslavinsky/FFTmem_out.txt";
// always begin
//     #10 clk_i = ~clk_i;
// end

initial begin
  clk = 0;
  forever #(CLK_PERIOD / 2) clk = ~clk;
end

// butterfly_stage butterfly_stage_dut(
//   .clk_i( clk ),
//   .rst_i( rst ),
//   .signal( signal_tb ),
//   .final_stage( final_stage_tb ),
//   .num_of_signal(num_of_signal_tb),
//   .final_num(final_num_tb)
// );

FFT_wrapper #(SIGNAL_COUNT, SIGNAL_SIZE)
wrapper_dut(
  .clk_i(clk),
  .reset(rst),
  .tvalid(tvalid_tb),
  .signal(signal_tb),
  .tready(tready_tb),
  .final_stage(final_stage_tb),
  .final_num_top(final_num_tb),
  .tlast(tlast_tb)
);

int fd;

initial begin
  rst = '1;
  tvalid_tb = '0;

  #20
  rst = 0;

  $readmemb("mem_in.txt", signal_store_tb, 0);
  

  for (int i=0; i < SIGNAL_COUNT + 1; ++i) begin
    #20
    tlast_tb = '0;
    tvalid_tb = '1;
    num_of_signal_tb = i;
    signal_tb = signal_store_tb[i];
    if (i == 7)
      tlast_tb = '1;

  end
  
  #20
  tlast_tb = '0;
  tvalid_tb = '0;

 
 final_stage_store_tb[final_num_tb] = final_stage_tb;
 for (int i = 1; i < SIGNAL_COUNT + 1; ++i ) begin
  @(final_num_tb)
  final_stage_store_tb[final_num_tb] = final_stage_tb;
 end

 



  // $writememb("mem_out.txt", final_stage_store_tb, 0);
   
  fd = $fopen("mem_out.txt", "w");
  if (fd) begin   
    $display("File was opened succcessfully");
    $fwrite(fd, final_stage_store_tb);
    //  $writememb("mem_out.txt", final_stage_store_tb, 0);
  end
  else    $display("File was NOT opened succcessfully");
  $fclose(fd);
end
// #20
// num_of_signal_tb = 3'd0;
// signal_tb = signal_store_tb[0];
// #20
// num_of_signal_tb = 3'd1;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd2;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd3;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd4;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd5;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd6;
// signal_tb = ;
// #20
// num_of_signal_tb = 3'd7;
// signal_tb = ;





endmodule

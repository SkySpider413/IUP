// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3.1_AR72614 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
// Date        : Sat May 11 16:57:50 2024
// Host        : fedora running 64-bit Fedora Linux 39 (Workstation Edition)
// Command     : write_verilog -force -mode synth_stub
//               /home/skymark/FPGA/Vivado/2018.3/bin/project_101/project_100.srcs/sources_1/ip/vga_bitmap/vga_bitmap_stub.v
// Design      : vga_bitmap
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3.1_AR72614" *)
module vga_bitmap(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[13:0],douta[7:0]" */;
  input clka;
  input [13:0]addra;
  output [7:0]douta;
endmodule

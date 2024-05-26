-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3.1_AR72614 (lin64) Build 2489853 Tue Mar 26 04:18:30 MDT 2019
-- Date        : Sat May 11 16:57:50 2024
-- Host        : fedora running 64-bit Fedora Linux 39 (Workstation Edition)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/skymark/FPGA/Vivado/2018.3/bin/project_101/project_100.srcs/sources_1/ip/vga_bitmap/vga_bitmap_stub.vhdl
-- Design      : vga_bitmap
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_bitmap is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 13 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end vga_bitmap;

architecture stub of vga_bitmap is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[13:0],douta[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_2,Vivado 2018.3.1_AR72614";
begin
end;

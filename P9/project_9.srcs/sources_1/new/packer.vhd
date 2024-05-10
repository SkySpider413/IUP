library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity packer is
    port(
        val_i : in std_logic_vector(7 downto 0);
        frame_o : out std_logic_vector(9 downto 0)
    );
end packer;

architecture Behavioral of packer is

begin
    frame_o(9) <= '0';
    frame_o(8) <= val_i(0);
    frame_o(7) <= val_i(1);
    frame_o(6) <= val_i(2);
    frame_o(5) <= val_i(3);
    frame_o(4) <= val_i(4);
    frame_o(3) <= val_i(5);
    frame_o(2) <= val_i(6);
    frame_o(1) <= val_i(7);
    frame_o(0) <= '1';
end Behavioral;

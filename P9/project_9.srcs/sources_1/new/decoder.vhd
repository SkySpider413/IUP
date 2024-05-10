library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    Port(
        clk_i : in std_logic;
        RXD_i : in std_logic;
        val_o : out std_logic_vector (7 downto 0);
        val_ready_o : out std_logic
    );
end decoder;

architecture Behavioral of decoder is

component catcher is
    Port(
        clk_i : in std_logic;
        RXD_i : in std_logic;
        frame_o : out std_logic_vector (9 downto 0);
        frame_ready_o : out std_logic
    );
end component;

signal frame : std_logic_vector (9 downto 0);
signal frame_ready : std_logic := '0';
signal frame_decoded : std_logic_vector (7 downto 0);
signal decode_ready : std_logic := '0';

begin

    ctc : catcher port map(
        clk_i => clk_i,
        RXD_i => RXD_i,
        frame_o => frame,
        frame_ready_o => frame_ready
    );
    
    frame_decoded (7) <= frame (1);
    frame_decoded (6) <= frame (2);
    frame_decoded (5) <= frame (3);
    frame_decoded (4) <= frame (4);
    frame_decoded (3) <= frame (5);
    frame_decoded (2) <= frame (6);
    frame_decoded (1) <= frame (7);
    frame_decoded (0) <= frame (8);
    
    
    decode_ready <= '1' when (frame(9) = '0' and frame(0) = '1' and frame_ready = '1') else '0';
    
    val_o <= frame_decoded;
    val_ready_o <= decode_ready;
    
    



end Behavioral;

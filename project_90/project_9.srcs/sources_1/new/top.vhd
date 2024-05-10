library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity top is
    Port (
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        RXD_i : in STD_LOGIC;
        TXD_o : out STD_LOGIC
     );
end top;

architecture Behavioral of top is

component decoder is
    Port(
        clk_i : in std_logic;
        RXD_i : in std_logic;
        val_o : out std_logic_vector (7 downto 0);
        val_ready_o : out std_logic
    );
end component;

component packer is
    port(
        val_i : in std_logic_vector(7 downto 0);
        frame_o : out std_logic_vector(9 downto 0)
    );
end component;

component sender is
    port(
        frame_i : in std_logic_vector(9 downto 0);
        flip_i : in std_logic;
        frame_ready_i : in std_logic;
        clk_i : in std_logic;
        txd : out std_logic;
        flip_o : out std_logic
    );
end component;

signal val : std_logic_vector (7 downto 0);
signal val_ready : std_logic := '0';
signal val20 : std_logic_vector (7 downto 0);
signal val20_ready : std_logic := '0';
signal val20_ready_prev : std_logic := '1';
signal packed_val20 : std_logic_vector(9 downto 0);
signal flip_o : std_logic := '0';
signal flip_stable : std_logic := '1';
--signal txd : std_logic := '1';

begin
    snd : sender port map(
        frame_i => packed_val20,
        flip_i => flip_stable,
        frame_ready_i => val20_ready,
        clk_i => clk_i,
        txd => TXD_o,
        flip_o => flip_o
    );
    
--    process (clk_i)
--    begin
--        if rising_edge(clk_i) then
--            TXD_o <= txd;
--        end if;
--    end process;
    --TXD_o <= txd;
    --TXD_o <= RXD_i;
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if (val20_ready = '1') and (flip_o = flip_stable) and (val20_ready_prev = '0') then
                flip_stable <= not flip_stable;
                val20_ready_prev <= val20_ready;
            elsif (val20_ready = '0' and val20_ready_prev = '1') then
                val20_ready_prev <= val20_ready;
            end if;
        end if;
    end process;


    dcd : decoder port map(
        clk_i => clk_i,
        RXD_i => RXD_i,
        val_o => val,
        val_ready_o => val_ready
    );

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if val_ready = '1' then
                val20 <= std_logic_vector(unsigned(val)+32);
                val20_ready <= '1';
            else
                val20_ready <= '0';
            end if;
        end if;
    end process;

    pck : packer port map(
        val_i => val20,
        frame_o => packed_val20
    );

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           ps2_clk_i : in STD_LOGIC;
           ps2_data_i : in STD_LOGIC;
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Behavioral of top is

component decoder is
    Port(
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        ps2_clk_i : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        hex_v_o : out std_logic_vector(3 downto 0);
        enable_o : out std_logic
    );
end component;

component hextranslate is
    Port (
        dot : in std_logic;
        hex_value : in std_logic_vector(3 downto 0);
        segment : out std_logic_vector(7 downto 0)
   );
end component;

signal ps2_clk_int : std_logic := '0';
signal hex : std_logic_vector(3 downto 0);
signal led_enable : std_logic := '0';

begin

--    process (clk_i)
--    begin
--        if rising_edge(clk_i) then
--            ps2_clk_int <= ps2_clk_i;
--        end if;
--    end process;

    dc : decoder port map(
        clk_i => clk_i,
        rst_i => rst_i,
        ps2_clk_i => ps2_clk_i,
        ps2_data_i => ps2_data_i,
        hex_v_o => hex,
        enable_o => led_enable
    );
    
    hxt : hextranslate port map(
        dot => '0',
        hex_value => hex,
        segment => led7_seg_o
    );
    
    led7_an_o(3 downto 1) <= "111";
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            led7_an_o(0) <= not led_enable;
        end if;
    end process;

end Behavioral;

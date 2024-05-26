library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity s10 is
--  Port ( );
end s10;

architecture Behavioral of s10 is

component top is
    port(
        clk_i : in std_logic;
        red_o : out std_logic_vector(3 downto 0);
        green_o : out std_logic_vector(3 downto 0);
        blue_o : out std_logic_vector(3 downto 0);
        hsync_o : out std_logic;
        vsync_o : out std_logic;
        sw5_i : in std_logic;
        sw6_i : in std_logic;
        sw7_i : in std_logic;
        btn_i : in std_logic_vector(3 downto 0);
        led7_seg_o : out std_logic_vector(7 downto 0);
        led7_an_o : out std_logic_vector(3 downto 0)
    );
end component;
signal clk_i : std_logic := '0';
signal hsync : std_logic := '0';
signal vsync : std_logic := '0';
signal red_o : std_logic_vector(3 downto 0);
signal green_o : std_logic_vector(3 downto 0);
signal blue_o : std_logic_vector(3 downto 0);
signal l7 : std_logic_vector(7 downto 0);
begin

    uut: top port map(
        clk_i => clk_i,
        sw5_i => '1',
        sw6_i => '0',
        sw7_i => '1',
        btn_i => "0000",
        hsync_o => hsync,
        vsync_o => vsync,
        led7_seg_o => l7,
        green_o => green_o,
        red_o => red_o,
        blue_o => blue_o
    );
    clk_i <= not clk_i after 5ns;

end Behavioral;

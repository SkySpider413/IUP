library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sim8 is
--  Port ( );
end sim8;

architecture Behavioral of sim8 is

--component decoder is
--    Port(
--        clk_i : in STD_LOGIC;
--        rst_i : in STD_LOGIC;
--        ps2_clk_i : in STD_LOGIC;
--        ps2_data_i : in STD_LOGIC;
--        hex_v_o : out std_logic_vector(3 downto 0);
--        enable_o : out std_logic
--    );
--end component;

component top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           ps2_clk_i : in STD_LOGIC;
           ps2_data_i : in STD_LOGIC;
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component catcher is
    Port(
        clk_i : in STD_LOGIC;
        ps2_clk_i : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        frame_o : out std_logic_vector(10 downto 0);
        ready_o : out std_logic
    );
end component;

signal clk_i : STD_LOGIC := '1';
signal rst_i : STD_LOGIC := '0';
signal ps2_clk_i : STD_LOGIC;
signal ps2_data_i : STD_LOGIC;

signal led7_an : STD_LOGIC_VECTOR (3 downto 0);
signal led7_seg : STD_LOGIC_VECTOR (7 downto 0);
signal hex_v_o : std_logic_vector(3 downto 0);
signal enable_o : std_logic;

signal frame : std_logic_vector (10 downto 0);
--signal frame_o : std_logic_vector (10 downto 0);
--signal frame_ready_o : std_logic;
begin
    clk_i <= not clk_i after 5ns;
    
--    uut : decoder port map(
--        clk_i => clk_i,
--        rst_i => rst_i,
--        ps2_clk_i => ps2_clk_i,
--        ps2_data_i => ps2_data_i,
--        hex_v_o => hex_v_o,
--        enable_o => enable_o
--    );
    

    uut : top port map(
        clk_i => clk_i,
        rst_i => rst_i,
        ps2_clk_i => ps2_clk_i,
        ps2_data_i => ps2_data_i,
        led7_an_o => led7_an,
        led7_seg_o => led7_seg
    );

--    uut : catcher port map(
--        clk_i => clk_i,
--        ps2_clk_i => ps2_clk_i,
--        ps2_data_i => ps2_data_i,
--        frame_o => frame_o,
--        ready_o => frame_ready_o
--    );

    process
    begin
        ps2_clk_i <= '1';
        wait for 5us;
        frame <= "00110100001"; --1
        wait for 5us;
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        wait for 5us;
        frame <= "00000111111";  --f0
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        ps2_clk_i <= '1';
        wait for 5us;
        frame <= "00110100001"; --1 cancel
        wait for 5us;
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        
        wait for 5us;
        frame <= "00110001001";  --9
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        wait for 5us;
        frame <= "00000111111";  --f0
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        wait for 5us;
        frame <= "00110001001";  --9
        for i in 0 to 10 loop
            ps2_data_i <= frame(10-i);
            wait for 25us;
            ps2_clk_i <= '0';
            wait for 25us;
            ps2_clk_i <= '1';
            wait for 5us;
        end loop;
        wait for 1ms;
        
        
        wait for 2ms;
        rst_i <= '1';
        wait for 50us;
        rst_i <= '0';
        wait for 1ms;
        
        wait;
    end process;

end Behavioral;

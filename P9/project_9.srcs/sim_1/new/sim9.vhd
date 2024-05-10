library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sim9 is
--  Port ( );
end sim9;

architecture Behavioral of sim9 is

--component decoder is
--    Port(
--        clk_i : in std_logic;
--        rxd_i : in std_logic;
--        val_o : out std_logic_vector (7 downto 0);
--        val_ready_o : out std_logic
--    );
--end component;

component top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           RXD_i : in STD_LOGIC;
           TXD_o : out STD_LOGIC);
end component;

--component sender is
--    port(
--        frame_i : in std_logic_vector(9 downto 0);
--        flip_i : in std_logic;
--        frame_ready_i : in std_logic;
--        clk_i : in std_logic;
--        txd : out std_logic;
--        flip_o : out std_logic
--    );
--end component;


signal clk_i : std_logic := '0';
signal rxd_i : std_logic := '1';
--signal val_o : std_logic_vector (7 downto 0);
--signal val_ready_o : std_logic;
signal frame : std_logic_vector (9 downto 0);
signal TXD_o : std_logic := 'Z';
signal rst_i : std_logic := '0';
signal flip : std_logic;
signal frame_ready : std_logic;
signal txd : std_logic;
signal flip_o : std_logic;
begin

    clk_i <= not clk_i after 5ns;
    
--    uut : sender port map(
--        frame_i => frame,
--        flip_i => flip,
--        frame_ready_i => frame_ready,
--        clk_i => clk_i,
--        txd => txd,
--        flip_o => flip_o
--    );
    
--    process
--    begin
--        wait for 5us;
--        flip <= '1';
--        frame_ready <= '1';
--        frame <= "0101000101";
--        wait for 10ms;
--        wait;
    
--    end process;
    
    
    uut : top port map(
        clk_i => clk_i,
        rst_i => rst_i,
        rxd_i => RXD_i,
        TXD_o => TXD_o
    );
    
    
--    uut : decoder port map(
--        clk_i => clk_i,
--        rxd_i => rxd_i,
--        val_o => val_o,
--        val_ready_o => val_ready_o
--    );

    process
    begin
        rxd_i <= '1';
        frame <= "0101000101";
        wait for 1us;
        for i in 0 to 9 loop
            rxd_i <= frame(9-i);
            wait for 104us;
        end loop;
        rxd_i <= '1';
        wait for 2ms;
        
        rxd_i <= '1';
        frame <= "0000101001";
        wait for 1us;
        for i in 0 to 9 loop
            rxd_i <= frame(9-i);
            wait for 104us;
        end loop;
        rxd_i <= '1';
        wait for 1ms;
        wait;
    end process;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity catcher is
    Port(
        clk_i : in STD_LOGIC;
        ps2_clk_i : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        frame_o : out std_logic_vector(10 downto 0);
        ready_o : out std_logic
    );
end catcher;

architecture Behavioral of catcher is
signal counter : integer := 4;
signal counter_prev : integer := 3;
signal counter_max : integer := 200;

signal ps2_clk_shift : std_logic_vector(3 downto 0) := x"f";
signal ps2_clk_sync : std_logic := '1';
signal ps2_clk_sync_prev : std_logic := '1';
signal ps2_frame_unstable : std_logic_vector(10 downto 0) := "ZZZZZZZZZZZ";

signal ps2_frame_stable : std_logic_vector(10 downto 0) := "ZZZZZZZZZZZ";
signal ps2_frame_ready : std_logic := '0';
signal frame_bits_loaded : integer := 0;
begin
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if (ps2_clk_sync = '0' and ps2_clk_sync_prev = '1') then
                ps2_frame_unstable(10 downto 1) <= ps2_frame_unstable(9 downto 0);
                ps2_frame_unstable(0) <= ps2_data_i;
                ps2_clk_sync_prev <= ps2_clk_sync;
                if frame_bits_loaded = 10 then
                    frame_bits_loaded <= 0;
                    ps2_frame_ready <= '1';
                else
                    frame_bits_loaded <= frame_bits_loaded + 1;
                    ps2_frame_ready <= '0';
                end if;
            else
                ps2_clk_sync_prev <= ps2_clk_sync;
            end if;
        end if;
    end process;
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if ps2_frame_ready = '1' then
                frame_o <= ps2_frame_unstable;
                ready_o <= '1';
            else
                
                ready_o <= '0';
            end if;
        end if;
    
    end process;
    
    
    
    process (clk_i)  -- counter to probe clk
    begin
        if (rising_edge(clk_i)) then
            if counter = counter_max then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    process (clk_i)  -- clk shift
    begin
        if rising_edge(clk_i) then
            if (counter = 2 and counter_prev = 1) then
                ps2_clk_shift(3 downto 1) <= ps2_clk_shift(2 downto 0);
                ps2_clk_shift(0) <= ps2_clk_i;
                counter_prev <= counter;
            else
                counter_prev <= counter;
                ps2_clk_shift <= ps2_clk_shift;
            
            end if;
        end if;
    end process;
    
    -- sync clk
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if ps2_clk_shift = x"f" then
                ps2_clk_sync <= '1';
            elsif ps2_clk_shift = x"0" then
                ps2_clk_sync <= '0';
            else
                ps2_clk_sync <= ps2_clk_sync;
            end if;
        end if;
    end process;
    


end Behavioral;

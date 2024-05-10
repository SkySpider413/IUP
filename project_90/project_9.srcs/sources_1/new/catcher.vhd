library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity catcher is
    Port(
        clk_i : in std_logic;
        RXD_i : in std_logic;
        frame_o : out std_logic_vector (9 downto 0);
        frame_ready_o : out std_logic
    );
end catcher;

architecture Behavioral of catcher is
signal bits_loaded : integer := 0;
signal counter : integer := 1;
signal counter_prev : integer := 0;
signal counter_max : integer := 200;
signal in_frame : std_logic := '0';
signal start_frame_shift : std_logic_vector (3 downto 0) := x"f";
signal probe_cooldown : integer := 0;
signal frame_unstable : std_logic_vector (9 downto 0);
signal frame_stable : std_logic_vector (9 downto 0);
signal frame_ready : std_logic := '0';

begin

    process (clk_i)
    begin
        if rising_edge(clk_i) then  -- sync
            if in_frame = '0' then  -- waiting for start
                if start_frame_shift = x"0" then
                    in_frame <= '1';
                    probe_cooldown <= 4500;
                    bits_loaded <= 0;
                end if;
            else  -- getting stuff
                if probe_cooldown = 0 then
                    frame_unstable(9 downto 1) <= frame_unstable(8 downto 0);
                    frame_unstable(0) <= RXD_i;
                    probe_cooldown <= 10410;
                    bits_loaded <= bits_loaded + 1;
                    if bits_loaded = 9 then
                        in_frame <= '0';
                    end if;
                else
                    probe_cooldown <= probe_cooldown - 1;
                end if;
            end if;
        end if;
    end process;

    process (bits_loaded, frame_unstable)
    begin
        if bits_loaded = 10 then
            frame_o <= frame_unstable;
            frame_ready_o <= '1';
        else
            frame_o <= "ZZZZZZZZZZ";
            frame_ready_o <= '0';
        end if;
    end process;

    process (clk_i)  -- counter to probe frame_start
    begin
        if (rising_edge(clk_i)) then
            if counter = counter_max then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
--    process (counter, RXD_i,start_frame_shift,counter_prev)
--    begin
--        if (counter = 18 and counter_prev = 17) then
--            start_frame_shift (3 downto 1) <= start_frame_shift (2 downto 0);
--            start_frame_shift (0) <= RXD_i;
--            counter_prev <= counter;
--        else
--            counter_prev <= counter;
--        end if;
----        counter_prev <= counter;
--    end process;
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if (counter = 18 and counter_prev = 17) then
                start_frame_shift (3 downto 1) <= start_frame_shift (2 downto 0);
                start_frame_shift (0) <= RXD_i;
                counter_prev <= counter;
            else
                counter_prev <= counter;
            end if;
    --        counter_prev <= counter;
        end if;
    end process;
    

end Behavioral;

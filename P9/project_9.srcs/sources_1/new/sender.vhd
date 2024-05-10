
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sender is
    port(
        frame_i : in std_logic_vector(9 downto 0);
        flip_i : in std_logic;
        frame_ready_i : in std_logic;
        clk_i : in std_logic;
        txd : out std_logic;
        flip_o : out std_logic
    );
end sender;

architecture Behavioral of sender is
signal bit_cooldown : integer := 0;
signal bits_sent : integer := 0;
signal sending : std_logic := '0';
signal flip_prev : std_logic := '1';
signal ready_prev : std_logic := '0';
signal temp : std_logic_vector (9 downto 0);
signal txd_s : std_logic := '1';
signal flip_stable : std_logic := '1';
begin



    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if bit_cooldown /= 0 then
                bit_cooldown <= bit_cooldown - 1;
            elsif ((flip_i /= flip_prev) and (frame_ready_i = '1')) then
                if sending = '0' then
                    bit_cooldown <= 10; -- waiting for frame to stabilize
                    bits_sent <= 0;
                    sending <= '1';
                    temp <= frame_i;
                else
                    txd_s <= temp(9);
                    temp(9 downto 1) <= temp (8 downto 0);
                    temp(0) <= '1';
                    bit_cooldown <= 10416;
                    if bits_sent = 10 then
                        sending <= '0';
                        bits_sent <= 0;
                        flip_prev <= flip_i;
                        flip_stable <= flip_i;
                    else
                        bits_sent <= bits_sent + 1;
                    end if;
                end if;
--                flip_prev <= flip_i;
            end if;
        end if;
    end process;
    flip_o <= flip_stable;
    txd <= txd_s;

end Behavioral;

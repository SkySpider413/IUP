library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    Port(
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        ps2_clk_i : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        hex_v_o : out std_logic_vector(3 downto 0);
        enable_o : out std_logic
    );
end decoder;

architecture Behavioral of decoder is

component catcher is
    Port(
        clk_i : in STD_LOGIC;
        ps2_clk_i : in STD_LOGIC;
        ps2_data_i : in STD_LOGIC;
        frame_o : out std_logic_vector(10 downto 0);
        ready_o : out std_logic
    );
end component;

signal frame_o : std_logic_vector(10 downto 0);
signal ready_o : std_logic := '0';
signal lastF0 : std_logic := '0';
signal enable : std_logic := '0';
signal clicked : std_logic_vector(15 downto 0) := x"0000";
signal ready_o_prev : std_logic := '0';
signal rev : std_logic_vector(7 downto 0);

begin
    ctc : catcher port map(
        clk_i => clk_i,
        ps2_clk_i => ps2_clk_i,
        ps2_data_i => ps2_data_i,
        frame_o => frame_o,
        ready_o => ready_o
    );
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            enable_o <= enable;
        end if;
    end process;
    
    rev(7) <= frame_o(2);
    rev(6) <= frame_o(3);
    rev(5) <= frame_o(4);
    rev(4) <= frame_o(5);
    rev(3) <= frame_o(6);
    rev(2) <= frame_o(7);
    rev(1) <= frame_o(8);
    rev(0) <= frame_o(9);
    
    process (clk_i)
    variable xorr : std_logic := '0';
    begin
        if rising_edge(clk_i) then
            if ((ready_o = '1') and (ready_o_prev = '0')) then -- only once
                xorr := frame_o(9) xor
                    frame_o(8) xor
                    frame_o(7) xor
                    frame_o(6) xor
                    frame_o(5) xor
                    frame_o(4) xor
                    frame_o(3) xor
                    frame_o(2);
                if ((frame_o(10) = '0') and ((frame_o(1) = not xorr) and (frame_o(0) = '1'))) then  -- valid frame
                    lastF0 <= '0';
                    if rev = x"F0" then
                        lastF0 <= '1';
                    elsif rev = x"45" then
                        if lastF0 = '0' then
                            hex_v_o <= x"0";
                            enable <= '1';
                        end if;
                    elsif rev = x"16" then
                        if lastF0 = '0' then
                            hex_v_o <= x"1";
                            enable <= '1';
                        end if;
                    elsif rev = x"1e" then
                        if lastF0 = '0' then
                            hex_v_o <= x"2";
                            enable <= '1';
                        end if;
                    elsif rev = x"26" then
                        if lastF0 = '0' then
                            hex_v_o <= x"3";
                            enable <= '1';
                        end if;
                    elsif rev = x"25" then
                        if lastF0 = '0' then
                            hex_v_o <= x"4";
                            enable <= '1';
                        end if;
                    elsif rev = x"2e" then
                        if lastF0 = '0' then
                            hex_v_o <= x"5";
                            enable <= '1';
                        end if;
                    elsif rev = x"36" then
                        if lastF0 = '0' then
                            hex_v_o <= x"6";
                            enable <= '1';
                        end if;
                    elsif rev = x"3d" then
                        if lastF0 = '0' then
                            hex_v_o <= x"7";
                            enable <= '1';
                        end if;
                    elsif rev = x"3e" then
                        if lastF0 = '0' then
                            hex_v_o <= x"8";
                            enable <= '1';
                        end if;
                    elsif rev = x"46" then
                        if lastF0 = '0' then
                            hex_v_o <= x"9";
                            enable <= '1';
                        end if;
                    elsif rev = x"1c" then
                        if lastF0 = '0' then
                            hex_v_o <= x"a";
                            enable <= '1';
                        end if;
                    elsif rev = x"32" then
                        if lastF0 = '0' then
                            hex_v_o <= x"b";
                            enable <= '1';
                        end if;
                    elsif rev = x"21" then
                        if lastF0 = '0' then
                            hex_v_o <= x"c";
                            enable <= '1';
                        end if;
                    elsif rev = x"23" then
                        if lastF0 = '0' then
                            hex_v_o <= x"d";
                            enable <= '1';
                        end if;
                    elsif rev = x"24" then
                        if lastF0 = '0' then
                            hex_v_o <= x"e";
                            enable <= '1';
                        end if;
                    elsif rev = x"2b" then
                        if lastF0 = '0' then
                            hex_v_o <= x"f";
                            enable <= '1';
                        end if;
                    else
                        enable <= '0';
                        hex_v_o <= "ZZZZ";
                    end if;
                end if;
            end if;
            ready_o_prev <= ready_o;
            if rst_i = '1' then
                hex_v_o <= "ZZZZ";
                enable <= '0';
            end if;
        end if;
    end process;
    
--    hex_v_o(3) <= ready_o;
--    hex_v_o(2) <= ready_o_prev;
--    hex_v_o(1) <= notlastF0;
--    hex_v_o(0) <= enable;
    

end Behavioral;

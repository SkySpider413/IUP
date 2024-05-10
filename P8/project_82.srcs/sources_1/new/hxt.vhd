
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hextranslate is
    Port (
        dot : in std_logic;
        hex_value : in std_logic_vector(3 downto 0);
        segment : out std_logic_vector(7 downto 0)
   );
end hextranslate;

architecture Behavioral of hextranslate is

function hex_to_segment(value : std_logic_vector) return std_logic_vector is
begin
    case value(3 downto 0) is
        when x"0" =>
            return "0000001";
        when x"1" =>
            return "1001111";
        when x"2" =>
            return "0010010";
        when x"3" =>
            return "0000110";
        when x"4" =>
            return "1001100";
        when x"5" =>
            return "0100100";
        when x"6" =>
            return "0100000";
        when x"7" =>
            return "0001111";
        when x"8" =>
            return "0000000";
        when x"9" =>
            return "0000100";
        when x"a" =>
            return "0001000";
        when x"b" =>
            return "1100000";
        when x"c" =>
            return "0110001";
        when x"d" =>
            return "1000010";
        when x"e" =>
            return "0110000";
        when x"f" =>
            return "0111000";
        when others =>
            return "1111111";
    end case;
end function;

begin
    segment(0) <= not dot;
    segment(7 downto 1) <= hex_to_segment(hex_value);
end Behavioral;

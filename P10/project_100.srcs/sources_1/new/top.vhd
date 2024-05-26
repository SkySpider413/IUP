
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
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
end top;

architecture Behavioral of top is

--signal clka : std_logic := '0';
signal addra : std_logic_vector (13 downto 0);
signal douta : std_logic_vector (7 downto 0);

component vga_bitmap IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;
signal RGBvh : std_logic_vector(4 downto 0) := "00000";
signal vsync : std_logic;
signal hsync : std_logic;
signal framecounter : integer := 0;
signal linecounter : integer := 0;
signal frametimer : integer := 0;
signal in123 : std_logic := '0';
signal in456 : std_logic := '0';
signal pxcd : integer range 0 to 32767 := 0;
signal lcd : integer range 0 to 32767 := 0;
signal imx : integer range 0 to 32767 := 300;
signal imy : integer range 0 to 32767 := 100;
signal nextRGB : std_logic_vector(2 downto 0) := "000";
signal currentRGB : std_logic_vector(2 downto 0) := "000";
signal slice : std_logic_vector(3 downto 0) := x"0";

signal state : std_logic_vector(3 downto 0) := x"0";
signal in_image_x : std_logic := '0';
signal in_image_y : std_logic := '0';
signal next_pxcd : integer range 0 to 32767 := 0;
signal next_lcd : integer range 0 to 32767 := 0;
signal next_tempx : integer range 0 to 32767 := 0;
signal next_tempy : integer range 0 to 32767 := 0;

begin
    mem_block : vga_bitmap port map(
        clka => clk_i,
        addra => addra,
        douta => douta
    );
    
    process (clk_i)  -- ruling what to show
    variable tempx : integer range 0 to 32767 := 0;
    variable tempy : integer range 0 to 32767 := 0;
    variable xd : std_logic_vector(2 downto 0) := "000";
    --variable slice : std_logic_vector(3 downto 0) := "0000";
    begin
        if falling_edge(clk_i) then
            nextRGB <= nextRGB;
            if frametimer = 0 then  --check if nex pixel is in image bounds
                if state = x"0" then  --next pixel from current
                    -- test pxcd for begin on edge aka next is 639
                    --if (pxcd = 0) and (imx = 639) then
                    --    in_image_x <= '1';
                    if (pxcd - 1) = (imx) then
                        in_image_x <= '1';
                    elsif (pxcd - 1) = (imx - 256) then
                        in_image_x <= '0';
                    end if;
                    next_pxcd <= pxcd - 1;
                    next_tempx <= imx - (pxcd - 1);
                    next_lcd <= lcd;
                    
                elsif state = x"3" then --first pixel from next line
                    if (imx = 639) then
                        in_image_x <= '1';
                    else
                        in_image_x <= '0';
                    end if;
                    
                    if (lcd-1) = (imy) then
                        in_image_y <= '1';
                    elsif (lcd-1) = (imy-96) then
                        in_image_y <= '0';
                    end if; 
                    next_pxcd <= 639;
                    next_tempx <= imx - 639;
                    next_lcd <= lcd - 1;
                    
                elsif state = x"6" then  --top left 
                    if 639 = imx then
                        in_image_x <= '1';
                    else
                        in_image_x <= '0';
                    end if;
                    
                    if 479 = imy then
                        in_image_y <= '1';
                    else
                        in_image_y <= '0';
                    end if;
                    next_pxcd <= 639;
                    next_tempx <= imx - 639;
                    next_lcd <= 479;
                end if;
            elsif frametimer = 1 then  -- calc where on image and issue call
                if (in_image_x='1') and (in_image_y='1') then
                    --tempx := imx-next_pxcd;
                    --tempx := tempx / 2;
                    --tempy := 95-imy+next_lcd;
--                    addra <= std_logic_vector(to_unsigned(118+(95-imy+next_lcd)*128+(imx-next_pxcd)/2,14));
                    addra <= std_logic_vector(to_unsigned(118+(95-imy+next_lcd)*128+next_tempx/2,14));
                    --addra <= std_logic_vector(to_unsigned((tempy - 96)*128+tempx,14));
                end if;
            elsif frametimer = 2 then  -- capture douta
                if (in_image_x = '1') and (in_image_y = '1') then
                    if (next_pxcd - imx) mod 2 = 0 then
                        slice <= douta(7 downto 4);
                    else
                        slice <= douta(3 downto 0);
                    end if;
                end if;
            elsif frametimer = 3 then  -- set nextRGB from slice
                if (in_image_x = '1') and (in_image_y = '1') then
                    if slice = x"0" then
                        nextRGB <= "000";
                    elsif slice = x"9" then
                        nextRGB <= "100";
                    elsif slice = x"a" then
                        nextRGB <= "010";
                    elsif slice = x"b" then
                        nextRGB <= "110";
                    elsif slice = x"c" then
                        nextRGB <= "001";
                    elsif slice = x"d" then
                        nextRGB <= "101";
                    elsif slice = x"e" then
                        nextRGB <= "011";
                    elsif slice = x"f" then
                        nextRGB <= "111";
                    else
                        nextRGB <= RGBvh(4 downto 2);
                    end if;
                else
                    nextRGB <= (sw5_i, sw6_i, sw7_i);
                end if;
            
            end if;
        end if;        
    end process;
    
    --red_o <= RGBvh(4) & RGBvh(4) & RGBvh(4) & RGBvh(4);
    --green_o <= RGBvh(3) & RGBvh(3) & RGBvh(3) & RGBvh(3);
    --blue_o <= RGBvh(2) & RGBvh(2) & RGBvh(2) & RGBvh(2);
    red_o(3 downto 0) <= (others => RGBvh(4));
    green_o(3 downto 0) <= (others => RGBvh(3));
    blue_o(3 downto 0) <= (others => RGBvh(2));
    vsync_o <= RGBvh(1);
    hsync_o <= RGBvh(0);

    process (clk_i)  -- ruling current pixel position
    begin
        if rising_edge(clk_i) then
            RGBvh(1 downto 0) <= RGBvh(1 downto 0);
            if frametimer = 3 then  --end of pixel
                frametimer <= 0;
                if state = x"0" then
                    if pxcd = 0 then
                        state <= x"1";
                        pxcd <= 15;
                    else
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"1" then
                    if pxcd = 0 then
                        state <= x"2";
                        pxcd <= 95;
                        RGBvh(1 downto 0) <= "10";
                    else
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"2" then
                    if pxcd = 0 then
                        state <= x"3";
                        pxcd <= 47;
                        RGBvh(1 downto 0) <= "11";
                    else
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"3" then
                    if pxcd = 0 then
                        if lcd = 0 then
                            state <= x"4";
                            lcd <= 9;
                            pxcd <= 799;
                        else
                            lcd <= lcd - 1;
                            state <= x"0";
                            pxcd <= 639;
                        end if;
                    else
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"4" then
                    if pxcd = 144 then
                        RGBvh(0) <= '0';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 48 then
                        RGBvh(0) <= '1';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 0 then
                        if lcd = 0 then
                            state <= x"5";
                            lcd <= 1;
                            pxcd <= 799;
                            RGBvh(1) <= '0';
                            if btn_i(0) = '1' then
                                if imx /= 639 then
                                    imx <= imx+1;
                                end if;
                            end if;
                            if btn_i(1) = '1' then
                                if imy /= 95 then
                                    imy <= imy - 1;
                                end if;
                            end if;
                            if btn_i(2) = '1' then
                                if imy /= 479 then
                                    imy <= imy + 1;
                                end if;
                            end if;
                            if btn_i(3) = '1' then
                                if imx /= 255 then
                                    imx <= imx - 1;
                                end if;
                            end if;
                        else
                            lcd <= lcd - 1;
                            pxcd <= 799;
                        end if;
                    else 
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"5" then
                    if pxcd = 144 then
                        RGBvh(0) <= '0';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 48 then
                        RGBvh(0) <= '1';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 0 then
                        if lcd = 0 then
                            state <= x"6";
                            RGBvh(1) <= '1';
                            pxcd <= 799;
                            lcd <= 32;
                        else
                            lcd <= lcd - 1;
                            pxcd <= 799;
                        end if;
                    else
                        pxcd <= pxcd - 1;
                    end if;
                elsif state = x"6" then
                    if pxcd = 144 then
                        RGBvh(0) <= '0';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 48 then
                        RGBvh(0) <= '1';
                        pxcd <= pxcd - 1;
                    elsif pxcd = 0 then
                        if lcd = 0 then
                            state <= x"0";
                            pxcd <= 639;
                            lcd <= 479;
                        else
                            lcd <= lcd - 1;
                            pxcd <= 799;
                        end if;
                    else
                        pxcd <= pxcd - 1;
                    end if;
                end if;
            else
                frametimer <= frametimer + 1;  --still in pixel
            end if;
        
        end if;
    end process;
    
    
    
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if state = x"0" then
                RGBvh(4 downto 2) <= nextRGB;
                --RGBvh(4) <= sw5_i;
                --RGBvh(3) <= sw6_i;
                --RGBvh(2) <= sw7_i;
                --RGBvh(1 downto 0) <= "11";
            elsif state = x"1" then
                RGBvh(4 downto 2) <= "000";
            elsif state = x"2" then
                RGBvh(4 downto 2) <= "000";
            elsif state = x"3" then
                RGBvh(4 downto 2) <= "000";
            elsif state = x"4" then
                RGBvh(4 downto 2) <= "000";
            elsif state = x"5" then
                RGBvh(4 downto 2) <= "000";
            elsif state = x"6" then
                RGBvh(4 downto 2) <= "000";
            end if;
        end if;
    end process;
    
    led7_seg_o (3 downto 0) <= state;
    led7_seg_o(7) <=  in_image_x;--RGBvh(4);
    led7_seg_o(6) <=  in_image_y;--RGBvh(3);
    led7_seg_o(5) <=  RGBvh(2);
    --led7_seg_o(7) <=  sw7_i;
    --led7_seg_o(6) <=  sw6_i;
    --led7_seg_o(5) <=  sw5_i;
    led7_seg_o(4) <= '1';
--    led7_seg_o (7 downto 4) <= x"0";
    led7_an_o <= "1110";
    --led7_seg_o (3 downto 1) <= (sw5_i, sw6_i, sw7_i);
    


end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_color is
    Port (
        pixel_x  : in  STD_LOGIC_VECTOR(9 downto 0);
        pixel_y  : in  STD_LOGIC_VECTOR(9 downto 0);
        video_on : in  STD_LOGIC;

        r_out    : out STD_LOGIC_VECTOR(3 downto 0);
        g_out    : out STD_LOGIC_VECTOR(3 downto 0);
        b_out    : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_color;

architecture Behavioral of vga_color is
begin

    process(pixel_x, pixel_y, video_on)
        variable x : integer;
        variable y : integer;
    begin
        x := to_integer(unsigned(pixel_x));
        y := to_integer(unsigned(pixel_y));

        -- Default: black
        r_out <= "0000";
        g_out <= "0000";
        b_out <= "0000";

        if video_on = '1' then

            -- Red rectangle
            if x >= 50 and x < 200 and
               y >= 150 and y < 300 then

                r_out <= "1111";
                g_out <= "0000";
                b_out <= "0000";

            -- Green rectangle
            elsif x >= 245 and x < 395 and
                  y >= 150 and y < 300 then

                r_out <= "0000";
                g_out <= "1111";
                b_out <= "0000";

            -- Blue rectangle
            elsif x >= 440 and x < 590 and
                  y >= 150 and y < 300 then

                r_out <= "0000";
                g_out <= "0000";
                b_out <= "1111";

            end if;
        end if;
    end process;

end Behavioral;

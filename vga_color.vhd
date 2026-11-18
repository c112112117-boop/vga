
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
        variable x  : integer;
        variable y  : integer;
        variable dx : integer;
    begin
        x := to_integer(unsigned(pixel_x));
        y := to_integer(unsigned(pixel_y));
        dx := abs(x - 515);

        -- 預設背景為黑色
        r_out <= "0000";
        g_out <= "0000";
        b_out <= "0000";

        if video_on = '1' then

            -- 左邊：紅色正方形
            if x >= 50 and x < 200 and
               y >= 150 and y < 300 then

                r_out <= "1111";
                g_out <= "0000";
                b_out <= "0000";

            -- 中間：綠色圓形
            elsif ((x - 320) * (x - 320) +
                   (y - 225) * (y - 225)) <= (75 * 75) then

                r_out <= "0000";
                g_out <= "1111";
                b_out <= "0000";

            -- 右邊：藍色三角形
            elsif y >= 150 and y < 300 and
                  (2 * dx) <= (y - 150) then

                r_out <= "0000";
                g_out <= "0000";
                b_out <= "1111";

            end if;
        end if;
    end process;

end Behavioral;

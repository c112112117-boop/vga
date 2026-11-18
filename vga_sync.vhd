
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    Port (
        pixel_clk : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;
        video_on  : out STD_LOGIC;
        pixel_x   : out STD_LOGIC_VECTOR(9 downto 0);
        pixel_y   : out STD_LOGIC_VECTOR(9 downto 0)
    );
end vga_sync;

architecture Behavioral of vga_sync is
    signal h_count : integer range 0 to 799 := 0;
    signal v_count : integer range 0 to 524 := 0;
begin

    process(pixel_clk, rst)
    begin
        if rst = '1' then
            h_count <= 0;
            v_count <= 0;

        elsif rising_edge(pixel_clk) then
            if h_count = 799 then
                h_count <= 0;

                if v_count = 524 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    hsync <= '0' when h_count >= 656 and h_count <= 751 else '1';
    vsync <= '0' when v_count >= 490 and v_count <= 491 else '1';

    video_on <= '1' when h_count < 640 and v_count < 480 else '0';

    pixel_x <= std_logic_vector(to_unsigned(h_count, 10));
    pixel_y <= std_logic_vector(to_unsigned(v_count, 10));

end Behavioral;
    

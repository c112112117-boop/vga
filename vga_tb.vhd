
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_tb is
end vga_tb;

architecture Behavioral of vga_tb is

    signal video_clk : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '1';

    signal hsync     : STD_LOGIC;
    signal vsync     : STD_LOGIC;

    signal r_out     : STD_LOGIC_VECTOR(3 downto 0);
    signal g_out     : STD_LOGIC_VECTOR(3 downto 0);
    signal b_out     : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- 100 MHz clock (10 ns period)
    video_clk <= not video_clk after 5 ns;

    -- Device Under Test
    uut : entity work.vga_top
        port map (
            video_clk => video_clk,
            rst       => rst,
            hsync     => hsync,
            vsync     => vsync,
            r_out     => r_out,
            g_out     => g_out,
            b_out     => b_out
        );

    -- Reset sequence
    process
    begin
        rst <= '1';
        wait for 100 ns;

        rst <= '0';
        wait;

    end process;

end Behavioral;

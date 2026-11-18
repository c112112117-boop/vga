
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_top is
    Port (
        -- 100 MHz input clock
        video_clk : in  STD_LOGIC;

        -- Reset (high = reset)
        rst       : in  STD_LOGIC;

        -- VGA sync signals
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;

        -- RGB outputs (4 bits per color)
        r_out     : out STD_LOGIC_VECTOR(3 downto 0);
        g_out     : out STD_LOGIC_VECTOR(3 downto 0);
        b_out     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_top;

architecture Behavioral of vga_top is

    -- Clock Wizard signals
    signal pixel_clk : STD_LOGIC;
    signal locked    : STD_LOGIC;
    signal rst_int   : STD_LOGIC;

    -- VGA position signals
    signal pixel_x   : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y   : STD_LOGIC_VECTOR(9 downto 0);

    -- Video active signal
    signal video_on  : STD_LOGIC;

begin

    ------------------------------------------------
    -- Clock Wizard: 100 MHz -> 25 MHz
    ------------------------------------------------
    clock_inst : entity work.clk_wiz_0
        port map (
            clk_in1  => video_clk,
            reset    => rst,
            clk_out1 => pixel_clk,
            locked   => locked
        );

    -- Keep VGA circuit in reset until clock is locked
    rst_int <= rst or (not locked);

    ------------------------------------------------
    -- VGA Synchronization
    ------------------------------------------------
    sync_inst : entity work.vga_sync
    port map (
        pixel_clk => pixel_clk,
        rst       => rst_int,
        hsync     => hsync,
        vsync     => vsync,
        video_on  => video_on,
        pixel_x   => pixel_x,
        pixel_y   => pixel_y
    );

    ------------------------------------------------
    -- VGA Color Generator
    ------------------------------------------------
    color_inst : entity work.vga_color
        port map (
            pixel_x => pixel_x,
            pixel_y => pixel_y,
            video_on => video_on,
            r_out   => r_out,
            g_out   => g_out,
            b_out   => b_out
        );

end Behavioral;

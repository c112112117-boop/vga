library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--==================================================
-- VGA Top Module
-- 整個 VGA 顯示系統的最上層模組
--==================================================
entity vga_top is
    Port (
        -- 100 MHz input clock
        -- FPGA 板子提供的 100 MHz 時脈輸入
        video_clk : in  STD_LOGIC;

        -- Reset (high = reset)
        -- 高電位時進行重置
        rst       : in  STD_LOGIC;

        -- VGA sync signals
        -- VGA 水平與垂直同步訊號
        hsync     : out STD_LOGIC;
        vsync     : out STD_LOGIC;

        -- RGB outputs (4 bits per color)
        -- RGB 三種顏色的輸出，每種顏色有 4 bits
        r_out     : out STD_LOGIC_VECTOR(3 downto 0);
        g_out     : out STD_LOGIC_VECTOR(3 downto 0);
        b_out     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end vga_top;

--==================================================
-- Architecture
-- 描述 VGA Top Module 的內部運作
--==================================================
architecture Behavioral of vga_top is

    -- Clock Wizard signals
    -- Clock Wizard 產生的時脈及狀態訊號
    signal pixel_clk : STD_LOGIC;  -- 25 MHz VGA pixel clock
    signal locked    : STD_LOGIC; -- 時脈是否已穩定
    signal rst_int   : STD_LOGIC; -- 內部使用的 reset 訊號

    -- VGA position signals
    -- 表示目前畫面像素的位置
    signal pixel_x   : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y   : STD_LOGIC_VECTOR(9 downto 0);

    -- Video active signal
    -- 判斷目前是否位於有效顯示區域
    signal video_on  : STD_LOGIC;

begin

    ------------------------------------------------
    -- Clock Wizard: 100 MHz -> 25 MHz
    -- 將輸入的 100 MHz 時脈轉換成 VGA 使用的 25 MHz
    ------------------------------------------------
    clock_inst : entity work.clk_wiz_0
        port map (
            clk_in1  => video_clk, -- 輸入 100 MHz 時脈
            reset    => rst,        -- 外部 reset
            clk_out1 => pixel_clk,  -- 輸出 25 MHz 時脈
            locked   => locked      -- 時脈穩定狀態
        );

    -- Keep VGA circuit in reset until clock is locked
    -- 如果時脈尚未穩定，讓 VGA 電路保持在 reset 狀態
    -- rst_int = rst OR (NOT locked)
    rst_int <= rst or (not locked);

    ------------------------------------------------
    -- VGA Synchronization
    -- 產生 VGA 的水平、垂直同步訊號及目前像素座標
    ------------------------------------------------
    sync_inst : entity work.vga_sync
    port map (
        pixel_clk => pixel_clk, -- VGA 使用的 25 MHz 時脈
        rst       => rst_int,   -- 內部 reset
        hsync    => hsync,     -- 水平同步訊號
        vsync    => vsync,     -- 垂直同步訊號
        video_on => video_on,  -- 是否在有效畫面區域
        pixel_x  => pixel_x,   -- 目前水平像素座標
        pixel_y  => pixel_y    -- 目前垂直像素座標
    );

    ------------------------------------------------
    -- VGA Color Generator
    -- 根據目前像素座標決定要輸出什麼顏色
    ------------------------------------------------
    color_inst : entity work.vga_color
        port map (
            pixel_x => pixel_x,   -- 水平座標
            pixel_y => pixel_y,   -- 垂直座標
            video_on => video_on, -- 有效顯示區域判斷
            r_out   => r_out,    -- 紅色輸出
            g_out   => g_out,    -- 綠色輸出
            b_out   => b_out    -- 藍色輸出
        );

end Behavioral;

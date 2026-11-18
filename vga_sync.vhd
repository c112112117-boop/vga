library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--==================================================
-- Entity：VGA 同步訊號產生器
-- 用來產生 VGA 螢幕所需的水平、垂直同步訊號，
-- 以及目前像素的 X、Y 座標和有效顯示訊號。
--==================================================
entity vga_sync is
    Port (
        pixel_clk : in  STD_LOGIC;  -- VGA 像素時脈，25MHz
        rst       : in  STD_LOGIC;  -- 重置訊號，高電位有效

        hsync     : out STD_LOGIC;  -- 水平同步訊號
        vsync     : out STD_LOGIC;  -- 垂直同步訊號
        video_on  : out STD_LOGIC;  -- 有效畫面顯示區域訊號

        pixel_x   : out STD_LOGIC_VECTOR(9 downto 0); -- 目前水平座標 X
        pixel_y   : out STD_LOGIC_VECTOR(9 downto 0)  -- 目前垂直座標 Y
    );
end vga_sync;

architecture Behavioral of vga_sync is

    --==================================================
    -- VGA 水平計數器
    -- 一條掃描線共 800 個時脈週期
    -- 計數範圍為 0～799
    --==================================================
    signal h_count : integer range 0 to 799 := 0;

    --==================================================
    -- VGA 垂直計數器
    -- 一個畫面共 525 條掃描線
    -- 計數範圍為 0～524
    --==================================================
    signal v_count : integer range 0 to 524 := 0;

begin

    --==================================================
    -- 水平與垂直計數器控制
    -- 使用 pixel_clk 控制畫面掃描位置
    --==================================================
    process(pixel_clk, rst)
    begin

        -- Reset：將水平與垂直計數器歸零
        if rst = '1' then
            h_count <= 0;
            v_count <= 0;

        -- 每當像素時脈上升沿，更新計數器
        elsif rising_edge(pixel_clk) then

            -- 當水平計數到 799，代表一條掃描線結束
            if h_count = 799 then
                h_count <= 0;  -- 水平計數器歸零，開始下一條掃描線

                -- 當垂直計數到 524，代表整個畫面掃描完成
                if v_count = 524 then
                    v_count <= 0;  -- 垂直計數器歸零，開始下一個畫面

                else
                    -- 尚未掃描完整個畫面，垂直計數器加 1
                    v_count <= v_count + 1;
                end if;

            else
                -- 尚未掃描完目前掃描線，水平計數器加 1
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    --==================================================
    -- Horizontal Sync：水平同步訊號
    -- 當水平計數器位於 656～751 時輸出低電位
    -- 其餘時間輸出高電位
    --==================================================
    hsync <= '0' when h_count >= 656 and h_count <= 751 else '1';

    --==================================================
    -- Vertical Sync：垂直同步訊號
    -- 當垂直計數器位於 490～491 時輸出低電位
    -- 其餘時間輸出高電位
    --==================================================
    vsync <= '0' when v_count >= 490 and v_count <= 491 else '1';

    --==================================================
    -- Video On：有效顯示區域判斷
    -- 當 X 座標小於 640 且 Y 座標小於 480 時，
    -- 表示目前像素位於可顯示畫面的範圍內
    --==================================================
    video_on <= '1' when h_count < 640 and v_count < 480 else '0';

    --==================================================
    -- 輸出目前像素的水平座標 X
    -- 將整數 h_count 轉換成 10-bit 二進位訊號
    --==================================================
    pixel_x <= std_logic_vector(to_unsigned(h_count, 10));

    --==================================================
    -- 輸出目前像素的垂直座標 Y
    -- 將整數 v_count 轉換成 10-bit 二進位訊號
    --==================================================
    pixel_y <= std_logic_vector(to_unsigned(v_count, 10));

end Behavioral;

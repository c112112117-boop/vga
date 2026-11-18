# vga
1. 作業介紹

本專案使用 VHDL 在 ZedBoard FPGA 上實作 VGA 顯示，解析度為 640 × 480。畫面包含黑色背景、左側紅色方形、中間綠色圓形及右側藍色三角形。

2. 系統功能

使用 Clock Wizard 將輸入的 100 MHz 時脈轉換為 25 MHz，作為 VGA 像素時脈。

使用 VGA Sync 模組產生水平同步（HSYNC）、垂直同步（VSYNC）及像素座標。

使用 VGA Color 模組根據像素座標決定顯示的顏色及圖形。

畫面只在有效顯示區域輸出顏色，其餘區域為黑色。

3. 程式檔案

vga_top.vhd：連接時脈、VGA 同步及顏色產生模組。

vga_sync.vhd：產生 VGA 同步訊號及像素座標。

vga_color.vhd：控制 RGB 顏色輸出及圖形顯示。

clk_wiz_0：將 100 MHz 時脈轉換為 25 MHz。

4. 顯示結果

VGA 螢幕顯示黑色背景，並呈現左側紅色方形、中間綠色圓形及右側藍色三角形。

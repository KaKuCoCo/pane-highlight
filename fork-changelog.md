# Fork changelog

本紀錄比較 `olegpulatov/pane-highlight` 與 `KaKuCoCo/pane-highlight` 的 `main` 分支，列出 fork 專屬變更。日期為 Git 作者日期。

## 2026-11-10

- 新增命令面板的壁紙取色開關。
  - `Pane Highlight: wallpaper colors on` 與 `… off` 不需重新載入即可切換；`on` 會重新讀取圖片，換壁紙後執行即可換色。
  - 選擇記在 kv，直到 `config.json` 的 `wallpaper` 改變為止，與動畫選項相同。
  - 原本只能改 `config.json` 再重新載入外掛；圖片分析途中關閉時，不再套用分析結果。

## 2026-11-09

- 調整 `tern process` 的 `--window` 選項位置。
  - 將 `--window` 移到動詞之後，並更新版本與紀錄。
  - Tern 0.9.13 將動詞前的選項解讀為啟動視窗，錯誤地開啟參數路徑，卻回傳成功，導致外掛反覆使用該視窗鍵。
- 發布 0.3.0。
  - 新增壁紙取色、未命中規則時的 `color`，以及可切換的 `default` 與 `glow` 動畫。
  - 焦點切換先顯示前次顏色，300 毫秒後才查詢程序；空規則則略過查詢。
  - 壁紙顏色依佔比與彩度排序並按主題調整，以維持邊框可讀性。
  - Windows 在 UI 執行緒外分析圖片，其他平台使用壁紙外掛的色盤；無可用顏色時回退至主題強調色。
  - 提交未說明動畫選項和圓角變更的個別原因。

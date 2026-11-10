# Fork changelog

上游：[olegpulatov/pane-highlight](https://github.com/olegpulatov/pane-highlight)

## 2026-11-10

### Added
- 命令面板新增壁紙取色開關（`Pane Highlight: wallpaper colors on/off`）。
  - 原因：原本要改 `config.json` 再重新載入外掛。

### Changed
- 前景程式查詢改用 `cx:window_key()`，不再逐一嘗試視窗編號 1 到 9。
  - 原因：`cx:window_key()` 直接提供本視窗的 key；掃描會多開程序，也碰不到編號以外的視窗。

## 2026-11-09

### Added
- 壁紙取色、未命中規則時的 `color`，以及 `default`、`glow` 動畫選項。
  - 原因：邊框顏色配合壁紙。

### Changed
- 焦點切換先顯示前次顏色，300 毫秒後才查詢程序。
  - 原因：減少切換焦點時的查詢次數。

### Fixed
- `tern process` 的 `--window` 移到動詞之後。
  - 原因：Tern 0.9.13 把動詞前的選項當成啟動視窗，錯誤開啟參數路徑。
  - 上游：未回報。

## 已移除

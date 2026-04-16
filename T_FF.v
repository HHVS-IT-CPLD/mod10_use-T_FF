`timescale 1ns / 1ps

// ============================================================
// 模組名稱：T_FF
// 功能說明：
//   1) 這是一個 T 行正反器（T Flip-Flop）。
//   2) 在時脈正緣 (posedge clk) 觸發時：
//      - 若 t = 1，輸出 q 會反相（toggle）。
//      - 若 t = 0，輸出 q 維持原值（hold）。
//   3) 提供非同步低有效重置 rst_n：
//      - 當 rst_n = 0 時，不需等待時脈，q 立即清為 0。
// ============================================================
module T_FF (
	input  wire clk,     // 時脈訊號：在正緣更新狀態
	input  wire rst_n,   // 非同步低有效重置：0=立即重置，1=正常運作
	input  wire t,       // T 控制輸入：1=反相，0=保持
	output reg  q,       // 主輸出
	output wire q_bar    // 反相輸出（永遠等於 ~q）
);

	// --------------------------------------------------------
	// 狀態更新區塊
	// 敏感度列表使用：posedge clk 或 negedge rst_n
	// 表示此 always 區塊會在「時脈正緣」或「重置負緣」時執行。
	// --------------------------------------------------------
	always @(posedge clk or negedge rst_n) begin
		// 非同步重置優先權最高：只要 rst_n 拉低，立刻清除 q
		if (!rst_n)
			q <= 1'b0;
		// 正常運作：依照 t 決定是否反相
		else if (t)
			q <= ~q;      // t=1：反相（toggle）
		else
			q <= q;       // t=0：保持（hold）
	end

	// q_bar 為 q 的組合邏輯反相輸出
	assign q_bar = ~q;

endmodule
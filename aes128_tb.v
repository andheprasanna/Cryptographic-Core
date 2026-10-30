`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2026 22:11:07
// Design Name: 
// Module Name: aes128_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Yeshvanth M
// Modified: Cleaned-up AES-128 testbench
//
// Description:
// Testbench for AES-128 encryption and decryption
//
// Tool: Xilinx Vivado
//////////////////////////////////////////////////////////////////////////////////

module aes128_tb;

/* Clock */
localparam CLK_PERIOD = 10;
reg clk = 1'b0;
always #(CLK_PERIOD / 2) clk = ~clk;

/* DUT signals */
reg          reset_key_i  = 1'b0;
reg          load_data_i  = 1'b0;
reg          enc_or_dec_i = 1'b1;   // 1 = encrypt, 0 = decrypt
reg  [127:0] plain_text_i = 128'd0;
reg  [127:0] cipher_key_i = 128'd0;

wire [127:0] cipher_text;
wire         cipher_ready, key_ready;

/* Test data */
localparam [127:0] KEY  = 128'h2B28AB097EAEF7CF15D2154F16A6883C;
localparam [127:0] PT_A = 128'h4C6D73646F20756F72696D6C6570206F;   // your vector
localparam [127:0] CT_A = 128'hBFC4C771D72CD65B5C4DFAAEFFF80EDB;
localparam [127:0] PT_B = 128'h328831E0435A3137F6309807A88DA234;   // FIPS-197 App. B (same key)
localparam [127:0] CT_B = 128'h3902DC1925DC116A8409850B1DFB9732;

/* Instantiate DUT */
aes128 encrypt (
    .clk_i          (clk),
    .reset_key_i    (reset_key_i),
    .load_data_i    (load_data_i),
    .plain_text_i   (plain_text_i),
    .cipher_key_i   (cipher_key_i),
    .enc_or_dec_i   (enc_or_dec_i),
    .cipher_text_o  (cipher_text),
    .cipher_ready_o (cipher_ready),
    .key_ready_o    (key_ready)
);

/* Result counters */
integer checks = 0;
integer errors = 0;

task check;
    input        cond;
    input [8*48-1:0] msg;
    begin
        checks = checks + 1;
        if (cond)
            $display("[%0t] PASS: %0s", $time, msg);
        else begin
            errors = errors + 1;
            $display("[%0t] FAIL: %0s", $time, msg);
        end
    end
endtask

/* Load the cipher key and wait for the key schedule (10 cycles) */
task load_key;
    begin
        cipher_key_i = KEY;
        plain_text_i = KEY;
        reset_key_i = 1; #(CLK_PERIOD);
        reset_key_i = 0; #(CLK_PERIOD);
        check(key_ready === 1'b0, "key_ready low after key load");

        repeat (10) #(CLK_PERIOD);
        check(key_ready === 1'b1, "key schedule done in 10 cycles");
    end
endtask

/* Push one block through the core and compare with the expected result */
task run_block;
    input [127:0]    din;
    input [127:0]    expected;
    input [8*32-1:0] name;
    begin
        $display("---- %0s ----", name);
        // only one 128-bit lane feeds the data, so drive both inputs
        plain_text_i = din;
        cipher_key_i = din;

        load_data_i = 1; #(CLK_PERIOD);
        load_data_i = 0; #(CLK_PERIOD);
        check(cipher_ready === 1'b0, "cipher_ready low after data load");

        repeat (10) #(CLK_PERIOD);
        check(cipher_ready === 1'b1, "result ready in 10 cycles");
        check(cipher_text === expected, "result matches expected value");
        if (cipher_text !== expected)
            $display("        got %h  expected %h", cipher_text, expected);
    end
endtask

initial begin
    $timeformat(-9, 0, " ns", 0);   // print times in ns instead of ps
    load_key;

    /* Encryption, including repeated data loads */
    enc_or_dec_i = 1'b1;
    run_block(PT_A, CT_A, "encrypt A (first load)");
    run_block(PT_A, CT_A, "encrypt A (repeat 1)");
    run_block(PT_A, CT_A, "encrypt A (repeat 2)");

    /* Repeated key load */
    load_key;
    run_block(PT_A, CT_A, "encrypt A after key reload");

    /* Standard FIPS-197 vector */
    run_block(PT_B, CT_B, "encrypt FIPS-197 vector B");

    /* Decryption: cipher text in, original plain text out */
    enc_or_dec_i = 1'b0;
    run_block(CT_A, PT_A, "decrypt A");
    run_block(CT_B, PT_B, "decrypt B");

    /* Summary */
    $display("=====================================");
    if (errors == 0)
        $display(" ALL %0d CHECKS PASSED", checks);
    else
        $display(" %0d of %0d CHECKS FAILED", errors, checks);
    $display("=====================================");

    #(CLK_PERIOD);
    $finish;
end

endmodule

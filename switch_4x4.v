module switch_4x4 (
    input clk, rst,
    input [31:0] input_1, input_2, input_3, input_4,
    output [31:0] output_1, output_2, output_3, output_4
);
    
    reg [31:0] input_word_to_1, input_word_to_2, input_word_to_3, input_word_to_4;
    reg [32:0] output_buf_1_1, output_buf_1_2, output_buf_1_3, output_buf_1_4;
    reg [32:0] output_buf_2_1, output_buf_2_2, output_buf_2_3, output_buf_2_4;
    reg [32:0] output_buf_3_1, output_buf_3_2, output_buf_3_3, output_buf_3_4;
    reg [32:0] output_buf_4_1, output_buf_4_2, output_buf_4_3, output_buf_4_4;

    input_daemon input_daemon_1(.clk(clk), .rst(rst), .input_word(input_word_to_1),
        .to_output_buf_1(output_buf_1_1), .to_output_buf_2(output_buf_1_2),
        .to_output_buf_3(output_buf_1_3), .to_output_buf_4(output_buf_1_4)
    );

    input_daemon input_daemon_2(.clk(clk), .rst(rst), .input_word(input_word_to_2),
        .to_output_buf_1(output_buf_2_1), .to_output_buf_2(output_buf_2_2),
        .to_output_buf_3(output_buf_2_3), .to_output_buf_4(output_buf_2_4)
    );

        input_daemon input_daemon_3(.clk(clk), .rst(rst), .input_word(input_word_to_3),
        .to_output_buf_1(output_buf_3_1), .to_output_buf_2(output_buf_3_2),
        .to_output_buf_3(output_buf_3_3), .to_output_buf_4(output_buf_3_4)
    );

        input_daemon input_daemon_4(.clk(clk), .rst(rst), .input_word(input_word_to_4),
        .to_output_buf_1(output_buf_4_1), .to_output_buf_2(output_buf_4_2),
        .to_output_buf_3(output_buf_4_3), .to_output_buf_4(output_buf_4_4)
    );

endmodule
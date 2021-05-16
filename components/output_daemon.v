module output_daemon (
    input clk,rst,
    input [32:0] NOBLOCKOBUF_FROM_1, NOBLOCKOBUF_FROM_2, NOBLOCKOBUF_FROM_3, NOBLOCKOBUF_FROM_4,
    output [31:0] OUTPUT_PORT
);

    reg [7:0] down_counter;
    wire [7:0] next_down_counter;
    reg [32:0] pkt_1_e_word, pkt_2_e_word, pkt_3_e_word, pkt_4_e_word;
    reg [2:0] active_packet, priority_queue, next_active_packet, next_priority_queue;
    wire p1_valid, p2_valid, p3_valid, p4_valid, valid_active_pkt_word_read;
    wire started_new_packet;
    wire [15:0] new_packet_length;
    wire read_from_1, read_from_2, read_from_3, read_from_4;

    wire [31:0] data_to_out;
    wire send_flag;

    assign p1_valid = pkt_1_e_word[32];
    assign p2_valid = pkt_2_e_word[32];
    assign p3_valid = pkt_3_e_word[32];
    assign p4_valid = pkt_4_e_word[32];

    assign started_new_packet = ((next_active_packet != 3'd0) & (down_counter == 0));
    assign read_from_1 = (~p1_valid) | (next_active_packet == 3'd1);
    assign read_from_2 = (~p2_valid) | (next_active_packet == 3'd2);
    assign read_from_3 = (~p3_valid) | (next_active_packet == 3'd3);
    assign read_from_4 = (~p4_valid) | (next_active_packet == 3'd4);

    priority_select priority_select_instance(.down_counter(down_counter),
.active_packet(active_packet), 
.priority_queue(priority_queue),
.p1_valid(p1_valid), 
.p2_valid(p2_valid), 
.p3_valid(p3_valid), 
.p4_valid(p4_valid),
.next_active_packet(next_active_packet), 
.next_priority_queue(next_priority_queue));

    always @(*) begin
        case (active_packet)
            3'd1:
                valid_active_pkt_word_read <= p1_valid; 
            3'd2:
                valid_active_pkt_word_read <= p2_valid;
            3'd3:
                valid_active_pkt_word_read <= p3_valid;
            3'd4:
                valid_active_pkt_word_read <= p4_valid;
            default: 
                valid_active_pkt_word_read <= 1'b0;
        endcase
    end

    always @(*) begin
        case (next_active_packet)
            3'd1:
                new_packet_length <= pkt_1_e_word[23:8];
            3'd2:
                new_packet_length <= pkt_2_e_word[23:0];
            3'd3:
                new_packet_length <= pkt_3_e_word[23:8];
            3'd4:
                new_packet_length <= pkt_4_e_word[23:8];
            default: 
                new_packet_length <= 16'd0;  
        endcase
    end

    always @(*) begin
        if(started_new_packet == 1'b1)
            next_down_counter <= (new_packet_length - 1);
        else begin
            if(valid_active_pkt_word_read == 1'b1) 
                next_down_counter <= (down_counter - 1);
            else
                next_down_counter <= down_counter;
        end
    end

    always @(*) begin
        case (next_active_packet)
            3'd1:
                data_to_out <= pkt_1_e_word[31:0];
            3'd2:
                data_to_out <= pkt_2_e_word[31:0];
            3'd3:
                data_to_out <= pkt_3_e_word[31:0];
            3'd4:
                data_to_out <= pkt_4_e_word[31:0];
            default: 
                data_to_out <= 32'd0;
        endcase
    end

    always @(*) begin
        case (next_active_packet)
            3'd1:
                send_flag <= p1_valid;
            3'd2:
                send_flag <= p2_valid;
            3'd3:
                send_flag <= p3_valid;
            3'd4:
                send_flag <= p4_valid;
            default:
                send_flag <= 1'b0;
        endcase
    end

    always @(posedge clk, rst) begin
        if(rst == 1'b1) begin
            down_counter <= 16'd0;
            pkt_1_e_word <= 33'd0;
            pkt_2_e_word <= 33'd0;
            pkt_3_e_word <= 33'd0;
            pkt_4_e_word <= 33'd0;
            active_packet <= 3'd0;
            priority_queue <= 3'd1;
        end else begin
            down_counter <= next_down_counter;
            if (read_from_1) 
                pkt_1_e_word <= NOBLOCKOBUF_FROM_1;
            if (read_from_2) 
                pkt_2_e_word <= NOBLOCKOBUF_FROM_2;
            if (read_from_3) 
                pkt_3_e_word <= NOBLOCKOBUF_FROM_3;
            if (read_from_4) 
                pkt_4_e_word <= NOBLOCKOBUF_FROM_4;

            active_packet <= next_active_packet;
            priority_queue <= next_priority_queue;
        end

        if(send_flag)
            OUTPUT_PORT <= data_to_out;

    end

endmodule
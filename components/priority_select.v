module priority_select (
    input [15:0] down_counter,
    input [2:0] active_packet, priority_queue,
    input p1_valid, p2_valid, p3_valid, p4_valid,
    output reg [2:0] next_active_packet, next_priority_queue
);

    wire d0, select_1, select_2, select_3, select_4, is_select_done;
    reg [2:0] temp_next_priority_queue;

    assign d0 = (down_counter == 0) ? 1'b1: 1'b0;

    assign select_1 = (d0 & p1_valid & ((priority_queue == 3'd1) | (~p2_valid & ~p3_valid & ~p4_valid) ) );
    assign select_2 = (d0 & p2_valid & ((priority_queue == 3'd2) | (~p1_valid & ~p3_valid & ~p4_valid) ) );
    assign select_3 = (d0 & p3_valid & ((priority_queue == 3'd3) | (~p1_valid & ~p2_valid & ~p4_valid) ) );
    assign select_4 = (d0 & p4_valid & ((priority_queue == 3'd4) | (~p1_valid & ~p2_valid & ~p3_valid) ) );
    assign is_select_done = (select_1 | select_2 | select_3 | select_4);


    always @(*) begin
        if(d0 == 1'b0)
            next_active_packet <= active_packet;
        else if(select_1 == 1'b1)
            next_active_packet <= 3'd1;
        else if(select_2 == 1'b1)
            next_active_packet <= 3'd2;
        else if(select_3 == 1'b1)
            next_active_packet <= 3'd3;
        else if(select_4 == 1'b1)
            next_active_packet <= 3'd4;
    end

    always @(*) begin
        if(priority_queue == 3'd0)
            temp_next_priority_queue <= 3'd1;
        if(priority_queue == 3'd1)
            temp_next_priority_queue <= 3'd2;
        if(priority_queue == 3'd2)
            temp_next_priority_queue <= 3'd3;
        if(priority_queue == 3'd3)
            temp_next_priority_queue <= 3'd4;
        if(priority_queue == 3'd4)
            temp_next_priority_queue <= 3'd1;
    end

    always @(*) begin
        if(is_select_done == 1'b1)
            next_priority_queue <= temp_next_priority_queue;
        else
            next_priority_queue <= priority_queue;
    end

endmodule
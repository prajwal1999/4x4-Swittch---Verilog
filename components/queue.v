module queue
(
    input clk, rst, wr_en, rd_en,
    input [32:0] wr_data,
    output reg [32:0] rd_data
);
    
    reg [32:0] queue_data[127:0];
    reg [6:0] rd_ptr, wr_ptr;
    integer i;
    // always @(negedge clk) begin
    //     if( (rst != 1'b1) & (wr_en == 1'b1) ) begin
    //         queue_data[wr_ptr] = wr_data;
    //         wr_data = wr_data - 1;
    //     end
    // end

    always @(posedge clk, rst) begin
        if(rst == 1'b1) begin
            for (i=0; i<128; i=i+1) begin
                queue_data[i] <= 33'd0;
            end
            wr_ptr <= 7'd127;
            rd_ptr <= 7'd127;
            rd_data <= 33'd0;
        end else begin
            if(rd_en == 1'b1) begin
                rd_data = queue_data[rd_ptr];
                rd_ptr = rd_ptr-1;
            end
            if(wr_en == 1'b1) begin
                queue_data[wr_ptr] = wr_data;
                wr_ptr = wr_ptr - 1;
            end
        end
    end

endmodule
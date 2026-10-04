`default_nettype none

module zxc_core(
    input wire [0:0] input_0,
    input wire [7:0] input_1,
    output wire [7:0] output_0,
    output wire fault
);

wire [0:0] n_0;
assign n_0 = input_0;

wire [7:0] n_1;
assign n_1 = input_1;

wire [0:0] n_2;
assign n_2 = 1'd1;

wire [0:0] n_3;
assign n_3 = !n_2;

wire [7:0] n_4;
assign n_4 = n_2 ? n_1 : n_1;

wire [0:0] n_5;
assign n_5 = 1'd0;

wire [0:0] n_6;
assign n_6 = n_5 || n_2;

wire [0:0] n_7;
assign n_7 = !n_3;

wire [0:0] n_8;
assign n_8 = n_7 && n_6;

wire [0:0] n_9;
assign n_9 = !n_8;

wire [0:0] n_10;
assign n_10 = n_8 && n_3;

wire [0:0] n_11;
assign n_11 = n_0 == n_2;

wire [0:0] n_12;
assign n_12 = n_8 && n_11;

wire [0:0] n_13;
assign n_13 = n_12 && n_3;

wire [0:0] n_14;
assign n_14 = n_5 || n_5;

wire [0:0] n_15;
assign n_15 = !n_11;

wire [0:0] n_16;
assign n_16 = n_8 && n_15;

wire [7:0] n_17;
assign n_17 = 8'd0;

wire [0:0] n_18;
assign n_18 = n_16 && n_3;

wire [0:0] n_19;
assign n_19 = n_14 || n_5;

wire [7:0] n_20;
assign n_20 = n_12 ? n_4 : n_4;

wire [0:0] n_21;
assign n_21 = n_5 || n_12;

wire [7:0] n_22;
assign n_22 = n_16 ? n_17 : n_20;

wire [0:0] n_23;
assign n_23 = n_21 || n_16;

wire [0:0] n_24;
assign n_24 = !n_9;

wire [0:0] n_25;
assign n_25 = !n_10;

wire [0:0] n_26;
assign n_26 = n_24 && n_25;

wire [0:0] n_27;
assign n_27 = !n_13;

wire [0:0] n_28;
assign n_28 = n_26 && n_27;

wire [0:0] n_29;
assign n_29 = !n_18;

wire [0:0] n_30;
assign n_30 = n_28 && n_29;

wire [0:0] n_31;
assign n_31 = n_30 && n_23;

assign output_0 = n_22;
assign fault = !n_31;

endmodule

module zxc_kernel(
    input wire clk,
    input wire reset,
    input wire input_valid,
    output wire input_ready,
    output reg output_valid,
    input wire output_ready,
    input wire [0:0] input_0,
    input wire [7:0] input_1,
    output reg [7:0] output_0,
    output reg fault
);

wire core_fault;
wire [7:0] core_output_0;

zxc_core core(
    .input_0(input_0),
    .input_1(input_1),
    .output_0(core_output_0),
    .fault(core_fault)
);

assign input_ready = !reset && (!output_valid || output_ready);

always @(posedge clk) begin
    if (reset) begin
        output_valid <= 1'b0;
        fault <= 1'b0;
        output_0 <= 8'd0;
    end else if (input_ready) begin
        output_valid <= input_valid;

        if (input_valid) begin
            fault <= core_fault;
            output_0 <= core_output_0;
        end
    end
end

endmodule

`default_nettype wire

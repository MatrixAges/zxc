`default_nettype none

module zxc_kernel(
    input wire [63:0] input_0,
    output wire [63:0] output_0,
    output wire fault
);

wire [63:0] n_0;
assign n_0 = input_0;

wire [63:0] n_1;
assign n_1 = 64'd3;

wire [63:0] n_2;
assign n_2 = n_0 + n_1;

wire [64:0] n_3;
assign n_3 = {1'd0, n_0};

wire [64:0] n_4;
assign n_4 = {1'd0, n_1};

wire [64:0] n_5;
assign n_5 = n_3 + n_4;

wire [64:0] n_6;
assign n_6 = {1'd0, n_2};

wire [0:0] n_7;
assign n_7 = n_5 == n_6;

wire [0:0] n_8;
assign n_8 = !n_7;

wire [63:0] n_9;
assign n_9 = n_7 ? n_2 : n_2;

wire [0:0] n_10;
assign n_10 = 1'd0;

wire [0:0] n_11;
assign n_11 = n_10 || n_7;

wire [0:0] n_12;
assign n_12 = !n_8;

wire [0:0] n_13;
assign n_13 = n_12 && n_11;

assign output_0 = n_9;
assign fault = !n_13;

endmodule

`default_nettype wire

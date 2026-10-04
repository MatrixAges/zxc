`default_nettype none

module zxc_kernel(
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

assign output_0 = n_4;
assign fault = !n_8;

endmodule

`default_nettype wire

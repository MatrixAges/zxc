`default_nettype none

module zxc_kernel(
    input wire [0:0] input_0,
    input wire [7:0] input_1,
    output wire [0:0] output_0,
    output wire [7:0] output_1,
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

wire [0:0] n_4;
assign n_4 = n_1 == n_1;

wire [0:0] n_5;
assign n_5 = !n_4;

wire [7:0] n_6;
assign n_6 = n_2 ? n_1 : n_1;

wire [0:0] n_7;
assign n_7 = 1'd0;

wire [0:0] n_8;
assign n_8 = n_7 || n_2;

wire [0:0] n_9;
assign n_9 = !n_3;

wire [0:0] n_10;
assign n_10 = !n_5;

wire [0:0] n_11;
assign n_11 = n_9 && n_10;

wire [0:0] n_12;
assign n_12 = n_11 && n_8;

wire [0:0] n_13;
assign n_13 = !n_12;

wire [0:0] n_14;
assign n_14 = !n_0;

wire [0:0] n_15;
assign n_15 = n_2 ? n_14 : n_14;

wire [0:0] n_16;
assign n_16 = n_9 && n_8;

wire [0:0] n_17;
assign n_17 = !n_16;

wire [0:0] n_18;
assign n_18 = n_16 && n_16;

wire [0:0] n_19;
assign n_19 = n_18 && n_3;

wire [0:0] n_20;
assign n_20 = n_18 ? n_15 : n_15;

wire [0:0] n_21;
assign n_21 = n_7 || n_18;

wire [0:0] n_22;
assign n_22 = n_9 && n_9;

wire [0:0] n_23;
assign n_23 = !n_17;

wire [0:0] n_24;
assign n_24 = n_22 && n_23;

wire [0:0] n_25;
assign n_25 = n_24 && n_23;

wire [0:0] n_26;
assign n_26 = !n_19;

wire [0:0] n_27;
assign n_27 = n_25 && n_26;

wire [0:0] n_28;
assign n_28 = n_27 && n_21;

wire [0:0] n_29;
assign n_29 = !n_28;

wire [0:0] n_30;
assign n_30 = n_12 && n_28;

wire [0:0] n_31;
assign n_31 = n_30 && n_12;

wire [0:0] n_32;
assign n_32 = n_31 && n_3;

wire [0:0] n_33;
assign n_33 = n_31 ? n_20 : n_20;

wire [7:0] n_34;
assign n_34 = n_31 ? n_6 : n_6;

wire [0:0] n_35;
assign n_35 = n_7 || n_31;

wire [0:0] n_36;
assign n_36 = n_22 && n_9;

wire [0:0] n_37;
assign n_37 = !n_13;

wire [0:0] n_38;
assign n_38 = n_36 && n_37;

wire [0:0] n_39;
assign n_39 = !n_29;

wire [0:0] n_40;
assign n_40 = n_38 && n_39;

wire [0:0] n_41;
assign n_41 = n_40 && n_37;

wire [0:0] n_42;
assign n_42 = !n_32;

wire [0:0] n_43;
assign n_43 = n_41 && n_42;

wire [0:0] n_44;
assign n_44 = n_43 && n_35;

assign output_0 = n_33;
assign output_1 = n_34;
assign fault = !n_44;

endmodule

`default_nettype wire

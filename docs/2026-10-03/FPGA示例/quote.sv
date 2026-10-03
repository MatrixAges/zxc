`default_nettype none

module zxc_core(
    input wire [31:0] input_0,
    input wire [31:0] input_1,
    output wire [31:0] output_0,
    output wire fault
);

wire [31:0] n_0;
assign n_0 = input_0;

wire [31:0] n_1;
assign n_1 = input_1;

wire [0:0] n_2;
assign n_2 = n_0 > n_1;

wire [0:0] n_3;
assign n_3 = 1'd1;

wire [0:0] n_4;
assign n_4 = !n_3;

wire [31:0] n_5;
assign n_5 = 32'd0;

wire [0:0] n_6;
assign n_6 = n_2 && n_4;

wire [0:0] n_7;
assign n_7 = n_5 <= n_1;

wire [0:0] n_8;
assign n_8 = !n_7;

wire [0:0] n_9;
assign n_9 = n_2 && n_8;

wire [0:0] n_10;
assign n_10 = n_2 && n_7;

wire [0:0] n_11;
assign n_11 = !n_2;

wire [0:0] n_12;
assign n_12 = 1'd0;

wire [0:0] n_13;
assign n_13 = n_12 || n_11;

wire [0:0] n_14;
assign n_14 = n_0 <= n_1;

wire [0:0] n_15;
assign n_15 = !n_14;

wire [31:0] n_16;
assign n_16 = n_1 - n_0;

wire [32:0] n_17;
assign n_17 = {1'd0, n_1};

wire [32:0] n_18;
assign n_18 = {1'd0, n_0};

wire [32:0] n_19;
assign n_19 = n_17 - n_18;

wire [32:0] n_20;
assign n_20 = {1'd0, n_16};

wire [0:0] n_21;
assign n_21 = n_19 == n_20;

wire [0:0] n_22;
assign n_22 = n_21 && n_21;

wire [0:0] n_23;
assign n_23 = !n_22;

wire [0:0] n_24;
assign n_24 = n_14 && n_23;

wire [0:0] n_25;
assign n_25 = n_14 && n_22;

wire [0:0] n_26;
assign n_26 = n_16 == n_16;

wire [0:0] n_27;
assign n_27 = n_21 && n_26;

wire [0:0] n_28;
assign n_28 = !n_27;

wire [0:0] n_29;
assign n_29 = n_25 && n_28;

wire [0:0] n_30;
assign n_30 = n_25 && n_27;

wire [31:0] n_31;
assign n_31 = n_25 ? n_16 : n_16;

wire [0:0] n_32;
assign n_32 = n_12 || n_25;

wire [0:0] n_33;
assign n_33 = !n_15;

wire [0:0] n_34;
assign n_34 = !n_24;

wire [0:0] n_35;
assign n_35 = n_33 && n_34;

wire [0:0] n_36;
assign n_36 = !n_29;

wire [0:0] n_37;
assign n_37 = n_35 && n_36;

wire [0:0] n_38;
assign n_38 = n_37 && n_32;

wire [0:0] n_39;
assign n_39 = !n_38;

wire [0:0] n_40;
assign n_40 = n_13 && n_39;

wire [0:0] n_41;
assign n_41 = n_13 && n_38;

wire [0:0] n_42;
assign n_42 = n_31 <= n_1;

wire [0:0] n_43;
assign n_43 = !n_42;

wire [0:0] n_44;
assign n_44 = n_41 && n_43;

wire [0:0] n_45;
assign n_45 = n_41 && n_42;

wire [31:0] n_46;
assign n_46 = n_2 ? n_5 : n_5;

wire [0:0] n_47;
assign n_47 = n_12 || n_2;

wire [31:0] n_48;
assign n_48 = n_41 ? n_31 : n_46;

wire [0:0] n_49;
assign n_49 = n_47 || n_41;

wire [0:0] n_50;
assign n_50 = !n_4;

wire [0:0] n_51;
assign n_51 = !n_6;

wire [0:0] n_52;
assign n_52 = n_50 && n_51;

wire [0:0] n_53;
assign n_53 = !n_9;

wire [0:0] n_54;
assign n_54 = n_52 && n_53;

wire [0:0] n_55;
assign n_55 = !n_40;

wire [0:0] n_56;
assign n_56 = n_54 && n_55;

wire [0:0] n_57;
assign n_57 = !n_44;

wire [0:0] n_58;
assign n_58 = n_56 && n_57;

wire [0:0] n_59;
assign n_59 = n_58 && n_49;

assign output_0 = n_48;
assign fault = !n_59;

endmodule

module zxc_kernel(
    input wire clk,
    input wire reset,
    input wire input_valid,
    output wire input_ready,
    output reg output_valid,
    input wire output_ready,
    input wire [31:0] input_0,
    input wire [31:0] input_1,
    output reg [31:0] output_0,
    output reg fault
);

wire core_fault;
wire [31:0] core_output_0;

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
        output_0 <= 32'd0;
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

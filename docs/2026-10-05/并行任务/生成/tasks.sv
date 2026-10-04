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
assign n_14 = n_12 && n_3;

wire [0:0] n_15;
assign n_15 = n_6 == n_6;

wire [0:0] n_16;
assign n_16 = !n_15;

wire [7:0] n_17;
assign n_17 = n_2 ? n_6 : n_6;

wire [0:0] n_18;
assign n_18 = !n_16;

wire [0:0] n_19;
assign n_19 = n_9 && n_18;

wire [0:0] n_20;
assign n_20 = n_19 && n_8;

wire [0:0] n_21;
assign n_21 = !n_20;

wire [0:0] n_22;
assign n_22 = n_17 == n_17;

wire [0:0] n_23;
assign n_23 = !n_22;

wire [7:0] n_24;
assign n_24 = n_2 ? n_17 : n_17;

wire [0:0] n_25;
assign n_25 = !n_23;

wire [0:0] n_26;
assign n_26 = n_9 && n_25;

wire [0:0] n_27;
assign n_27 = n_26 && n_8;

wire [0:0] n_28;
assign n_28 = !n_27;

wire [0:0] n_29;
assign n_29 = n_20 && n_28;

wire [0:0] n_30;
assign n_30 = n_20 && n_27;

wire [0:0] n_31;
assign n_31 = n_30 && n_3;

wire [7:0] n_32;
assign n_32 = n_30 ? n_24 : n_24;

wire [0:0] n_33;
assign n_33 = n_7 || n_30;

wire [0:0] n_34;
assign n_34 = !n_21;

wire [0:0] n_35;
assign n_35 = n_9 && n_34;

wire [0:0] n_36;
assign n_36 = !n_29;

wire [0:0] n_37;
assign n_37 = n_35 && n_36;

wire [0:0] n_38;
assign n_38 = !n_31;

wire [0:0] n_39;
assign n_39 = n_37 && n_38;

wire [0:0] n_40;
assign n_40 = n_39 && n_33;

wire [0:0] n_41;
assign n_41 = !n_40;

wire [0:0] n_42;
assign n_42 = n_12 && n_41;

wire [0:0] n_43;
assign n_43 = n_12 && n_40;

wire [0:0] n_44;
assign n_44 = n_0 == n_2;

wire [0:0] n_45;
assign n_45 = n_44 && n_3;

wire [0:0] n_46;
assign n_46 = !n_0;

wire [0:0] n_47;
assign n_47 = n_2 ? n_46 : n_46;

wire [0:0] n_48;
assign n_48 = n_9 && n_8;

wire [0:0] n_49;
assign n_49 = !n_48;

wire [0:0] n_50;
assign n_50 = n_48 && n_3;

wire [0:0] n_51;
assign n_51 = n_48 ? n_47 : n_47;

wire [0:0] n_52;
assign n_52 = n_7 || n_48;

wire [0:0] n_53;
assign n_53 = !n_49;

wire [0:0] n_54;
assign n_54 = n_9 && n_53;

wire [0:0] n_55;
assign n_55 = !n_50;

wire [0:0] n_56;
assign n_56 = n_54 && n_55;

wire [0:0] n_57;
assign n_57 = n_56 && n_52;

wire [0:0] n_58;
assign n_58 = !n_57;

wire [0:0] n_59;
assign n_59 = n_44 && n_58;

wire [0:0] n_60;
assign n_60 = n_44 && n_57;

wire [0:0] n_61;
assign n_61 = n_44 && n_21;

wire [0:0] n_62;
assign n_62 = n_60 && n_20;

wire [0:0] n_63;
assign n_63 = n_62 && n_3;

wire [0:0] n_64;
assign n_64 = n_7 || n_7;

wire [0:0] n_65;
assign n_65 = !n_44;

wire [0:0] n_66;
assign n_66 = n_65 && n_3;

wire [0:0] n_67;
assign n_67 = n_64 || n_7;

wire [0:0] n_68;
assign n_68 = n_62 ? n_51 : n_51;

wire [0:0] n_69;
assign n_69 = n_7 || n_62;

wire [0:0] n_70;
assign n_70 = n_65 ? n_2 : n_68;

wire [0:0] n_71;
assign n_71 = n_69 || n_65;

wire [0:0] n_72;
assign n_72 = n_9 && n_9;

wire [0:0] n_73;
assign n_73 = n_72 && n_9;

wire [0:0] n_74;
assign n_74 = !n_45;

wire [0:0] n_75;
assign n_75 = n_73 && n_74;

wire [0:0] n_76;
assign n_76 = n_75 && n_74;

wire [0:0] n_77;
assign n_77 = !n_59;

wire [0:0] n_78;
assign n_78 = n_76 && n_77;

wire [0:0] n_79;
assign n_79 = !n_61;

wire [0:0] n_80;
assign n_80 = n_78 && n_79;

wire [0:0] n_81;
assign n_81 = !n_63;

wire [0:0] n_82;
assign n_82 = n_80 && n_81;

wire [0:0] n_83;
assign n_83 = !n_66;

wire [0:0] n_84;
assign n_84 = n_82 && n_83;

wire [0:0] n_85;
assign n_85 = n_84 && n_71;

wire [0:0] n_86;
assign n_86 = !n_85;

wire [0:0] n_87;
assign n_87 = n_12 && n_86;

wire [0:0] n_88;
assign n_88 = n_43 && n_85;

wire [0:0] n_89;
assign n_89 = n_20 && n_3;

wire [0:0] n_90;
assign n_90 = n_7 || n_20;

wire [0:0] n_91;
assign n_91 = n_90 || n_7;

wire [0:0] n_92;
assign n_92 = !n_89;

wire [0:0] n_93;
assign n_93 = n_35 && n_92;

wire [0:0] n_94;
assign n_94 = n_93 && n_91;

wire [0:0] n_95;
assign n_95 = !n_94;

wire [0:0] n_96;
assign n_96 = n_12 && n_95;

wire [0:0] n_97;
assign n_97 = n_88 && n_94;

wire [0:0] n_98;
assign n_98 = n_97 && n_3;

wire [0:0] n_99;
assign n_99 = n_97 ? n_70 : n_70;

wire [7:0] n_100;
assign n_100 = n_97 ? n_32 : n_32;

wire [0:0] n_101;
assign n_101 = n_7 || n_97;

wire [0:0] n_102;
assign n_102 = !n_13;

wire [0:0] n_103;
assign n_103 = !n_14;

wire [0:0] n_104;
assign n_104 = n_102 && n_103;

wire [0:0] n_105;
assign n_105 = n_104 && n_103;

wire [0:0] n_106;
assign n_106 = n_105 && n_103;

wire [0:0] n_107;
assign n_107 = !n_42;

wire [0:0] n_108;
assign n_108 = n_106 && n_107;

wire [0:0] n_109;
assign n_109 = !n_87;

wire [0:0] n_110;
assign n_110 = n_108 && n_109;

wire [0:0] n_111;
assign n_111 = !n_96;

wire [0:0] n_112;
assign n_112 = n_110 && n_111;

wire [0:0] n_113;
assign n_113 = !n_98;

wire [0:0] n_114;
assign n_114 = n_112 && n_113;

wire [0:0] n_115;
assign n_115 = n_114 && n_101;

assign output_0 = n_99;
assign output_1 = n_100;
assign fault = !n_115;

endmodule

`default_nettype wire

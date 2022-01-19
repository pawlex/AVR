module flash
       (	input		clk,
         input		mem_ce,
         input	[9:0]	mem_a,
         output	[15:0]	mem_d
       );
reg [1:0] mem_hi;
always @(posedge clk) mem_hi <= mem_a[9:8];
reg [15:0] mem_d;
wire [15:0] db0;
SB_RAM40_4K flash0
            (	.RDATA(db0),
              .RADDR({3'b000,mem_a[7:0]}),
              .RCLKE(1'b1),
              .RCLK(clk),
              .RE(mem_ce),
              .WADDR(11'b00000000000),
              .MASK(16'b0000000000000000),
              .WDATA(16'b0000000000000000),
              .WCLKE(1'b0),
              .WCLK(1'b0),
              .WE(1'b0)
            );
defparam flash0.READ_MODE = 0;
defparam flash0.INIT_0 = 256'he0f7_e9e8_e0b0_e6a0_e010_bfde_e0d2_bfcd_e5cf_be1f_2411_cfff_c023_c001_c03a_c004;
defparam flash0.INIT_1 = 256'hd044_f7e1_07b2_38a2_921d_c001_e0b0_e7ac_e020_f7d1_07b1_37ac_920d_9631_95c8_c003;
defparam flash0.INIT_2 = 256'he99f_b180_939f_938f_2411_920f_b60f_920f_921f_9508_e090_e080_b980_cffe_9b0d_c3a9;
defparam flash0.INIT_3 = 256'h920f_b60f_920f_921f_9518_901f_900f_be0f_900f_918f_919f_b980_5280_f408_319a_0f98;
defparam flash0.INIT_4 = 256'h9518_901f_900f_be0f_900f_918f_919f_b984_2789_e082_b194_b98a_b18a_939f_938f_2411;
defparam flash0.INIT_5 = 256'h9731_2ff3_2fe2_e091_ef84_b984_2784_b184_e03b_eb28_e041_9478_9a57_b98a_e082_9a17;
defparam flash0.INIT_6 = 256'he083_b194_b984_e980_007e_9380_007f_9390_e090_e680_b983_e08c_cff4_f7d1_9701_f7f1;
defparam flash0.INIT_7 = 256'h2f80_b984_258d_b184_e0db_ebc8_2ef9_e090_2ee9_e69e_2ed8_e083_e010_e000_b984_2789;
defparam flash0.INIT_8 = 256'h900f_900f_900f_900f_900f_d022_92ef_92ff_930f_931f_938f_939f_d018_2f71_2f60_2f91;
defparam flash0.INIT_9 = 256'h0e08_c004_2755_2400_cfe0_4f1f_5f0f_f7d1_9701_f7f1_9731_2ffd_2fec_e093_ee88_900f;
defparam flash0.INIT_A = 256'hebe2_e0b0_e0a0_9508_2f95_2d80_f7b9_0571_f3b8_9567_9576_f029_9700_1f99_0f88_1f59;
defparam flash0.INIT_B = 256'h007f_9190_007e_9180_2f5f_2f4e_9171_9161_2ff5_2fe4_4f5f_5f4b_2f5d_2f4c_c2f0_e0f0;
defparam flash0.INIT_C = 256'h2ff9_2fe8_2f15_2f04_2ef7_2ee6_2ed9_2ec8_c2ca_e0f0_ece8_e0b0_e0ab_c2fb_e0e2_d002;
defparam flash0.INIT_D = 256'hfd93_2dff_2dee_8193_2dfd_2dec_2e79_2e68_9601_2f9d_2f8c_c1ef_ff81_8183_8216_8217;
defparam flash0.INIT_E = 256'h8000_ff93_95c8_fd93_f451_3285_c1d5_f409_2388_2eff_2eee_2d80_9631_8000_ff93_95c8;
defparam flash0.INIT_F = 256'h15f3_e1ff_2c31_2c21_2c91_cfdf_d1e8_e090_2d7d_2d6c_f429_3285_2eff_2eee_2d80_9631;
wire [15:0] db1;
SB_RAM40_4K flash1
            (	.RDATA(db1),
              .RADDR({3'b000,mem_a[7:0]}),
              .RCLKE(1'b1),
              .RCLK(clk),
              .RE(mem_ce),
              .WADDR(11'b00000000000),
              .MASK(16'b0000000000000000),
              .WDATA(16'b0000000000000000),
              .WCLKE(1'b0),
              .WCLK(1'b0),
              .WE(1'b0)
            );
defparam flash1.READ_MODE = 0;
defparam flash1.INIT_0 = 256'h2d23_f471_3380_f059_328d_c010_6120_2d23_f4a9_3283_f079_3280_f438_f079_328b_f0e0;
defparam flash1.INIT_1 = 256'hed20_c031_fc37_c027_2e32_c025_60f8_2df3_c022_60e4_2de3_2e38_6082_2d83_c009_6021;
defparam flash1.INIT_2 = 256'h0e28_2e22_d25b_e06a_2d82_c019_0e98_2e92_d261_e06a_2d89_c006_fe36_f488_302a_0f28;
defparam flash1.INIT_3 = 256'h68f0_2df3_f421_368c_c008_2e3e_64e0_2de3_c187_fc36_f431_328e_c010_2e38_6280_2d83;
defparam flash1.INIT_4 = 256'hcfae_1181_2eff_2eee_2d80_9631_8000_ff93_95c8_fd93_2dff_2dee_f461_3688_c002_2e3f;
defparam flash1.INIT_5 = 256'hf009_3583_f081_3783_f031_3683_c00e_8329_e32f_4f1f_5f0c_f428_3093_5495_7d9f_2f98;
defparam flash1.INIT_6 = 256'h2e51_2e40_c017_2cb7_2ca6_2c91_9483_2488_4f1f_5f0e_8389_8180_2ff1_2fe0_c027_c067;
defparam flash1.INIT_7 = 256'h2d9b_2d8a_ef7f_ef6f_c002_e070_2d69_c003_fe36_80b1_80a0_2ff1_2fe0_1c51_0e4f_e0f2;
defparam flash1.INIT_8 = 256'h2ff1_2fe0_1c51_0e42_e022_2e51_2e40_c01a_2e3f_77ff_2df3_2d15_2d04_2e99_2e88_d155;
defparam flash1.INIT_9 = 256'h68f0_2df3_2e99_2e88_d12d_2d9b_2d8a_ef7f_ef6f_c002_e070_2d69_c003_fe36_80b1_80a0;
defparam flash1.INIT_A = 256'h942a_d133_e090_e280_2d7d_2d6c_f4d0_0699_1688_e090_2d82_c01f_fc33_2d15_2d04_2e3f;
defparam flash1.INIT_B = 256'h1021_d123_e090_2d7d_2d6c_2ebf_2eae_2d80_9631_8000_fe37_95c8_fc37_2dfb_2dea_cff4;
defparam flash1.INIT_C = 256'hc007_fe37_2ff1_2fe0_f549_3689_f011_3684_c0ed_f751_0491_1481_0891_1a82_e021_942a;
defparam flash1.INIT_D = 256'h2df3_4f1f_5f0e_0b99_0b88_0c00_2e07_8171_8160_c008_4f1f_5f0c_8193_8182_8171_8160;
defparam flash1.INIT_E = 256'h2d46_e030_e02a_2e3f_68f0_4f9f_4f8f_4f7f_9561_9570_9580_9590_c009_ff97_2e3f_76ff;
defparam flash1.INIT_F = 256'h2eb9_7f99_2d93_c025_e030_e02a_2eb2_7e2f_2d23_f431_3785_c046_1886_2e88_d133_2d57;
wire [15:0] db2;
SB_RAM40_4K flash2
            (	.RDATA(db2),
              .RADDR({3'b000,mem_a[7:0]}),
              .RCLKE(1'b1),
              .RCLK(clk),
              .RE(mem_ce),
              .WADDR(11'b00000000000),
              .MASK(16'b0000000000000000),
              .WDATA(16'b0000000000000000),
              .WCLKE(1'b0),
              .WCLK(1'b0),
              .WE(1'b0)
            );
defparam flash2.READ_MODE = 0;
defparam flash2.INIT_0 = 256'hc00d_feb4_2ebe_61e0_2fe9_c0b4_f021_3788_f019_3780_c0b9_f079_3588_f418_f0c1_368f;
defparam flash2.INIT_1 = 256'hc002_e030_e120_c005_e030_e028_c006_2eb2_6026_2f29_c00a_fe34_c009_2ebf_60f4_2dfb;
defparam flash2.INIT_2 = 256'he080_8171_8160_c006_4f1f_5f0c_8193_8182_8171_8160_c007_feb7_2ff1_2fe0_e032_e120;
defparam flash2.INIT_3 = 256'h2ea2_7f2e_2d23_c00d_fe36_2e3f_77ff_2dfb_1886_2e88_d0ef_2d57_2d46_4f1f_5f0e_e090;
defparam flash2.INIT_4 = 256'h2cb9_c001_2cb8_c003_2ca3_2cb8_c005_2ea8_7e8e_2d83_c009_fc32_c00b_fe34_f458_1489;
defparam flash2.INIT_5 = 256'h94b3_c006_fea2_c009_2ea9_7e99_2d9a_f421_3380_8180_1df1_0de8_2ffd_2fec_c010_fea4;
defparam flash2.INIT_6 = 256'hc00e_189b_2c92_0c28_f488_14b2_c006_fea0_c011_fca3_94b3_f009_7886_2d8a_c004_94b3;
defparam flash2.INIT_7 = 256'hfea4_2c21_2c98_c002_182b_f418_14b2_cff7_94b3_d06b_e090_e280_2d7d_2d6c_f460_14b2;
defparam flash2.INIT_8 = 256'h2d6c_e090_e588_c002_e090_e788_c003_fca1_c018_fea2_d05c_e090_e380_2d7d_2d6c_c011;
defparam flash2.INIT_9 = 256'hd042_e090_2d7d_2d6c_e28d_fca7_e280_c001_e28b_c002_fea1_f059_7886_2d8a_c00d_2d7d;
defparam flash2.INIT_A = 256'h2d6c_8180_1df1_0de8_2df7_2de6_948a_cff7_949a_d03b_e090_e380_2d7d_2d6c_f438_1489;
defparam flash2.INIT_B = 256'h2dec_cff6_942a_d025_e090_e280_2d7d_2d6c_ce22_f409_2022_cff4_1081_d02f_e090_2d7d;
defparam flash2.INIT_C = 256'h1001_4070_5061_9631_95c8_2ff9_2fe8_c0e5_e1e2_962b_ef9f_ef8f_c002_8197_8186_2dfd;
defparam flash2.INIT_D = 256'h0f8e_9590_9580_f7d8_1001_9001_4070_5061_2ff9_2fe8_9508_1f9f_0f8e_9590_9580_f7d0;
defparam flash2.INIT_E = 256'hc017_ff22_c032_ef9f_ef8f_c003_fd21_8123_2ff7_2fe6_93df_93cf_931f_930f_9508_1f9f;
defparam flash2.INIT_F = 256'h938c_8320_8331_4f3f_5f2f_2f3b_2f2a_81b1_81a0_f44c_0753_1742_8135_8124_8157_8146;
wire [15:0] db3;
SB_RAM40_4K flash3
            (	.RDATA(db3),
              .RADDR({3'b000,mem_a[7:0]}),
              .RCLKE(1'b1),
              .RCLK(clk),
              .RE(mem_ce),
              .WADDR(11'b00000000000),
              .MASK(16'b0000000000000000),
              .WDATA(16'b0000000000000000),
              .WCLKE(1'b0),
              .WCLK(1'b0),
              .WE(1'b0)
            );
defparam flash3.READ_MODE = 0;
defparam flash3.INIT_0 = 256'h2de0_85f1_8400_2ff7_2fe6_2fc8_2fd9_2f17_2f06_c019_8326_8337_4f3f_5f2f_8137_8126;
defparam flash3.INIT_1 = 256'h2f9d_2f8c_9716_938e_939c_9617_9601_9717_919c_918d_9616_2fb1_2fa0_f6c1_2b89_9509;
defparam flash3.INIT_2 = 256'h5f6e_7f6e_936f_94e8_f199_3120_f169_3028_27aa_2ff5_2fe4_9508_910f_911f_91cf_91df;
defparam flash3.INIT_3 = 256'h1f8a_1f79_0f68_1da1_1f9a_1f89_1f78_0f67_d03f_e0b4_d041_e0b1_4faf_4f9f_4f8f_4f7f;
defparam flash3.INIT_4 = 256'h0c00_0c00_1930_0c00_2e06_913f_9468_f409_d023_1da1_1d91_1d81_1d71_0f6a_1da1_1d91;
defparam flash3.INIT_5 = 256'h2f46_cff5_f7c9_d00f_e0b3_9341_5d40_7047_2f46_9508_2f9f_2f8e_f6ce_9331_5d30_1930;
defparam flash3.INIT_6 = 256'h9577_9587_9597_95a6_e0b4_cfe9_f7a9_d002_9341_5240_fd31_5d49_f018_334a_5d40_704f;
defparam flash3.INIT_7 = 256'h9537_9547_9557_9406_2e0a_2f59_2f48_2f37_2f26_9508_0571_0561_9700_f7c9_95ba_9567;
defparam flash3.INIT_8 = 256'hf7d1_9586_f011_0f66_0e06_fd80_2400_9508_1da0_1f95_1f84_1f73_0f62_f7c9_95ba_9527;
defparam flash3.INIT_9 = 256'h92ff_92ef_92df_92cf_92bf_92af_929f_928f_927f_926f_925f_924f_923f_922f_9508_2d80;
defparam flash3.INIT_A = 256'h8839_882a_9409_bfcd_be0f_bfde_94f8_b60f_0bdb_1bca_b7de_b7cd_93df_93cf_931f_930f;
defparam flash3.INIT_B = 256'h81b9_81aa_811b_810c_80fd_80ee_80df_84c8_84b9_84aa_849b_848c_847d_846e_845f_8848;
defparam flash3.INIT_C = 256'h0000_0000_0200_0000_cfff_94f8_9508_2fdb_2fca_bfcd_be0f_bfde_94f8_b60f_1dd1_0fce;
defparam flash3.INIT_D = 256'h0000_0000_0000_0000_0000_0000_000a_6425_203e_3d20_6425_205d_785b_0000_0000_0021;
defparam flash3.INIT_E = 256'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
defparam flash3.INIT_F = 256'h0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
always @(*) begin
    casex (mem_hi)
        2'd0: mem_d = db0;
        2'd1: mem_d = db1;
        2'd2: mem_d = db2;
        2'd3: mem_d = db3;
        default: mem_d = 16'h0000;
    endcase
end

endmodule

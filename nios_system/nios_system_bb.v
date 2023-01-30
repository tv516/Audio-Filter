
module nios_system (
	AUD_ADCDAT_to_the_audio_0,
	AUD_ADCLRCK_to_the_audio_0,
	AUD_BCLK_to_the_audio_0,
	AUD_DACDAT_from_the_audio_0,
	AUD_DACLRCK_to_the_audio_0,
	clk_clk,
	i2c_SDAT,
	i2c_SCLK,
	pin_export,
	reset_reset,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	switches_export);	

	input		AUD_ADCDAT_to_the_audio_0;
	input		AUD_ADCLRCK_to_the_audio_0;
	input		AUD_BCLK_to_the_audio_0;
	output		AUD_DACDAT_from_the_audio_0;
	input		AUD_DACLRCK_to_the_audio_0;
	input		clk_clk;
	inout		i2c_SDAT;
	output		i2c_SCLK;
	output		pin_export;
	input		reset_reset;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	input	[7:0]	switches_export;
endmodule

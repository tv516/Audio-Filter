	component nios_system is
		port (
			AUD_ADCDAT_to_the_audio_0   : in    std_logic                     := 'X';             -- ADCDAT
			AUD_ADCLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- ADCLRCK
			AUD_BCLK_to_the_audio_0     : in    std_logic                     := 'X';             -- BCLK
			AUD_DACDAT_from_the_audio_0 : out   std_logic;                                        -- DACDAT
			AUD_DACLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- DACLRCK
			clk_clk                     : in    std_logic                     := 'X';             -- clk
			i2c_SDAT                    : inout std_logic                     := 'X';             -- SDAT
			i2c_SCLK                    : out   std_logic;                                        -- SCLK
			pin_export                  : out   std_logic;                                        -- export
			reset_reset                 : in    std_logic                     := 'X';             -- reset
			sdram_addr                  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                 : out   std_logic;                                        -- cas_n
			sdram_cke                   : out   std_logic;                                        -- cke
			sdram_cs_n                  : out   std_logic;                                        -- cs_n
			sdram_dq                    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                   : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                 : out   std_logic;                                        -- ras_n
			sdram_we_n                  : out   std_logic;                                        -- we_n
			sdram_clk_clk               : out   std_logic;                                        -- clk
			switches_export             : in    std_logic_vector(7 downto 0)  := (others => 'X')  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			AUD_ADCDAT_to_the_audio_0   => CONNECTED_TO_AUD_ADCDAT_to_the_audio_0,   --     audio.ADCDAT
			AUD_ADCLRCK_to_the_audio_0  => CONNECTED_TO_AUD_ADCLRCK_to_the_audio_0,  --          .ADCLRCK
			AUD_BCLK_to_the_audio_0     => CONNECTED_TO_AUD_BCLK_to_the_audio_0,     --          .BCLK
			AUD_DACDAT_from_the_audio_0 => CONNECTED_TO_AUD_DACDAT_from_the_audio_0, --          .DACDAT
			AUD_DACLRCK_to_the_audio_0  => CONNECTED_TO_AUD_DACLRCK_to_the_audio_0,  --          .DACLRCK
			clk_clk                     => CONNECTED_TO_clk_clk,                     --       clk.clk
			i2c_SDAT                    => CONNECTED_TO_i2c_SDAT,                    --       i2c.SDAT
			i2c_SCLK                    => CONNECTED_TO_i2c_SCLK,                    --          .SCLK
			pin_export                  => CONNECTED_TO_pin_export,                  --       pin.export
			reset_reset                 => CONNECTED_TO_reset_reset,                 --     reset.reset
			sdram_addr                  => CONNECTED_TO_sdram_addr,                  --     sdram.addr
			sdram_ba                    => CONNECTED_TO_sdram_ba,                    --          .ba
			sdram_cas_n                 => CONNECTED_TO_sdram_cas_n,                 --          .cas_n
			sdram_cke                   => CONNECTED_TO_sdram_cke,                   --          .cke
			sdram_cs_n                  => CONNECTED_TO_sdram_cs_n,                  --          .cs_n
			sdram_dq                    => CONNECTED_TO_sdram_dq,                    --          .dq
			sdram_dqm                   => CONNECTED_TO_sdram_dqm,                   --          .dqm
			sdram_ras_n                 => CONNECTED_TO_sdram_ras_n,                 --          .ras_n
			sdram_we_n                  => CONNECTED_TO_sdram_we_n,                  --          .we_n
			sdram_clk_clk               => CONNECTED_TO_sdram_clk_clk,               -- sdram_clk.clk
			switches_export             => CONNECTED_TO_switches_export              --  switches.export
		);


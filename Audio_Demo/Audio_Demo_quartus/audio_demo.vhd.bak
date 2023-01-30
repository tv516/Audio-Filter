LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY audio_demo IS
    PORT (	CLOCK2_50           					 		   : in std_logic;
				KEY                					 		   : in std_logic_vector (3 downto 0);
				SW                 					 		   : in std_logic_vector (7 downto 0);
	
	
				DRAM_CLK,DRAM_CKE	 								: OUT STD_LOGIC;
				DRAM_ADDR			 								: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
				DRAM_BA           								: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				DRAM_CS_N,DRAM_CAS_N,DRAM_RAS_N,DRAM_WE_N	: OUT STD_LOGIC;
				DRAM_DQ												: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				DRAM_UDQM,DRAM_LDQM								: OUT STD_LOGIC;
	
				AUD_ADCDAT 											: IN STD_LOGIC;
            AUD_ADCLRCK 										: INOUT STD_LOGIC;
            AUD_BCLK 											: INOUT  STD_LOGIC;
            AUD_DACDAT 											: OUT STD_LOGIC;
            AUD_DACLRCK 										: INOUT  STD_LOGIC;
				AUD_XCK                            		   : OUT STD_LOGIC;

              -- the_audio_and_video_config_0
            FPGA_I2C_SCLK	 											: OUT STD_LOGIC;
            FPGA_I2C_SDAT	 											: INOUT STD_LOGIC;
				
				LEDR                              		   : OUT STD_LOGIC_VECTOR(7 downto 0);
				
				GPIO_0                             		   : INOUT STD_LOGIC_VECTOR(35 downto 0)

        );
END audio_demo;



ARCHITECTURE rtl OF audio_demo IS

    
      component nios_system is
        port (            

						AUD_ADCDAT_to_the_audio_0   : in    std_logic                     := '0';             --       audio.ADCDAT
						AUD_ADCLRCK_to_the_audio_0  : in    std_logic                     := '0';             --            .ADCLRCK
						AUD_BCLK_to_the_audio_0     : in    std_logic                     := '0';             --            .BCLK
						AUD_DACDAT_from_the_audio_0 : out   std_logic;                                        --            .DACDAT
						AUD_DACLRCK_to_the_audio_0  : in    std_logic                     := '0';             --            .DACLRCK
						clk_clk                     : in    std_logic                     := '0';             --         clk.clk
						i2c_SDAT                    : inout std_logic                     := '0';             --         i2c.SDAT
						i2c_SCLK                    : out   std_logic;                                        --            .SCLK
						pin_export                  : out   std_logic;                                        --       pin.export
						reset_reset                 : in    std_logic                     := '0';             --       reset.reset
						sdram_addr                  : out   std_logic_vector(12 downto 0);                    --       sdram.addr
						sdram_ba                    : out   std_logic_vector(1 downto 0);                     --            .ba
						sdram_cas_n                 : out   std_logic;                                        --            .cas_n
						sdram_cke                   : out   std_logic;                                        --            .cke
						sdram_cs_n                  : out   std_logic;                                        --            .cs_n
						sdram_dq                    : inout std_logic_vector(15 downto 0) := (others => '0'); --            .dq
						sdram_dqm                   : out   std_logic_vector(1 downto 0);                     --            .dqm
						sdram_ras_n                 : out   std_logic;                                        --            .ras_n
						sdram_we_n                  : out   std_logic;                                        --            .we_n
						sdram_clk_clk               : out   std_logic;                                        --   sdram_clk.clk
						sw_export                   : in    std_logic_vector(7 downto 0)  := (others => '0')  --          sw.export
        );
    end component nios_system;
	 
    ----------------------------------------------------------------------------
    --               Internal Wires and Registers Declarations                --
    ----------------------------------------------------------------------------

	signal reset_n : std_logic;
	signal DRAM_DQM : std_logic_vector(1 DOWNTO 0);
	signal int_AUD_BCLK  : std_logic;
	signal int_AUD_DACDAT  : std_logic;
	signal int_AUD_DACLRCK : std_logic;
	signal count           : std_logic_vector(3 downto 0);
	signal test_sig        : std_logic;

begin

   LEDR <= "10101010";
	AUD_XCK <= count(1);
	
	reset_n <= not KEY(0);
   DRAM_UDQM <= DRAM_DQM(1);
	DRAM_LDQM <= DRAM_DQM(0);
   --int_AUD_BCLK <= AUD_BCLK;
 	GPIO_0(0) <= AUD_BCLK; 
	AUD_DACDAT <= int_AUD_DACDAT;
	GPIO_0(1) <= int_AUD_DACDAT;
   --int_AUD_DACLRCK <= AUD_DACLRCK;
 	GPIO_0(2) <= AUD_DACLRCK;   
	GPIO_0(3) <= test_sig; 	

	 
  NiosII : nios_system
        PORT MAP(
            
						AUD_ADCDAT_to_the_audio_0     => AUD_ADCDAT,
						AUD_ADCLRCK_to_the_audio_0    => AUD_ADCLRCK,
						AUD_BCLK_to_the_audio_0       => AUD_BCLK,
						AUD_DACDAT_from_the_audio_0   => int_AUD_DACDAT,
						AUD_DACLRCK_to_the_audio_0    => AUD_DACLRCK,     
						clk_clk                       => CLOCK2_50,                    
						i2c_SDAT                      => FPGA_I2C_SDAT,         
						i2c_SCLK                      => FPGA_I2C_SCLK,	
						pin_export                    => test_sig,
						reset_reset                   => reset_n,
						sdram_addr                    => DRAM_ADDR,
						sdram_ba                      => DRAM_BA,
						sdram_cas_n                   => DRAM_CAS_N,
						sdram_cke                     => DRAM_CKE,
						sdram_cs_n                    => DRAM_CS_N,
						sdram_dq                      => DRAM_DQ,
						sdram_dqm                     => DRAM_DQM,
						sdram_ras_n                   => DRAM_RAS_N,
						sdram_we_n                    => DRAM_WE_N,
						sdram_clk_clk                 => DRAM_CLK,                                                    
						sw_export                     => SW(7 downto 0)
			
						);
						
	clkgen: process(CLOCK2_50, reset_n) 
		begin
			if (reset_n = '1') then
				count <= "0000";
         elsif (rising_edge(CLOCK2_50)) then
            count <= count + 1;
			end if;
		end process;
		
END rtl;
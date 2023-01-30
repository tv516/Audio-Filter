--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Tessa Vincent
--
--       LAB NAME:  Lab 9
--
--      FILE NAME:  Audio_Filter: High/Low
--
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE audio_filter_pkg IS
	COMPONENT audio_filter IS
	PORT(
		clk: IN STD_LOGIC;
		reset_n: IN STD_LOGIC;
		address: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		write: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
END PACKAGE;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.generic_reg_pkg.all;
use work.synchronizer_pkg.all;

--entity declaration--
entity audio_filter is
    port
    (
        clock     : in  std_logic;
        reset_n   : in  std_logic;
        write     : in  std_logic;
        address   : in  std_logic;

        writedata : in std_logic_vector(15 downto 0);
        readdata  : out std_logic_vector(15 downto 0)
    );
end audio_filter;


architecture arch of audio_filter is


type   std_filter_array is array (16 downto 0) of std_logic_vector(15 downto 0);
--16 bitx signed fixed points--
constant low_pass_signal : std_filter_array :=
(

    X"0051", --81.92/0.0025--
    X"00BA", --186.78/0.0057--
    X"01E1", --481.69/0.0147--
    X"0408", --1032.19/0.0315--
    X"071A", --1818.62/0.0555--
    X"0AAC", --2732.85/0.0834--
    X"0E11", --3601.20/0.1099--
    X"107F", --4223.80/0.1289--
    X"1161", --4449.89/0.1358--
    X"107F", --4223.80//0.1289--
    X"0E11", --3601.20/0.1099--
    X"0AAC", --2732.85/0.0834--
    X"071A", --1818.62/0.0555--
    X"0408", --1032.19/0.0315--
    X"01E1", --481.69/0.0147--
    X"00BA", --186.78/0.0057--
    X"0051" --81.92/0.0025--
);

constant high_pass_signal : std_filter_array :=
(
    X"003E",
    X"FF9A",
    X"FE9E",
    X"0000",
    X"0535",
    X"05B2",
    X"F5AC",
    X"DAB7",
    X"4C91",
    X"DAB7",
    X"F5AC",
    X"05B2",
    X"0535",
    X"0000",
    X"FE9E",
    X"FF9A",
    X"003E"
);

constant delta  :  std_filter_array :=(0 => x"7FFF", others => x"0000");
signal coeffs    : std_filter_array;

--stores data after multiplier--
type   data_multiplier is array (15 downto 0) of std_logic_vector(15 downto 0);
signal data_multiplier_signal : data_multiplier;

type std_array is array(15 downto 0) of std_logic_vector(15 downto 0);
signal reg_data : std_array := (others => (others => '0'));

--stores data after shift--
type   enable_reg is array (16 downto 0) of signed(15 downto 0);
signal enable_reg_signal : enable_reg:= (others => (others => '0'));

--stores data after multiplier 32--
type   ram_type is array (16 downto 0) of std_logic_vector(31 downto 0);
signal after_multi_32 : ram_type := (others => (others => '0'));

type registers is array(1 downto 0)  of std_logic_vector(15 downto 0);

signal edge_reset : std_logic :='0';
signal reg_data_1 :std_logic_vector(15 downto 0);
signal reg_data_0 :std_logic_vector(15 downto 0);
    
--multipler component--
component multiplier IS
PORT
(
    dataa  : in  std_logic_vector (15 downto 0);
    datab  : in  std_logic_vector (15 downto 0);
    result : out std_logic_vector (31 downto 0)
    );

END component multiplier;
                       
-- Signals--
signal filter : integer;

begin
--Synchronizer--
reset_sync: synchronizer
	PORT MAP(
		clk => clock,
		reset => '0',
		input => reset_n,
		edge => edge_reset
	);
  

--Writes data to registers depending on the address 
 RamBlock : PROCESS(clock, edge_reset)
    BEGIN
        IF (edge_reset = '1') THEN
          reg_data_0 <= (OTHERS => '0');
          reg_data_1 <= (OTHERS => '0');
        ELSIF rising_edge(clock) THEN
           IF (write = '1') THEN
                IF address = '0' THEN
                    reg_data_0 <= writedata;
                ELSE
                    reg_data_1 <= writedata;
                END IF;
           END IF;
        END IF;
    END PROCESS RamBlock;
    
--- chooses between low or high signal
    switch: PROCESS(edge_reset, reg_data_1)
    BEGIN
        IF edge_reset = '1' THEN
            coeffs <= delta;
        ELSE
            IF reg_data_1(15 DOWNTO 0) = x"0000" THEN
                coeffs <= low_pass_signal;
            ELSIF reg_data_1(15 DOWNTO 0) = x"0101" THEN
                coeffs <= high_pass_signal;
            ELSE
                coeffs <= delta;
            END IF;
        END IF;
    END PROCESS;
      
	generic_reg_process:
	for i in 0 to 15 GENERATE
		lsb: if i = 0 GENERATE
			U0: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clock,
				reset => edge_reset,
				enable => write,
				input => reg_data_0(15 DOWNTO 0),
				output => reg_data(0)
			);
		END GENERATE lsb;
		
		msb: if i > 0 GENERATE
			Ux: generic_reg
			GENERIC MAP( bit_width => 16)
			PORT MAP(
				clk => clock,
				reset => edge_reset,
				enable => write,
				input => reg_data(i-1),
				output => reg_data(i)
			);
		END GENERATE msb;
	END GENERATE;
	
	multipler_gen:
	for i IN 0 TO 16 GENERATE	
		lsb: if i = 0 GENERATE
			U0: multiplier
			PORT MAP(
				dataa => reg_data_0(15 DOWNTO 0),
				datab => coeffs(0),
				result => after_multi_32(0)
		   );
		enable_reg_signal(0) <= SIGNED(after_multi_32(0)(30 DOWNTO 15));
		END GENERATE lsb;
		
		msb: if i > 0 GENERATE
			U1: multiplier
			PORT MAP(
				dataa => reg_data(i-1),
				datab => coeffs(i),
				result => after_multi_32(i)
			);
		enable_reg_signal(i) <= enable_reg_signal(i-1) + SIGNED(after_multi_32(i)(30 DOWNTO 15));
		END GENERATE msb;
		

	END GENERATE;
	
    readdata <= STD_LOGIC_VECTOR(enable_reg_signal(16));

end arch;
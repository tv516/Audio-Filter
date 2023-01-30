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
library ieee;
use ieee.std_logic_1164.all;

PACKAGE generic_reg_pkg IS
  COMPONENT generic_reg IS
    GENERIC( bit_width : INTEGER := 4);
    PORT (
        clk    : IN  std_logic;
        reset  : IN  std_logic;
        enable : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
        output: OUT STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0)
    );
  END COMPONENT;
END PACKAGE;

library ieee;
use ieee.std_logic_1164.all;


ENTITY generic_reg  IS
  GENERIC( bit_width : INTEGER := 4);
  PORT (
    clk    : IN  std_logic;
    reset  : IN  std_logic;
    enable : IN STD_LOGIC;
    input : IN STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0);
    output: OUT STD_LOGIC_VECTOR(bit_width-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF generic_reg IS
BEGIN
    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            output <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF(enable = '1') THEN
                output <= input;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;
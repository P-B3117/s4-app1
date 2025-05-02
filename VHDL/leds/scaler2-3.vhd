----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 02:15:45 PM
-- Design Name: 
-- Module Name: scaler2-3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY scaler2_3 IS
    PORT (
        ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        a2_3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END scaler2_3;

ARCHITECTURE Behavioral OF scaler2_3 IS

BEGIN
    -- 2^-1+2^-3+2^-5
END Behavioral;

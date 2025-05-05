----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2025 03:49:50 PM
-- Design Name: 
-- Module Name: Fct2_3 - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fct2_3 is
    Port ( ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
           ADCbinI : in STD_LOGIC;
           A2_3 : in STD_LOGIC_VECTOR (2 downto 0);
           A2_3I : in STD_LOGIC);
end Fct2_3;

architecture Behavioral of Fct2_3 is

COMPONENT Add4bits is
    Port ( X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : in STD_LOGIC_VECTOR (3 downto 0);
           C1 : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Co : out STD_LOGIC);
end COMPONENT;

signal in1: std_logic_vector(3 downto 0) := "0000";
signal in3: std_logic_vector(3 downto 0) := "0000";

begin

in3 <= ADCbin;

end Behavioral;

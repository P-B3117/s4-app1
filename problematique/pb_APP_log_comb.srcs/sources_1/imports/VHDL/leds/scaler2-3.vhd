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
use ieee.numeric_std.all;               -- Needed for shifts

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scaler2_3 is
    Port ( ADCbin : in STD_LOGIC_VECTOR (3 downto 0);
           ADCbinI : in STD_LOGIC;
           A2_3 : out STD_LOGIC_VECTOR (2 downto 0);
           A2_3I : out STD_LOGIC);
end scaler2_3;

architecture Behavioral of scaler2_3 is

COMPONENT Add4bits is
    Port ( X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : in STD_LOGIC_VECTOR (3 downto 0);
           C1 : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Co : out STD_LOGIC);
end COMPONENT;

signal in1 : STD_LOGIC_VECTOR (3 downto 0);
signal in3 : STD_LOGIC_VECTOR (3 downto 0);
signal output : STD_LOGIC_VECTOR (3 downto 0);

begin

in1 <= STD_LOGIC_VECTOR(shift_right(unsigned(ADCbin), 1));
in3 <= STD_LOGIC_VECTOR(shift_right(unsigned(ADCbin), 3));


Add4bits_instance : Add4bits PORT MAP(
      X => in1,
      Y => in3,
      C1 => ADCbinI,
      S => output,
      Co => A2_3I
   );
   
 A2_3 <= output(2 downto 0);
-- A2_3 <= S_4bits (2 downto 0);

end Behavioral;

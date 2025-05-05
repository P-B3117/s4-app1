----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 05:22:39 PM
-- Design Name: 
-- Module Name: Add4bits - Behavioral
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

entity Add4bits is
    Port ( X : in STD_LOGIC_VECTOR (3 downto 0);
           Y : in STD_LOGIC_VECTOR (3 downto 0);
           C1 : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Co : out STD_LOGIC);
end Add4bits;

architecture Behavioral of Add4bits is

COMPONENT Add1bitA is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           C : in STD_LOGIC;
           S : out STD_LOGIC;
           Co : out STD_LOGIC);
end COMPONENT;


COMPONENT Add1bitB is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           C : in STD_LOGIC;
           S : out STD_LOGIC;
           Co : out STD_LOGIC);
end COMPONENT;

begin

 -- Make 4 UUT for the 4 bits and map them to internal signals thingies
  UUT: Add1bitB PORT MAP(
      S => sortie_sim, 
      X => b_sim, 
      Y => c_sim, 
      C => a_sim
   );

end Behavioral;

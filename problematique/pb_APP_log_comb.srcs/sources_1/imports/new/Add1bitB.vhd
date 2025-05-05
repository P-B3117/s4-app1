----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 05:22:39 PM
-- Design Name: 
-- Module Name: Add1bitB - Behavioral
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

entity Add1bitB is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           C : in STD_LOGIC;
           S : out STD_LOGIC;
           Co : out STD_LOGIC);
end Add1bitB;

architecture Behavioral of Add1bitB is

begin

S <= X xor Y xor C;
Co <= (X and Y) or (C and (X or Y));

end Behavioral;

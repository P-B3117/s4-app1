----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 05:17:57 PM
-- Design Name: 
-- Module Name: Add1bitA - Behavioral
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

entity Add1bitA is
    Port ( X : in STD_LOGIC;
           Y : in STD_LOGIC;
           C : in STD_LOGIC;
           S : out STD_LOGIC;
           Co : out STD_LOGIC);
end Add1bitA;

architecture Behavioral of Add1bitA is

Signal init : STD_LOGIC_VECTOR (2 downto 0);

begin
init <= X & Y & C;

p : process (init)
begin

case init is
    when "000" =>
    S <= '0'; 
    Co <= '0';
    when "001" =>
    S <= '1'; 
    Co <= '0';
    when "010" =>
    S <= '1'; 
    Co <= '0';
    when "011" =>
    S <= '0'; 
    Co <= '1';
    when "100" =>
    S <= '1'; 
    Co <= '0';
    when "101" =>
    S <= '0'; 
    Co <= '1';
    when "110" =>
    S <= '0'; 
    Co <= '1';
    when "111" =>
    S <= '1'; 
    Co <= '1';
    when others =>
    S <= '0';
    Co <= '0';
 end case;

end process;

end Behavioral;

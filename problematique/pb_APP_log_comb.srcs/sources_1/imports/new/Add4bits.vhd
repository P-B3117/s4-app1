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

signal C1o: std_logic_vector(2 downto 0) := "000";

begin

 -- Make 4 UUT for the 4 bits and map them to internal signals thingies
  U0: Add1bitB PORT MAP(
      S => S(0), 
      X => X(0), 
      Y => Y(0), 
      C => C1,
      Co => C1o(0)
   );
   
   U1: Add1bitB PORT MAP(
      S => S(1), 
      X => X(1), 
      Y => Y(1), 
      C => C1o(0),
      Co => C1o(1)
   );
   
   U2: Add1bitA PORT MAP(
      S => S(2), 
      X => X(2), 
      Y => Y(2), 
      C => C1o(1),
      Co => C1o(2)
   );
   
   U3: Add1bitA PORT MAP(
      S => S(3), 
      X => X(3), 
      Y => Y(3), 
      C => C1o(2),
      Co => Co
   );

end Behavioral;

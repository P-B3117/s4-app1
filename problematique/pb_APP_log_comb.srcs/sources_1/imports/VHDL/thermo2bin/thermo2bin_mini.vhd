LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY thermo2bin_mini IS
    PORT (
        thermo : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        bin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END thermo2bin_mini;

ARCHITECTURE Behavioral OF thermo2bin_mini IS

BEGIN
    bin(0) <= thermo(2) OR (thermo(0) AND NOT thermo(1));
    bin(1) <= thermo(1);
    bin(2) <= '0';
    bin(3) <= '0';
END Behavioral;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decoder3_8 IS
    PORT (
        a2_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END decoder3_8;

ARCHITECTURE Behavioral OF decoder3_8 IS

BEGIN
    LED(0) <= (NOT a2_3(2)) AND (NOT a2_3(1)) AND (NOT a2_3(0));
    LED(1) <= (NOT a2_3(2)) AND (NOT a2_3(1)) AND a2_3(0);
    LED(2) <= (NOT a2_3(2)) AND a2_3(1) AND (NOT a2_3(0));
    LED(3) <= (NOT a2_3(2)) AND a2_3(1) AND a2_3(0);
    LED(4) <= a2_3(2) AND (NOT a2_3(1)) AND (NOT a2_3(0));
    LED(5) <= a2_3(2) AND (NOT a2_3(1)) AND a2_3(0);
    LED(6) <= a2_3(2) AND a2_3(1) AND (NOT a2_3(0));
    LED(7) <= a2_3(2) AND a2_3(1) AND a2_3(0);

END Behavioral;

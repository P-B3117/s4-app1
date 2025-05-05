LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY parity IS
    PORT (
        packet : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        switch : IN STD_LOGIC;
        parity : OUT STD_LOGIC
    );
END parity;

ARCHITECTURE Behavioral OF parity IS
    SIGNAL errors : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    -- One 1 Three 0
    errors(0) <= packet(0) AND NOT packet(1) AND NOT packet(2) AND NOT packet(3);
    errors(1) <= NOT packet(0) AND packet(1) AND NOT packet(2) AND NOT packet(3);
    errors(2) <= NOT packet(0) AND NOT packet(1) AND packet(2) AND NOT packet(3);
    errors(3) <= NOT packet(0) AND NOT packet(1) AND NOT packet(2) AND packet(3);

    -- One 0 Three 1
    errors(4) <= NOT packet(0) AND packet(1) AND packet(2) AND packet(3);
    errors(5) <= packet(0) AND NOT packet(1) AND packet(2) AND packet(3);
    errors(6) <= packet(0) AND packet(1) AND NOT packet(2) AND packet(3);
    errors(7) <= packet(0) AND packet(1) AND packet(2) AND NOT packet(3);

    parity <= (switch AND (errors(1) OR errors(2) OR errors(4) OR errors(5) OR errors(6) OR errors(7)))
        OR (NOT switch AND NOT errors(1) AND NOT errors(2) AND NOT errors(4) AND NOT errors(5) AND NOT errors(6) AND NOT errors(7));
END Behavioral;

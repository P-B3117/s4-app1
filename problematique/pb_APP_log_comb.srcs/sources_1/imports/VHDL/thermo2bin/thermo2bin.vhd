LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY thermo2bin IS
    PORT (
        thermo : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        bin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        error : OUT STD_LOGIC
    );
END thermo2bin;

ARCHITECTURE Behavioral OF thermo2bin IS
    SIGNAL s0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s3 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL b0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL b1 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT thermo2bin_mini IS
        PORT (
            thermo : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            bin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT full_adder_4bit IS
        PORT (
            a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    mini0 : thermo2bin_mini
    PORT MAP(
        thermo => thermo(2 DOWNTO 0),
        bin => s0
    );

    mini1 : thermo2bin_mini
    PORT MAP(
        thermo => thermo(5 DOWNTO 3),
        bin => s1
    );

    mini2 : thermo2bin_mini
    PORT MAP(
        thermo => thermo(8 DOWNTO 6),
        bin => s2
    );

    mini3 : thermo2bin_mini
    PORT MAP(
        thermo => thermo(11 DOWNTO 9),
        bin => s3
    );

    first_adder : full_adder_4bit
    PORT MAP(
        a => s0,
        b => s1,
        cin => '0',
        s => b0
    );

    second_adder : full_adder_4bit
    PORT MAP(
        a => s2,
        b => s3,
        cin => '0',
        s => b1
    );

    -- BIN
    bin_adder : full_adder_4bit
    PORT MAP(
        a => b0,
        b => b1,
        cin => '0',
        s => bin
    );

    -- Error
    error <= (thermo(1) AND NOT thermo(0))
        OR (thermo(2) AND NOT thermo(1))
        OR (thermo(3) AND NOT thermo(2))
        OR (thermo(4) AND NOT thermo(3))
        OR (thermo(5) AND NOT thermo(4))
        OR (thermo(6) AND NOT thermo(5))
        OR (thermo(7) AND NOT thermo(6))
        OR (thermo(8) AND NOT thermo(7))
        OR (thermo(9) AND NOT thermo(8))
        OR (thermo(10) AND NOT thermo(9))
        OR (thermo(11) AND NOT thermo(10));
END Behavioral;

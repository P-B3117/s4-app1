LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY thermo2bin IS
    PORT (
        thermo : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        bin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        error : OUT STD_LOGIC
    );
END thermo2bin;

-- thermo 11 11 11 11 11 11
-- s0     10 10 10 10 10 10
-- s1      100   100   100
-- s2        1000
-- bin       1100

ARCHITECTURE Behavioral OF thermo2bin IS
    signal a0_temp : std_logic_vector(3 downto 0);
    signal b0_temp : std_logic_vector(3 downto 0);
    signal a1_temp : std_logic_vector(3 downto 0);
    signal b1_temp : std_logic_vector(3 downto 0);
    signal a2_temp : std_logic_vector(3 downto 0);
    signal b2_temp : std_logic_vector(3 downto 0);

    SIGNAL s0 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL s1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL s2 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT full_adder IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            cin : IN STD_LOGIC;
            s : OUT STD_LOGIC;
            cout : OUT STD_LOGIC
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
    -- S0
    adder_0_1 : full_adder
    PORT MAP(
        a => thermo(0),
        b => thermo(1),
        cin => '0',
        s => s0(0),
        cout => s0(1)
    );

    adder_2_3 : full_adder
    PORT MAP(
        a => thermo(2),
        b => thermo(3),
        cin => '0',
        s => s0(2),
        cout => s0(3)
    );

    adder_4_5 : full_adder
    PORT MAP(
        a => thermo(4),
        b => thermo(5),
        cin => '0',
        s => s0(4),
        cout => s0(5)
    );

    adder_6_7 : full_adder
    PORT MAP(
        a => thermo(6),
        b => thermo(7),
        cin => '0',
        s => s0(6),
        cout => s0(7)
    );

    adder_8_9 : full_adder
    PORT MAP(
        a => thermo(8),
        b => thermo(9),
        cin => '0',
        s => s0(8),
        cout => s0(9)
    );

    adder_10_11 : full_adder
    PORT MAP(
        a => thermo(10),
        b => thermo(11),
        cin => '0',
        s => s0(10),
        cout => s0(11)
    );

    -- S1
    a0_temp <= "00" & s0(1 DOWNTO 0); 
    b0_temp <= "00" & s0(3 DOWNTO 2); 
    adder_10_32 : full_adder_4bit
    PORT MAP(
        a => a0_temp,
        b => b0_temp,
        cin => '0',
        s => s1(3 DOWNTO 0)
    );

    a1_temp <= "00" & s0(5 DOWNTO 4); 
    b1_temp <= "00" & s0(7 DOWNTO 6); 
    adder_54_76 : full_adder_4bit
    PORT MAP(
        a => a1_temp,
        b => b1_temp,
        cin => '0',
        s => s1(7 DOWNTO 4)
    );

    a2_temp <= "00" & s0(9 DOWNTO 8); 
    b2_temp <= "00" & s0(11 DOWNTO 10); 
    adder_98_1110 : full_adder_4bit
    PORT MAP(
        a => a2_temp,
        b => b2_temp,
        cin => '0',
        s => s1(11 DOWNTO 8)
    );

    -- S2
    adder_3210_7654 : full_adder_4bit
    PORT MAP(
        a => s1(3 DOWNTO 0),
        b => s1(7 DOWNTO 4),
        cin => '0',
        s => s2
    );

    -- BIN
    adder_81 : full_adder_4bit
    PORT MAP(
        a => s1(11 DOWNTO 8),
        b => s2,
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

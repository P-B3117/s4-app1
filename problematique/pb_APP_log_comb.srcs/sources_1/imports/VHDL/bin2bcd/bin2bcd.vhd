LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin2bcd IS
    PORT (
        ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        tens_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        code_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY bin2bcd;

ARCHITECTURE behavioral OF bin2bcd IS
    SIGNAL ADCsubstracted : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL coutish : STD_LOGIC;

    COMPONENT bin2bcd_non_signed IS
        PORT (
            ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            tens_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            units_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT bin2bcd_signed IS
        PORT (
            ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

            code_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            units_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT adder_4bit IS
        PORT (
            a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    non_signed : bin2bcd_non_signed
    PORT MAP(
        ADCbin => ADCbin,
        tens_ns => tens_ns,
        units_ns => units_ns
    );

    substract5 : adder_4bit
    PORT MAP(
        a => ADCbin,
        b => "1011",
        s => ADCsubstracted,
        cout => coutish
    );

    signed : bin2bcd_signed
    PORT MAP(
        ADCbin => ADCsubstracted,
        code_s => code_s,
        units_s => units_s
    );
END ARCHITECTURE behavioral;

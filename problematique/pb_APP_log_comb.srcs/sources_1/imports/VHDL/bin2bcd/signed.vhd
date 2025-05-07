LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY bin2bcd_signed IS
    PORT (
        ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        code_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY bin2bcd_signed;

ARCHITECTURE behavioral OF bin2bcd_signed IS
    SIGNAL ADCbin_not : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL ADCbin_two_complement : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT adder_4bit IS
        PORT (
            a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    ADCbin_not <= NOT(ADCbin);

    substract10 : adder_4bit
    PORT MAP(
        a => ADCbin_not,
        b => "0001",
        s => ADCbin_two_complement
    );

    units_s <= ADCbin_two_complement WHEN ADCbin(3) = '1' ELSE ADCbin;
    code_s <= "1101" WHEN ADCbin(3) = '1' ELSE "0000";
END ARCHITECTURE behavioral;

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
    SIGNAL substract_value : STD_LOGIC_VECTOR(3 DOWNTO 0);

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
    substract_value <= "0110" WHEN ((ADCbin(3) AND ADCbin(1)) OR (ADCbin(3) AND ADCbin(2))) = '1' ELSE
        "0000";

    substract10 : full_adder_4bit
    PORT MAP(
        a => ADCbin,
        b => substract_value,
        cin => '0',
        s => units_s
    );

    code_s <= "1101" WHEN ((ADCbin(3) AND ADCbin(1)) OR (ADCbin(3) AND ADCbin(2))) = '1' ELSE
        "0000";
END ARCHITECTURE behavioral;

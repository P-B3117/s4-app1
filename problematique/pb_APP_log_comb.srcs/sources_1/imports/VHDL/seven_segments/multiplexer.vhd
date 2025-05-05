LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY multiplexer IS
    PORT (
        ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        tens_ns : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_ns : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        code_s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        error : IN STD_LOGIC;

        BTN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        S2 : IN STD_LOGIC;

        DAFF0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        DAFF1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END ENTITY multiplexer;

ARCHITECTURE behavioral OF multiplexer IS

BEGIN
    PROCESS (BTN, S2, ADCbin, tens_ns, units_ns, units_s, code_s, error)
    BEGIN
        IF error = '1' THEN
            DAFF0 <= "1110";
            DAFF1 <= "1010";

        ELSIF S2 = '1' THEN
            DAFF0 <= "1110";
            DAFF1 <= "1010";

        ELSE
            CASE BTN IS
                WHEN "00" =>
                    DAFF0 <= tens_ns;
                    DAFF1 <= units_ns;

                WHEN "01" =>
                    DAFF0 <= "0000";
                    DAFF1 <= ADCbin;

                WHEN "10" =>
                    DAFF0 <= code_s;
                    DAFF1 <= units_s;

                WHEN "11" =>
                    DAFF0 <= "1110";
                    DAFF1 <= "1010";

            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE behavioral;

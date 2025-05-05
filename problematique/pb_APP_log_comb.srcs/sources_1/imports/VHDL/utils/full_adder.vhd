LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        cin : IN STD_LOGIC;
        s : OUT STD_LOGIC;
        cout : OUT STD_LOGIC
    );
END full_adder;

ARCHITECTURE Behavioral OF full_adder IS

BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END Behavioral;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder_4bit IS
    PORT (
        a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END full_adder_4bit;

ARCHITECTURE Behavioral OF full_adder_4bit IS
    SIGNAL cint : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    s(0) <= a(0) XOR b(0) XOR cin;
    cint(0) <= (a(0) AND b(0)) OR (cin AND a(0)) OR (cin AND b(0));

    s(1) <= a(1) XOR b(1) XOR cint(0);
    cint(1) <= (a(1) AND b(1)) OR (cint(0) AND a(1)) OR (cint(0) AND b(1));

    s(2) <= a(2) XOR b(2) XOR cint(1);
    cint(2) <= (a(2) AND b(2)) OR (cint(1) AND a(2)) OR (cint(1) AND b(2));

    s(3) <= a(3) XOR b(3) XOR cint(2);

    cout <= (a(3) AND b(3)) OR (cint(2) AND a(3)) OR (cint(2) AND b(3));
END Behavioral;

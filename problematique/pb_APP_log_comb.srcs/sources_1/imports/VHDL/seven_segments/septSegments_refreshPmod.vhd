---------------------------------------------------------------------------------------------
-- circuit affhex_pmodssd.vhd
---------------------------------------------------------------------------------------------
-- Universit� de Sherbrooke - D�partement de GEGI
-- APP de circuits logiques
-- Auteur(s)       : R�jean Fontaine, Daniel Dalle, Marc-Andr� T�trault
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
---------------------------------------------------------------------------------------------
-- Description:
-- S�paration du d�codage 7-segments pour faciliter un affichage en simulation
---------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY septSegments_refreshPmod IS
    GENERIC (const_CLK_MHz : INTEGER := 100); -- horloge en MHz, typique 100 MHz 
    PORT (
        clk : IN STD_LOGIC; -- horloge systeme, typique 100 MHz (preciser par le constante)
        i_SSD0 : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- donnee a afficher sur 1er chiffre
        i_SSD1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- donnee a afficher sur 2e chiffre     
        JPmod : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- sorties directement adaptees au connecteur PmodSSD
    );
END septSegments_refreshPmod;

ARCHITECTURE Behavioral OF septSegments_refreshPmod IS

    -- realisation compteur division horloge pour multiplexer affichage SSD
    -- constante pour ajuster selon l horloge pilote du controle des afficheurs
    CONSTANT CLK_SSD_KHz_des : INTEGER := 5; --Khz   -- horloge desiree pour raffraichir afficheurs 7 segment
    CONSTANT const_div_clk_SSD : INTEGER := (const_CLK_MHz * 1000 / CLK_SSD_KHz_des - 1);
    CONSTANT cdvia : STD_LOGIC_VECTOR(15 DOWNTO 0) := conv_std_logic_vector(const_div_clk_SSD, 16); -- donne 5 KHz soit 200 us

    SIGNAL counta : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL segm : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL SEL : STD_LOGIC := '0';

BEGIN

    -- selection chiffre pour affichage
    local_CLK_proc : PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            counta <= counta + 1;
            IF (counta = cdvia) THEN -- devrait se produire aux 200 us approx
                counta <= (OTHERS => '0');
                SEL <= NOT SEL; -- bascule de la selection du chiffre (0 ou 1)
                -- SEL devrait avoir periode de 400 us approx

                -- l'ordre n'est pas important pour l'affichage physique
                IF (SEL = '1') THEN
                    segm(6 DOWNTO 0) <= i_SSD0;
                ELSE
                    segm(6 DOWNTO 0) <= i_SSD1;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    JPmod <= SEL & segm;

END Behavioral;

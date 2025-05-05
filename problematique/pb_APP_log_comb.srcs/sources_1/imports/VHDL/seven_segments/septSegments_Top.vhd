---------------------------------------------------------------------------------------------
-- circuit affhex_pmodssd.vhd
---------------------------------------------------------------------------------------------
-- Universit� de Sherbrooke - D�partement de GEGI
-- Version         : 2.0
-- Nomenclature    : 0.8 GRAMS
-- Date            : revision 23 octobre 2018
-- Auteur(s)       : R�jean Fontaine, Daniel Dalle
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
-- Outils          : vivado 2016.1 64 bits, vivado 2018.2
---------------------------------------------------------------------------------------------
-- Description:
-- Affichage sur module de 2 chiffes (7 segments) sur PmodSSD 
-- reference https://reference.digilentinc.com/reference/pmod/pmodssd/start 
--           PmodSSD� Reference Manual Doc: 502-126 Digilent, Inc.
--
-- Revisions
-- mise a jour D Dalle 22 octobre 2018 corrections, simplifications
-- mise a jour D Dalle 15 octobre documentation affhex_pmodssd_sol_v0.vhd
-- mise a jour D Dalle 12 septembre pour eviter l'usage d'une horloge interne
-- mise a jour D Dalle 7 septembre, calcul des constantes.
-- mise a jour D Dalle 5 septembre 2018, nom affhexPmodSSD, 6 septembre :division horloge
-- module de commande le l'afficheur 2 segments 2 digits sur pmod
-- Daniel Dalle revision pour sortir les signaux du connecteur Pmod directement
-- Daniel Dalle 30 juillet 2018:
-- revision pour une seule entre sur 8 bits affichee sur les deux chiffres Hexa
--
-- Creation selon affhex7segx4v3.vhd 
-- (Daniel Dalle, R�jean Fontaine Universite de Sherbrooke, Departement GEGI)
-- 26 septembre 2011, revision 12 juin 2012, 25 janvier 2013, 7 mai 2015
-- Contr�le de l'afficheur a sept segment (BASYS2 - NEXYS2)
-- horloge 100MHz et diviseur interne
---------------------------------------------------------------------------------------------
-- � faire :
-- 
-- 
-- 
---------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY septSegments_Top IS
    GENERIC (const_CLK_MHz : INTEGER := 100); -- horloge en MHz, typique 100 MHz 
    PORT (
        clk : IN STD_LOGIC; -- horloge systeme, typique 100 MHz (preciser par le constante)
        i_AFF0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- donnee a afficher sur 4 bits : chiffre hexa position 0
        i_AFF1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- donnee a afficher sur 4 bits : chiffre hexa position 1
        o_AFFSSD_Sim : OUT STRING(2 DOWNTO 1);
        o_AFFSSD : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END septSegments_Top; -- sorties directement adaptees au connecteur PmodSSD

ARCHITECTURE Behavioral OF septSegments_Top IS

    COMPONENT septSegments_encodeur IS
        PORT (
            i_AFF : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- caract�re � afficher
            o_CharacterePourSim : OUT STRING(1 TO 1); -- pour simulation seulement
            o_Seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- encodage 7-segments
        );
    END COMPONENT;

    COMPONENT septSegments_refreshPmod IS
        GENERIC (const_CLK_MHz : INTEGER := 100); -- horloge en MHz, typique 100 MHz 
        PORT (
            clk : IN STD_LOGIC; -- horloge systeme, typique 100 MHz (preciser par le constante)
            i_SSD0 : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- donnee a afficher sur 1er chiffre
            i_SSD1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- donnee a afficher sur 2e chiffre     
            JPmod : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- sorties directement adaptees au connecteur PmodSSD
        );
    END COMPONENT;
    SIGNAL s_segment_lsb : STD_LOGIC_VECTOR (6 DOWNTO 0);
    SIGNAL s_segment_msb : STD_LOGIC_VECTOR (6 DOWNTO 0);

BEGIN
    inst_segm_lsb : septSegments_encodeur
    PORT MAP(
        i_AFF => i_AFF0,
        o_CharacterePourSim => o_AFFSSD_Sim(1 DOWNTO 1),
        o_Seg => s_segment_lsb
    );

    inst_segm_msb : septSegments_encodeur
    PORT MAP(
        i_AFF => i_AFF1,
        o_CharacterePourSim => o_AFFSSD_Sim(2 DOWNTO 2),
        o_Seg => s_segment_msb
    );

    inst_refresh : septSegments_refreshPmod
    --generic(const_CLK_MHz : integer := 100); -- horloge en MHz, typique 100 MHz 
    PORT MAP(
        clk => clk,
        i_SSD0 => s_segment_lsb,
        i_SSD1 => s_segment_msb,
        JPmod => o_AFFSSD
    );

END Behavioral;

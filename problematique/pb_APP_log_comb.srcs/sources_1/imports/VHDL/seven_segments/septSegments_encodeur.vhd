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
-- Affichage sur module de 2 chiffes (7 o_Segents) sur PmodSSD 
-- reference https://reference.digilentinc.com/reference/pmod/pmodssd/start 
--           PmodSSD� Reference Manual Doc: 502-126 Digilent, Inc.
--
-- Revisions
-- mise a jour D Dalle 22 octobre 2018 corrections, simplifications
-- mise a jour D Dalle 15 octobre documentation affhex_pmodssd_sol_v0.vhd
-- mise a jour D Dalle 12 septembre pour eviter l'usage d'une horloge interne
-- mise a jour D Dalle 7 septembre, calcul des constantes.
-- mise a jour D Dalle 5 septembre 2018, nom affhexPmodSSD, 6 septembre :division horloge
-- module de commande le l'afficheur 2 o_Segents 2 digits sur pmod
-- Daniel Dalle revision pour sortir les signaux du connecteur Pmod directement
-- Daniel Dalle 30 juillet 2018:
-- revision pour une seule entre sur 8 bits affichee sur les deux chiffres Hexa
--
-- Creation selon affhex7segx4v3.vhd 
-- (Daniel Dalle, R�jean Fontaine Universite de Sherbrooke, Departement GEGI)
-- 26 septembre 2011, revision 12 juin 2012, 25 janvier 2013, 7 mai 2015
-- Contr�le de l'afficheur a sept o_Segent (BASYS2 - NEXYS2)
-- horloge 100MHz et diviseur interne
---------------------------------------------------------------------------------------------
-- � faire :
-- 
-- 
-- 
---------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY septSegments_encodeur IS
    PORT (
        i_AFF : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- caract�re � afficher
        o_CharacterePourSim : OUT STRING(1 TO 1); -- pour simulation seulement  
        o_Seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- encodage 7-segments
    );
END septSegments_encodeur;

ARCHITECTURE Behavioral OF septSegments_encodeur IS
    -- fonction r�serv�e pour l'affichage en simulation seulement
    FUNCTION segment2String(display : STD_LOGIC_VECTOR(6 DOWNTO 0))
        RETURN STRING IS
        VARIABLE v_ReturnString : STRING(1 TO 1);
    BEGIN
        CASE display IS
            WHEN "0111111" => v_ReturnString := "0"; -- 0
            WHEN "0000110" => v_ReturnString := "1"; -- 1
            WHEN "1011011" => v_ReturnString := "2"; -- 2
            WHEN "1001111" => v_ReturnString := "3"; -- 3
            WHEN "1100110" => v_ReturnString := "4"; -- 4
            WHEN "1101101" => v_ReturnString := "5"; -- 5 
            WHEN "1111101" => v_ReturnString := "6"; -- 6 
            WHEN "0000111" => v_ReturnString := "7"; -- 7 
            WHEN "1111111" => v_ReturnString := "8"; -- 8
            WHEN "1101111" => v_ReturnString := "9"; -- 9 
            WHEN "1110111" => v_ReturnString := "A"; -- A
            WHEN "1111100" => v_ReturnString := "B"; -- b 
            WHEN "0111001" => v_ReturnString := "C"; -- C 
            WHEN "1011110" => v_ReturnString := "D"; -- d 
            WHEN "1111001" => v_ReturnString := "E"; -- E
            WHEN "1110001" => v_ReturnString := "F"; -- F 
            WHEN "1000000" => v_ReturnString := "-"; -- n�gatif
            WHEN "1010000" => v_ReturnString := "r"; -- r pour erreur
            WHEN OTHERS => v_ReturnString := "_"; -- code non reconnu
        END CASE;
        RETURN v_ReturnString;
    END segment2String;
    -- fin de la fonction
    SIGNAL s_Seg : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    -- correspondance des o_Segents des afficheurs
    o_Segent : PROCESS (i_AFF)
    BEGIN
        CASE i_AFF IS
                --                      "gfedcba"
            WHEN "0000" => s_Seg <= "0111111"; -- 0
            WHEN "0001" => s_Seg <= "0000110"; -- 1
            WHEN "0010" => s_Seg <= "1011011"; -- 2
            WHEN "0011" => s_Seg <= "1001111"; -- 3
            WHEN "0100" => s_Seg <= "1100110"; -- 4
            WHEN "0101" => s_Seg <= "1101101"; -- 5 
            WHEN "0110" => s_Seg <= "1111101"; -- 6 
            WHEN "0111" => s_Seg <= "0000111"; -- 7 
            WHEN "1000" => s_Seg <= "1111111"; -- 8
            WHEN "1001" => s_Seg <= "1101111"; -- 9 
            WHEN "1010" => s_Seg <= "1110111"; -- A
            WHEN "1011" => s_Seg <= "1111100"; -- B 
            WHEN "1100" => s_Seg <= "0111001"; -- C 
            WHEN "1101" => s_Seg <= "1000000"; -- negatif 
            WHEN "1110" => s_Seg <= "1111001"; -- E
            WHEN "1111" => s_Seg <= "1010000"; -- r
            WHEN OTHERS => s_Seg <= "0000000";
        END CASE;
    END PROCESS;
    o_CharacterePourSim <= segment2String(s_Seg);
    o_Seg <= s_Seg;

END Behavioral;

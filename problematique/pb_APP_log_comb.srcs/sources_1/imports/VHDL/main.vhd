---------------------------------------------------------------------------------------------
-- Universit� de Sherbrooke - D�partement de GEGI
-- Version         : 3.0
-- Nomenclature    : GRAMS
-- Date            : 21 Avril 2020
-- Auteur(s)       : R�jean Fontaine, Daniel Dalle, Marc-Andr� T�trault
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--                   peripheriques: Pmod8LD PmodSSD
--
-- Outils          : vivado 2019.1 64 bits
---------------------------------------------------------------------------------------------
-- Description:
-- Circuit utilitaire pour le laboratoire et la probl�matique de logique combinatoire
--
---------------------------------------------------------------------------------------------
-- � faire :
-- Voir le guide de l'APP
--    Ins�rer les modules additionneurs ("components" et "instances")
--
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;

ENTITY main IS
    PORT (
        i_btn : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- Boutons de la carte Zybo
        i_sw : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- Interrupteurs de la carte Zybo
        sysclk : IN STD_LOGIC; -- horloge systeme
        i_ADC_th    : in    std_logic_vector(11 downto 0); -- Thermobin?
        i_S1        : in    std_logic;
        i_S2        : in    std_logic;
        o_SSD : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- vers cnnecteur pmod afficheur 7 segments
        o_led : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- vers DELs de la carte Zybo
        o_led6_r : OUT STD_LOGIC; -- vers DEL rouge de la carte Zybo
        o_pmodled : OUT STD_LOGIC_VECTOR (7 DOWNTO 0) -- vers connecteur pmod 8 DELs
    );
END main;

ARCHITECTURE BEHAVIORAL OF main IS
    CONSTANT nbreboutons : INTEGER := 4; -- Carte Zybo Z7
    CONSTANT freq_sys_MHz : INTEGER := 125; -- 125 MHz 

    SIGNAL d_s_1Hz : STD_LOGIC;
    SIGNAL clk_5MHz : STD_LOGIC;
    --
    SIGNAL d_opa : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"; -- operande A
    SIGNAL d_opb : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"; -- operande B
    SIGNAL d_cin : STD_LOGIC := '0'; -- retenue entree
    SIGNAL d_sum : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"; -- somme
    SIGNAL d_cout : STD_LOGIC := '0'; -- retenue sortie
    --
    SIGNAL d_AFF0 : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    SIGNAL d_AFF1 : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
    
    -- ThermoBin
    SIGNAL ADCbin : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL error : STD_LOGIC;

    
    -- Scaler2_3
    SIGNAL a2_3 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    
    -- bin2bcd
    SIGNAL tens_ns : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL units_ns : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL code_s : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL units_s : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    
    COMPONENT synchro_module_v2 IS
        GENERIC (const_CLK_syst_MHz : INTEGER := freq_sys_MHz);
        PORT (
            clkm : IN STD_LOGIC; -- Entr�e  horloge maitre
            o_CLK_5MHz : OUT STD_LOGIC; -- horloge divise utilise pour le circuit             
            o_S_1Hz : OUT STD_LOGIC -- Signal temoin 1 Hz
        );
    END COMPONENT;

    COMPONENT septSegments_Top IS
        PORT (
            clk : IN STD_LOGIC; -- horloge systeme, typique 100 MHz (preciser par le constante)
            i_AFF0 : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0
            i_AFF1 : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- donnee a afficher sur 8 bits : chiffre hexa position 1 et 0     
            o_AFFSSD_Sim : OUT STRING(1 TO 2);
            o_AFFSSD : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT thermo2bin IS
        PORT (
            thermo : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            bin : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            error : OUT STD_LOGIC
        );
     END COMPONENT;

    COMPONENT scaler2_3 IS
        PORT (
            ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            a2_3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT decoder3_8 IS
        PORT (
            a2_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    
    
    COMPONENT parity IS
        PORT (
        packet : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        switch : IN STD_LOGIC;
        parity : OUT STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT multiplexer IS
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
    END COMPONENT;
    
    COMPONENT bin2bcd IS
    PORT (
        ADCbin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        tens_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_ns : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

        code_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        units_s : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
BEGIN

    inst_synch : synchro_module_v2
    GENERIC MAP(const_CLK_syst_MHz => freq_sys_MHz)
    PORT MAP(
        clkm => sysclk,
        o_CLK_5MHz => clk_5MHz,
        o_S_1Hz => d_S_1Hz
    );

    inst_aff : septSegments_Top
    PORT MAP(
        clk => clk_5MHz,
        -- donnee a afficher definies sur 8 bits : chiffre hexa position 1 et 0
        i_AFF1 => d_AFF1,
        i_AFF0 => d_AFF0,
        o_AFFSSD_Sim => OPEN, -- ne pas modifier le "open". Ligne pour simulations seulement.
        o_AFFSSD => o_SSD -- sorties directement adaptees au connecteur PmodSSD
    );
    
    thermobin : thermo2bin
    PORT MAP(
      thermo => i_ADC_th,
      bin => ADCbin,
      error => error
    );

    pmodled_scale : scaler2_3
    PORT MAP(
        ADCbin => ADCbin,
        a2_3 => a2_3
    );

    pmodled_decode : decoder3_8
    PORT MAP(
        a2_3 => a2_3,
        LED => o_pmodled
    );
    
    pmodled_parity : parity
    PORT MAP(
        packet => ADCbin,
        switch => i_S1,
--        parity => o_led(0)
        parity => o_led6_r
    );
    
    seven_seg_bin2bcd : bin2bcd
    PORT MAP(
        ADCbin => ADCbin,
        tens_ns => tens_ns,
        units_ns => units_ns,
        code_s => code_s,
        units_s => units_s
    );
    
    seven_seg_mux : multiplexer
    PORT MAP(
    ADCbin => ADCbin,
    tens_ns => tens_ns,
    units_ns => units_ns,
    code_s => code_s,
    units_s => units_s,
    error => error,
    BTN => i_btn(1 downto 0),
    S2 => i_s2,
    DAFF0 => d_AFF0,
    DAFF1 => d_AFF1
    );
    
    

    d_opa <= i_sw; -- operande A sur interrupteurs
    d_opb <= i_btn; -- operande B sur boutons
    d_cin <= '0'; -- la retenue d'entr�e alterne 0 1 a 1 Hz

    d_AFF0 <= d_sum(3 DOWNTO 0); -- Le resultat de votre additionneur affich� sur PmodSSD(0)
    d_AFF1 <= '0' & '0' & '0' & d_Cout; -- La retenue de sortie affich�e sur PmodSSD(1) (0 ou 1)
    o_led6_r <= d_Cout; -- La led couleur repr�sente aussi la retenue en sortie  Cout
    o_pmodled <= d_opa & d_opb; -- Les op�randes d'entr�s reproduits combin�s sur Pmod8LD
    o_led (3 DOWNTO 0) <= '0' & '0' & '0' & d_S_1Hz; -- La LED0 sur la carte repr�sente la retenue d'entr�e        
END BEHAVIORAL;

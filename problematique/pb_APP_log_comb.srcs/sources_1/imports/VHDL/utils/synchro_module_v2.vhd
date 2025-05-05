---------------------------------------------------------------------------------------------
-- synchro_module_v2.vhd 
---------------------------------------------------------------------------------------------
-- Generation d'horloge et de signaux de synchronisation
---------------------------------------------------------------------------------------------
-- Universit� de Sherbrooke - D�partement de GEGI
-- 
-- Version        : 2.0
-- Nomenclature   : ref GRAMS
-- Date           : 13 sept. 2018, 4 decembre 2018
-- Auteur(s)      : Daniel Dalle
-- Technologies   : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
-- Outils         : vivado 2018.2 64 bits
-- 
--------------------------------
-- Description
--------------------------------
-- G�n�ration de signaux de synchronisation, incluant des "strobes"
-- Voir les comentaires dans la declaration entity pour le description des signaux
-- revisions
-- 4 decembre 2018  : reduction des signaux de sorties
-- 16 octobre 2018  : documentation
-- 13 septembre 2018: creation 
-- 
--------------------------------
-- � FAIRE:
--------------------------------
--
--
---------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL; -- requis pour les constantes  etc.
USE IEEE.STD_LOGIC_UNSIGNED.ALL; -- pour les additions dans les compteurs

LIBRARY UNISIM;
USE UNISIM.vcomponents.ALL;

ENTITY synchro_module_v2 IS
   GENERIC (const_CLK_syst_MHz : INTEGER := 100);
   PORT (
      clkm : IN STD_LOGIC; -- Entr�e  horloge maitre
      o_clk_5MHz : OUT STD_LOGIC; -- horloge divisee via bufg  
      o_S_1Hz : OUT STD_LOGIC -- Signal temoin 1 Hz (0,99952 Hz) 
   );
END synchro_module_v2;

ARCHITECTURE Behavioral OF synchro_module_v2 IS

   --   component strb_gen is
   --       Port ( 
   --           CLK      : in STD_LOGIC;    -- Entr�e  horloge maitre 
   --           i_don    : in  STD_LOGIC;   -- signal pour generer strobe au front montant          
   --           o_stb    : out  STD_LOGIC   -- strobe synchrone resultant
   --           );                           
   --   end component;

   -- constantes pour les diviseurs
   CONSTANT CLKp_MHz_des : INTEGER := 5; -- Mhz
   CONSTANT constante_diviseur_p : INTEGER := (const_CLK_syst_MHz/(2 * CLKp_MHz_des)); -- considerant toggle sur le signal Clkp5MHzint
   --constant constante_diviseur_p: integer  :=(const_CLK_syst_MHz/(CLKp_MHz_des)-1);
   CONSTANT cdiv1 : STD_LOGIC_VECTOR(3 DOWNTO 0) := conv_std_logic_vector(constante_diviseur_p, 4);
   CONSTANT cdiv2 : STD_LOGIC_VECTOR(4 DOWNTO 0) := conv_std_logic_vector (25, 5); -- overflow a Clkp5MHzint/26 = 192.3 kHz  soit 5.2 us
   CONSTANT cdiv3 : STD_LOGIC_VECTOR(15 DOWNTO 0) := conv_std_logic_vector (1848, 16); -- overflow a Clk200kHzInt / 1924 = 99.952 = ~100 Hz soit 10.005 ms (t r�el)
   CONSTANT cdiv4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := conv_std_logic_vector (99, 8); -- o_S1Hz = o_clk3 / 100    =  1 Hz soit 1 s

   -- 
   SIGNAL ValueCounter5MHz : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
   SIGNAL ValueCounter200kHz : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
   SIGNAL ValueCounter100Hz : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
   SIGNAL ValueCounter1Hz : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

   SIGNAL d_s5MHzInt : STD_LOGIC := '0';
   SIGNAL clk_5MHzInt : STD_LOGIC := '0';
   SIGNAL d_s1HzInt : STD_LOGIC := '0';
   SIGNAL d_s100HzInt : STD_LOGIC := '0';
   SIGNAL d_strobe_100HzInt : STD_LOGIC := '0';
BEGIN

   -- buffer d'horloge n�cessaire pour impl�mentation d'un signal d'horloge
   -- a distribuer dans tout le circuit
   ClockBuffer : bufg
   PORT MAP(
      I => d_s5MHzInt,
      O => clk_5MHzInt
   );

   --inst_strb_100Hz : strb_gen 
   --    Port map ( 
   --      CLK     =>  clk_5MHzInt,
   --      i_don   =>  d_s100HzInt,     
   --      o_stb   =>  d_strobe_100HzInt
   --      );           

   o_clk_5MHz <= clk_5MHzInt;
   --o_S_100Hz   <= d_s100HzInt;
   o_S_1Hz <= d_s1HzInt;
   --o_stb_100Hz <= d_strobe_100HzInt;

   PROCESS (clkm)
   BEGIN
      IF (clkm'event AND clkm = '1') THEN
         ValueCounter5MHz <= ValueCounter5MHz + 1;
         IF (ValueCounter5MHz = cdiv1) THEN -- evenement se produit aux 100 approx ns
            ValueCounter5MHz <= "00000";
            d_s5MHzInt <= NOT d_s5MHzInt; -- pour generer horloge a exterieur du module (prevoir bufg)   
            ValueCounter200kHz <= ValueCounter200kHz + 1;
            IF (ValueCounter200kHz = cdiv2) THEN -- evenement se produit aux 5 us approx
               ValueCounter200kHz <= "00000";
               ValueCounter100Hz <= ValueCounter100Hz + 1;
               IF (ValueCounter100Hz = cdiv3) THEN -- evenement se produit aux 5 ms  approx
                  ValueCounter100Hz <= "0000000000000000";
                  -- d_s100HzInt <= Not d_s100HzInt;
                  ValueCounter1Hz <= ValueCounter1Hz + 1;
                  IF (ValueCounter1Hz = cdiv4) THEN -- evenement se produit aux 500 ms approx
                     ValueCounter1Hz <= "00000000";
                     d_s1HzInt <= NOT d_s1HzInt;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;
END Behavioral;

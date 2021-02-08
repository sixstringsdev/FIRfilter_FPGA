library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port(	clk:																			in std_logic;
					sw1,sw2,syn,sw4,sw5:											in std_logic;
--				FIR_IN:																in std_logic_vector(15 downto 0);
					fir_out:																	out std_logic_vector( 15 downto 0)
				);
end top_level;

architecture solucion of top_level is

signal a,b,rst:																								std_logic;
signal t,q:																										std_logic_vector(15 downto 0);
signal fir_in_32bits:																				std_logic_vector(31 downto 0);

component anti_rebote is
port(clk,entrada: in std_logic;
			salida: 			out std_logic);
end component ;

component filtro_gaussiano is
	port(	clk:																			in std_logic;
					syn:																			in std_logic;
					clk_mux:																in std_logic;
					fir_in:																		in std_logic_vector(31 downto 0);
					fir_out:																	out std_logic_vector(15 downto 0)
					);
end component;
BEGIN

rst <= '1';
fir_in_32bits <= "0000000000000000"&q;
q <= "0000010000000000" when sw1 = '0'  else (others=>'0'); 


U1: anti_rebote port map(clk,sw2,b);
U2: anti_rebote port map(clk,sw5,a);
U3: filtro_gaussiano port map(b,syn,a,fir_in_32bits,t) ;

fir_out <= not q when sw4 = '0'  else not t; 

end solucion;
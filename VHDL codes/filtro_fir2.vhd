--This is a 15th order GAUSSIAN FIR FILTER base on the 3 order filter. Using structural style.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filtro_fir is
	port(	clk:																			in std_logic;
					syn:																			in std_logic;
					clk_mux:																in std_logic;
					fir_in:																		in std_logic_vector(31 downto 0);
					fir_out:																	out std_logic_vector(15 downto 0)
					);
end filtro_fir;


architecture solucion of filtro_fir is

signal v1,v2,v3,v4,RD:																					std_logic;
signal q:																													std_logic_vector(1 downto 0) := (others =>'0');
signal fir_in_32bits,temp1,temp2,temp3,temp4: 				signed(31 downto 0);
signal xout1,xout2,xout3,xout4,xoutemp:								signed(39 downto 0);

component filtro_gauss is
	port( 	
					clk:				in std_logic := '0';
					
--Entrada de datos 					
					data_in:			in signed(31 downto 0) := (others =>'0');
					sample_valid_in:		in std_logic := '0';
					
--Salida de datos
				data_ext:				out signed(31 downto 0) := (others =>'0');
				data_out:				out signed(39 downto 0) := (others => '0');
				sample_valid_out:	out std_logic := '0';
-- Entrada de datos de los coeficientes
				a0 : integer;
				a1 : integer;
				a2 : integer;
				a3 : integer
				);
end component;

begin

fir_in_32bits <= signed(fir_in);

U1: filtro_gauss	port map (
    					clk =>				clk,
					
					data_in =>			fir_in_32bits,
					sample_valid_in =>		syn,
					
					data_ext =>			temp1,
					data_out =>			xout1,
					sample_valid_out =>	     	 v1,
	 
    a0 => 1699265,	
    a1 => 51806487,	
    a2 => 161842189,
    a3 => 51806487

    );

U2: filtro_gauss	port map (
    					clk =>				clk,
					
					data_in =>			fir_in_32bits,
					sample_valid_in =>		syn,
					
					data_ext =>			temp2,
					data_out =>			xout2,
					sample_valid_out =>	     	v2,

    a0 => 4943672,	
    a1 => 85274409,	
    a2 => 150720567,
    a3 =>27296761

    );
	 
U3: filtro_gauss	port map (
    					clk =>				clk,
					
					data_in =>			fir_in_32bits,
					sample_valid_in =>		syn,
					

					data_ext =>			temp3,
					data_out =>			xout3,
					sample_valid_out =>	     	v3,
	 
    a0 => 12473824,	
    a1 => 121734827,	
    a2 => 121734827,
    a3 =>12473824

    );	 
	 
U4: filtro_gauss	port map (
    					clk =>				clk,
					
					data_in =>			fir_in_32bits,
					sample_valid_in =>		syn,
					
					data_ext =>			temp4,
					data_out =>			xout4,
					sample_valid_out =>	      	v4,
	 
    a0 => 27296761,	
    a1 => 150720567,	
    a2 => 85274409,
    a3 =>4943672

    );	 	 

	 RD <= v1 and v2 and v3 and v4;
	 
process(clk_mux)
begin
		if RD = '1' then 
			if rising_edge (clk_mux) then
				q <=  std_logic_vector( unsigned(q) + 1 );
			end if;
		end if;
end process;

with q select xoutemp <= xout1 when "00",
														xout2 when "01",
														xout3 when "10",
														xout4 when others;
														
fir_out <= std_logic_vector(resize(xoutemp,16));

end solucion;

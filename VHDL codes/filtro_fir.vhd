library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filtro_fir is
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
end filtro_fir;

architecture solucion of filtro_fir is

signal state : integer := 0;

--señales para el multiplicador
signal mult_in_a, mult_in_b :   signed(31 downto 0)  := (others =>'0');
signal mult_out :	signed(63 downto 0) := (others =>'0');
signal temp : 		signed (39 downto 0) := (others=>'0');

--señales temporales
signal in_z0, in_z1, in_z2, in_z3 : signed (31 downto 0)  := (others =>'0');


begin

---multiplicador
process(mult_in_a,mult_in_b)
begin
	mult_out <= mult_in_a*mult_in_b;
end process;


process(clk)
begin
if rising_edge(clk) then
		
			-- Empeiza el filtro validando que el dato ha llegado
			if (sample_valid_in ='1' and state = 0) then
					--carga el multiplicador con  data_in * a0
					data_ext <=in_z3;
					in_z3 <= in_z2;
					in_z2 <= in_z1;
					in_z1 <= in_z0;
					mult_in_a <=data_in;
					in_z0 <= data_in;
					mult_in_b <= to_signed(a0,32);
					state<= 1;
					
					
			elsif (state = 1) then
					--guardamos el producto y la suma temp y aplicamos  un corrimiento de 30
					temp <= temp + resize(shift_right(mult_out,30),40);
					mult_in_a <= in_z1;
					mult_in_b <= to_signed(a1,32);
					state <= 2;
			
			elsif (state = 2) then
				temp <= temp + resize(shift_right(mult_out,30),40);
				mult_in_a <= in_z2;
				mult_in_b <= to_signed(a2,32);			
				state <= 3;
				
			elsif(state = 3) then
				temp <= temp + resize(shift_right(mult_out,30),40);
				mult_in_a <= in_z3;
				mult_in_b <= to_signed(a3,32);			
				state <= 4;
			
			elsif(state = 4) then
				temp <= temp+ resize(shift_right(mult_out,30),40);
				state <= 5;
				
			elsif(state=5) then
				data_out <=temp;
				sample_valid_out <= '1';
				state <= 6;
				
			elsif(state = 6) then
				sample_valid_out <= '0';
				temp <= (others=>'0');
				state <= 0;
				
			end if;
end if;		
end process;
end solucion;

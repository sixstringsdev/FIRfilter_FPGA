--This code basiscally allows us to change switches using the clock of the FPGA

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity anti_rebote is
port(clk,entrada: in std_logic;
salida: out std_logic);

end anti_rebote;
architecture solucion of anti_rebote is
type estados is (S0,S1,S2,S3);
signal EA: estados;
signal contador: std_logic_vector(20 downto 0);
signal clk_2: std_logic;
begin

process(clk)
begin
if rising_edge(clk) then
contador <= contador+1;
end if;
end process;
clk_2 <= contador(20);
process(clk_2)
begin
if rising_edge(clk_2) then
case EA is
when S0=> salida <= '0';

if entrada='0' then EA <= S0;
else EA <= S1; end if;

when S1=> salida <= '0';

if entrada='0' then EA <= S0;
else EA <= S2; end if;

when S2=> salida <= '1';

if entrada='0' then EA <= S3;
else EA <= S2; end if;

when S3=> salida <= '1';

if entrada='0' then EA <= S0;
else EA <= S2; end if;

end case;
end if;
end process;
end solucion;

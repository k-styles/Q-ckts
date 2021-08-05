library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use IEEE.NUMERIC_STD.all;

entity complex_mult is
    port (
        I0, I1 : in complex_num;
        O0 : out complex_num);
end entity;

architecture Behavioural of complex_mult is
begin
    process (I0, I1)
    begin
        O0 <= I0 * I1;
    end process;
end Behavioural;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use work.quantum_pkg.all;
use IEEE.NUMERIC_STD.all;

entity grover_tb is
end grover_tb;

architecture testbench of grover_tb is
    signal I1, I0 : qubit;
    signal O : qubit_2;
begin
    -- Insert values for generic parameters !!
    UUT : grover port map (I1 => I1, I0 => I0, O => O);

    tb1 : process
        constant period : Time := 10 ns;
        variable realI1, realI2 : real_matrix(0 to 1 , 0 to 0 , 0 to 1 );
    begin
        realI1 := (
            (0=>(1.0,0.0)),
            (0=>(0.0,0.0))
        );
        I1 <= to_vector(realI1, 2);
        I0 <= to_vector(realI1, 2);
        wait for period;

        wait;
    end process;
end;
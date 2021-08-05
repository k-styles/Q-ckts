library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std .all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use work.quantum_pkg.all;
use std.textio.all;

entity test is
    port (
        zk : in Std_logic; -- AND gate input
        B : out Std_logic -- AND gate output
    );
end test;

architecture andLogic of test is
    signal input_q_real : real_matrix(0 to 255, 0 to 0, 0 to 1);
begin
    process (zk)
        variable fm : matrix(0 to 3 ,0 to  3 );
        variable fm_r: real_matrix(0 to 3 , 0 to 3 , 0 to 1 );
        variable input_qubit : n_qubit(0 to 255);
        variable qft_out : n_qubit(0 to 255);
    begin
        fm := gen_fourier_mat(4);
        fm_r := mat_to_real(fm, (4,4));

        for i in 0 to 255 loop
            input_qubit(i)(0) := to_complex(0.0,0.0);
        end loop;

        for i in 0 to 63 loop
            input_qubit(i*4)(0) := to_complex(1.0/8,0.0);
        end loop;

        qft_out := inv_qft(input_qubit, 8);
        input_q_real <= vec_to_real(qft_out, 256);


        B <= zk;
    end process;
end andLogic;


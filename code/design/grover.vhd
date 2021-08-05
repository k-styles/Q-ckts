library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use work.quantum_pkg.all;
use IEEE.NUMERIC_STD.all;

entity grover is
    port (
        I1, I0 : in qubit_1;
        O : out qubit_2);
end entity;

-- oracle is |11>
architecture Behavioural of grover is
begin
    process (I1, I0)
        variable q1, q0 : qubit_1;
        variable ket_q1q0 : qubit_2;
        variable real_1 : real_matrix(0 to 1, 0 to 0, 0 to 1);
        variable real_2 : real_matrix(0 to 3, 0 to 0, 0 to 1);
        variable pauli_z_2, H_2 : matrix(0 to 3, 0 to 3);
    begin
        -- q1 := I1;0
        q1 := H(I1);
        q0 := H(I0);

        ket_q1q0 := kronecker(q1, q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        ket_q1q0 := apply_gate(c_z_gate, ket_q1q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        -- diffusion
        H_2 := kronecker(H_gate, H_gate, (2, 2), (2, 2));
        ket_q1q0 := apply_gate(H_2, ket_q1q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        pauli_z_2 := kronecker(pauli_z_gate, pauli_z_gate, (2, 2), (2, 2));
        ket_q1q0 := apply_gate(pauli_z_2, ket_q1q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        ket_q1q0 := apply_gate(c_z_gate, ket_q1q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        ket_q1q0 := apply_gate(H_2, ket_q1q0, 2);
        real_2 := vec_to_real(ket_q1q0, 4);

        O <= ket_q1q0;
    end process;
end Behavioural;

-- architecture Behavioural of complex_add is
-- begin
--     process (I)
--     variable q1, q0 : qubit_1;
--     variable ancillary1 : qubit_1;
--     variable ket_q1q0: qubit_2;
--     variable ket_s, bra_s: qubit_2;
--     variable oracle_real: real_matrix(3 downto 0, 3 downto 0, 1 downto 0); 
--     variable oracle: matrix(3 downto 0, 3 downto 0);
--     variable diffuser: matrix(3 downto 0, 3 downto 0);
--     begin
--         input := I;
--         q1 := H(q1);
--         q0 := H(q0);

--         ket_q1q0 := kronecker(q1,q2,(2,1),(2,1));

--         ket_q1q0 := mat_mul(oracle, ket_q1q0, (4,4), (4,1));

--         bra_s := ket_to_bra(ket_s, 2);
--         diffuser := mat_mul(ket_s, bra_s, (4,1), (1,4));
--         diffuser := mat_mul(diffuser, to_complex(2,0), (4,4));
--         diffuser := diffuser - Identity;

--         ket_q1q0 := mat_mul(diffuser, ket_q1q0, (4,4), (4,1));

--         O0 <= ket_q1q0;
--     end process;
-- end Behavioural;
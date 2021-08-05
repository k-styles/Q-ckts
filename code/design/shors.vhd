library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std .all;
use ieee.math_real.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use work.quantum_pkg.all;

entity shors is
    port (
        N : in integer; -- AND gate input
        cp : in integer -- AND gate output
        -- measurement : out integer
    );
end shors;

architecture behav of shors is
    function make_b_qft(N, cp, num_qubits: integer) return n_qubit is
        variable remainder : integer := 1;
        variable temp_remainder: integer;
        variable num_elements : integer := 2**num_qubits;
        variable ket : n_qubit(0 to num_elements-1);
        variable idx : integer;
        variable num_rem_1 : integer := 0;
    begin
        temp_remainder := 1;
        ket(0)(0) := to_complex(1.0,0.0);
        num_rem_1 := num_rem_1 + 1;
        for i in 1 to num_elements-1 loop
            idx := integer(i);
            temp_remainder := cp*temp_remainder mod N;
            if (temp_remainder = remainder) then
                ket(idx)(0) := to_complex(1.0,0.0);
                num_rem_1 := num_rem_1 + 1;
            else 
                ket(idx)(0) := to_complex(0.0,0.0);
            end if;
        end loop;
        -- can use float instead, for synthesizing
        ket := mat_mult(to_complex(1.0/sqrt(real(num_rem_1)), 0.0), ket, num_elements);
        return ket;
    end function make_b_qft;

  --  function write_measure(ket: n_qubit; num_qubits: integer) return integer is
    --    variable success : integer;
      --  variable threshold: real;
    --begin
        -- write all the measurements????
       -- threshold := 1.0 / sqrt(REAL(2**num_qubits));
      --  for i in 0 to 2**num_qubits-1 loop
      --     if (magnitude(ket(i)(0)) > threshold) then
           --     write_ket(i);
        ---   end if;
      --  end loop;
    --    success := 1;
  --      return success;
  --  end function write_measure;

    signal out_ket_s : n_qubit(0 to 2**8 -1);
begin
    process (N)
        variable num_qubits : integer := 8;
        variable before_qft_ket, out_ket : n_qubit(0 to 2**num_qubits - 1);
        variable success : integer;
    begin
        before_qft_ket := make_b_qft(N,cp,num_qubits);
        out_ket := inv_qft(before_qft_ket, num_qubits);

      --  success := write_measure(out_ket, num_qubits);
        out_ket_s <= out_ket;
        -- measurement <= success;
    end process;
end behav;
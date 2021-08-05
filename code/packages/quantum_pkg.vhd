library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use IEEE.NUMERIC_STD.all;

package quantum_pkg is

    subtype n_qubit is vector;

    subtype qubit is vector(0 to 1 );
    subtype qubit_1 is qubit;
    subtype qubit_2 is vector(0 to 3 );
    subtype qubit_3 is vector(0 to 7 );

    subtype gate is matrix;
    subtype gate_1 is matrix(0 to 1 , 0 to 1 );
    subtype gate_2 is matrix(0 to 3 , 0 to 3 );
    subtype gate_3 is matrix(0 to 7 , 0 to 7 );

    subtype bra is matrix(0 to 0 , 0 to 1 );
    subtype bra_2 is matrix(0 to 0 , 0 to 3 );
    subtype bra_3 is matrix(0 to 0 , 0 to 7 );

    function to_qubit(q_ele: real_matrix) return qubit;

    function to_qubit_2(q_ele: real_matrix) return qubit_2;

    function to_qubit_3(q_ele: real_matrix) return qubit_3;

    function ket_to_bra (q:vector; num_qubits: integer) return matrix;
    function in_prod (ql, qr:n_qubit; num_qubits: integer) return complex_num;

    function paulix(q_in : qubit) return qubit;
    function H(q_in : qubit) return qubit;
    -- function cnot(q_in : qubit_2) return qubit_2;

    function apply_gate(gate: matrix; ket_in: n_qubit; num_qubits: integer) return n_qubit;

    function inv_qft(ket_in: n_qubit; num_qubits: integer) return n_qubit;

    constant paulix_real : real_matrix(0 to 1 , 0 to 1 ,0 to 1 ) := (
    ((0.0, 0.0), (1.0, 0.0)), 
    ((1.0, 0.0), (0.0, 0.0))
    );
    constant paulix_gate : gate_1 := to_matrix(paulix_real, (2,2)); 

    constant pauli_z_real : real_matrix(0 to 1 , 0 to 1 , 0 to 1 ) := (
    ((1.0, 0.0), (0.0, 0.0)), 
    ((0.0, 0.0), (-1.0, 0.0))
    );
    constant pauli_z_gate : gate_1 := to_matrix(pauli_z_real, (2,2)); 
 
    constant c_z_real : real_matrix(0 to 3 , 0 to 3 , 0 to 1 ) := (
    ((1.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)),
    ((0.0, 0.0), (1.0, 0.0), (0.0, 0.0), (0.0, 0.0)),
    ((0.0, 0.0), (0.0, 0.0), (1.0, 0.0), (0.0, 0.0)),
    ((0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (-1.0, 0.0))
    );
    constant c_z_gate : gate_2 := to_matrix(c_z_real,(4,4));

    constant h_real : real_matrix(0 to 1 , 0 to 1 , 0 to 1 ):= (
    ((0.7071067, 0.0), (0.7071067, 0.0)), 
    ((0.7071067, 0.0), (-0.7071067, 0.0))
    );
    constant h_gate : gate_1 := to_matrix(h_real, (2,2)); 
    
    constant cnot_real : real_matrix(0 to 3 , 0 to 3 , 0 to 1 ) := (
    ((1.0, 0.0), (0.0, 0.0), (0.0, 0.0), (0.0, 0.0)),
    ((0.0, 0.0), (1.0, 0.0), (0.0, 0.0), (0.0, 0.0)),
    ((0.0, 0.0), (0.0, 0.0), (0.0, 0.0), (1.0, 0.0)),
    ((0.0, 0.0), (0.0, 0.0), (1.0, 0.0), (0.0, 0.0))
    );
    constant cnot_gate : gate_2 := to_matrix(cnot_real,(4,4));

    -- constant nq_f :integer := 5;
    -- constant fourier_matrix : gate(nq_f-1 downto, nq_f-1 downto 0) := gen_fm(nq);

    component grover is port (
        I1, I0 : in qubit_1;
        O : out qubit_2);
    end component;
    
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use work.matrix_pkg.all;
use IEEE.NUMERIC_STD.all;

package body quantum_pkg is

    function to_qubit(q_ele: real_matrix) return qubit is
        variable result: qubit;
    begin
        result := to_vector(q_ele,2);
        return result;
    end function to_qubit;

    function to_qubit_2(q_ele: real_matrix) return qubit_2 is
        variable result: qubit_2;
    begin
        result := to_vector(q_ele,4);
        return result;
    end function to_qubit_2;

    function to_qubit_3(q_ele: real_matrix) return qubit_3 is
        variable result: qubit_3;
    begin
        result := to_vector(q_ele,8);
        return result;
    end function to_qubit_3;
    
    function ket_to_bra (q:n_qubit; num_qubits: integer) return matrix is
        variable result: matrix(0 to 0 , 0 to 2**num_qubits-1 );
        begin
            result:=conjugate_transpose(q,2**num_qubits);
        return result;
    end function ket_to_bra;        


    function bra_to_ket (q:bra; num_qubits: integer) return n_qubit is
        variable result_mat : matrix(0 to 2**num_qubits-1 , 0 to 0);
        variable result: n_qubit(0 to 2**num_qubits-1 );
        begin
            result_mat:=conjugate_transpose(q,(1,2**num_qubits));
            result := mat_to_vec(result_mat, 2**num_qubits);
        return result;
    end function bra_to_ket;        

    
    function in_prod ( ql,qr:n_qubit; num_qubits: integer) return complex_num is
        variable result: complex_num;
        variable result_matrix: matrix(0 to 0, 0 to 0);
        variable qr_mat : matrix(0 to 2**num_qubits-1 , 0 to 0);
        variable bl: bra;
        begin
            bl:= ket_to_bra(ql, num_qubits);
            qr_mat := vec_to_mat(qr, 2**num_qubits);
            result_matrix:=mat_mult(bl,qr_mat,(1,2**num_qubits),(2**num_qubits,1));
            result:=result_matrix(0,0);
        return result;
    end function in_prod;        

    
    function paulix(q_in : qubit) return qubit is
        variable result : qubit;
    begin
        result := mat_mult(paulix_gate, q_in, 2);
        return result;
    end function paulix;

    function H(q_in : qubit) return qubit is 
        variable result : qubit;
    begin
        result := mat_mult(H_gate, q_in, 2);
        return result;
    end function H;


    function apply_gate(gate : matrix; ket_in: n_qubit; num_qubits: integer) return n_qubit is 
        variable dimension : integer := 2**num_qubits;
        variable ket_out : n_qubit( 0 to dimension-1 ); 
    begin
        ket_out := mat_mult(gate, ket_in, dimension);
        return ket_out;
    end function apply_gate;

    function inv_qft(ket_in: n_qubit; num_qubits: integer) return n_qubit is 
        variable ket_out: n_qubit(0 to 2**num_qubits-1);
        variable inv_qft_gate: gate(0 to 2**num_qubits-1,0 to 2**num_qubits-1);
        variable qft_gate: gate(0 to 2**num_qubits-1,0 to 2**num_qubits-1);
    begin
        qft_gate := gen_fourier_mat(2**num_qubits);
        inv_qft_gate := conjugate_transpose(qft_gate, (2**num_qubits,2**num_qubits));
        ket_out := apply_gate(inv_qft_gate, ket_in, num_qubits);
        
        return ket_out;
    end function inv_qft;


end package body quantum_pkg;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;
use work.complex_pkg.all;
--use ieee.math_complex.all;
use ieee.math_real.all;
use IEEE.NUMERIC_STD.ALL;

package matrix_pkg is
    
    type matrix is array(integer range<>, integer range<>) of complex;

    type one_element_arr is array(0 to 0) of complex;
    type vector is array(integer range<>) of one_element_arr;
    -- indexed as v: vector(1 dt 0); v(1)(0);


    type dim is array(0 to 1) of integer;
    type real_matrix is array(integer range<>, integer range<>, integer range<>) of real;
    -- ToDo : change to 2d array of complex_real

    -- dim : (num_row,num_col)

    function mat_mult (l, r : matrix; dim1,dim2:dim) return matrix;
    function mat_mult (l:matrix; r:vector; num_elements: integer) return vector;

    function mat_mult (c: complex; r:matrix; dim1:dim) return matrix;
    function mat_mult (c: complex; r:vector; num_elements: integer) return vector;


    function kronecker(lm, rm : matrix; dim1,dim2:dim) return matrix;  --kronecker
    function kronecker(lv, rv : vector; num_elements:integer) return vector;  --kronecker

    function conjugate_transpose(m: matrix; dim1:dim) return matrix;
    function conjugate_transpose(v: vector; num_elements: integer) return matrix;

    function to_matrix(m_ele: real_matrix ; m_dim: dim) return matrix;
    function to_vector(m_ele: real_matrix ; num_elements: integer) return vector;

    function mat_to_real(m:matrix; dim_m:dim)  return real_matrix;
    function vec_to_real(v:vector; num_elements:integer)  return real_matrix;

    function mat_to_vec(m:matrix; num_elements: integer) return vector;
    function vec_to_mat(v:vector; num_elements: integer) return matrix;

    function gen_fourier_mat(order: integer ) return matrix;
end package;
--    ><, <>, *, @
--|>, <|
--<a|b>
--a><b
--|ab>, |a>|b>

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use IEEE.NUMERIC_STD.ALL;


package body matrix_pkg is 

    function mat_mult (l, r : matrix; dim1,dim2:dim) return matrix is
    -- dim : (num_row,num_col)
    variable l_num_row: integer := dim1(0);
    variable l_num_col: integer := dim1(1);
    variable r_num_row: integer := dim2(0);
    variable r_num_col: integer := dim2(1);
    variable result: matrix(0 to l_num_row-1,0 to r_num_col-1 );
    variable zero: complex := to_complex(0.0,0.0);
	 variable temp : complex;
    begin
            --find result
        for i in 0 to l_num_row-1 loop
            for j in 0 to r_num_col-1 loop
                    result(i,j) := zero;
            end loop;
        end loop;

		  
		  for i in 0 to l_num_row-1 loop
            for j in 0 to r_num_col-1 loop
                for k in 0 to l_num_col-1 loop
                    temp := l(i,k)*r(k,j);
                    result(i,j) := result(i,j)+ temp;
                end loop;
            end loop;
        end loop;

        return result;
    end function mat_mult;

    function mat_mult (l:matrix; r:vector; num_elements: integer) return vector is
        variable r_mat : matrix(0 to num_elements-1 ,0 to 0 );
        variable result_mat: matrix(0 to num_elements-1, 0 to 0);
        variable result_vec : vector(0 to num_elements-1);
        begin
            r_mat := vec_to_mat(r,num_elements);
            result_mat := mat_mult(l, r_mat, (num_elements,num_elements), (num_elements,1));
            result_vec := mat_to_vec(result_mat, num_elements);
            return result_vec;
    end function mat_mult;

    function mat_mult (c: complex; r:matrix; dim1:dim) return matrix is
        variable r_num_row: integer := dim1(0);
        variable r_num_col:  integer := dim1(1);
        variable result: matrix(0 to r_num_row-1 , 0 to r_num_col-1 );
        begin
                --find result
            for i in 0 to r_num_row-1 loop
                for j in 0 to r_num_col-1 loop
                    result(i,j) := c*r(i,j);
                end loop;
            end loop;

        return result;
    end function mat_mult; 

    function mat_mult (c: complex; r:vector; num_elements: integer) return vector is
        variable r_m : matrix(0 to num_elements-1, 0 to 0);
        variable result_m : matrix(0 to num_elements-1, 0 to 0);
        variable result_vec : vector(0 to num_elements-1);
    begin
        r_m := vec_to_mat(r, num_elements);
        result_m := mat_mult(c, r_m, (num_elements, 1));
        result_vec := mat_to_vec(result_m, num_elements);
        
        return result_vec;
    end function mat_mult;

    function kronecker(lm, rm : matrix; dim1,dim2:dim) return matrix is
        -- dim : (num_row,num_col)
        variable l_num_row: integer := dim1(0);
        variable l_num_col: integer := dim1(1);
        variable r_num_row: integer := dim2(0);
        variable r_num_col: integer := dim2(1);
        variable result: matrix( 0 to (l_num_row*r_num_row)-1 , 0 to (l_num_col*r_num_col)-1 );
        begin
            --find result
            for i in 0 to l_num_row-1 loop
                for j in 0 to l_num_col-1 loop
                    for k in 0 to r_num_row-1 loop
                        for l in 0 to r_num_col-1 loop
                            result((i*r_num_row)+k,(j*r_num_col)+l) := lm(i,j)*rm(k,l);
                        end loop;
                    end loop;
                end loop;
            end loop;

            return result;
    end function kronecker;

    function kronecker(lv, rv : vector; num_elements:integer) return vector is  --kronecker
        variable lm: matrix( 0 to num_elements-1 , 0 to 0 );
        variable rm: matrix( 0 to num_elements-1 , 0 to 0 );
        variable result_mat: matrix( 0 to 2*num_elements-1 , 0 to 0 ); 
        variable result_vec: vector( 0 to 2*num_elements-1 );
        begin
            lm := vec_to_mat(lv, num_elements);
            rm := vec_to_mat(rv, num_elements);
            result_mat := kronecker(lm,rm, (num_elements,1), (num_elements,1));
            result_vec := mat_to_vec(result_mat, 2*num_elements);

            return result_vec;
    end function kronecker;


    function conjugate_transpose(m: matrix; dim1:dim) return matrix is 
        variable m_num_row:  integer := dim1(0);
        variable m_num_col:  integer := dim1(1);
        
        variable result: matrix(0 to m_num_col-1 , 0 to m_num_row-1 );
        begin
                --find result
            for i in 0 to m_num_row-1 loop
                for j in 0 to m_num_col-1 loop
                    result(j,i) := conjugate(m(i,j));
                end loop;
            end loop;

            return result;
    end function conjugate_transpose;

    function conjugate_transpose(v: vector; num_elements: integer) return matrix is
        variable m: matrix(0 to num_elements-1 , 0 to 0 );
        variable result: matrix(0 to 0 , 0 to num_elements-1 );
        
        begin
            m := vec_to_mat(v, num_elements);
            result := conjugate_transpose(m, (num_elements,1));
            
            return result;
    end function conjugate_transpose; 

    function to_matrix(m_ele: real_matrix; m_dim: dim) return matrix is
        variable m_num_row:  integer := m_dim(0);
        variable m_num_col:  integer := m_dim(1);
        variable m_ele_re,m_ele_im:real;

        variable result: matrix(0 to m_num_row-1 , 0 to m_num_col-1 );

        begin

            for r in 0 to m_num_row-1 loop
                for c in 0 to m_num_col-1 loop
                    m_ele_re:=m_ele(r,c,1);
                    m_ele_im:=m_ele(r,c,0);
                    result(r,c):=to_complex(m_ele_re,m_ele_im);
                end loop;
            end loop;

            return result;
    end function to_matrix;             

    function to_vector(m_ele: real_matrix ; num_elements: integer) return vector is 
        variable ret_mat: matrix(0 to num_elements-1 , 0 to 0);
        variable ret_vec: vector(0 to num_elements-1 );
        begin
            ret_mat := to_matrix(m_ele, (num_elements,1));
            ret_vec := mat_to_vec(ret_mat, num_elements);
            return ret_vec;
    end function to_vector;

    function mat_to_real(m:matrix; dim_m:dim)  return real_matrix is 
        variable m_num_row:  integer := dim_m(0);
        variable m_num_col:  integer := dim_m(1);
        variable result : real_matrix(0 to m_num_row-1 , 0 to m_num_col-1 , 0 to 1 );
        variable c_m: complex_real;
        begin
            for r in 0 to m_num_row-1 loop
                for c in 0 to m_num_col-1 loop
                    c_m:=complex_to_real(m(r,c));
                    result(r,c,0) := c_m(0);
                    result(r,c,1) := c_m(1);
                end loop;
            end loop;
        return result;
    end function mat_to_real;

    function vec_to_real(v:vector; num_elements:integer)  return real_matrix is 
        variable m : matrix(0 to num_elements-1 , 0 to 0 );
        variable result : real_matrix(0 to num_elements-1 , 0 to 0 , 0 to 1 );
        begin 
            m := vec_to_mat(v, num_elements);
            result := mat_to_real(m,(num_elements,1));
            
            return result;
    end function vec_to_real;

    function mat_to_vec(m:matrix; num_elements: integer) return vector is 
        variable result_vec : vector(0 to num_elements-1 );
        begin
            for idx in 0 to num_elements-1 loop
                result_vec(idx)(0) := m(idx,0);
            end loop;
            return result_vec;
    end function mat_to_vec;

    function vec_to_mat(v:vector; num_elements: integer) return matrix is 
        variable result_mat : matrix(0 to num_elements-1, 0 to 0 );
        begin
            for idx in 0 to num_elements-1 loop
                result_mat(idx,0) := v(idx)(0);
            end loop;
            return result_mat;
    end function vec_to_mat;


    function gen_fourier_mat(order: integer ) return matrix is
        variable N : integer := order;
        variable fourier_mat : matrix(0 to N-1 , 0 to N-1 );
        variable pi2_over_N : real := (2.0*MATH_PI)/real(N);
     
    begin 
        for i in 0 to N-1 loop
            for j in 0 to N-1 loop
                fourier_mat(i,j) := to_complex(
                    cos(real(i*j)*pi2_over_N)/sqrt(real(N)),
                    sin(real(i*j)*pi2_over_N)/sqrt(real(N))); 
            end loop;
        end loop;
        return fourier_mat;
    end function gen_fourier_mat;

end package body matrix_pkg;

    



--   mat_mul(a,b,r,c)
--   a*b;  matmul(a,b,ra,ca,rb,cb)


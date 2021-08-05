library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use IEEE.NUMERIC_STD.all;

package complex_pkg is
    constant num_bits : Integer := 16;

    type complex_num is record
        re, im : sfixed(1 downto 0 - num_bits);
    end record;

    type complex_real is array (0 to 1) of real;

    subtype c_num is complex_num;
    subtype complex is complex_num;

    function "+" (z1, z2 : complex_num) return complex_num;
    function "-" (z1, z2 : complex_num) return complex_num;
    function "*" (z1, z2 : complex_num) return complex_num;
    function conjugate (z1 : complex_num) return complex_num;
    function to_complex (re, im : real) return complex_num;
    function complex_to_real (z: complex_num) return complex_real;

    component complex_add is
        port (
            I0, I1 : in complex_num;
            O0 : out complex_num);
    end component;

    component complex_mult is
        port (
            I0, I1 : in complex_num;
            O0 : out complex_num);
    end component;

end package complex_pkg;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use IEEE.NUMERIC_STD.all;

package body complex_pkg is

    function "+" (z1, z2 : complex_num) return complex_num is
        variable r1, i1, r2, i2, res_r, res_i : sfixed(1 downto 0 - num_bits);
        --    variable t1,t2,t3,t4 : sfixed(1 downto 0-num_bits);
        variable result : complex_num;
    begin
        r1 := z1.re;
        i1 := z1.im;
        r2 := z2.re;
        i2 := z2.im;

        res_r := resize((r1 + r2), res_r);
        res_i := resize((i1 + i2), res_i);

        result.re := res_r;
        result.im := res_i;

        return result;
    end function "+";

    function "-" (z1, z2 : complex_num) return complex_num is
        variable result : complex_num;
        variable r1, i1, r2, i2, res_r, res_i : sfixed(1 downto 0 - num_bits);
    begin
        r1 := z1.re;
        i1 := z1.im;
        r2 := z2.re;
        i2 := z2.im;

        res_r := resize((r1 - r2), res_r);
        res_i := resize((i1 - i2), res_i);

        result.re := res_r;
        result.im := res_i;

        return result;
        return result;
    end function "-";

    function "*" (z1, z2 : complex_num) return complex_num is
        variable result : complex_num;
        variable r1, i1, r2, i2, res_r, res_i : sfixed(1 downto 0 - num_bits);
    begin
        r1 := z1.re;
        i1 := z1.im;
        r2 := z2.re;
        i2 := z2.im;

        res_r := resize(((r1 * r2) - (i1 * i2)), res_r);
        res_i := resize(((r1 * i2) + (r2 * i1)), res_i);

        result.re := res_r;
        result.im := res_i;

        return result;
    end function "*";

    function conjugate (z1 : complex_num) return complex_num is
        variable result : complex_num;
    begin
        result.re := z1.re;
        result.im := resize(-1 * z1.im, result.im);
        return result;
    end function conjugate;

    function to_complex (re, im : real) return complex_num is
        variable result : complex_num;
    begin
        result := (to_sfixed(re, result.re), to_sfixed(im, result.im));
        return result;
    end function to_complex;

    function complex_to_real (z: complex_num) return complex_real is 
        variable result : complex_real;
    begin
        result := (to_real(z.re),to_real(z.im));
        return result;
    end function complex_to_real;

end package body complex_pkg;

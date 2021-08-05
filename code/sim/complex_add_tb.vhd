library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fixed_pkg.all;
use work.complex_pkg.all;
use IEEE.NUMERIC_STD.all;
entity complex_add_tb is
end complex_add_tb;

architecture testbench of complex_add_tb is
    signal z1, z2 : c_num;
    signal z_out : c_num;
begin
    UUT : complex_add port map(I0 => z1, I1 => z2, O0 => z_out);

    tb1 : process
        constant period : Time := 10 ns;
        variable bool1, bool2 : Boolean;
        variable err, err1, err2, t1, t2, t3, t4 : sfixed(1 downto 0 - num_bits);
        variable err_vec : Std_logic_vector(num_bits + 1 downto 0);
    begin
        err_vec := (others => '0');
        err_vec(1) := '1';
        err_vec(0) := '1';
        err := to_sfixed(err_vec, 1, 0 - num_bits);
        z1 <= (to_sfixed(0.15, z1.re), to_sfixed(0.31, z1.re));
        z2 <= (to_sfixed(0.23, z1.re), to_sfixed(-0.21, z1.re));
        wait for period;
        t1 := resize(z_out.re - 0.38, t1);
        t2 := resize(z_out.re - to_sfixed(0.38, t1), t1);
        err1 := resize(abs(z_out.re - 0.38), err1);
        err2 := resize(abs(z_out.im - 0.1), err1);
        bool1 := (abs(z_out.re - 0.38) <= err);
        bool2 := (abs(z_out.im - 0.1) <= err);
        assert(bool1 and bool2)
        report "test failed for (0.15,0.31)+(0.23,-0.21)" severity error;

        z1 <= (to_sfixed(0.2, z1.re), to_sfixed(0.3, z1.re));
        z2 <= (to_sfixed(0.6, z1.re), to_sfixed(0.1, z1.re));
        wait for period;
        bool1 := (abs(z_out.re - to_sfixed(0.8, z1.re)) <= err);
        bool2 := (abs(z_out.im - to_sfixed(0.4, z1.re)) <= err);
        assert(bool1 and bool2)
        report "test failed for (0.2,0.3)+(0.6,0.1)" severity error;

        z1 <= (to_sfixed(0.015, z1.re), to_sfixed(0.9, z1.re));
        z2 <= (to_sfixed(-0.3, z1.re), to_sfixed(-0.89, z1.re));
        wait for period;
        bool1 := (abs(z_out.re - to_sfixed(-0.285, z1.re)) <= err);
        bool2 := (abs(z_out.im - to_sfixed(0.01, z1.re)) <= err);
        assert(bool1 and bool2)
        report "test failed for (0.015,0.9)+(-0.3,-0.89)" severity error;
        wait;
    end process;

end testbench;
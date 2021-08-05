from math import gcd
from fractions import Fraction
import random


def read_ket():
    with open("ket.txt", "r") as ftr:
        line = ftr.readline()
        ket = list(map(int, line.split(',')))
    print("ket: ", ket)
    return ket

def find_period(qft_out, n):
    frac = Fraction(qft_out/2**8).limit_denominator(n)
    print("frac: ", frac)
    return frac.denominator

def shors(n, coprime):
    ket = read_ket()
    qft_out = random.choice(ket)
    print("qft_out: ", qft_out)

    period = find_period(qft_out, n)
    print("period: ", period)
    success = 0
    factors = [0,0]
    if period % 2 == 0:
        factor = gcd((coprime)**(period//2)-1, n)
        if (n % factor == 0):
            factors = [factor, n//factor]
            success = 1

    return (success, factors)


def main():
    # n = int(input("Enter value to find factorial for"))
    n = 15

    coprime = 7
    success, factors = shors(n, coprime)

    num_iterations = 1
    while(not success):
        if (num_iterations == 5):
            print("not working, use different coprime or increase num_iterations")
            break
        num_iterations += 1
        success, factors = shors(n, coprime)

    print("factors: ", factors)
    
    # for i in range(1, n):
    #     if gcd(i, n) == 1:
    #         coprime = i
    #         success, factors = shors(n, coprime)
    #         if not success:
    #             continue
    #         return factors

main()
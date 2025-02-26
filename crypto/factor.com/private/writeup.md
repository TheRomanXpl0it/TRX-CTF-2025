# factor.com - Writeup  

This challenge is similar to standard RSA, except that the modulus $N$ is a product of multiple primes, some of which can be **very small**.  

### Exploiting the Structure  

Instead of waiting for all primes to be small (which could take an impractical amount of time), we can **extract small pieces of information at a time** by factoring parts of $N$.  

If we manage to extract even **one small prime factor** $q$ of $N$, we can immediately start recovering the flag:  

### Breaking It Down  

We are given the standard RSA equation:  

$$
\text{flag}^e \mod N = c
$$

If we find a small prime **$q$** that divides $N$, we can reduce the equation modulo $q$:  

$$
c \mod q = (\text{flag}^e \mod N) \mod q = \text{flag}^e \mod q
$$

Since $e$ is known, we can compute the **$e$-th root modulo $q$** to recover:  

$$
\text{flag} \mod q
$$

### Reconstructing the Full Flag  

By repeating this process for multiple small prime factors, we collect a system of modular equations:  

$$
\text{flag} \mod q_1, \quad \text{flag} \mod q_2, \quad \dots, \quad \text{flag} \mod q_n
$$

Finally, using the **Chinese Remainder Theorem (CRT)**, we reconstruct the original flag.  

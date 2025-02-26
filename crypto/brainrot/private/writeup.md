# Brainrot - Writeup

We're given three equations and need to recover a flag, which we can split into five parts:  

$$
f_0, f_1, f_2, f_3, f_4
$$

These equations represent **the evaluation of a polynomial** at specific points. The unknowns (the flag parts) are the **coefficients** of this polynomial. The given values are just different points where the polynomial has been evaluated:

$$
P(x) = \sum_{i=0}^{4} \mathrm{rot}_{8000}(f_i) \cdot x^i
$$

We also have two modulus values that play a role in how the results are structured:

$$
m_1 = \text{b2l}(b'\text{cant\_give\_you\_everything}')
$$

$$
m_2 = \text{b2l}(b'\text{only\_half!!!}')
$$

## The Given Equations

The challenge gives us three polynomial evaluations, but with a **double modulo operation** applied. First, the result is reduced modulo $m_1$, and then **that result** is further reduced modulo $m_2$:

$$
\begin{aligned}
    P(0x\text{deadbeef}) \mod m_1 \mod m_2 &= r_1 \\
    P(13371337) \mod m_1 \mod m_2 &= r_2 \\
    P(0x\text{cafebabe}) \mod m_1 \mod m_2 &= r_3
\end{aligned}
$$


## $\mathrm{rot}_{8000}$

The function $\mathrm{rot}_{8000}$ applies a specific transformation that encodes each flag part using UTF-16. It can be expressed as:

$$
\mathrm{rot}_{8000}(\text{'FLAG'}).encode('utf-16') =
0xfffe0000000000000000 +
\sum_{i=0}^{3} ((0x40 + \text{FLAG}[i]) \times 256 + 0x1f) \times 256^{2(3-i)}
$$

(This can be recovered just by playing with this function a bit)

## Working Around the Moduli

To simplify things, we introduce two helper variables $k_1$ and $k_2$:

$$
\text{eq} - k_1 \cdot m_1 - k_2 \cdot m_2 = \text{res}
$$

Since $k_2$ is roughly $m_1 / m_2$, we end up with a system of three equations where the solutions are small and bounded.


## Solving with LLL

At this point, solving the equations comes down to **finding small solutions to a linear system**. This is exactly what LLL is good for.

A **great explanation** of how to use LLL for problems like this can be found here:  
https://magicfrank00.github.io/writeups/posts/lll-to-solve-linear-equations/

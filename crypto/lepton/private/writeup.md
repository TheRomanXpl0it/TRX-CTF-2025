# lepton - Writeup

This challenge is inspired by Seashells from N1CTF 2024.

To solve this we exploit the fact that sagemath gives an error when calling .xy() on the 0 point, so we can use this as an oracle to recover the privkey one bit at a time.

The writeup is basically the same as https://magicfrank00.github.io/writeups/writeups/n1ctf2024/seashells/
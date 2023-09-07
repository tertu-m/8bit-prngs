# oldschool-prngs
Optimized pseudorandom number generator implementations for various "old"/8-bit processor architectures in ASM.

Currently I only plan to implement generators where there are not already implementations available for a particular platform. I also generally don't plan to implement generators where C compilers for the platform seem to do an acceptable job.

Note that in some cases I have not actually tried to assemble the resulting source code. I will indicate when that is the case and try not to do it in the future.

## sfc8
Chaotic random number generator with better statistical qualities and performance than a high-quality 32-bit LCG on an 8-bit CPU.<br>
Class: Chaotic<br>
Period: Variable. Seeds are on multiple cycles, the largest of which is about 2^31.5 and the smallest of which is 2^9. Notably, the seed 0 is on the largest cycle.<br>
State size: 32 bits<br>
Seed size: 24 bits<br>
Output size: 8 bits

## sfc16
Chaotic random number generator. Not as fast as sfc8 on 8-bit CPUs but with 16-bit output and higher statistical quality.<br>
Class: Chaotic<br>
Period: Variable. Expected to be about 2^62, guaranteed to be at least 2^16.<br>
State size: 64 bits<br>
Seed size: 48 bits<br>
Output size: 16 bits

## sfc32
Chaotic random number generator. Generally a good choice for 32-bit CPUs.<br>
Class: Chaotic<br>
Period: Variable. Expected to be about 2^126, guaranteed to be at least 2^32.<br>
State size: 128 bits<br>
Seed size: 96 bits<br>
Output size: 32 bits
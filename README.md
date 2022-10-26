Algorithm for division without restoration, positive numbers:

-reset P (n+1 bits)
-load the dividend in A (n bits)
-load the divisor in B (n bits)
-repeat n times
  -if P it is negative (MSB = 1) then
    -move one position to the left P (LSB P = MSB A)
    -P <= P+B
  -else
    -move one position to the left P (LSB P = MSB A)
    -P <= P+(-B)
  -move one position to the left A (LSB P = MSB A)
-if P it is negative (MSB = 1) then
  -P <= P+B
-P contain remainder
-A contain quotient

How to use this files:
1. Downlaod the files;
2. Put them in a directory;
3. Open Modelsim;
4. Change directory to the directory who contain the files;
5. Create a project and add the files;
6. Compile the files and start stimulate.

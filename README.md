# Non-Restoring Division Algorithm, Positive Numbers:

![Non-Restoring Division Algorithm, Positive Numbers Diagram](https://github.com/ElTheScreeps/Algorithm_for_division_without_restoration_positive_numbers/assets/115155585/e501a9e7-83e3-4ae5-834d-afaf2892a4ea)

- reset P (n+1 bits)
- load the dividend in A (n bits)
- load the divisor in B (n bits)
- repeat n times
  - if P is negative (MSB = 1) then
    - shift P left by one position (LSB P = MSB A)
    - P <= P+B
  - else
    - shift P left by one position (LSB P = MSB A)
    - P <= P+(-B)
  - shift A left by one position (LSB A = not MSB P)
- if P is negative (MSB = 1) then
  - P <= P+B
- P contains the remainder

- A contains the quotient

Divison and steps:

![image](https://user-images.githubusercontent.com/115155585/197961471-b052bc27-19cc-4384-bdef-46cd3b335cd2.png)


How to use this files:
1. Download the files;
2. Put them in a directory;
3. Open Modelsim;
4. Change directory to the directory who contain the files;
5. Create a project and add the files;
6. Compile the files and start stimulate.

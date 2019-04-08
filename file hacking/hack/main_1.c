#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>

const int FILE_SIZE = 522;

long int f_size (FILE *file);
int file_check (FILE *file);
int file_fixing (FILE *file);

int main ()
{
    FILE *file_in = fopen ("C:/Users/fox/CLionProjects/password/vzlom1.com", "r+b");

    if (file_in == NULL)
    {
        printf ("Opening file failure\n");

        return 0;
    }

    int check = file_check (file_in);

    if (check != -1)    file_fixing (file_in);

    fclose(file_in);

    return 0;
}

int file_check (FILE * file)
{
    assert (file);

    if (f_size (file) == FILE_SIZE)

        return 1;

    return -1;
}

long int f_size (FILE *file)
{
    assert (file);

    fseek (file, 0, SEEK_END);

    long int symbCount = 0;

    symbCount = ftell (file);

    fseek (file, 0, SEEK_SET);

    return symbCount;
}

int file_fixing (FILE *file)
{
    assert (file);

    fseek (file, 153, SEEK_SET);

    char JNE = getc(file);

    if (JNE == 116) // 't' je
    {
        printf ("the file has already been hacked\n");

        return 0;
    }

    else
    {
        fseek (file, 153, SEEK_SET);

        printf ("%c\n", JNE);
        putc(116, file);

        printf ("YES, we've done it\n");

    }

    return 0;

}

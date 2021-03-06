#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>

const int FILE_SIZE = 522;

long int f_size (FILE *file);
int file_check (FILE *file);
int file_fixing (FILE *file, FILE *n_file);

int main ()
{
    FILE *file_in = fopen ("C:/Users/fox/CLionProjects/password/vzlom.com", "rb");

    FILE *file_out = fopen ("C:/Users/fox/CLionProjects/password/vzlom2.com", "wb");

    if (file_in == NULL || file_out == NULL)
    {
        printf ("Opening file failure\n");

        return 0;
    }

    int check = file_check (file_in);

    if (check != -1)    file_fixing (file_in, file_out);

    fclose(file_in);
    fclose(file_out);

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

int file_fixing (FILE *file, FILE *n_file)
{
    assert (file);

    char *buff = (char *) calloc (FILE_SIZE, sizeof(char));

    fread (buff, FILE_SIZE, sizeof(*buff), file);

    if (buff[153] == 116)
    {
        printf ("the file has already been hacked\n");

        return 0;
    }

    else
    {
        buff[153] = 116;

        printf ("YES, we've done it\n");

    }

    fwrite (buff, sizeof(char), FILE_SIZE, n_file);

    free (buff);

    return 0;

}
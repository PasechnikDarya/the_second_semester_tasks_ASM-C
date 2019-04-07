#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <ctype.h>

const int FILE_SIZE = 1000;

long int f_size (FILE *file);
int file_check (FILE *file);
int file_fixing (FILE *file);

int main ()
{
    FILE *file = fopen ("vzlom.com", "w");

    if (file == NULL)
    {
        printf ("Opening file failure\n");

        return 0;
    }

    int check = file_check (file);

    if (check != 0)    file_fixing (file);

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

    long int symbCount = ftell (file);

    fseek (file, 0, SEEK_SET);

    return symbCount;
}

int file_fixing (FILE *file)
{
    assert (file);

    char *buff = (char *) calloc (FILE_SIZE, sizeof(char));

    fread (buff, FILE_SIZE, sizeof(*buff), file);

    if (buff[199] == 74)
    {
        printf ("the file has already been hacked\n");

        return 0;
    }

    else        buff[199] = 74;

    fprintf(file, "%s", buff);

    return 0;

}
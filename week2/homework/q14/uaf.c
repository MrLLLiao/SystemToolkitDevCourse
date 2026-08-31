#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main() {
    char *greeting = malloc(32);
    strcpy(greeting, "Hello, world!");
    printf("%s\n", greeting);

    free(greeting);

    greeting[0] = 'J';       /* BUG: free 之后仍读写该内存 -> use-after-free */
    printf("%s\n", greeting);

    return 0;
}

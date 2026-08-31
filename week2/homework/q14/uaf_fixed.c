#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int main() {
    char *greeting = malloc(32);
    strcpy(greeting, "Hello, world!");
    printf("%s\n", greeting);

    greeting[0] = 'J';       /* 修复: 对内存的读写放在 free 之前 */
    printf("%s\n", greeting);

    free(greeting);          /* 之后才释放, 不再有 use-after-free */
    return 0;
}

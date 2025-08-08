#include <stdio.h>
#include <unistd.h>

#define TRY_NUM 500
#define SLEEP_SEC 3

int main()
{
    int try = 0;

    for(try = 0; try < TRY_NUM; try++)
    {
        printf("tracing me !!\n");
        sleep(SLEEP_SEC);
    }
    return 0;
}

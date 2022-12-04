#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

int
main (void)
{
    unsigned int i = 0, percent;
    char bar[101];
    const char indicators[] = { '|', '/', '-', '\\', '|', '/', '-', '\\' };
    const struct timespec ts = { 0, 250000000L };

    memset (&bar, '\0', sizeof (bar));

    for (percent = 1; percent <= 100; percent++)
      {
        int printed;
        bar[percent - 1] = '=';
        if (percent < 100)
          printed = printf ("%3d%% %c [%s>", percent, indicators[i], bar);
        else
          printed = printf ("%3d%% [==%s]", percent, bar);
        if (printed <= 0)
          exit (EXIT_FAILURE);
        fflush (stdout);
        if (nanosleep (&ts, NULL) < 0)
          {
            perror ("nanosleep");
            exit (EXIT_FAILURE);
          }
        if (percent < 100)
          {
            int clear = printed;
            while (clear--)
              printf ("\b");
            if ((i + 1) > (sizeof (indicators) - 1))
              i = 0;
            else
              i++;
          }
        else
          puts (" completed.");
        fflush (stdout);
      }

    exit (EXIT_SUCCESS);
}

/* Link with -lncurses */

#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAUSE_MS 200

static void draw_matrix (int, int);
static void alter_mode_pos (char *, int *, int);

static struct {
    char first;
    char second;
} mode;

static struct {
    int x, y;
} pos;

int
main (void)
{
    int x, y;

    initscr ();
    curs_set (0);
    noecho ();
    getmaxyx (stdscr, x, y);
    draw_matrix (x, y);
    endwin ();

    exit (EXIT_SUCCESS);
}

static void
draw_matrix (int x, int y)
{
    int xiter, yiter;
    char matrix[x][y];

    for (xiter = 0; xiter < x; xiter++)
      memset (&matrix[xiter], 0, y);

    pos.x = (x / 2) - 1;
    memset (&matrix[pos.x], 0, y);

    pos.y = (y / 2) - 1;
    for (xiter = 0; xiter < x; xiter++)
      matrix[xiter][pos.y] = '|';

    matrix[pos.x][pos.y] = '+';

    mode.first = mode.second = '+';

    while (1)
      {
        int pos_y;

        clear ();

        for (xiter = 0; xiter < x; xiter++)
          for (yiter = 0; yiter < y; yiter++)
            if (matrix[xiter][yiter] != 0)
              {
                move (xiter, yiter);
                addch (matrix[xiter][yiter]);
              }

        memset (&matrix[pos.x], 0, y);

        alter_mode_pos (&mode.first, &pos.x, x);

        memset (&matrix[pos.x], '-', y);

        for (xiter = 0; xiter < x; xiter++)
          matrix[xiter][pos.y] = 0;

        alter_mode_pos (&mode.second, &pos.y, y);

        for (xiter = 0; xiter < x; xiter++)
          matrix[xiter][pos.y] = '|';

        switch (mode.second)
          {
            case '+':
              pos_y = pos.y + 1;
              break;
            case '-':
              pos_y = pos.y - 1;
              break;
            default:
              abort ();
          }
        matrix[pos.x][pos.y] = '+';
        matrix[pos.x][pos_y] = '-';

        napms (PAUSE_MS);
        refresh ();
    }
}

static void
alter_mode_pos (char *mode, int *pos, int max)
{
    switch (*mode)
      {
        case '+':
          if (*pos != 0)
            (*pos)--;
          else
            {
              (*pos)++;
              *mode = '-';
            }
          break;
        case '-':
          if (*pos + 1 != max)
            (*pos)++;
          else
            {
              (*pos)--;
              *mode = '+';
            }
          break;
        default:
          abort ();
      }
}

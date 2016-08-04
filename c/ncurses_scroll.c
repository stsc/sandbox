/* Link with -lncurses */

#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void draw_matrix (int, int);

struct {
    char first;
    char second;
} mode;

struct {
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

void
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

    mode.first  = '+';
    mode.second = '+';

    while (1)
      {
        clear ();

        for (xiter = 0; xiter < x; xiter++)
          for (yiter = 0; yiter < y; yiter++)
            if (matrix[xiter][yiter] != 0)
              {
                move (xiter, yiter);
                addch (matrix[xiter][yiter]);
              }

        memset (&matrix[pos.x], 0, y);

        switch (mode.first)
          {
            case '+':
              if (pos.x != 0)
                pos.x--;
              else
                {
                  pos.x++;
                  mode.first = '-';
                }
              break;
            case '-':
              if (pos.x + 1 != x)
                pos.x++;
              else
                {
                  pos.x--;
                  mode.first = '+';
                }
              break;
            default:
              abort ();
        }

        memset (&matrix[pos.x], '-', y);

        for (xiter = 0; xiter < x; xiter++)
          matrix[xiter][pos.y] = 0;

        switch (mode.second)
          {
            case '+':
              if (pos.y != 0)
                pos.y--;
              else
                {
                  pos.y++;
                  mode.second = '-';
                }
              break;
            case '-':
              if (pos.y + 1 != y)
                pos.y++;
              else
                {
                  pos.y--;
                  mode.second = '+';
                }
              break;
            default:
              abort ();
          }

        for (xiter = 0; xiter < x; xiter++)
          matrix[xiter][pos.y] = '|';

        switch (mode.second)
          {
            case '+':
              matrix[pos.x][pos.y]     = '+';
              matrix[pos.x][pos.y + 1] = '-';
              break;
            case '-':
              matrix[pos.x][pos.y]     = '+';
              matrix[pos.x][pos.y - 1] = '-';
              break;
            default:
              abort ();
          }

        napms (200);
        refresh ();
    }
}


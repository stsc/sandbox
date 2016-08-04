/* Link with -lncurses */

#include <ctype.h>
#include <ncurses.h>
#include <stdlib.h>

#define PAUSE_MS 1500

struct message {
    const char *text;
    int napms;
};
static const struct message messages[] = {
    { "Wake up, Neo...",           200 },
    { "The Matrix has you...",     500 },
    { "Follow the white rabbit.",   80 },
    {  NULL,                      1500 },
};

int
main (void)
{
    const struct message *msg = messages;
    initscr ();
    cbreak ();
    curs_set (0);
    start_color ();
    init_pair (1, COLOR_GREEN, COLOR_BLACK);
    attron (A_BOLD);
    attron (COLOR_PAIR (1));
    while (1)
      {
         const char *p;
         for (p = msg->text; *p != '\0'; p++)
           {
             addch (*p);
             refresh ();
             napms (!isspace (*p) && p[1] != '\0' ? msg->napms : 0);
           }
         napms (PAUSE_MS);
         clear ();
         refresh ();
         msg++;
         if (msg->text == NULL)
           {
             napms (msg->napms);
             msg = messages;
           }
      }
    attroff (A_BOLD);
    attroff (COLOR_PAIR (1));
    endwin ();
    exit (EXIT_SUCCESS);
}

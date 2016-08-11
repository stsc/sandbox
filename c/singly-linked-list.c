#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct list {
    char *str;
    struct list *next;
};

int
main (void)
{
    unsigned int i;
    struct list *start = NULL, *current, *tmp;

    for (i = 0; i < 10; i++)
      {
        struct list *entry = malloc (sizeof (struct list));

        entry->str =  malloc (strlen ("entry-N") + 1);
        snprintf (entry->str, strlen ("entry-N") + 1, "entry-%u", i);

        if (start == NULL)
          start = current = entry;
        else
          {
            current->next = entry;
            current = current->next;
          }
      }

    current->next = NULL;

    for (current = start; current != NULL; current = current->next)
      puts (current->str);

    for (current = start; current != NULL; current = tmp)
      {
        free (current->str);
        tmp = current->next;
        free (current);
      }

    start = NULL;

    exit (EXIT_SUCCESS);
}

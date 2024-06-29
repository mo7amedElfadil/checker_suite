# 0x12. C - Singly linked lists



Resources

Read or watch:

- [Linked Lists](/rltoken/joxg32-tt4lUh8Afgst8tA)



- [Google](/rltoken/USaZbNdfcuIFII-K2YPsKQ)



- [Youtube](/rltoken/epKUCIcoA6XaN1T3Vtr_9w)



Learning Objectives

At the end of this project, you are expected to be able to explain to anyone, without the help of Google:

General

Copyright - Plagiarism

Requirements

General

- ```vi```



- ```vim```



- ```emacs```



- ```gcc```



- ```-Wall -Werror -Wextra -pedantic -std=gnu89```



- ```README.md```



- ```Betty```



- [betty-style.pl](https://github.com/alx-tools/Betty/blob/master/betty-style.pl)



- [betty-doc.pl](https://github.com/alx-tools/Betty/blob/master/betty-doc.pl)



- ```malloc```



- ```free```



- ```exit```



- ```printf```



- ```puts```



- ```calloc```



- ```realloc```



- [_putchar](https://github.com/alx-tools/_putchar.c/blob/master/_putchar.c)



- ```_putchar.c```



- ```main.c```



- ```main.c```



- ```main.c```



- ```_putchar```



- ```lists.h```



More Info

Please use this data structure for this project:

```
/**
 * struct list_s - singly linked list
 * @str: string - (malloc'ed string)
 * @len: length of the string
 * @next: points to the next node
 *
 * Description: singly linked list node structure
 */
typedef struct list_s
{
    char *str;
    unsigned int len;
    struct list_s *next;
} list_t;
```


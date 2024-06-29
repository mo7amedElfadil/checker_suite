# 0x17. C - Doubly linked lists

Resources

Read or watch:

- [What is a Doubly Linked List](/rltoken/C5_IRM981SVn8oA8RP3gag)



Learning Objectives

At the end of this project, you are expected to be able to explain to anyone, without the help of Google:

General

Copyright - Plagiarism

Requirements

General

- ```vi```



- ```vim```



- ```emacs```



- ```README.md```



- ```Betty```



- [betty-style.pl](https://github.com/alx-tools/Betty/blob/master/betty-style.pl)



- [betty-doc.pl](https://github.com/alx-tools/Betty/blob/master/betty-doc.pl)



- ```malloc```



- ```free```



- ```printf```



- ```exit```



- ```main.c```



- ```main.c```



- ```main.c```



- ```lists.h```



More Info

Please use this data structure for this project:

```
/**
 * struct dlistint_s - doubly linked list
 * @n: integer
 * @prev: points to the previous node
 * @next: points to the next node
 *
 * Description: doubly linked list node structure
 * 
 */
typedef struct dlistint_s
{
    int n;
    struct dlistint_s *prev;
    struct dlistint_s *next;
} dlistint_t;
```


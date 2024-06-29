# 0x00. C - Hello, World



Resources

Read or watch:

[Everything you need to know to start with C.pdf](/rltoken/P01aLj9BDfDUOv-y9x82Yw)

*You do not have to learn everything in there yet, but make sure you read it entirely first*

[Dennis Ritchie](/rltoken/YWFrRob_-Yo-_NQikMLI-g)

[“C” Programming Language: Brian Kernighan](/rltoken/W4oygfMgAp5Hyc7o6QuSYQ)

[Why C Programming Is Awesome](/rltoken/WYdE1novaWa0yt5fzGvLBw)

[Learning to program in C part 1](/rltoken/aE_pZLbexuLroHA0FmjLbw)

[Learning to program in C part 2](/rltoken/3a5y1N-0FlTaPbKRxlRLlQ)

[Understanding C program Compilation Process](/rltoken/idYJyVfQRZ9e5aljiT5UKg)

[Betty Coding Style](/rltoken/wJg_qB9ducisfVQNk62htg)

[Hash-bang under the hood](/rltoken/BFBusLVUbFgGFcOGVPQcRw)

*Look at only after you finish consuming the other resources*

[Linus Torvalds on C vs. C++](/rltoken/JrokM8Pk6bd9wPqQvEfSAA)

*Look at only after you finish consuming the other resources*

man or help:

```gcc```

```printf (3)```

```puts```

```putchar```

Learning Objectives

At the end of this project, you are expected to be able to explain to anyone, without the help of Google:

General

```gcc main.c```

```main```

```printf```

```puts```

```putchar```

```sizeof```

```gcc```

```gcc```

```betty-style```

```main```

Copyright - Plagiarism

Requirements

C

```vi```

```vim```

```emacs```

```gcc```

```-Wall -Werror -Wextra -pedantic -std=gnu89```

```README.md```

```README.md```

*this*

```system```

```Betty```

[betty-style.pl](https://github.com/alx-tools/Betty/blob/master/betty-style.pl)

[betty-doc.pl](https://github.com/alx-tools/Betty/blob/master/betty-doc.pl)

Shell Scripts

```vi```

```vim```

```emacs```

```$ wc -l file```

```#!/bin/bash```

More Info

Betty linter

To run the Betty linter just with command betty <filename>:

[Betty](/rltoken/QkZtBg3ps5iLBlUdX-CPJQ)

[repo](/rltoken/QkZtBg3ps5iLBlUdX-CPJQ)

```cd```

```sudo ./install.sh```

```emacs```

```vi```

```betty```

```
#!/bin/bash
# Simply a wrapper script to keep you from having to use betty-style
# and betty-doc separately on every item.
# Originally by Tim Britton (@wintermanc3r), multiargument added by
# Larry Madeo (@hillmonkey)

BIN_PATH="/usr/local/bin"
BETTY_STYLE="betty-style"
BETTY_DOC="betty-doc"

if [ "$#" = "0" ]; then
    echo "No arguments passed."
    exit 1
fi

for argument in "$@" ; do
    echo -e "\n========== $argument =========="
    ${BIN_PATH}/${BETTY_STYLE} "$argument"
    ${BIN_PATH}/${BETTY_DOC} "$argument"
done
```

```chmod a+x betty```

```betty```

```/bin/```

```$PATH```

```sudo mv betty /bin/```

You can now type betty <filename> to run the Betty linter!


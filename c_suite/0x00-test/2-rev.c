#include "main.h"
#include <string.h>

/**
 * rev - reverse string
 * @s: pointer to 1st char in string
 *
 * Return: reverse string
 */
char *rev(char *s)
{
	int i = 0, len;
	char tmp;

	if (!s)
		return (NULL);

	len  = strlen(s);

	for (i = 0; i < len / 2; i++)
	{
		tmp = s[i];
		s[i] = s[len - 1 - i];
		s[len - 1 - i] = tmp;
	}

	return (s);
}


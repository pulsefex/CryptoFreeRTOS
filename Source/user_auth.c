#include "user_auth.h"
#include <string.h>

int authenticateUser(const char *username, const char *password)
{
    const char *correctUsername = "admin";
    const char *correctPassword = "password";

    if (strcmp(username, correctUsername) == 0 && strcmp(password, correctPassword) == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

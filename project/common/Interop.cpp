#include <stdio.h>
#include "Interop.h"
#include "../iphone/InteropIPhone.h"


namespace interop
{
    void Initialize()
    {
        #ifdef IPHONE
        iphone::InitializeIPhone();
        #endif
    }

    void LaunchURL(const char* url)
    {
        #ifdef IPHONE
        iphone::LaunchURL(url);
        #else
        printf("[ERROR] Native interop::LaunchURL() called but no implementation exists for this platform.");
        #endif
    }
}
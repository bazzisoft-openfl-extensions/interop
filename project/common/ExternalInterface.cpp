#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Interop.h"


using namespace interop;



static void interop_launch_url(value urlValue) {

    LaunchURL(val_string(urlValue));

}
DEFINE_PRIM(interop_launch_url, 1);



extern "C" void interop_main () {

    val_int(0); // Fix Neko init

}
DEFINE_ENTRY_POINT (interop_main);



extern "C" int interop_register_prims()
{
    Initialize();
    return 0;
}

#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "InteropIPhone.h"
#include "ExtensionKit.h"


//
// Function that dynamically implements the NMEAppDelegate.openURL callback and
// saves the URI application was launched from.
// For some reason we can't get this from a regular notification.
//
static BOOL ApplicationOpenURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation)
{
    const char* theUrl = [[url absoluteString] UTF8String];
    extensionkit::DispatchEventToHaxe("interop.event.LaunchedFromURLEvent",
                                      extensionkit::CSTRING, "interop_launched_from_url",
                                      extensionkit::CSTRING, theUrl,
                                      extensionkit::CEND);
    return YES;
}


namespace interop
{
    namespace iphone
    {
        void InitializeIPhone()
        {
            // Dynamically add ApplicationOpenURL() as the openURL handler in our UIApplication delegate
            class_addMethod(NSClassFromString(@"NMEAppDelegate"),
                            @selector(application:openURL:sourceApplication:annotation:),
                            (IMP) ApplicationOpenURL,
                            "B@:@@@@");
        }

        void LaunchURL(const char* url)
        {
            NSURL* nsurl = [NSURL URLWithString:[NSString stringWithUTF8String:url]];
            [[UIApplication sharedApplication] openURL:nsurl];
        }
    }
}
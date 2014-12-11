package interop;

import extensionkit.ExtensionKit;
import flash.net.URLRequest;
import interop.event.LaunchedFromURLEvent;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#elseif flash
import openfl.Lib;
#end


#if (android && openfl)
import openfl.utils.JNI;
#end


class Interop
{
    #if cpp
    private static var interop_launch_url = null;
    #end

    #if android
    private static var interop_launch_url_jni = null;
    #end

    private static var s_initialized:Bool = false;

    public static function Initialize() : Void
    {
        if (s_initialized)
        {
            return;
        }

        s_initialized = true;

        ExtensionKit.Initialize();

        #if cpp
        interop_launch_url = Lib.load("interop", "interop_launch_url", 1);
        #end

        #if android
        interop_launch_url_jni = JNI.createStaticMethod("org.haxe.extension.interop.Interop", "LaunchURL", "(Ljava/lang/String;)V");
        #end

        #if (cpp && !mobile)

        // On desktop platforms, treat the first command line param as the launched from URL
        if (Sys.args().length > 0)
        {
            SimulateLaunchedFromURL(Sys.args()[0]);
        }

        #elseif flash

        // On flash, use the flashvar launchedfromurl= to set the launched from URL.
        var flashvars:Dynamic<String> = Lib.current.stage.loaderInfo.parameters;
        if (Reflect.hasField(flashvars, "launchedfromurl"))
        {
            SimulateLaunchedFromURL(Reflect.field(flashvars, "launchedfromurl"));
        }

        #end
    }

    public static function LaunchURL(url:String) : Void
    {
        openfl.Lib.getURL(new URLRequest(url));
    }

    public static function SimulateLaunchedFromURL(url:String) : Void
    {
        ExtensionKit.stage.dispatchEvent(new LaunchedFromURLEvent(LaunchedFromURLEvent.LAUNCHED_FROM_URL, url));
    }
}
package org.haxe.extension.interop;

import org.haxe.extension.extensionkit.HaxeCallback;
import org.haxe.extension.extensionkit.Trace;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;


public class Interop extends org.haxe.extension.Extension
{
    public static void LaunchURL(final String url)
    {
        mainActivity.runOnUiThread(new Runnable()
        {
            @Override
            public void run()
            {
                Trace.Info("Launching intent for " + url);
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                mainActivity.startActivity(browserIntent);
            }
        });
    }

    private void CheckIfLaunchedFromURL(Intent intent)
    {
        String action = intent.getAction();
        String dataString = intent.getDataString();

        if (Intent.ACTION_VIEW == action && dataString != null)
        {
            Trace.Info("Launched from URL: " + dataString);
            HaxeCallback.DispatchEventToHaxe("interop.event.LaunchedFromURLEvent",
                                             new Object[] {
                                                 "interop_launched_from_url",
                                                 dataString
                                             });
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        CheckIfLaunchedFromURL(mainActivity.getIntent());
    }

    @Override
    public void onNewIntent(Intent intent)
    {
        CheckIfLaunchedFromURL(intent);
    }
}
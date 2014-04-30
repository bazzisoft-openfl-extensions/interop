Interop
=======

### Launch your iOS/Android app via a URL with parameters

This extension provides functionality for launching other apps via a URL, and detecting 
when this app is launched by a URL with a custom scheme. This can be useful for 
integrating with 3rd party apps or integrating to & from a website.


Dependencies
------------

- This extension implicitly includes `extensionkit` which must be available in a folder
  beside this one.
- This extension adds additional values to `Info.plist` on ios and `Android.manifest` on android.


Installation
------------

    git clone https://github.com/bazzisoft-openfl-extensions/extensionkit
    git clone https://github.com/bazzisoft-openfl-extensions/interop
    lime rebuild extensionkit [linux|windows|mac|android|ios]
    lime rebuild interop [linux|windows|mac|android|ios]


Usage
-----

### project.xml

    <include path="/path/to/interop" />

    <!-- 
    This specifies that our app can be launched with URLs like:

        my-custom-url-scheme://any-host/any/path
    -->
    <setenv name="LAUNCH_FROM_URL_SCHEME" value="my-custom-url-scheme" />


### Haxe
    
    class Main extends Sprite
    {
    	public function new()
        {
    		super();

            // Add the event listener BEFORE calling Initialize(), otherwise you will not receive
            // the event if the app was created via a URL rather than just resumed.
            stage.addEventListener(LaunchedFromURLEvent.LAUNCHED_FROM_URL, function(e) { trace(e); } );

            Interop.Initialize();
    
            ...
        }
    }


### AndroidManifest.xml

If not overriding the default `AndroidManifest.xml` template in your project.xml,
the interop extension will override it and add the required intent filters based
on the `LAUNCH_FROM_URL_SCHEME` env setting.

If you override with your own `AndroidManifest.xml`, make sure to include the
following additional `<intent-filter>` node under `<application>`:

    <intent-filter>
    
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="my-custom-url-scheme"/>
    
    </intent-filter>


### Info.plist

If not overriding the default `Info.plist` template in your project.xml,
the interop extension will override it and add the required custom URL scheme based
on the `LAUNCH_FROM_URL_SCHEME` env setting.

If you override with your own `Info.plist`, make sure to include the
following additional nodes under the top level `<dict>`:

	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>None</string>
			<key>CFBundleURLName</key>
			<string>::APP_PACKAGE::</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>my-custom-url-scheme</string>
			</array>
		</dict>
	</array>

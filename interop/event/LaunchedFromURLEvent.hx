package interop.event;
import flash.events.Event;
import interop.utils.URLParser;


class LaunchedFromURLEvent extends Event
{
    public static inline var LAUNCHED_FROM_URL = "interop_launched_from_url";

    public var url(default, null) : String;
    public var parsedUrl(default, null) : URLParser;

    public function new(type:String, url:String)
    {
        super(type, true, true);

        this.url = url;
        this.parsedUrl = URLParser.Parse(url);
    }

	public override function clone() : Event
    {
		return new LaunchedFromURLEvent(type, url);
	}

	public override function toString() : String
    {
		return "[LaunchedFromURLEvent type=" + type + " url=" + url + "]";
	}
}
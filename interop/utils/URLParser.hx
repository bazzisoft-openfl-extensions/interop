package interop.utils;


class URLParser
{
    public var url(default, null) : String;
    public var source(default, null) : String;
    public var protocol(default, null) : String;
    public var authority(default, null) : String;
    public var userInfo(default, null) : String;
    public var user(default, null) : String;
    public var password(default, null) : String;
    public var host(default, null) : String;
    public var port(default, null) : String;
    public var relative(default, null) : String;
    public var path(default, null) : String;
    public var directory(default, null) : String;
    public var file(default, null) : String;
    public var queryString(default, null) : String;
    public var anchor(default, null) : String;
    public var query(default, null) : QueryMap;

    private static var PARTS : Array<String> = ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","queryString","anchor"];

    public function new(url:String, urlDecode:Bool = true)
    {
        if (urlDecode)
        {
            url = StringTools.urlDecode(url);
        }

        // Save for 'ron
        this.url = url;

        // The almighty regexp (courtesy of http://blog.stevenlevithan.com/archives/parseuri)
        var r:EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;

        // Match the regexp to the url
        r.match(url);

        // Use reflection to set each part
        for (i in 0...PARTS.length)
        {
            var s = r.matched(i);
            Reflect.setField(this, PARTS[i],  (s != null ? s : ""));
        }

        query = new QueryMap(queryString);
    }

    public function toString() : String
    {
        var s : String = "url: " + url + "\n";
        for (i in 0...PARTS.length)
        {
            s += PARTS[i] + ": " + Reflect.field(this, PARTS[i]) + "\n";
        }

        s += "query(QueryMap): ";
        for (k in query.keys())
        {
            s += k + "=" + Std.string(query.getList(k)) + ", ";
        }

        if (StringTools.endsWith(s, ", "))
        {
            s = s.substr(0, s.length - 2);
        }
        s += "\n";
        return s;
    }

    public static function Parse(url:String, urlDecode:Bool = true) : URLParser
    {
        return new URLParser(url, urlDecode);
    }

    public static function ParseTestURL() : URLParser
    {
        return new URLParser("http://foo:bar@sub.domain.com:8080/path/to/my%20dir/something.php?one=two&two=3&one=three%20or+four&blank=&empty#withRef");
    }
}


private class QueryMap
{
    private var m_map:Map<String, Array<String>>;

    public function new(queryString:String)
    {
        m_map = new Map<String, Array<String>>();

        var r:EReg = ~/(?:^|&)([^&=]+)=?([^&]*)/;
        while (r.match(queryString))
        {
            var key = r.matched(1);
            var val = r.matched(2);

            if (!m_map.exists(key))
            {
                m_map.set(key, new Array<String>());
            }
            m_map.get(key).push(val);

            queryString = r.matchedRight();
        }
    }

    public function exists(key:String) : Bool
    {
        return m_map.exists(key);
    }

    public function get(key:String, ?defaultValue:String) : String
    {
        if (m_map.exists(key))
        {
            return m_map.get(key)[0];
        }
        else
        {
            return defaultValue;
        }
    }

    public function getList(key:String, ?defaultValue:Array<String>) : Array<String>
    {
        if (m_map.exists(key))
        {
            return m_map.get(key);
        }
        else
        {
            return defaultValue;
        }

    }

    public function keys() : Iterator<String>
    {
        return m_map.keys();
    }
}
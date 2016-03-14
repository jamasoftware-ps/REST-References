using System;
using System.IO;
using System.Net;
using System.Collections.Generic;

// Newtonsoft.Json is available from http://www.newtonsoft.com/json
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class Searching
{
    static public void Main()
    {
        string baseURL = "{base url}/rest/latest/";
        
        // Username and password should be stored according
        // to your organization's security policies
        string username = "API_User";
        string password = "********";

        string stringToFind = "Unique string";

        string containsParameter = "contains=" + WebUtility.UrlEncode(stringToFind);

        string url = baseURL + "abstractitems?" + containsParameter;

        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Credentials = new NetworkCredential(username, password);
        request.Method = WebRequestMethods.Http.Get;
        request.PreAuthenticate = true;

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();

        Stream stream = response.GetResponseStream();
        StreamReader streamReader = new StreamReader(stream);

        JObject jsonResponse = JObject.Parse(streamReader.ReadToEnd());
        JObject meta = (JObject) jsonResponse["meta"];
        JObject pageInfo = (JObject) meta["pageInfo"];
        long totalResults = (long) pageInfo["totalResults"];

        if (totalResults == 1)
        {
            JArray data = (JArray) jsonResponse["data"];
            JObject item = (JObject) data[0];

            JObject fields = (JObject) item["fields"];
            string name = (string) fields["name"];
            Console.WriteLine(name);
        }
        else
        {
            Console.WriteLine("stringToFind wasn't unique");
        }
    }
}

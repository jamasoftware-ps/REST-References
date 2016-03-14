using System;
using System.IO;
using System.Net;
using System.Collections.Generic;

// Newtonsoft.Json is available from http://www.newtonsoft.com/json
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class BasicAuth
{
    static public void Main()
    {
        string baseURL = "{base url}/rest/latest/";

        // Username and password should be stored according
        // to your organization's security policies
        string username = "API_User";
        string password = "********";

        string resource = "projects";

        int allowedResults = 20;
        string maxResults = "maxResults=" + allowedResults;

        long resultCount = -1;
        long startIndex = 0;

        while (resultCount != 0)
        {
            string startAt = "startAt=" + startIndex;

            string url = baseURL + resource + "?" + startAt + "&" + maxResults;

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

            startIndex = (long) pageInfo["startIndex"] + allowedResults;
            resultCount = (long) pageInfo["resultCount"];

            JArray projects = (JArray) jsonResponse["data"];
            foreach (JObject project in projects)
            {
                JObject fields = (JObject) project["fields"];
                string name = (string) fields["name"];
                Console.WriteLine(name);
            }
        }
    }
}

using System;
using System.IO;
using System.Net;
using System.Collections.Generic;

// Newtonsoft.Json is available from http://www.newtonsoft.com/json
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class Searching
{
    static private string baseURL = "{base url}/rest/latest/";

    // Username and password should be stored according
    // to your organization's security policies
    static private string username = "API_User";
    static private string password = "********";

    static private string stringToFind = "Unique string";

    static public void Main()
    {
        long itemId = getId(stringToFind);
        updateItem(itemId);
    }

    static public JObject get(string requestURL) 
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(requestURL);
        request.Credentials = new NetworkCredential(username, password);
        request.Method = WebRequestMethods.Http.Get;
        request.PreAuthenticate = true;

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();

        Stream stream = response.GetResponseStream();
        StreamReader streamReader = new StreamReader(stream);

        return JObject.Parse(streamReader.ReadToEnd());
    }

    static public int put(string requestURL, JObject payload)
    {
        HttpWebRequest request = (HttpWebRequest) WebRequest.Create(requestURL);
        request.Credentials = new NetworkCredential(username, password);
        request.Method = WebRequestMethods.Http.Put;
        request.ContentType = "application/json; charset=UTF-8";
        request.PreAuthenticate = true;

        StreamWriter streamWriter = new StreamWriter(request.GetRequestStream());
        streamWriter.Write(payload.ToString());
        streamWriter.Flush();

        HttpWebResponse response = (HttpWebResponse) request.GetResponse();

        return (int)response.StatusCode;
    }

    static public long getId(string toFind)
    {
        string url = baseURL + "abstractitems?contains=" + WebUtility.UrlEncode(stringToFind);
        JObject response = get(url);
        JObject meta = (JObject) response["meta"];
        JObject pageInfo = (JObject) meta["pageInfo"];
        long totalResults = (long) pageInfo["totalResults"];

        if(totalResults == 1)
        {
            JArray data = (JArray) response["data"];
            JObject item = (JObject) data[0];

            return (long) item["id"];
        }
        else
        {
            Console.WriteLine("stringToFind wasn't unique");
            Environment.Exit(1);
        }
        return -1;
    }

    static public void updateItem(long itemId)
    {
        setLockState(true, itemId);
        JObject item = getItem(itemId);
        item["fields"]["description"] += testResults();
        putItem(itemId, item);
        setLockState(false, itemId);
    }

    static public void setLockState(bool locked, long itemId)
    {
        JObject payload = new JObject();    
        payload.Add("locked", locked);

        string url = baseURL + "items/" + itemId + "/lock";
        put(url, payload);
    }

    static public JObject getItem(long itemId)
    {
        string url = baseURL + "items/" + itemId;
        JObject jsonResponse = get(url);
        return (JObject) jsonResponse["data"];
    }

    static public void putItem(long itemId, JObject item)
    {
        string url = baseURL + "items/" + itemId;

        int responseCode = put(url, item);
        if(responseCode < 400)
        {
            Console.WriteLine("Success");
        }
    }

    static public string testResults()
    {
        Random random = new Random();
        string htmlTemplate = "<p><strong>Imported test results:</strong></p>Status:&nbsp;";

        bool testPassed = random.Next(2) == 1;

        if(testPassed)
        {
            return htmlTemplate + "pass";
        }
        return htmlTemplate + "fail";
    }
}

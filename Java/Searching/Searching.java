import java.util.Base64; // Java 8
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.IOException;
import java.net.URLEncoder;

// Simple json available here: https://code.google.com/p/json-simple/
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Searching {

    public static void main(String[] args) throws Exception {
        String baseURL = "{base url}/rest/latest/";

        // Username and password should be stored according
        // to your organization's security policies
        String username = "API_User";
        String password = "********";
        String auth = Base64.getEncoder().encodeToString((username + ":" + password).getBytes());

        String stringToFind = "Unique string";

        String containsParameter = "contains=" + URLEncoder.encode(stringToFind, "UTF-8");

        String requestURL = baseURL + "abstractitems?" + containsParameter;

        URL url = new URL(requestURL);
        HttpURLConnection connection = (HttpURLConnection)url.openConnection();
        connection.setRequestProperty("Authorization", "Basic " + auth);

        InputStream content = connection.getInputStream();

        BufferedReader in = new BufferedReader(new InputStreamReader(content));

        JSONParser parser = new JSONParser();
        JSONObject response = (JSONObject) parser.parse(in.readLine());
        JSONObject meta = (JSONObject) response.get("meta");
        JSONObject pageInfo = (JSONObject) meta.get("pageInfo");
        long totalResults = (long) pageInfo.get("totalResults");

        if(totalResults == 1) {
            JSONArray data = (JSONArray) response.get("data");
            JSONObject item = (JSONObject) data.get(0);

            JSONObject fields = (JSONObject) item.get("fields");
            String name = (String) fields.get("name");
            System.out.println(name);

        } else {
            System.out.println("stringToFind wasn't unique");
        }
    }
}


import java.util.Base64; // Java 8
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Random;
import java.net.MalformedURLException;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URLEncoder;

// Simple json available here: https://code.google.com/p/json-simple/
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class UpdateItem {
    private static String baseURL = "{base url}/rest/latest/";

    // Username and password should be stored according
    // to your organization's security policies
    private static String username = "API_User";
    private static String password = "********";
    private static String auth = Base64.getEncoder().encodeToString((username + ":" + password).getBytes());

    private static String stringToFind = "Unique string";

    public static void main(String[] args) throws Exception {
        long itemId = getId(stringToFind);
        updateItem(itemId);
    }

    public static JSONObject get(String requestURL) throws Exception {
        JSONParser parser =  new JSONParser();
        URL url = new URL(requestURL);
        HttpURLConnection connection = (HttpURLConnection)url.openConnection();
        connection.setRequestProperty("Authorization", "Basic " + auth);

        InputStream content = connection.getInputStream();

        BufferedReader in = new BufferedReader(new InputStreamReader(content));
        return (JSONObject) parser.parse(in.readLine());
    }

    public static int put(String requestURL, JSONObject payload) throws Exception {
        URL url = new URL(requestURL);
        HttpURLConnection connection = (HttpURLConnection)url.openConnection();
        connection.setRequestMethod("PUT");
        connection.setDoOutput(true);
        connection.setRequestProperty("Authorization", "Basic " + auth);
        connection.setRequestProperty("Content-Type", "application/json");
        OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
        out.write(payload.toString());
        out.flush();
        out.close();
        return connection.getResponseCode();
    }

    public static long getId(String toFind) throws Exception {
        String url = baseURL + "abstractitems?contains=" + URLEncoder.encode(toFind, "UTF-8");
        JSONObject response = get(url);
        JSONObject meta = (JSONObject) response.get("meta");
        JSONObject pageInfo = (JSONObject) meta.get("pageInfo");
        long totalResults = (long) pageInfo.get("totalResults");

        if(totalResults == 1) {
            JSONArray data = (JSONArray) response.get("data");
            JSONObject item = (JSONObject) data.get(0);

            return (long) item.get("id");
        } else {
            System.out.println("stringToFind wasn't unique");
            System.exit(1);
        }
        return -1;
    }

    public static void updateItem(long itemId) throws Exception {
        setLockState(true, itemId);
        JSONObject item = getItem(itemId);
        JSONObject fields = (JSONObject) item.get("fields");
        String description = (String) fields.get("description");
        fields.put("description", description + testResults());
        putItem(itemId, item);
        setLockState(false, itemId);
    }

    public static void setLockState(boolean locked, long itemId) throws Exception {
        JSONObject payload = new JSONObject();
        payload.put("locked", locked);
    
        String url = baseURL + "items/" + itemId + "/lock";
        put(url, payload);
    }

    public static JSONObject getItem(long itemId) throws Exception {
        String url = baseURL + "items/" + itemId;
        JSONObject jsonResponse = get(url);
        return (JSONObject) jsonResponse.get("data");
    }

    public static void putItem(long itemId, JSONObject item) throws Exception {
        String url = baseURL + "items/" + itemId;
        int responseCode = put(url, item);
        if(responseCode < 400) {
            System.out.println("Success");
        }
    }

    public static String testResults() throws Exception {
        Random random = new Random();
        String htmlTemplate = "<p><strong>Imported test results:</strong></p>Status:&nbsp;";

        boolean testPassed = random.nextBoolean();

        if(testPassed) {
            return htmlTemplate + "pass";
        }
        return htmlTemplate + "fail";
    }
}

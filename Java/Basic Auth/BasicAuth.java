import java.util.Base64; // Java 8
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.IOException;

public class BasicAuth {
    public static void main(String[] args) throws MalformedURLException, IOException {
        String baseURL = "{base url}/rest/latest/";
        
        // Username and password should be stored according
        // to your organization's security policies
        String username = "API_User";
        String password = "********";
        String auth = Base64.getEncoder().encodeToString((username + ":" + password).getBytes());

        String resource = "projects";

        URL url = new URL(baseURL + resource);
        HttpURLConnection connection = (HttpURLConnection)url.openConnection();
        connection.setRequestProperty("Authorization", "Basic " + auth);

        InputStream content = connection.getInputStream();

        BufferedReader in = new BufferedReader(new InputStreamReader(content));
        System.out.println(in.readLine());
    }
}


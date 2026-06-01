package com.senhostel.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AIIntegrationUtil {

    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String OPENAI_API_KEY = "YOUR_OPENAI_API_KEY";

    public static String askOpenAI(String userMessage) {
        String fallback = "I could not find an exact hostel answer. Please contact admin or try asking in a simpler form.";

        try {
            URL url = new URL(OPENAI_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String payload = "{"
                    + "\"model\":\"gpt-4o-mini\","
                    + "\"messages\":["
                    + "{\"role\":\"system\",\"content\":\"You are a hostel management assistant. Give short factual answers.\"},"
                    + "{\"role\":\"user\",\"content\":\"" + userMessage.replace("\"", "\\\"") + "\"}"
                    + "]"
                    + "}";

            OutputStream os = conn.getOutputStream();
            os.write(payload.getBytes("UTF-8"));
            os.close();

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
            br.close();

            String apiResponse = response.toString();

            int contentIndex = apiResponse.indexOf("\"content\":\"");
            if (contentIndex != -1) {
                int start = contentIndex + 11;
                int end = apiResponse.indexOf("\"", start);
                if (end > start) {
                    return apiResponse.substring(start, end).replace("\\n", " ");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return fallback;
    }
}
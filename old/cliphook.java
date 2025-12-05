import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ClipboardLogger {

    private static final String LOG_FILE = "/home/dein_user/clipboard.log";
    private static final int INTERVAL = 2000; // Millisekunden

    private static String lastHash = "";

    public static void main(String[] args) throws InterruptedException {
        while (true) {
            try {
                String content = getClipboard();
                if (!content.isEmpty()) {
                    String currentHash = sha256(content);
                    if (!currentHash.equals(lastHash)) {
                        logClipboard(content);
                        System.out.println("Neuer Clipboard-Inhalt geloggt: " +
                                (content.length() > 30 ? content.substring(0, 30) + "..." : content));
                        lastHash = currentHash;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            Thread.sleep(INTERVAL);
        }
    }

    private static String getClipboard() throws IOException, InterruptedException {
        Process process = new ProcessBuilder("wl-paste", "-n").start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line).append("\n");
        }
        process.waitFor();
        return sb.toString().trim();
    }

    private static String sha256(String str) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(str.getBytes(StandardCharsets.UTF_8));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private static void logClipboard(String content) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             BufferedWriter bw = new BufferedWriter(fw)) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            bw.write("[" + timestamp + "]\n");
            bw.write(content + "\n\n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}


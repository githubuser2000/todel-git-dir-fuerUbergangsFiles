import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.security.MessageDigest
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import kotlin.concurrent.thread

const val LOG_FILE = "/home/dein_user/clipboard.log"
const val INTERVAL_MS = 2000L // 2 Sekunden

fun getClipboard(): String {
    return try {
        val process = ProcessBuilder("wl-paste", "-n").start()
        val reader = BufferedReader(InputStreamReader(process.inputStream))
        val content = reader.readText().trim()
        process.waitFor()
        content
    } catch (e: Exception) {
        ""
    }
}

fun sha256(str: String): String {
    val md = MessageDigest.getInstance("SHA-256")
    val hashBytes = md.digest(str.toByteArray(Charsets.UTF_8))
    return hashBytes.joinToString("") { "%02x".format(it) }
}

fun logClipboard(content: String) {
    val timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
    File(LOG_FILE).appendText("[$timestamp]\n$content\n\n")
}

fun main() {
    var lastHash = ""

    while (true) {
        val content = getClipboard()
        if (content.isNotEmpty()) {
            val currentHash = sha256(content)
            if (currentHash != lastHash) {
                logClipboard(content)
                println("Neuer Clipboard-Inhalt geloggt: ${content.take(30)}...")
                lastHash = currentHash
            }
        }
        Thread.sleep(INTERVAL_MS)
    }
}


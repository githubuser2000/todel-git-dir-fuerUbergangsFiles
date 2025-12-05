package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
	"time"
)

const (
	LOG_FILE     = "/home/dein_user/clipboard.log"
	INTERVAL_SEC = 2
)

func getClipboard() (string, error) {
	cmd := exec.Command("wl-paste", "-n")
	output, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(output)), nil
}

func hashString(s string) string {
	hash := sha256.Sum256([]byte(s))
	return hex.EncodeToString(hash[:])
}

func logClipboard(content string) {
	timestamp := time.Now().Format("2006-01-02 15:04:05")
	entry := fmt.Sprintf("[%s]\n%s\n\n", timestamp, content)
	f, err := os.OpenFile(LOG_FILE, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		fmt.Println("Fehler beim Loggen:", err)
		return
	}
	defer f.Close()
	if _, err := f.WriteString(entry); err != nil {
		fmt.Println("Fehler beim Schreiben:", err)
	}
}

func main() {
	var lastHash string

	for {
		content, err := getClipboard()
		if err == nil && content != "" {
			currentHash := hashString(content)
			if currentHash != lastHash {
				logClipboard(content)
				fmt.Println("Neuer Clipboard-Inhalt geloggt:", truncate(content, 30), "...")
				lastHash = currentHash
			}
		}
		time.Sleep(INTERVAL_SEC * time.Second)
	}
}

func truncate(s string, length int) string {
	if len(s) > length {
		return s[:length]
	}
	return s
}


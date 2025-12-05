use std::process::Command;
use std::{thread, time};
use std::fs::OpenOptions;
use std::io::Write;
use sha2::{Sha256, Digest};
use chrono::Local;

const LOG_FILE: &str = "/home/dein_user/clipboard.log";
const INTERVAL_SECS: u64 = 2;

fn get_clipboard() -> Option<String> {
    let output = Command::new("wl-paste")
        .arg("-n")
        .output()
        .ok()?;

    if output.status.success() {
        let s = String::from_utf8_lossy(&output.stdout).to_string();
        Some(s.trim_end().to_string())
    } else {
        None
    }
}

fn hash_string(s: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(s.as_bytes());
    format!("{:x}", hasher.finalize())
}

fn log_clipboard(content: &str) {
    let timestamp = Local::now().format("%Y-%m-%d %H:%M:%S").to_string();
    let mut file = OpenOptions::new()
        .append(true)
        .create(true)
        .open(LOG_FILE)
        .unwrap();

    writeln!(file, "[{}]", timestamp).unwrap();
    writeln!(file, "{}", content).unwrap();
    writeln!(file).unwrap();
}

fn main() {
    let mut last_hash = String::new();

    loop {
        if let Some(content) = get_clipboard() {
            if !content.is_empty() {
                let current_hash = hash_string(&content);
                if current_hash != last_hash {
                    log_clipboard(&content);
                    println!("Neuer Clipboard-Inhalt geloggt: {}...", &content.chars().take(30).collect::<String>());
                    last_hash = current_hash;
                }
            }
        }
        thread::sleep(time::Duration::from_secs(INTERVAL_SECS));
    }
}


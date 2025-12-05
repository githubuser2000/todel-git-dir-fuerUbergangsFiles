import { exec } from 'child_process';
import { writeFile, appendFile } from 'fs';
import { createHash } from 'crypto';
import { format } from 'date-fns';

const LOG_FILE = '/home/dein_user/clipboard.log';
const INTERVAL = 2000; // Millisekunden

let lastHash = '';

function getClipboard(): Promise<string> {
  return new Promise((resolve, reject) => {
    exec('wl-paste -n', (error, stdout, stderr) => {
      if (error) return resolve('');
      resolve(stdout.trim());
    });
  });
}

function hashString(content: string): string {
  return createHash('sha256').update(content).digest('hex');
}

function logClipboard(content: string) {
  const timestamp = format(new Date(), 'yyyy-MM-dd HH:mm:ss');
  const entry = `[${timestamp}]\n${content}\n\n`;
  appendFile(LOG_FILE, entry, (err) => {
    if (err) console.error('Fehler beim Loggen:', err);
  });
}

async function loop() {
  while (true) {
    const content = await getClipboard();
    if (content) {
      const currentHash = hashString(content);
      if (currentHash !== lastHash) {
        logClipboard(content);
        console.log('Neuer Clipboard-Inhalt geloggt:', content.slice(0, 30), '...');
        lastHash = currentHash;
      }
    }
    await new Promise((r) => setTimeout(r, INTERVAL));
  }
}

loop();


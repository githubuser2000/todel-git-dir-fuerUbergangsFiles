const fs = require('fs');
const cheerio = require('cheerio');

// Lese die HTML-Datei mit der Tabelle ein
const html = fs.readFileSync('/home/alex/religionen.html', 'utf8');

// Verwende cheerio, um das HTML zu parsen
const $ = cheerio.load(html);

// Entferne die Inhalte der Zellen in der Tabelle mit der ID "bigtable"
$('#bigtable td').empty();

// Speichere die veränderte HTML-Datei in einer neuen Datei
fs.writeFileSync('/home/alex/meine_neue_tabelle.html', $.html());

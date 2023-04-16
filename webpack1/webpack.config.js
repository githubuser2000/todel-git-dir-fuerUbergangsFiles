const path = require('path');

module.exports = {
  entry: './your_entry_file.js', // Pfad zu Ihrer Eintrittsdatei
  output: {
    path: path.resolve(__dirname, 'dist'), // Ausgabeverzeichnis
    filename: 'bundle.js' // Ausgabedatei
  },
  resolve: {
    alias: {
      zstd: '@oneidentity/zstd-js/decompress' // Verwenden Sie das alias "zstd" für das "decompress"-Modul
    }
  }
};

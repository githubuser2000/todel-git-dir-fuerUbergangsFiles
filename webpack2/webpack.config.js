const path = require('path');

module.exports = {
  entry: './your_entry_file2.js', // Pfad zu Ihrer Eintrittsdatei
  output: {
    path: path.resolve(__dirname, 'dist'), // Ausgabeverzeichnis
    filename: 'bundle.js' // Ausgabedatei
  },
  resolve: {
      alias:  {  loadCompressedData: 'functions.js',
      zstd: '@oneidentity/zstd-js/asm/decompress' // Verwenden Sie das alias "zstd" für das "decompress"-Modul
    }
  },
  module: {
    rules: [
      {
        test: /\.m?js$/, // Wenden Sie den "babel-loader" nur auf JavaScript-Dateien an
        exclude: /(node_modules|bower_components)/, // Ausschließen von Verzeichnissen, die nicht transpiliert werden sollen
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'] // Verwenden Sie das "@babel/preset-env"-Preset
          }
        }
      }
    ]
  }
};

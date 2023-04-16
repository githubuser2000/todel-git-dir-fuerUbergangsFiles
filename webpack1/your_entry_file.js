//import zstd from 'zstd'; // Verwenden Sie das importierte "zstd"-Modul
import {ZstdInit, ZstdDec} from '@oneidentity/zstd-js/decompress';
ZstdInit().then(({ZstdSimple, ZstdStream}) => {
  // Create some sample data to compress
  data = new Uint8Array(Array.from({length: 1000}, (_, i) => i % 256));

  /*
   * The required parameter is the data
   * It must be a Uint8Array
   * */
  compressedSimpleData = ZstdSimple.compress(data);

  compressedStreamData = ZstdStream.compress(data);
});

/*
const compressedData = []; // Ihre Zstd-komprimierten Daten
const decompressedData = zstd.decompress(compressedData); // Entpacken Sie die Daten mit der "decompress"-Funktion

console.log(decompressedData); // Ausgabe der entpackten Daten
*/

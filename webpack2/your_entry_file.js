import {ZstdInit, ZstdDec} from '@oneidentity/zstd-js/decompress';

function loadCompressedData() {
    const base64Data = "KLUv/WD4BI0GADLIHB5QpdYBwOaJojUTL1KdYK2bHa60uyQp0yWqnsxMqw4BhurnGlvNq4qfa2w1r6p9rrHVvKr0ucZWS1YKF7+MqPEMQrEJjY9/JglJALMxONixgJ5FcYcf0MM80KI47wkaNP7uLMoMaFzAIBN29WVC0suXaRE5oCHAOEkqw54BYKVpG5gByAmRJAiCIEpmhEASBEEQJTNCIAmCkKNOSKnCVJoS6YZShwrFQ1MyZJqFlKGdHhAEtBGLUDRlByQEqAPuK3Clz7K6pC5QBbjj2gw1";
    return new Uint8Array(atob(base64Data).split('').map(char => char.charCodeAt(0)));
}

ZstdInit().then(({ZstdSimple, ZstdStream}) => {
  // Load the compressed data
  const someCompressedData = loadCompressedData();

  // Decompress the compressed simple data
  const decompressedSimpleData = ZstdSimple.decompress(someCompressedData);

  // Decompress the compressed stream data
  const decompressedStreamData = ZstdStream.decompress(someCompressedData);

  console.log('[Simple]', decompressedSimpleData);
  console.log('[Stream]', decompressedStreamData);
});

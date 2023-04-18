const bundle = require('./bundle.js');
const functionNames = Object.keys(bundle);

functionNames.forEach(functionName => {
  const fn = bundle[functionName];
  if (typeof fn === 'function') {
    fn();
    console.log(`Function ${functionName} called successfully`);
  }
});
console.log(functionNames.length);
//bundle.myLibrary.loadCompressedData(0,0);
bundle.myLibrary.length;


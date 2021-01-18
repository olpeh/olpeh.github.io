const visualRegression = require('visual-regression');

// Probably stupid to use a "big enough height" here...
const height = 1200;
const viewportConfigs = [
  {
    width: 380,
    height
  },
  {
    width: 480,
    height
  },
  {
    width: 481,
    height
  },
  {
    width: 768,
    height
  },
  {
    width: 769,
    height
  },
  {
    width: 1024,
    height
  },
  {
    width: 1025,
    height
  },
  {
    width: 1280,
    height
  },
  {
    width: 1600,
    height
  },
  {
    width: 1920,
    height
  }
];

describe('olavihaapala.fi looks ok', () => {
  const options = {
    baseUrl: 'https://olavihaapala.fi',
    testPaths: [
      '/',
      '/projects/',
      '/contact/',
      '/talks/',
      '/2018/11/11/visual-regression.html'
    ],
    viewportConfigs
  };
  visualRegression.testVisualRegressions(options);
});

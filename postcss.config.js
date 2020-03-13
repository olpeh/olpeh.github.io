const plugins = [require('tailwindcss')];

if (process.env.NODE_ENV !== 'development') {
  console.log('Purging unused CSS using postcss-purgecss');
  plugins.push(
    require('@fullhuman/postcss-purgecss')({
      content: ['./src/**/*.{elm}'],
      defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || []
    })
  );
}

plugins.push(require('autoprefixer'));
plugins.push(require('cssnano'));

module.exports = {
  plugins
};

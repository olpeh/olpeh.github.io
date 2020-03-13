module.exports = {
  plugins: [
    require('tailwindcss'),
    require('postcss-elm-tailwind')(),
    require('autoprefixer')
  ]
};

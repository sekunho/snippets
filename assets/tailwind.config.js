module.exports = {
  purge: [
    '../lib/**/*.html.{leex, eex}',
    '../lib/**/*.{ex, sface}',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: theme => ({
        'gruvbox-bg0_h': '#1d2021',
        'gruvbox-bg': '#282828',
        'gruvbox-bg1': '#3c3836',
        'gruvbox-bg2': '#504945',
        'gruvbox-bg3': '#665c54',
        'gruvbox-bg4': '#7c6f64',
        'gruvbox-fg': '#ebdbb2',
        'gruvbox-gray': '#928374',
        'gruvbox-orange': '#fe8019',
        'gruvbox-red': '#fb4934',
        'gruvbox-green': '#b8bb26'
      }),
      inset: theme => ({
        '1/6': '16.666667%',
        '2/6': '33.333333%'
      }),
      fontFamily: theme => ({
        mono: ['Fira Mono', 'monospace']
      })
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

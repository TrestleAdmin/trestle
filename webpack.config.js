const path = require('path');

const CopyWebpackPlugin = require('copy-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  mode: 'production',
  entry: path.resolve(__dirname, 'frontend/index.js'),
  output: {
    library: 'Trestle',
    libraryExport: 'Trestle',
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'app/assets/bundle/trestle')
  },
  optimization: {
    minimizer: [
      new TerserPlugin({
        extractComments: false
      }),
      new CssMinimizerPlugin()
    ]
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: [
          { loader: 'babel-loader' }
        ]
      },
      {
        test: /\.(ttf|eot|svg|woff2?)(\?[\s\S]+)?$/,
        type: 'asset/resource'
      },
      {
        test: /\.(png|jpg|gif)$/i,
        type: 'asset/inline'
      },
      {
        test: /\.s?[ac]ss$/,
        use: [
          { loader: MiniCssExtractPlugin.loader },
          { loader: 'css-loader' },
          {
            loader: 'postcss-loader',
            options: {
              postcssOptions: {
                plugins: [
                  ['autoprefixer', {}]
                ]
              }
            }
          },
          { loader: 'sass-loader' }
        ]
      },
      {
        test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: {
            exposes: ['$', 'jQuery']
          }
        }]
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        {
          from: 'node_modules/@fortawesome/fontawesome-free/webfonts/*',
          to: '[name][ext]'
        },
        {
          from: 'node_modules/flatpickr/dist/l10n/*.js',
          to: 'flatpickr/[name][ext]',
          globOptions: {
            ignore: ['**/index.js']
          }
        }
      ]
    }),
    new MiniCssExtractPlugin({
      filename: 'bundle.css'
    })
  ],
  resolve: {
    mainFields: ['main']
  }
};

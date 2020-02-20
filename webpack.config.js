const path = require('path');

const Uglify = require('uglify-js');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: path.resolve(__dirname, 'frontend/index.js'),
  output: {
    library: 'Trestle',
    libraryExport: 'Trestle',
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'app/assets/bundle/trestle')
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        styles: {
          name: 'styles',
          test: /\.css$/,
          chunks: 'all',
          enforce: true
        }
      }
    },
    minimizer: [
      new UglifyJsPlugin({
        cache: true,
        parallel: true,
        sourceMap: true
      }),
      new OptimizeCSSAssetsPlugin({
        cssProcessorPluginOptions: {
          preset: ['default', { normalizePositions: false }]
        }
      })
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
        use: {
          loader: 'file-loader',
          options: {
            name: '[name].[ext]'
          }
        }
      },
      {
        test: /\.(png|jpg|gif)$/i,
        exclude: /node_modules/,
        use: {
          loader: 'url-loader'
        }
      },
      {
        test: /\.s?[ac]ss$/,
        use: [
          { loader: MiniCssExtractPlugin.loader },
          { loader: 'css-loader' },
          { loader: 'postcss-loader', options: { plugins: [ require('autoprefixer') ] } },
          { loader: 'resolve-url-loader' },
          { loader: 'sass-loader', options: { sourceMap: true } }
        ]
      },
      {
        test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: 'jQuery'
        }, {
          loader: 'expose-loader',
          options: '$'
        }]
      }
    ]
  },
  plugins: [
    new CopyWebpackPlugin([
      { from: 'node_modules/@fortawesome/fontawesome-free/webfonts/*', to: '[name].[ext]' },
      {
        from: 'node_modules/flatpickr/dist/l10n/*.js',
        to: 'flatpickr/[name].[ext]',
        ignore: ['index.js'],
        transform: function(fileContent, path) {
          return Uglify.minify(fileContent.toString()).code.toString();
        }
      }
    ]),
    new MiniCssExtractPlugin({
      filename: 'bundle.css'
    })
  ]
};

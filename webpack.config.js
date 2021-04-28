const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  mode: "production",
  entry: {
    main: './src',
  },
  module: {
    rules: [
      {
        test: /.scss$/,
        use: ExtractTextPlugin.extract({
          publicPath: '../../',
          use: ['css-loader', 'sass-loader']
        })
      }
    ]
  },
  plugins: [new ExtractTextPlugin({
    filename: '[name].css',
    allChunks: true,
  })]
}

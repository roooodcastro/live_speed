const { environment, } = require('@rails/webpacker');

const erb =  require('./loaders/erb');
const vue =  require('./loaders/vue');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

if (process.env.BUNDLE_ANALYZER) {
  environment.plugins.prepend('BundleAnalyzerPlugin', new BundleAnalyzerPlugin());
}

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.append('vue', vue);
environment.loaders.append('erb', erb);

// Add support for .wav files
environment.loaders.get('file').test = /\.(jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|woff2|wav)$/i

module.exports = environment;

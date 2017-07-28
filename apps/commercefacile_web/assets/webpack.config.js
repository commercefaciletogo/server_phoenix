const path = require("path");
const webpack = require("webpack");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = env => { 
    const isDev = !(env && env.prod);

    return {

        entry: {
            home: 'js/home.js',
            ads: 'js/ad/all.js',
            ad: 'js/ad/single.js',
            create: 'js/ad/create.js'
        },

        output: {
            path: path.resolve(__dirname, "../priv/static"),
            filename: 'js/[name].js',
        },

        module: {
            loaders: [
                {
                    test: /\.js$/,
                    exclude: /node_modules/,
                    loader: "babel-loader",
                    query: {
                        presets: ["es2015"]
                    }
                }
            ]
        },

        plugins: [
            new webpack.ProvidePlugin({
                $: 'jquery',
                jQuery: 'jquery',
                'window.jQuery': 'jquery'
            })
        ],

        resolve: {
            modules: ["node_modules", __dirname],
            extensions: [".js", ".json", ".css", ".vue"],
            alias: {
                vue: 'vue/dist/vue.js'
            }
        },

    };
};
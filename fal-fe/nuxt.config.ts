// https://nuxt.com/docs/api/configuration/nuxt-config
import vuetify, { transformAssetUrls } from 'vite-plugin-vuetify'
export default defineNuxtConfig({
    compatibilityDate: '2024-04-03',
    devtools: { enabled: true },
    ssr: true,
    devServer: {
        host: '0.0.0.0',
        port: 3000,
    },
    build: {
        transpile: ['vuetify'],
    },
    googleFonts: {
        families: {
            'Protest Guerrilla': true,
            'Roboto Slab': true,
            'Playwrite GB S': true,
            'Libre Baskerville': true,
        },
        display: 'swap',
    },
    modules: [
        '@nuxt/content',
        '@nuxtjs/mdc',
        '@nuxtjs/google-fonts',
        (_options, nuxt) => {
            nuxt.hooks.hook('vite:extendConfig', (config) => {
                // @ts-expect-error
                config.plugins.push(vuetify({ autoImport: true }))
            })
        },
        //...
    ],
    css: [
        '@/assets/css/github.css'
    ], 
    content: {
        markdown: {
            anchorLinks: false,
        },
        highlight: {
            theme: 'github-light',
        },
        watch: false,
    },
    vite: {
        vue: {
            template: {
                transformAssetUrls,             
            }
        },
    }
})

/*
PORT=3000 forever start -c node .output/server/index.mjs

# 安装forever
npm install forever -g
# 启动应用
forever start app.js --watch
# 关闭应用
forever stop app.js
# 重启应用
forever restart app.js
# 关闭所有应用
forever stopall
# 重启所有应用
forever restartall
# 显示所有运行的应用
forever list
*/
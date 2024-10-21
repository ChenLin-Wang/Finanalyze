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

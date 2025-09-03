import { defineConfig } from "vitepress";

// https://vitepress.dev/reference/site-config
export default defineConfig({
    title: "GitDone",
    description: "Store your todos in GitHub issues",
    themeConfig: {
        // https://vitepress.dev/reference/default-theme-config
        logo: "/logo.svg",

        nav: [
            { text: "Home", link: "/" },
            {
                text: "Contributing",
                link: "/contributing",
            },
            {
                text: "Development",
                items: [
                    {
                        text: "App Icon Generation",
                        link: "/development/app-icon-generation",
                    },
                ],
            },
            {
                text: "Repository",
                link: "https://github.com/RubberDuckCrew/gitdone",
            },
        ],

        sidebar: [
            {
                text: "Contributing",
                link: "/contributing",
            },
            {
                text: "Development",
                items: [
                    {
                        text: "App Icon Generation",
                        link: "/development/app-icon-generation",
                    },
                ],
            },
            {
                text: "Repository",
                link: "https://github.com/RubberDuckCrew/gitdone",
            },
        ],
        editLink: {
            pattern:
                "https://github.com/RubberDuckCrew/gitdone/blob/main/docs/src/:path",
            text: "View this page on GitHub",
        },
        socialLinks: [
            {
                icon: "github",
                link: "https://github.com/RubberDuckCrew/gitdone/",
            },
        ],
        search: {
            provider: "local",
        },
    },
    markdown: {
        image: {
            lazyLoading: true,
        },
    },
    srcDir: "./src",
    cleanUrls: true,
    lastUpdated: true,
    vite: {
        publicDir: "../public",
    },
});

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
                text: "Development",
                items: [
                    {
                        text: "Getting Started",
                        link: "/development/",
                    },
                    {
                        text: "Local Setup",
                        link: "/development/setup",
                    },
                    {
                        text: "Contributing",
                        link: "/development/contributing",
                    },
                    {
                        text: "CI/CD Workflows",
                        link: "/development/ci-cd",
                    },
                    {
                        text: "App icons",
                        link: "/development/app-icons",
                    },
                    {
                        text: "Concepts",
                        items: [
                            {
                                text: "Logging",
                                link: "/development/concepts/logging",
                            },
                            {
                                text: "MVVM Pattern",
                                link: "/development/concepts/mvvm",
                            },
                            {
                                text: "Dependency Injection",
                                link: "/development/concepts/dependency-injection",
                            },
                        ],
                    },
                ],
            },

            { text: "Download", link: "/download/" },
        ],

        sidebar: [
            {
                text: "Development",
                items: [
                    {
                        text: "Getting Started",
                        link: "/development/",
                    },
                    {
                        text: "Local Setup",
                        link: "/development/setup",
                    },
                    {
                        text: "Contributing",
                        link: "/development/contributing",
                    },
                    {
                        text: "CI/CD Workflows",
                        link: "/development/ci-cd",
                    },
                    {
                        text: "App icons",
                        link: "/development/app-icons",
                    },
                ],
            },
            {
                text: "Concepts",
                items: [
                    {
                        text: "Logging",
                        link: "/development/concepts/logging",
                    },
                    {
                        text: "MVVM Pattern",
                        link: "/development/concepts/mvvm",
                    },
                    {
                        text: "Dependency Injection",
                        link: "/development/concepts/dependency-injection",
                    },
                ],
            },
            { text: "Download", link: "/download/" },
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

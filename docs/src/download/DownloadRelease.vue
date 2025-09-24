<template>
    <template v-if="status === 'loading'">
        <p>Loading latest release...</p>
    </template>
    <template v-else-if="status === 'success'">
        <p>
            <VPButton
                text="Download latest stable release"
                theme="brand"
                v-if="releaseUrl"
                :href="releaseUrl" />
            <VPButton text="No stable release available" theme="alt" v-else />
        </p>
        <p>
            <VPButton
                text="Download latest pre-release"
                theme="brand"
                v-if="preReleaseUrl"
                :href="preReleaseUrl" />
            <VPButton text="No pre-release available" theme="alt" v-else />
        </p>
    </template>
    <template v-else>
        <p>
            Please download latest release manually from the
            <a
                href="https://github.com/RubberDuckCrew/gitdone/releases"
                target="_blank"
                >GitHub releases page</a
            >.
        </p>
    </template>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import VPButton from "vitepress/dist/client/theme-default/components/VPButton.vue";

const status = ref<DownloadStatus>("loading");
const preReleaseUrl = ref("");
const releaseUrl = ref("");

type DownloadStatus = "loading" | "success" | "error";

onMounted(() => {
    fetch("https://api.github.com/repos/RubberDuckCrew/gitdone/releases")
        .then((res) => res.json())
        .then((data) => {
            data.sort(
                (a: any, b: any) =>
                    new Date(b.published_at).getTime() -
                    new Date(a.published_at).getTime()
            );
            const latestRelease = data.find(
                (release: any) => !release.prerelease
            );
            const latestPreRelease = data.find(
                (release: any) => release.prerelease
            );
            if (
                latestPreRelease &&
                latestPreRelease.assets &&
                latestPreRelease.assets.length > 0
            ) {
                const apk = latestPreRelease.assets.find((a: any) =>
                    a.name.endsWith(".apk")
                );
                if (apk) {
                    preReleaseUrl.value = apk.browser_download_url;
                    status.value = "success";
                }
            }
            if (
                latestRelease &&
                latestRelease.assets &&
                latestRelease.assets.length > 0
            ) {
                const apk = latestRelease.assets.find((a: any) =>
                    a.name.endsWith(".apk")
                );
                if (apk) {
                    releaseUrl.value = apk.browser_download_url;
                    status.value = "success";
                }
            }
            if (status.value !== "success") {
                status.value = "error";
            }
        })
        .catch((e) => {
            status.value = "error";
        });
});
</script>

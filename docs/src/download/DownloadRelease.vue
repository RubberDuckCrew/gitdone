<template>
    <template v-if="status === 'loading'">
        <p>Loading latest release...</p>
    </template>
    <template v-else-if="status === 'success'">
        <p>
            <VPButton
                :text="`Download latest stable release (${releaseInfo.name})`"
                theme="brand"
                v-if="releaseInfo"
                :href="releaseInfo.url" />
            <VPButton
                text="No stable release available"
                theme="alt"
                disabled
                v-else />
        </p>
        <p>
            <VPButton
                :text="`Download latest pre-release (${preReleaseInfo.name})`"
                theme="brand"
                v-if="
                    preReleaseInfo && preReleaseInfo.name !== releaseInfo?.name
                "
                :href="preReleaseInfo.url" />
            <VPButton
                text="No pre-release available"
                theme="alt"
                disabled
                v-else />
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
const preReleaseInfo = ref<ReleaseInfo | null>(null);
const releaseInfo = ref<ReleaseInfo | null>(null);

type DownloadStatus = "loading" | "success" | "error";
type Release = {
    tag_name: string;
    prerelease: boolean;
    assets: Asset[];
    published_at: string;
};
type Asset = {
    name: string;
    browser_download_url: string;
};
type ReleaseInfo = {
    name: string;
    url: string;
};

onMounted(() => {
    fetch("https://api.github.com/repos/RubberDuckCrew/gitdone/releases")
        .then((res) => res.json())
        .then((data) => {
            data.sort(
                (a: Release, b: Release) =>
                    new Date(b.published_at).getTime() -
                    new Date(a.published_at).getTime()
            );
            const latestRelease = data.find(
                (release: Release) => !release.prerelease
            );
            const latestPreRelease = data.find(
                (release: Release) =>
                    release.prerelease &&
                    new Date(release.published_at) >
                        new Date(latestRelease?.published_at ?? 0)
            );
            preReleaseInfo.value = extractReleaseInfo(latestPreRelease);
            releaseInfo.value = extractReleaseInfo(latestRelease);
            status.value =
                preReleaseInfo.value || releaseInfo.value ? "success" : "error";
            if (status.value !== "success") {
                status.value = "error";
            }
        })
        .catch((e) => {
            status.value = "error";
        });
});

function extractReleaseInfo(release: Release | undefined): ReleaseInfo | null {
    if (release && release.assets && release.assets.length > 0) {
        const apk = release.assets.find((asset: Asset) =>
            asset.name.endsWith(".apk")
        );
        if (apk) {
            return {
                name: release.tag_name,
                url: apk.browser_download_url,
            };
        }
    }
    return null;
}
</script>

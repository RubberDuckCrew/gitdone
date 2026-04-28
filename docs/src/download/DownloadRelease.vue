<template>
    <template v-if="status === 'loading'">
        <p>Loading latest release...</p>
    </template>
    <template v-else-if="status === 'success'">
        <p>
            <VPButton
                v-if="releaseInfo"
                :text="`Download latest stable release (${releaseInfo.name})`"
                theme="brand"
                :href="releaseInfo.url" />
            <VPButton
                v-else
                text="No stable release available"
                theme="alt"
                disabled />
        </p>
        <p>
            <VPButton
                v-if="preReleaseInfo"
                :text="`Download latest pre-release (${preReleaseInfo.name})`"
                theme="brand"
                :href="preReleaseInfo.url" />
            <VPButton
                v-else
                text="No pre-release available"
                theme="alt"
                disabled />
        </p>
        <p>
            You can also find all releases on the
            <a
                href="https://github.com/RubberDuckCrew/gitdone/releases"
                target="_blank">
                GitHub releases page</a
            >.
        </p>
    </template>
    <template v-else>
        <p>
            Please download latest release manually from the
            <a
                href="https://github.com/RubberDuckCrew/gitdone/releases"
                target="_blank">
                GitHub releases page</a
            >.
        </p>
    </template>
</template>

<script setup lang="ts">
import VPButton from "vitepress/dist/client/theme-default/components/VPButton.vue";
import { useDownloadRelease } from "./downloadRelease.ts";

const { status, preReleaseInfo, releaseInfo } = useDownloadRelease();
</script>

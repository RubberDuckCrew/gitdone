<template>
    <template v-if="status === 'loading'">
        <p>🔄 Redirecting you to the latest release...</p>
        <p>
            If nothing happens,
            <a href="https://github.com/RubberDuckCrew/gitdone/releases"
                >click here</a
            >
            and manually download the latest release.
        </p>
    </template>
    <template v-else-if="status === 'success'">
        <p>✅ Download started! Enjoy the app 🚀</p>
    </template>
    <template v-else>
        <p>❌ Could not find a release. Please try again later.</p>
        <p>
            Please
            <a href="https://github.com/RubberDuckCrew/gitdone/releases"
                >click here</a
            >
            and manually download the latest release.
        </p>
    </template>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";

const status = ref("loading");

onMounted(async () => {
    try {
        const res = await fetch(
            "https://api.github.com/repos/RubberDuckCrew/gitdone/releases"
        );
        const data = await res.json();
        const latest = data[0];

        if (latest.assets && latest.assets.length > 0) {
            const apk = latest.assets.find(
                (asset: { name: string; browser_download_url: string }) =>
                    asset.name.endsWith(".apk")
            );
            if (apk) {
                window.location.href = apk.browser_download_url;
                status.value = "success";
                return;
            }
        }
    } catch (e) {
        console.error("Error fetching releases:", e);
        status.value = "error";
    }
});
</script>

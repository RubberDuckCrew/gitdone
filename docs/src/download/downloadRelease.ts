import { ref, onMounted, readonly } from "vue";

type DownloadStatus = "loading" | "success" | "errorFetchingReleases";
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

export function useDownloadRelease() {
    const status = ref<DownloadStatus>("loading");
    const preReleaseInfo = ref<ReleaseInfo>();
    const releaseInfo = ref<ReleaseInfo>();

    onMounted(() => {
        fetchReleases();
    });

    function fetchReleases() {
        fetch("https://api.github.com/repos/RubberDuckCrew/gitdone/releases")
            .then((res) => res.json())
            .then((releases: Release[]) => {
                processReleases(releases);
                status.value = "success";
            })
            .catch((e) => {
                console.error("Error fetching releases:", e);
                status.value = "errorFetchingReleases";
            });
    }

    function processReleases(releases: Release[]) {
        releases.sort(
            (a: Release, b: Release) =>
                new Date(b.published_at).getTime() -
                new Date(a.published_at).getTime()
        );
        const latestRelease = releases.find(
            (release: Release) => !release.prerelease
        );
        const latestPreRelease = releases.find(
            (release: Release) =>
                release.prerelease &&
                new Date(release.published_at) >
                    new Date(latestRelease?.published_at ?? 0)
        );
        preReleaseInfo.value = extractReleaseInfo(latestPreRelease);
        releaseInfo.value = extractReleaseInfo(latestRelease);
    }

    function extractReleaseInfo(
        release: Release | undefined
    ): ReleaseInfo | undefined {
        if (release?.assets && release.assets.length > 0) {
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
        return undefined;
    }

    return {
        status: readonly(status),
        preReleaseInfo: readonly(preReleaseInfo),
        releaseInfo: readonly(releaseInfo),
    };
}

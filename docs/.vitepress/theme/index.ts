import type { Theme } from "vitepress";
import DefaultTheme from "vitepress/theme";
// @ts-ignore
import "./style.css";

export default <Theme>{
    ...DefaultTheme,
};

const { EleventyRenderPlugin } = require("@11ty/eleventy");
const pluginTOC = require("eleventy-plugin-toc");
const markdownIt = require('markdown-it');
const markdownItAnchor = require('markdown-it-anchor');

module.exports = function (eleventyConfig) {
  // pass-throughs
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/js");

  // watch targets
  eleventyConfig.addWatchTarget("src/_javascript/");
  eleventyConfig.addWatchTarget("src/_sass/");
  eleventyConfig.addWatchTarget("README.md");

  // plugins
  eleventyConfig.addPlugin(EleventyRenderPlugin);
  eleventyConfig.addPlugin(pluginTOC, {
    tags: ['h2', 'h3'],
    wrapper: 'div',
    ul: true
  });

  // Markdown
  eleventyConfig.setLibrary(
    'md',
    markdownIt().use(markdownItAnchor)
  );

  return {
    dir: {
      input: "src",
      output: "_site",
    },
  };
};

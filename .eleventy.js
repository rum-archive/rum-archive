//
// Imports
//
const { EleventyRenderPlugin } = require("@11ty/eleventy");
const pluginTOC = require("eleventy-plugin-toc");
const markdownIt = require('markdown-it');
const markdownItAnchor = require('markdown-it-anchor');
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const Prism = require('prismjs');

// load Prism languages
const loadLanguages = require('prismjs/components/');
loadLanguages(['sql']);

//
// Exports (11ty configuration)
//
module.exports = function (eleventyConfig) {
  // pass-throughs
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/js");

  // watch targets
  eleventyConfig.addWatchTarget("src/_javascript/");
  eleventyConfig.addWatchTarget("src/_sass/");
  eleventyConfig.addWatchTarget("README.md");
  eleventyConfig.addWatchTarget("samples/");

  // plugins
  eleventyConfig.addPlugin(EleventyRenderPlugin);
  eleventyConfig.addPlugin(pluginTOC, {
    tags: ['h2', 'h3'],
    wrapper: 'div',
    ul: true
  });
  eleventyConfig.addPlugin(syntaxHighlight);

  // Markdown
  eleventyConfig.setLibrary(
    'md',
    markdownIt().use(markdownItAnchor)
  );

  eleventyConfig.addFilter("highlight", function(content, language) {
    return pairedShortcode(content, language);
  });

  return {
    dir: {
      input: "src",
      output: "docs",
    },
  };
};

//
// Imports
//
const { EleventyRenderPlugin } = require("@11ty/eleventy");
const pluginTOC = require("eleventy-plugin-toc");
const markdownIt = require('markdown-it');
const markdownItAnchor = require('markdown-it-anchor');
const markdownItFootnote = require('markdown-it-footnote');
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const Prism = require('prismjs');
const { DateTime } = require('luxon');

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
  eleventyConfig.addPassthroughCopy("src/blog/**/*.png");
  eleventyConfig.addPassthroughCopy("src/blog/**/*.svg");
  eleventyConfig.addPassthroughCopy({ "src/_favicon": "/" })

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
    markdownIt({
      html: true,
      linkify: true,
    }).use(markdownItAnchor)
      .use(markdownItFootnote)
  );

  // filters
  eleventyConfig.addFilter("highlight", function(content, language) {
    return pairedShortcode(content, language);
  });

  eleventyConfig.addFilter("readableDate", dateObj => {
    return DateTime.fromJSDate(dateObj, {zone: 'utc'}).toFormat("dd LLL yyyy");
  });

  eleventyConfig.addFilter('htmlDateString', (dateObj) => {
    return DateTime.fromJSDate(dateObj, { zone: 'utc' }).toFormat('yyyy-LL-dd');
  });

  return {
    dir: {
      input: "src",
      output: "docs",
    },
  };
};

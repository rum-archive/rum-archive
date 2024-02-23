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
const embedEverything = require("eleventy-plugin-embed-everything");
const pluginRss = require("@11ty/eleventy-plugin-rss");

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

  // recommended per https://www.highcharts.com/docs/accessibility/accessibility-module
  // TODO: currently, I can't have both these files map to js/highcharts, while ALSO having already an existing src/js/highcharts/ dir with other scripts in it
  //  --> figure out why and clean up (dirty fix for now is to have src/js/charts/ instead of src/js/highcharts/)
  eleventyConfig.addPassthroughCopy({"node_modules/highcharts/highstock.js": "js/highcharts/highstock.js"});
  eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/exporting.js": "js/highcharts/exporting.js"});
  eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/export-data.js": "js/highcharts/export-data.js"});
  eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/accessibility.js": "js/highcharts/accessibility.js"});

  // only during local development when running 11ty dev server
  if ( process.env.npm_lifecycle_script.includes("--serve") ) {
    eleventyConfig.addPassthroughCopy({"node_modules/highcharts/highstock.js.map": "js/highcharts/highstock.js.map"});
    eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/exporting.js.map": "js/highcharts/exporting.js.map"});
    eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/export-data.js.map": "js/highcharts/export-data.js.map"});
    eleventyConfig.addPassthroughCopy({"node_modules/highcharts/modules/accessibility.js.map": "js/highcharts/accessibility.js.map"});
  }

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
  eleventyConfig.addPlugin(embedEverything);
  eleventyConfig.addPlugin(pluginRss);

  // Liquid filters
  eleventyConfig.addLiquidFilter("dateToRfc3339", pluginRss.dateToRfc3339);

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

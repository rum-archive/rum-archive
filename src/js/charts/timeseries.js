// loosely adapted from and inspired by https://github.com/HTTPArchive/httparchive.org/blob/main/src/js/timeseries.js and other files in that directory
// intention was/is to be able to ingest both HTTPArchive and RUMArchive data and juxtapose both datasets side by side

class Colors {
  static HTTPARCHIVE_HEX = [
    '#04c7fd', // bright blue, desktop
    '#a62aa4', // purple, mobile
    '#12aef8', 
    '#842486'
  ];
  static RUMARCHIVE_HEX = [
    "#006a80", // dark cyan, the palmtree
    "#f2835c", // orange, mountain
    "#c2f2f2", // light cyan, the sky
    "#f2be7f", // light orange, bottom of sky
  ];
  // static get DESKTOP() { return Colors.HTTPARCHIVE_HEX[0]; }
  // static get MOBILE() {  return Colors.HTTPARCHIVE_HEX[1]; } 
  static get DESKTOP() { return Colors.RUMARCHIVE_HEX[0]; }
  static get MOBILE() {  return Colors.RUMARCHIVE_HEX[1]; } 
  static get TABLET() {  return Colors.RUMARCHIVE_SECONDARY[3]; } 

  static get LIST(){
    return [
      this.RUMARCHIVE_MAIN[0],
      this.RUMARCHIVE_MAIN[1],
      this.RUMARCHIVE_SECONDARY[1],
      this.RUMARCHIVE_SECONDARY[3],
      this.RUMARCHIVE_SECONDARY[5],
      this.RUMARCHIVE_MAIN[2],
      this.RUMARCHIVE_MAIN[3],
      this.RUMARCHIVE_SECONDARY[0],
      this.RUMARCHIVE_SECONDARY[2],
      this.RUMARCHIVE_SECONDARY[4],
      this.RUMARCHIVE_MAIN[0], // note: starts again here, that's intentional for now... we don't have more colors
      this.RUMARCHIVE_MAIN[1],
      this.RUMARCHIVE_SECONDARY[1],
      this.RUMARCHIVE_SECONDARY[3],
      this.RUMARCHIVE_SECONDARY[5],
      this.RUMARCHIVE_MAIN[2],
      this.RUMARCHIVE_MAIN[3],
      this.RUMARCHIVE_SECONDARY[0],
      this.RUMARCHIVE_SECONDARY[2],
      this.RUMARCHIVE_SECONDARY[4]
    ];
  }

  static RUMARCHIVE_MAIN = [
    "#006a80", // dark cyan, the palmtree
    "#f2835c", // orange, mountain
    "#c2f2f2", // light cyan, the sky
    "#f2be7f", // light orange, bottom of sky
  ];

  // 3 color scheme: [1], [3], [5] // blue red green
  static RUMARCHIVE_SECONDARY = [
    "#F2835C", // dark blue / black
    "#14ADCC", // radiant blue
    "#803B00", // brown
    "#CC3414", // scarlet
    "#CC9514", // dark orange
    "#089688", // green
  ];

  static RUMARCHIVE_ORANGE_1 = Colors.RUMARCHIVE_MAIN[1];
  static RUMARCHIVE_ORANGE_2 = Colors.RUMARCHIVE_MAIN[3];
  static RUMARCHIVE_BLUE_1   = Colors.RUMARCHIVE_MAIN[0];
  static RUMARCHIVE_BLUE_2   = Colors.RUMARCHIVE_SECONDARY[1];
  static RUMARCHIVE_SCARLET  = Colors.RUMARCHIVE_SECONDARY[3];
  static RUMARCHIVE_GREEN   = Colors.RUMARCHIVE_SECONDARY[5];

  // TODO: map these colors to actual hex values to be used
  // these should be the WebPageTest colors for the same metrics in the waterfalls, also used in mPulse
  /*
  timerMap = Dict{Symbol, AbstractString}(
        :beacons                                      => "hsl(45,100%,51%)",
        Symbol(BEACON_TABLE.timersResponse)           => "rgb(166,206,227)",
        Symbol(BEACON_TABLE.timersDns)                => "hsl(22,81%,31%)",
        Symbol(BEACON_TABLE.timersDomLoad)            => "hsl(250,61%,62%)",
        Symbol(BEACON_TABLE.timersDomReady)           => "hsl(48,85%,53%)",
        Symbol(BEACON_TABLE.firstcontentfulpaint)     => "hsl(208,66%,56%)",
        Symbol(BEACON_TABLE.firstinputdelay)          => "hsl(0,65%,51%)",
        Symbol(BEACON_TABLE.firstpaint)               => "hsl(185,66%,56%)",
        Symbol(BEACON_TABLE.timersPage)               => "rgb(202,178,214)",
        Symbol(BEACON_TABLE.longtaskstime)            => "hsl(30,100%,60%)",
        Symbol(BEACON_TABLE.timersDone)               => "hsl(145,65%,57%)",
        Symbol(BEACON_TABLE.timersSsl)                => "hsl(27,100%,45%)",
        Symbol(BEACON_TABLE.timersTcp)                => "hsl(118,51%,39%)",
        Symbol(BEACON_TABLE.ttfi)                     => "hsl(0,100%,89%)",
        Symbol(BEACON_TABLE.tti)                      => "hsl(305,66%,56%)",
        Symbol(BEACON_TABLE.ttvr)                     => "rgb(51,160,44)",
        Symbol(BEACON_TABLE.totalbrowsercachehitratio)=> "hsl(216,35%,50%)",
        Symbol(BEACON_TABLE.totalcdncachehitratio)    => "hsl(190,35%,50%)",
        Symbol(BEACON_TABLE.totaltransfersize)        => "hsl(30,100%,60%)",
        Symbol(BEACON_TABLE.totalorigintime)          => "rgb(253,191,111)",
    )
    */
}

class Metric {
  constructor(options, value=null) {
    this.options = options;
    this.value = value;
  }

  toString() {
    let type = this.options.type;
    if (this.options.singular && this.value === 1) {
      type = this.options.singular;
    }
    return `${this.value}${type === "%" ? '' : ' '}${type}`; // if %, should be 10%. If not, should be e.g., 10 KB
  }
}

async function timeseriesFromDataWithDefaults( queryName, chartElementID, metricFieldName, graphTitle, timeseriesCreationCallback ) {
  // used to set sensible defaults for a typical metric-based graphs that shows percentages for a couple of timeseries

  // TODO: move this endpoint selection logic to a more central location!
  const FORCE_EXTERNAL_DATA = false;
  let DATA_BASE_URL = "https://raw.githubusercontent.com/rum-archive/rum-insights-data/main/data-output/";

  if ( window.location.href.includes("localhost") && !FORCE_EXTERNAL_DATA ) {
    // allow for easy local testing
    // launch a basic python http server in the rum-insights-data dir with `python3 -m http.server 9000`
    DATA_BASE_URL = "http://localhost:9000/data-output/";
  }

  let response = await fetch(DATA_BASE_URL + queryName + ".json");
  let rumarchiveData = await response.json();

  const options = {};
  options.chartId = chartElementID;
  options.histogram = { enabled: false };
  options.metric = metricFieldName;
  options.type = "%";

  options.yMax = 100;

  // user can pass this in to do actual calculation of the timeseries
  // TODO: provide a default implementation for this as well, based on the metricFieldName
  options.timeseries = timeseriesCreationCallback( rumarchiveData, metricFieldName );

  // options.id = "device";
  options.name = graphTitle;

  timeseriesFromData(rumarchiveData, metricFieldName, options, rumarchiveData[0].date, rumarchiveData[rumarchiveData.length - 1].date );
}

function timeseriesFromData(data, metric, options, start, end){
  let [YYYY, MM, DD] = start.split('_');
  options.min = Date.UTC(YYYY, MM - 1, DD);
  [YYYY, MM, DD] = end.split('_');
  options.max = Date.UTC(YYYY, MM - 1, DD);

  if ( !options.dataArchive ) {
    options.dataArchive = {
      name: "RUM Archive",
      URL: "https://rumarchive.com/"
    };
  }

  // Ensure null values are filtered out.
  data = data.filter(o => getUnformattedPrimaryMetric(o, options) !== null);

  if ( options.timeseries && options.timeseries.length > 1 ) {
    drawTimeseries2(options.timeseries, options);
  }
  else {
    drawTimeseries(data, options);
  }
  drawTimeseriesTable(data, options, [options.min, options.max]);
}

function timeseriesFromURL(metric, options, start, end) {
  const dataUrl = `https://cdn.httparchive.org/reports/${options.lens ? `${options.lens.id}/` : ''}${metric}.json`;
  // options.chartId = `${metric}-chart`;
  // options.tableId = `${metric}-table`;
  options.metric = metric;

  fetch(dataUrl)
    .then(response => response.text())
    .then(jsonStr => JSON.parse(jsonStr))
    .then(data => data.sort((a, b) => a.date < b.date ? -1 : 1))
    .then(data => {
      // let [YYYY, MM, DD] = start.split('_');
      // options.min = Date.UTC(YYYY, MM - 1, DD);
      // [YYYY, MM, DD] = end.split('_');
      // options.max = Date.UTC(YYYY, MM - 1, DD);

      // // Ensure null values are filtered out.
      // data = data.filter(o => getUnformattedPrimaryMetric(o, options) !== null);

      // drawTimeseries(data, options);
      // drawTimeseriesTable(data, options, [options.min, options.max]);
      timeseriesFromData( data, metric, options, start, end );
    });
}

function drawSummary(data, options, start, end) {
  const desktop = data.filter(o => isDesktop(o) && o.timestamp >= start && o.timestamp <= end).map(toNumeric);
  const mobile = data.filter(o => isMobile(o) && o.timestamp >= start && o.timestamp <= end).map(toNumeric);

  drawClientSummary(desktop, options, 'desktop');
  drawClientSummary(mobile, options, 'mobile');
}

function drawClientSummary(data, options, client) {
  if (!data.length) {
    return;
  }

  const value = getSummary(data, options);

  // Assume the metric is not the median if the options have custom fields.
  const isMedian = !(options.timeseries && options.timeseries.fields);
  const change = getChange(data, options);

  console.warn("timeseries.js:drawClientSummary:drawMetricsSummary is not implemented yet!");
  // TODO: need to couple this correctly from HTTPArchive's utils.js
  // drawMetricSummary(options, client, value, isMedian, change);
}

function getSummary(data, options) {
  const o = data[data.length - 1];
  const summary = getPrimaryMetric(o, options);
  const metric = new Metric(options, summary);

  return metric.toString();
}

function getChange(data, options) {
  if (data.length < 2) {
    return;
  }

  let oldestIndex;

  for (let i = 0; i < data.length; i++) {
    if (getPrimaryMetric(data[i], options) > 0) {
      oldestIndex = i;
      break;
    }
  }

  if (oldestIndex === undefined) {
    return;
  }

  const oldest = getPrimaryMetric(data[oldestIndex], options);
  const latest = getPrimaryMetric(data[data.length - 1], options);

  return (latest - oldest) * 100 / oldest;
}

function getPrimaryMetric(o, options) {
  const field = getPrimaryFieldName(o, options);
  const primaryMetric = getUnformattedPrimaryMetric(o, options);
  const formatter = formatters[field];
  if (formatter) {
    return formatter(primaryMetric);
  }
  return primaryMetric;
}

function getPrimaryFieldName(o, options) {
  if (options.timeseries && options.timeseries.fields) {
    return options.timeseries.fields[0];
  }

  return 'p50';
}

function getUnformattedPrimaryMetric(o, options) {
  const field = getPrimaryFieldName(o, options);
  return o[field];
}

function drawTimeseries2(seriesInput, options) {
  // data = data.map(toNumeric);
  // const desktop = data.filter(isDesktop);
  // const mobile = data.filter(isMobile);

  const series = [];

  for( const serie of seriesInput ) {
    if ( serie.fields ) {
      serie.fields.forEach(field => {
        // + before the field to convert to numeric
        series.push(getLineSeries(serie.name, serie.data.map(o => [parseFloat(o.timestamp), parseFloat(o[field])]), serie.color));
      });
    }
    else {
      series.push(getLineSeries(serie.name, serie.data.map(toLine), serie.color));
      series.push(getAreaSeries(serie.name, serie.data.map(toIQR),  serie.color));
    }
  }


  // if (desktop.length) {
  //   if (options.timeseries && options.timeseries.fields) {
  //     options.timeseries.fields.forEach(field => {
  //       series.push(getLineSeries('Desktop', desktop.map(o => [o.timestamp, o[field]]), Colors.DESKTOP));
  //     });
  //   } else {
  //     series.push(getLineSeries('Desktop', desktop.map(toLine), Colors.DESKTOP));
  //     series.push(getAreaSeries('Desktop', desktop.map(toIQR), Colors.DESKTOP));
  //   }
  // }
  // if (mobile.length) {
  //   if (options.timeseries && options.timeseries.fields) {
  //     options.timeseries.fields.forEach(field => {
  //       series.push(getLineSeries('Mobile', mobile.map(o => [o.timestamp, o[field]]), Colors.MOBILE));
  //     });
  //   } else {
  //     series.push(getLineSeries('Mobile', mobile.map(toLine), Colors.MOBILE));
  //     series.push(getAreaSeries('Mobile', mobile.map(toIQR), Colors.MOBILE));
  //   }
  // }

  if (!series.length) {
    console.error('No timeseries data to draw', data, options);
    return;
  }

  console.log("SERIES TO SHOW", series);

  // const changeLogURL = options.changeLogURL || "/static/json/changelog.json";

  // getFlagSeries(changeLogURL)
  //   .then(flagSeries => series.push(flagSeries))
  //   // If the getFlagSeries request fails (503), catch so we can still draw the chart
  //   .catch(console.error)
  //   .then(_ => drawChart(options, series));
  
  drawChart(options, series);
}

function drawTimeseries(data, options) {
  data = data.map(toNumeric);
  const desktop = data.filter(isDesktop);
  const mobile = data.filter(isMobile);

  const series = [];
  if (desktop.length) {
    if (options.timeseries && options.timeseries.fields) {
      options.timeseries.fields.forEach(field => {
        series.push(getLineSeries('Desktop', desktop.map(o => [o.timestamp, o[field]]), Colors.DESKTOP));
      });
    } else {
      series.push(getLineSeries('Desktop', desktop.map(toLine), Colors.DESKTOP));
      series.push(getAreaSeries('Desktop', desktop.map(toIQR), Colors.DESKTOP));
    }
  }
  if (mobile.length) {
    if (options.timeseries && options.timeseries.fields) {
      options.timeseries.fields.forEach(field => {
        series.push(getLineSeries('Mobile', mobile.map(o => [o.timestamp, o[field]]), Colors.MOBILE));
      });
    } else {
      series.push(getLineSeries('Mobile', mobile.map(toLine), Colors.MOBILE));
      series.push(getAreaSeries('Mobile', mobile.map(toIQR), Colors.MOBILE));
    }
  }

  if (!series.length) {
    console.error('No timeseries data to draw', data, options);
    return;
  }

  const changeLogURL = options.changeLogURL || "/static/json/changelog.json";

  getFlagSeries(changeLogURL)
    .then(flagSeries => series.push(flagSeries))
    // If the getFlagSeries request fails (503), catch so we can still draw the chart
    .catch(console.error)
    .then(_ => drawChart(options, series));

}

let redrawTimeseriesTable = {};

function drawTimeseriesTable(data, options, [start, end]=[-Infinity, Infinity]) {

    return; // RumInsights doesn't do this yet

    // start = Math.floor(start);
    // end = Math.floor(end);
    // if (!redrawTimeseriesTable[options.metric]) {
    //   // Return a curried function to redraw the table given start/end times.
    //   redrawTimeseriesTable[options.metric] = debounce((dateRange) => {
    //     return drawTimeseriesTable(data, options, dateRange);
    //   }, 100);
    // }

    // drawSummary(data, options, start, end);

    // let cols = DEFAULT_COLS.concat(DEFAULT_FIELDS);
    // if (options.timeseries && options.timeseries.fields) {
    //   cols = DEFAULT_COLS.concat(options.timeseries.fields);
    // }

    // Promise.resolve(zip(data)).then(data => {
    //   const table = document.getElementById(options.tableId);
    //   Array.from(table.children).forEach(child => table.removeChild(child));

    //   const frag = document.createDocumentFragment();
    //   const thead = el('thead');

    //   if (!options.timeseries || !options.timeseries.fields) {
    //     const trMeta = el('tr');
    //     trMeta.classList.add('meta-row');
    //     DEFAULT_COLS.map(col => {
    //       return el('td');
    //     }).forEach(td => trMeta.appendChild(td));
    //     const th = el('th');
    //     th.classList.add('text-center');
    //     th.setAttribute('colspan', cols.length - DEFAULT_COLS.length);
    //     th.textContent = 'Percentile' + (th.colspan === 1 ? '' : 's');
    //     trMeta.appendChild(th);
    //     thead.appendChild(trMeta);
    //   }

    //   const tr = el('tr');
    //   cols.map(col => {
    //     const th = el('th');
    //     th.textContent = col;
    //     return th;
    //   }).forEach(th => tr.appendChild(th));
    //   thead.appendChild(tr);
    //   frag.appendChild(thead);

    //   const tbody = el('tbody');
    //   data.forEach(([date, arr]) => {
    //     if (date < start || date > end) {
    //       return;
    //     }

    //     arr.forEach((o, i) => tbody.appendChild(toRow(o, i, arr.length, cols)));
    //   });
    //   frag.appendChild(tbody);
    //   table.appendChild(frag);
    // });
}

const isDesktop = o => o.client == 'desktop';
const isMobile = o => o.client == 'mobile';
const toNumeric = ({client, date, ...other}) => {
  return Object.entries(other).reduce((o, [k, v]) => {
    o[k] = +v;
    return o;
  }, {client});
};
const toIQR = o => [o.timestamp, o.p25, o.p75];
const toLine = o => [o.timestamp, o.p50];
const getLineSeries = (name, data, color) => ({
  name,
  type: 'line',
  data,
  color,
  zIndex: 1,
  marker: {
    enabled: false
  }
});
const getAreaSeries = (name, data, color, opacity=0.1) => ({
  name,
  type: 'areasplinerange',
  linkedTo: ':previous',
  data,
  lineWidth: 0,
  color,
  fillOpacity: opacity,
  zIndex: 0,
  marker: {
    enabled: false,
    states: {
      hover: {
        enabled: false
      }
    }
  }
});
const flags = {};
let changelog = null;
const loadChangelog = (changeLogURL) => {
  if (!changelog) {
    changelog = fetch(changeLogURL).then(response => response.json());
  }

  return changelog;
};
const getFlagSeries = (changeLogURL) => loadChangelog(changeLogURL).then(data => {
  data.forEach(change => {
    flags[+change.date] = {
      title: change.title,
      desc: change.desc
    };
  });
  // Filter out changes that don't need to be displayed in time series
  data = data.filter(o => o.displayInTimeSeries !== false);
  return {
    type: 'flags',
    name: 'Changelog',
    data: data.map((change, i) => ({
      x: change.date,
      title: String.fromCharCode(65 + (i % 26))
    })),
    clip: false,
    color: '#90b1b6',
    y: 25,
    showInLegend: false
  };
});

function drawChart(options, series) {

  const chart = Highcharts.stockChart(options.chartId, {
    metric: options.metric,
    type: 'timeseries',
    chart: {
      zoomType: 'x',

      events: {
        load: function() {
            // Export to PNG doesn't include the logo if using external link. Have to include it as base64 here... eyeroll
            // see also: https://www.highcharts.com/forum/viewtopic.php?t=48036
            this.renderer.image('data:image/png;base64,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',
                 5, this.chartHeight - 30, 125, 25 ).add();
        }
      }
    },
    title: {
      text: `${options.lens ? `${options.lens.name}: ` : '' }` + `Timeseries of ${options.name}`
    },
    subtitle: {
      text: `Source: <a href="${options.dataArchive.URL}">${options.dataArchive.name}</a>`,
      useHTML: true
    },
    legend: {
      enabled: true
    },
    tooltip: {
      crosshairs: true,
      shared: true,
      useHTML: true,
      borderColor: 'rgba(247,247,247,0.85)',
      formatter: function() {
        // function getChangelog(changelog) {
        //   if (!changelog) return '';
        //   return `<p class="changelog">${changelog.title}</p>`;
        // }

        // const changelog = flags[this.x];
        const tooltip = `<p style="font-size: smaller; text-align: center;">${Highcharts.dateFormat('%b %e, %Y', this.x)}</p>`;

        // // Handle changelog tooltips first.
        // if (!this.points) {
        //   return `${tooltip} ${getChangelog(changelog)}`
        // }

        // console.log("TimeSeries:drawChart : tooltip:formatter : ", this, this.points);

        function getRow(points) {
          if (!points.length) 
            return '';
          let label;
          let data;
          // if (options.timeseries && options.timeseries.fields) {
          //   label = points[0].series.name;
          //   const formatter = formatters[options.timeseries.fields[0]];
          //   if (formatter) {
          //     data = formatter(points[0].point.y);
          //   } else {
          //     data = points[0].point.y.toFixed(1);
          //   }
          // } 
          // else {
          //   const [median] = points;
          //   label = `Median ${median.series.name}`;
          //   data = median.point.y.toFixed(1);
          // }

          label = points[0].series.name;
          data = points[0].point.y.toFixed(1);

          const metric = new Metric(options, data);
          return `<td>
            <p style="text-transform: uppercase; font-size: 10px;">
              ${label}
            </p>
            <p style="color: ${points[0].series.color}; font-size: 20px;">
              ${metric.toString()}
            </p>
          </td>`;
        }

        // const desktop = this.points.filter(o => o.series.name == 'Desktop');
        // const mobile = this.points.filter(o => o.series.name == 'Mobile');

        let rows = "";
        for ( let point of this.points ) {
          // assumption is that we have a single point per series/line we're drawing here
          rows += getRow([point])
        }

        // console.log(rows);

        return `${tooltip}
        <table cellpadding="5" style="text-align: center;">
          <tr>
            ${rows}
          </tr>
        </table>`;
        // ${getChangelog(changelog)}`;
      }
    },
    rangeSelector: {
      buttons: [{
        type: 'month',
        count: 1,
        text: '1m'
      }, {
        type: 'month',
        count: 3,
        text: '3m'
      }, {
        type: 'month',
        count: 6,
        text: '6m'
      }, {
        type: 'ytd',
        text: 'YTD'
      }, {
        type: 'year',
        count: 1,
        text: '1y'
      }, {
        type: 'year',
        count: 3,
        text: '3y'
      }, {
        type: 'all',
        text: 'All'
      }]
    },
    xAxis: {
      type: 'datetime',
      events: {
        // setExtremes: e => redrawTimeseriesTable[options.metric]([e.min, e.max])
      },
      min: options.min,
      max: options.max
    },
    yAxis: {
      title: {
        text: `${options.name}${options.redundant ? '' : ` (${options.type})`}`
      },
      opposite: false,
      min: 0,
      max: options.yMax ? options.yMax : null,
      endOnTick: true
    },
    series,
    // credits: {
    //   text: 'highcharts.com',
    //   href: 'http://highcharts.com'
    // },
    // exporting: {
    //   menuItemDefinitions: {
    //     showQuery: {
    //       onclick: function() {
    //         // const {metric, type} = this.options;
    //         // const url = getQueryUrl(metric, type);
    //         // if (!url) {
    //         //   console.warn(`Unable to get query URL for metric "${metric}" and chart type "${type}".`)
    //         //   return;
    //         // }
    //         // window.open(url, '_blank');
    //         alert("Query showing is not yet supported!");
    //       },
    //       text: 'Show Query'
    //     }
    //   },
    //   buttons: {
    //     contextButton: {
    //       menuItems: ['showQuery', 'downloadPNG']
    //     }
    //   }
    // }
  });

  chart.drawBenchmark = (name, value, color) => {
    chart.yAxis[0].update({
      plotLines: [{
        value,
        color,
        dashStyle: 'dash',
        width: 2,
        label: {
          text: name
        }
      }]
    });
  };
  window.charts = window.charts || {};
  window.charts[options.metric] = chart;
}

const prettyDate = (YYYY_MM_DD) => {
  const [YYYY, MM, DD] = YYYY_MM_DD.split('_');
  const d = new Date(Date.UTC(YYYY, MM - 1, DD));
  return getFullDate(d);
};

const DEFAULT_FIELDS = ['p10', 'p25', 'p50', 'p75', 'p90'];
const DEFAULT_COLS = ['date', 'client'];
const toFixed = value => parseFloat(value).toFixed(1);
const formatters = {
  date: prettyDate,
  p10: toFixed,
  p25: toFixed,
  p50: toFixed,
  p75: toFixed,
  p90: toFixed,
  percent: toFixed,
  urls: value => parseInt(value).toLocaleString()
};

// const zip = data => {
//   const dates = {};
//   data.forEach(o => {
//     let row = dates[o.timestamp];
//     if (row) {
//       row.push(o);
//       row.sort((a, b) => a.client == 'desktop' ? -1 : 1)
//       return;
//     }
//     dates[o.timestamp] = [o];
//   });
//   return Object.entries(dates).sort(([a], [b]) => a > b ? -1 : 1);
// };

// const toRow = (o, i, n, cols) => {
//   const row = el('tr');
//   cols.map(col => {
//     const td = el('td');
//     let text = o[col];
//     const formatter = formatters[col];
//     if (formatter) {
//       text = formatter(o[col]);
//     }
//     td.textContent = text;
//     return td;
//   }).forEach(td => td && row.appendChild(td));
//   return row;
// };

// export default {
//   timeseriesFromData: timeseriesFromData,
//   timeseriesFromURL: timeseriesFromURL,
//   Colors: Colors
// };


// module.exports = {
//   timeseriesFromData: timeseriesFromData,
//   timeseriesFromURL: timeseriesFromURL,
//   Colors: Colors
// };

export {
  timeseriesFromDataWithDefaults as fromDataWithDefaults,
  timeseriesFromData as fromData,
  timeseriesFromURL as fromURL,
  Colors
}
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

function timeseriesFromData(data, metric, options, start, end){
  let [YYYY, MM, DD] = start.split('_');
  options.min = Date.UTC(YYYY, MM - 1, DD);
  [YYYY, MM, DD] = end.split('_');
  options.max = Date.UTC(YYYY, MM - 1, DD);

  // Ensure null values are filtered out.
  data = data.filter(o => getUnformattedPrimaryMetric(o, options) !== null);

  drawTimeseries(data, options);
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
      zoomType: 'x'
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
        function getChangelog(changelog) {
          if (!changelog) return '';
          return `<p class="changelog">${changelog.title}</p>`;
        }

        const changelog = flags[this.x];
        const tooltip = `<p style="font-size: smaller; text-align: center;">${Highcharts.dateFormat('%b %e, %Y', this.x)}</p>`;

        // Handle changelog tooltips first.
        if (!this.points) {
          return `${tooltip} ${getChangelog(changelog)}`
        }

        function getRow(points) {
          if (!points.length) return '';
          let label;
          let data;
          if (options.timeseries && options.timeseries.fields) {
            label = points[0].series.name;
            const formatter = formatters[options.timeseries.fields[0]];
            if (formatter) {
              data = formatter(points[0].point.y);
            } else {
              data = points[0].point.y.toFixed(1);
            }
          } else {
            const [median] = points;
            label = `Median ${median.series.name}`;
            data = median.point.y.toFixed(1);
          }
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
        const desktop = this.points.filter(o => o.series.name == 'Desktop');
        const mobile = this.points.filter(o => o.series.name == 'Mobile');
        return `${tooltip}
        <table cellpadding="5" style="text-align: center;">
          <tr>
            ${getRow(desktop)}
            ${getRow(mobile)}
          </tr>
        </table>
        ${getChangelog(changelog)}`;
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
    credits: {
      text: 'highcharts.com',
      href: 'http://highcharts.com'
    },
    exporting: {
      menuItemDefinitions: {
        showQuery: {
          onclick: function() {
            // const {metric, type} = this.options;
            // const url = getQueryUrl(metric, type);
            // if (!url) {
            //   console.warn(`Unable to get query URL for metric "${metric}" and chart type "${type}".`)
            //   return;
            // }
            // window.open(url, '_blank');
            alert("Query showing is not yet supported!");
          },
          text: 'Show Query'
        }
      },
      buttons: {
        contextButton: {
          menuItems: ['showQuery', 'downloadPNG']
        }
      }
      }
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
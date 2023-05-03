
function donutFromData(metricName, options){

    // Ensure null values are filtered out.
    // data = data.filter(o => getUnformattedPrimaryMetric(o, options) !== null);

    if ( !options.datapoints || options.datapoints.length == 0 ) {
        console.warn("donutFromData: no datapoints passed to draw!");
        return;
    }

    /*
        Input data in options.datapoints looks like:
        NOTE: we expect the largest value to be first in the array
            [{
                "client": "mobile",
                "date": "2022_09_01",
                "percent": "87.7",
                "metricname": "value 1",
                "timestamp": "1661990400000",
                "color": Colors[0]
            },
            {
                "client": "mobile",
                "date": "2022_09_01",
                "percent": "8.7",
                "metricname": "value 2",
                "timestamp": "1661990400000",
                "color": Colors[1]
            },
            {
                "client": "mobile",
                "date": "2022_09_01",
                "percent": "3.6",
                "metricname": "value 3",
                "timestamp": "1661990400000",
                "color": Colors[2]
            }]

        Output data should look like (using "y" to indicate the percentage value)
            [{
                name: 'Value 1',
                y: 87.7,
                sliced: true,
                selected: true,
                color: Colors[0]
            }, {
                name: 'Value 2',
                y: 8.7,
                color: Colors[1]
            }, {
                name: 'Value 3',
                y: 3.6,
                color: Colors[2]
            }]
    */

     // percent, p50/p75/p90, etc. to select the input data field we want to plot in the donut chart
     // TODO :refactor by having descriptionKey for "metricName" and valueKey for "valueFieldName"
    const valueFieldName = options.datapointFieldname || "percent";

    const datapoints = options.datapoints.map( (datapoint) => {
        return {
            name: datapoint[metricName],
            y: parseFloat( datapoint[valueFieldName] ),
            color: datapoint.color
        }
    });

    // make the largest part of the pie stand out
    datapoints[0].sliced = true;
    datapoints[0].selected = true;

    drawDonut(options, datapoints);
}

function drawDonut(options, inputData) {

    const chart = Highcharts.chart(options.chartId, {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: options.name,
            align: 'center'
        },
        tooltip: {
            pointFormat: '<b>{point.percentage:.1f}%</b>'
        },
        accessibility: {
            point: {
                valueSuffix: '%'
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            name: '',
            colorByPoint: true,
            data: inputData
        }]
    });



    // const chart = Highcharts.stockChart(options.chartId, {
    //     metric: options.metric,
    //     type: 'timeseries',
    //     chart: {
    //       zoomType: 'x'
    //     },
    //     title: {
    //       text: `${options.lens ? `${options.lens.name}: ` : '' }` + `Timeseries of ${options.name}`
    //     },
    //     subtitle: {
    //       text: `Source: <a href="${options.dataArchive.URL}">${options.dataArchive.name}</a>`,
    //       useHTML: true
    //     },
    //     legend: {
    //       enabled: true
    //     },
    //     tooltip: {
    //       crosshairs: true,
    //       shared: true,
    //       useHTML: true,
    //       borderColor: 'rgba(247,247,247,0.85)',
    //       formatter: function() {
    //         function getChangelog(changelog) {
    //           if (!changelog) return '';
    //           return `<p class="changelog">${changelog.title}</p>`;
    //         }
    
    //         const changelog = flags[this.x];
    //         const tooltip = `<p style="font-size: smaller; text-align: center;">${Highcharts.dateFormat('%b %e, %Y', this.x)}</p>`;
    
    //         // Handle changelog tooltips first.
    //         if (!this.points) {
    //           return `${tooltip} ${getChangelog(changelog)}`
    //         }
    
    //         function getRow(points) {
    //           if (!points.length) return '';
    //           let label;
    //           let data;
    //           if (options.timeseries && options.timeseries.fields) {
    //             label = points[0].series.name;
    //             const formatter = formatters[options.timeseries.fields[0]];
    //             if (formatter) {
    //               data = formatter(points[0].point.y);
    //             } else {
    //               data = points[0].point.y.toFixed(1);
    //             }
    //           } else {
    //             const [median] = points;
    //             label = `Median ${median.series.name}`;
    //             data = median.point.y.toFixed(1);
    //           }
    //           const metric = new Metric(options, data);
    //           return `<td>
    //             <p style="text-transform: uppercase; font-size: 10px;">
    //               ${label}
    //             </p>
    //             <p style="color: ${points[0].series.color}; font-size: 20px;">
    //               ${metric.toString()}
    //             </p>
    //           </td>`;
    //         }
    //         const desktop = this.points.filter(o => o.series.name == 'Desktop');
    //         const mobile = this.points.filter(o => o.series.name == 'Mobile');
    //         return `${tooltip}
    //         <table cellpadding="5" style="text-align: center;">
    //           <tr>
    //             ${getRow(desktop)}
    //             ${getRow(mobile)}
    //           </tr>
    //         </table>
    //         ${getChangelog(changelog)}`;
    //       }
    //     },
    //     rangeSelector: {
    //       buttons: [{
    //         type: 'month',
    //         count: 1,
    //         text: '1m'
    //       }, {
    //         type: 'month',
    //         count: 3,
    //         text: '3m'
    //       }, {
    //         type: 'month',
    //         count: 6,
    //         text: '6m'
    //       }, {
    //         type: 'ytd',
    //         text: 'YTD'
    //       }, {
    //         type: 'year',
    //         count: 1,
    //         text: '1y'
    //       }, {
    //         type: 'year',
    //         count: 3,
    //         text: '3y'
    //       }, {
    //         type: 'all',
    //         text: 'All'
    //       }]
    //     },
    //     xAxis: {
    //       type: 'datetime',
    //       events: {
    //         // setExtremes: e => redrawTimeseriesTable[options.metric]([e.min, e.max])
    //       },
    //       min: options.min,
    //       max: options.max
    //     },
    //     yAxis: {
    //       title: {
    //         text: `${options.name}${options.redundant ? '' : ` (${options.type})`}`
    //       },
    //       opposite: false,
    //       min: 0,
    //       max: options.yMax ? options.yMax : null,
    //       endOnTick: true
    //     },
    //     series,
    //     credits: {
    //       text: 'highcharts.com',
    //       href: 'http://highcharts.com'
    //     },
    //     exporting: {
    //       menuItemDefinitions: {
    //         showQuery: {
    //           onclick: function() {
    //             // const {metric, type} = this.options;
    //             // const url = getQueryUrl(metric, type);
    //             // if (!url) {
    //             //   console.warn(`Unable to get query URL for metric "${metric}" and chart type "${type}".`)
    //             //   return;
    //             // }
    //             // window.open(url, '_blank');
    //             alert("Query showing is not yet supported!");
    //           },
    //           text: 'Show Query'
    //         }
    //       },
    //       buttons: {
    //         contextButton: {
    //           menuItems: ['showQuery', 'downloadPNG']
    //         }
    //       }
    //       }
    //   });
    
    //   chart.drawBenchmark = (name, value, color) => {
    //     chart.yAxis[0].update({
    //       plotLines: [{
    //         value,
    //         color,
    //         dashStyle: 'dash',
    //         width: 2,
    //         label: {
    //           text: name
    //         }
    //       }]
    //     });
    //   };
    //   window.charts = window.charts || {};
    //   window.charts[options.metric] = chart;

}

export {
    donutFromData as fromData
}
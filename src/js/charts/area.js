
// both inputs are Array<Array<xCoord,yCoord>>
function retarget( data, groundTruth ) {

    // to have proper stacking, we need identical x-coordinates for all series
    // RUMArchive histograms don't enforce this however, so we need to use one series as "ground truth"
    // and interpolate the data from the other series onto the ground truth's discrete x-coordinates

    // basic algo:
    // - for each x coordinate in the groundTruth, find the next lowest and next highest point in the data
    // - interpolate between lower+higher so you get the correct value for the ground truth x

    let output = [];

    // console.log("Retarget start", data, groundTruth);

    for ( let i = 0; i < groundTruth.length; ++i ){
        const currentX = groundTruth[i][0];

        // start and finish, we can't interpolate, so just re-use values
        if ( i === 0 ) {
            output.push( [  currentX, data[0][1] ] );
            continue;
        }
        else if ( i === groundTruth.length - 1 ) {
            output.push( [  currentX, data[data.length - 1][1] ] );
            continue;
        }

        let currentIndex = Math.min(i, data.length - 1); // assume the 2 arrays are SOMEWHAT aligned, this is a good starting point to start looking
        // ideal situation: x-coords match, just re-use value
        if ( data[currentIndex][0] === currentX ) {
            output.push( [  currentX, data[currentIndex][1] ] );
        }
        else {
            let lowerIndex = Number.MAX_SAFE_INTEGER;
            let higherIndex = -1;
        
            let direction = 0;

            // first find lower
            // 2 options: either the currentIndex is already lower, or it's higher (equal is handled above)
            if ( data[currentIndex][0] < currentX ) {
                lowerIndex = currentIndex;
            }
            else {
                for ( let di = currentIndex; di >= 0; --di ) {
                    if ( data[di][0] < currentX ) {
                        lowerIndex = di;
                        break;
                    }
                }
            }

            // then higher, again 2 options. Either already higher, or it's lower (need to look to the left)
            if ( data[currentIndex][0] > currentX ) {
                higherIndex = currentIndex;
            }
            else {
                for( let di = currentIndex; di <= data.length -1; ++di ){
                    if ( data[di][0] > currentX ) {
                        higherIndex = di;
                        break;
                    }
                }
            }

            // console.log( "remapping", currentX, lowerIndex, higherIndex, data[lowerIndex], data[higherIndex] );
            // console.log( "remapping", currentX, "is between", data[lowerIndex][0], "<", currentX, "<", data[higherIndex][0] );

            // output.push( data[i] ); // TODO: CHANGE!!!
            output.push( [ currentX, data[i][1] ] ); // TODO: calculate actual interpolated data[i]
        }
    }

    return output;
}

function areaFromData(metricName, options){

    // Ensure null values are filtered out.
    // data = data.filter(o => getUnformattedPrimaryMetric(o, options) !== null);

    if ( !options.series || options.series.length == 0 ) {
        console.warn("areaFromData: no series passed to draw!");
        return;
    }

    let series = [ options.series[0] ];

    // console.log("Retargeting", options.series);

    let groundTruth = options.series[0];
    for ( let i = 1; i < options.series.length; ++i ) {
        options.series[i].data = retarget(options.series[i].data, groundTruth.data);
        series.push( options.series[i] );
    }

    // console.log( "histogram data", series );

    Highcharts.chart(options.chartId, {
        chart: {
            type: 'area'
        },
        title: {
            text: options.name
        },
        xAxis: {
            title: {
                text: 'Time To First Byte'
            },
            type: "linear",
            // allowDecimals: false,
            labels: {
                formatter: function () {
                    return this.value; // clean, unformatted number for year
                }
            },
            // max: 4000 // TODO: make dynamic through options!!
        },
        yAxis: {
            title: {
                text: 'Amount of beacons'
            },
            labels: {
                formatter: function () {
                    return this.value / 1000 + 'k';
                }
            }
        },
        plotOptions: {
            area: {
                pointStart: 0,
                stacking: "normal",
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                }
            }
        },
        series: series
    });

}

export {
    areaFromData as fromData
}

class Constants {

    static FORCE_PRODUCTION_DATA = false; // to force getting data from the live site instead of local data when testing

    static get DATA_BASE_URL() {
        if ( !Constants.FORCE_PRODUCTION_DATA && window && window.location && window.location.href.includes("localhost") ) {
            // allow for easy local testing
            // launch a basic python http server in the rum-insights-data dir with `python3 -m http.server 9000`
            return "http://localhost:9000/data-output/";
        }
        else 
            return "/insights/data/";
    }

    static get QUERY_BASE_URL() {
        return "https://github.com/rum-archive/rum-insights-data/blob/main/queries/";
    }

    // queryName is the name of the query as defined in /rum-insights-data/queries/ without .jsonl
    // e.g., devicetype, os_devicetype

    // used to fetch the actual data
    static getDataURL( queryName ) {
        return Constants.DATA_BASE_URL + queryName + ".json";
    }

    // used to point to the query definition file for people who want to inspect the query
    static getQueryURL( queryName ) {
        return Constants.QUERY_BASE_URL + queryName + ".jsonl";
    }

    static getChangeLog() {

        let changelog = [
            {
                "date": "2023_03_07",
                "title": "Changed RageClick histogram logic",
                "desc": "The buckets used for RageClick histograms were different from those of other metrics/timers; this change made them consistent. See https://rumarchive.com/blog/2023-03-16-mpulse-january-data-rage-clicks-change/"
            },
            {
                "date": "2024_04_02",
                "title": "Added minor versions for Safari and iOS",
                "desc": "The USERAGENTVERSION and OSVERSION columns now include the minor versions (so 17.2 instead of just 17) for Safari and iOS respectively. See https://rumarchive.com/blog/2024-05-09-mpulse-april-2024-release-notes-minor-versions/"
            },
        ];

        // changes dates from human readable to UTC timestamp to be usable directly in rendering
        changelog.forEach( entry => {
                entry.timestamp = Constants.dateToTimestamp(entry.date);
            }
        );

        return changelog;
    }

    // date is of the form YYYY_MM_DD and is converted to a UTC timestamp integer
    static dateToTimestamp(date) {
        const [YYYY, MM, DD] = date.split('_');
        return Date.UTC(YYYY, MM - 1, DD);
    }
}

export {
    Constants
}

class Constants {

    static FORCE_PRODUCTION_DATA = false; // to force getting data from the live site instead of local data when testing

    static get DATA_BASE_URL() { 
        if ( !Constants.FORCE_PRODUCTION_DATA && window && window.location && window.location.href.includes("localhost") ) {
            // allow for easy local testing
            // launch a basic python http server in the rum-insights-data dir with `python3 -m http.server 9000`
            return "http://localhost:9000/data-output/";
        }
        else
            return "https://raw.githubusercontent.com/rum-archive/rum-insights-data/main/data-output/";
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
}

export {
    Constants
}
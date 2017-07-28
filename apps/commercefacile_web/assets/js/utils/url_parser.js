export default class URIParser {
    constructor(uri) {
        this.parser = document.createElement("a");
        this.parser.href = uri;
    }

    parse() {
        return this.parser;
    }
}
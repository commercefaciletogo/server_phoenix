export default class Uploader{
    constructor(file, url, startClb, progressClb, doneClb, failClb) {
        this.file = file;
        this.endpoint = url;
        this.sClb = startClb;
        this.pClb = progressClb;
        this.dClb = doneClb;
        this.fClb = failClb;
        this.xhr = new XMLHttpRequest();
        this.formData = new FormData;
    }

    init() {
        this.xhr.open("POST", this.endpoint);
        this.xhr.setRequestHeader("x-csrf-token", window.csrfToken);

        this.xhr.upload.addEventListener("progress", this.pClb);
        
        this.xhr.onloadstart = this.sClb;

        this.xhr.onloadend = e => this.dClb(this.xhr.response);

        // this.xhr.addEventListener("load", e => this.dClb(this.xhr.response), false);
        this.xhr.addEventListener("error", e => this.fClb(this.xhr.response), false);
        this.formData.append("image", this.file);
        this.xhr.send(this.formData);
    }
}
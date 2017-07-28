import $ from 'jquery';
require('imports-loader?define=>false&exports=>false!blueimp-file-upload/js/vendor/jquery.ui.widget.js');
require('imports-loader?define=>false&exports=>false!blueimp-file-upload/js/jquery.iframe-transport.js');
require('imports-loader?define=>false&exports=>false!blueimp-file-upload/js/jquery.fileupload.js');


export default class Uploader{
    constructor(inputEl, url, progressClb, addClb, doneClb, failClb) {
        this.element = $(inputEl);
        this.endpoint = url;
        this.pClb = progressClb;
        this.aClb = addClb;
        this.dClb = doneClb;
        this.fClb = failClb;
    }

    init() {
        return this.element.fileupload({

            url: this.endpoint,
            maxChunkSize: 1048576,
            maxRetries: 3,
            dataType: 'json',
            multipart: false,

            progressall: function (e, data) {
                this.pClb(e, data);
            }.bind(this),
            add: function (e, data) {
                this.aClb(e, data);
            }.bind(this),
            done: function (e, data) {
                this.dClb(e, data);
            }.bind(this),
            fail: function (e, data) {
                this.fClb(e, data);
            }.bind(this)

        }).on('fileuploadchunksend', function (e, data) {
            if (data.uploadedBytes === 3145728 ) return false;
        }).on('fileuploadchunkdone', function (e, data) {});
    }

    upload(files) {
        this.init()
            .fileupload('add', {files});
    }
}
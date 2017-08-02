import ImageCompressor from '../utils/compressor.js';
import URIParser from '../utils/url_parser';
import Uploader from '../utils/xhr_uploader';
import Vue from 'vue';
import { parseURL } from '../utils/helpers';

let loadingBase = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48c3ZnIHdpZHRoPSczOHB4JyBoZWlnaHQ9JzM4cHgnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDEwMCAxMDAiIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaWRZTWlkIiBjbGFzcz0idWlsLWhvdXJnbGFzcyI+PHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEwMCIgaGVpZ2h0PSIxMDAiIGZpbGw9Im5vbmUiIGNsYXNzPSJiayI+PC9yZWN0PjxnPjxwYXRoIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzMzNDQ2ZCIgc3Ryb2tlLXdpZHRoPSI1IiBzdHJva2UtbWl0ZXJsaW1pdD0iMTAiIGQ9Ik01OC40LDUxLjdjLTAuOS0wLjktMS40LTItMS40LTIuM3MwLjUtMC40LDEuNC0xLjQgQzcwLjgsNDMuOCw3OS44LDMwLjUsODAsMTUuNUg3MEgzMEgyMGMwLjIsMTUsOS4yLDI4LjEsMjEuNiwzMi4zYzAuOSwwLjksMS40LDEuMiwxLjQsMS41cy0wLjUsMS42LTEuNCwyLjUgQzI5LjIsNTYuMSwyMC4yLDY5LjUsMjAsODUuNWgxMGg0MGgxMEM3OS44LDY5LjUsNzAuOCw1NS45LDU4LjQsNTEuN3oiIGNsYXNzPSJnbGFzcyI+PC9wYXRoPjxjbGlwUGF0aCBpZD0idWlsLWhvdXJnbGFzcy1jbGlwMSI+PHJlY3QgeD0iMTUiIHk9IjIwIiB3aWR0aD0iNzAiIGhlaWdodD0iMjUiIGNsYXNzPSJjbGlwIj48YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJoZWlnaHQiIGZyb209IjI1IiB0bz0iMCIgZHVyPSIxcyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIHZhbHVlcz0iMjU7MDswIiBrZXlUaW1lcz0iMDswLjU7MSI+PC9hbmltYXRlPjxhbmltYXRlIGF0dHJpYnV0ZU5hbWU9InkiIGZyb209IjIwIiB0bz0iNDUiIGR1cj0iMXMiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiB2YWx1ZXM9IjIwOzQ1OzQ1IiBrZXlUaW1lcz0iMDswLjU7MSI+PC9hbmltYXRlPjwvcmVjdD48L2NsaXBQYXRoPjxjbGlwUGF0aCBpZD0idWlsLWhvdXJnbGFzcy1jbGlwMiI+PHJlY3QgeD0iMTUiIHk9IjU1IiB3aWR0aD0iNzAiIGhlaWdodD0iMjUiIGNsYXNzPSJjbGlwIj48YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJoZWlnaHQiIGZyb209IjAiIHRvPSIyNSIgZHVyPSIxcyIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIHZhbHVlcz0iMDsyNTsyNSIga2V5VGltZXM9IjA7MC41OzEiPjwvYW5pbWF0ZT48YW5pbWF0ZSBhdHRyaWJ1dGVOYW1lPSJ5IiBmcm9tPSI4MCIgdG89IjU1IiBkdXI9IjFzIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgdmFsdWVzPSI4MDs1NTs1NSIga2V5VGltZXM9IjA7MC41OzEiPjwvYW5pbWF0ZT48L3JlY3Q+PC9jbGlwUGF0aD48cGF0aCBkPSJNMjksMjNjMy4xLDExLjQsMTEuMywxOS41LDIxLDE5LjVTNjcuOSwzNC40LDcxLDIzSDI5eiIgY2xpcC1wYXRoPSJ1cmwoI3VpbC1ob3VyZ2xhc3MtY2xpcDEpIiBmaWxsPSIjYTRhY2JlIiBjbGFzcz0ic2FuZCI+PC9wYXRoPjxwYXRoIGQ9Ik03MS42LDc4Yy0zLTExLjYtMTEuNS0yMC0yMS41LTIwcy0xOC41LDguNC0yMS41LDIwSDcxLjZ6IiBjbGlwLXBhdGg9InVybCgjdWlsLWhvdXJnbGFzcy1jbGlwMikiIGZpbGw9IiNhNGFjYmUiIGNsYXNzPSJzYW5kIj48L3BhdGg+PGFuaW1hdGVUcmFuc2Zvcm0gYXR0cmlidXRlTmFtZT0idHJhbnNmb3JtIiB0eXBlPSJyb3RhdGUiIGZyb209IjAgNTAgNTAiIHRvPSIxODAgNTAgNTAiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBkdXI9IjFzIiB2YWx1ZXM9IjAgNTAgNTA7MCA1MCA1MDsxODAgNTAgNTAiIGtleVRpbWVzPSIwOzAuNzsxIj48L2FuaW1hdGVUcmFuc2Zvcm0+PC9nPjwvc3ZnPg=="

Vue.component('i-u-p', {
    template: "#imagePreviewTemplate",
    data(){
        return {
            compressedImage: {},
            uploadedInfo: {
                reference: null,
                url: null
            },
            inProgressClass: "is-busy",
            failedClass: "is-danger",
            successClass: "is-success",
            progressPercentage: 0,
            inProgress: true,
            failed: false,
            success: false,
            thumbnail: loadingBase,
            loading: loadingBase
        }
    },
    props: ["image"],
    computed: {
        inputValue(){
            return `images[${this.uploadedInfo.reference}]`;
        },
        showDelete() {
            return !this.inProgress;
        },
        progressClass() {
            if (this.inProgress) {
                return this.inProgressClass;    
            }
            if (this.success) {
                return this.successClass;
            }
            if (this.failed) {
                return this.failedClass;
            }
        }
    },
    methods: {
        onUploadStartClb(e) { 
            this.$emit("busy", true);
            this.inProgress = true;
            this.failed = false;
            this.success = false;

            console.log("start uploading... -> ");
        },
        progressClb(e) {
            console.log(e);
            this.inProgress = true;
            this.failed = false;
            this.success = false;

            if (e.lengthComputable) {
                let progress = parseInt(e.loaded / e.total * 100, 10);
                console.log("uploading... -> ", progress);
                console.log(e.loaded+  " / " + e.total)
                this.$set(this, "progressPercentage", progress);   
            }
        },
        doneClb(e) {
            this.inProgress = false;
            let response = JSON.parse(e);
            if (response.code === 200) {
                this.success = true;
                this.failed = false;

                this.$set(this, "thumbnail", this.compressedImage.base64);
                this.$set(this.uploadedInfo, "reference", response.data.filename);
                this.$set(this.uploadedInfo, "url", response.data.url);
                this.$emit("busy", false);
            }
        },
        failClb(e) {
            this.inProgress = false;
            this.failed = true;
            this.success = false;
            this.$set(this, "progressPercentage", 100);

            console.log("uploading failed -> ", e);
            this.$emit("busy", false);
        },
        doneCompressingClb({ compressed }) {
            console.log(compressed);
            console.log(this.image);
            this.$set(this, "compressedImage", compressed)
            this.upload(compressed.file);
        },
        remove() {
            this.$set(this, "thumbnail", this.loading);
            this.$emit("busy", true);
            if (this.failed) {
                this.$emit("remove", { id: this.image.name, scope: "client" });
                return this.$emit("busy", false);
            }

            this.inProgress = true;
            this.failed = false;
            this.success = false;

            let fd = new FormData
            fd.append("url", this.uploadedInfo.url);
            fd.append("edit_mode", window.editMode);

            let request = new XMLHttpRequest();
            request.open('DELETE', `${window.uploadUrl}/${this.uploadedInfo.reference}`);
            request.setRequestHeader("x-csrf-token", window.csrfToken);
            request.onload = () => { 
                let body = JSON.parse(request.response);
                if (body.code === 200) {
                    this.$emit("remove", { id: this.image.name, scope: "client" });
                    this.$emit("busy", true);
                }
            };
            request.send(fd);
        },
        compress(image) {
            let compressor = new ImageCompressor(image, document.createElement('canvas'), this.doneCompressingClb);
            compressor.compress();
        },
        upload(image) {
            let uploader = new Uploader(image, window.uploadUrl,this.onUploadStartClb, this.progressClb, this.doneClb, this.failClb);
            uploader.init();
        },
        retry() {
            this.reset();
            this.upload(this.compressedImage.file);
        },
        reset() {
            this.inProgress = true;
            this.failed = false;
            this.success = false;
            this.$set(this, "progressPercentage", 0);
        }
    },
    mounted() {
        this.compress(this.image);
    }
});

Vue.component("s-i", {
    template: "#sessionImageTemplate",
    data() { 
        return {
            loading: loadingBase,
            busy: false
        };
    },
    props: ["url"],
    computed: {
        inputValue() {
            return `images[${this.path}]`;
        },
        imageUrl() {
            return this.busy ? this.loading : this.url;
        },
        path() {
            return parseURL(this.url).file
        }
    },
    methods: {
        remove() {
            this.$set(this, "busy", true);
            this.$emit("busy", true);

            let fd = new FormData
            fd.append("url", this.url);
            fd.append("edit_mode", window.editMode);

            let request = new XMLHttpRequest();
            request.open('DELETE', `${window.uploadUrl}/${this.path}`);
            request.setRequestHeader("x-csrf-token", window.csrfToken);
            request.onload = () => { 
                let body = JSON.parse(request.response);
                if (body.code === 200) {
                    this.$emit("remove", { id: this.url, scope: "session" });
                    this.$set(this, "busy", false);
                    this.$emit("busy", false);
                }
            };
            request.send(fd);
        }
    }
});

new Vue({
    el: "#adImages",
    data: {
        sessionImages: window.sessionImages,
        images: [],
        busy: false
    },
    computed: {
        moreImages() {
            return this.sessionImages.length + this.images.length < 4;
        },
        noImage() {
            return this.sessionImages.length + this.images.length < 1;
        }
    },
    methods: {
        addImage() {
            let files = document.getElementById("adImageInput").files;
            // [...files].map(file => {
            //     this.images.push(file);
            //     if (!this.moreImages) return;
            // })
            this.$set(this, "images", [...this.images, ...files]);
            // this.images.push(files[0]);
        },
        removeImage({ id: name, scope: scope }) {
            if (scope === "session") {
                let images = this.sessionImages.filter(url => {
                    return url !== name
                });
                this.$set(this, 'sessionImages', images);
            } else {
                let images = this.images.filter(image => {
                    return image.name !== name
                });
                this.$set(this, 'images', images);
            }
        },
        updateSubmissionStatus(busy) {
            this.$set(this, "busy", busy);
        }
    },
    mounted() {
        console.log('form mounted');
    }
});
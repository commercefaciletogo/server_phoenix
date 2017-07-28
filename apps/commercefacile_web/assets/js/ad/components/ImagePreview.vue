<template>
    <div class="field is-horizontal">
        <div class="field-label">
            <input type="text" hidden :name="inputValue">
        </div>
        <div class="field-body">
            <div class="column is-12">
                <div class="box" style="padding: .25rem; border-radius: 3px; position: relative;">
                    <a @click="remove" style="position: absolute; top: -5px; right: -5px; background: #ff3860;" class="delete is-danger"></a>
                    <article class="media">
                        <div class="media-left">
                            <div class="ad-image-preview-wrapper">
                                <img :src="preview">
                            </div>
                        </div>
                        <div class="media-content">
                            <div class="content">
                                <p>
                                    <small v-text="image.name"></small>
                                </p>
                            </div>
                            <nav class="level is-mobile">
                                <progress class="progress is-small" value="15" max="100">15%</progress>
                            </nav>
                        </div>
                    </article>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/babel">
    import Uploader from '../../utils/uploader.js';

    export default {
        data(){
            return {

            }
        },
        porps: ["image"],
        computed: {
            preview(){
                return "";
            },
            inputValud(){
                return "";
            }
        },
        methods: {
            progressClb(e, data){},
            addClb(e, data){},
            doneClb(e, data){},
            failClb(e, data){},
            remove(){
                console.log("removing...");
            }
        },
        mounted(){
            let el = document.getElementById("adForm");
            let imageList = [this.image];

            let uploader = new Uploader(el, imageList, "", this.progressClb, this.addClb, this.doneClb, this.failClb);
            uploader.init();
        }
    }
</script>
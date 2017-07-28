export default class Map { 
    constructor(mapRegions, onHover, onClick) {
        this.regions = mapRegions;
        this.hoverCb = onHover;
        this.clickCb = onClick;
    }

    create() {
        const that = this;
        for (let i = 0; i <= this.regions.length; i++) {
            let el = this.regions[i];
            if (!el) return;
            
            el.attr({
                'stroke-width': '2',
                'stroke': '#fff',
                'fill': '#1d305d'
            });
            
            el.mouseover(function (e) {
                this.toFront();
                this.attr({
                    cursor: 'pointer'
                });
                this.animate({
                    transform: 's1.05',
                    fill: '#e8eaee'
                }, 200);
                that.hoverCb(e, {name: this.data('name'), id: this.data('id')});
            });

            el.mouseout(function (e) {
                this.animate({
                    transform: 's1',
                    fill: '#1d305d'
                }, 200);                
            });

            el.click(function (e) {
                this.animate({
                    transform: 's1',
                    fill: '#f79520'
                }, 200);
                that.clickCb(e, {name: this.data('name'), id: this.data('id')});
            });
        }
    }
}
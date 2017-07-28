var rsr = Raphael('beninMap', '300', '684.2');

var BEBOR = rsr.path("M300,195.2l-36.9,4.6l-23.5,5.3l-23.5,2.2l-14.3-3.3l-5.3-0.2l-15.6,2.4l-15.3-1.3l-5,1l-4.9,0.4 l-5.1,1.4h-4.7l-2.1,1.4l-0.6,0.6l-2.4,3.6l-1.2,2.4l-0.6,1.8l-0.2,1.6l0.1,1.7l0.5,1.7l0.6,0.9l2.5,2.6l1.1,1.7l1.5,4.3l0.3,1.7 l1.4,5.1l0.8,7.9l-0.1,2.2l-0.2,1.4l-1.7,2l-0.9,0.5l-3.9,1.6l-1.6,0.4l-5.3,0.2l-1,0.3l-2,1.4l-0.8,1.1l-0.5,1.9l0.5,2.1l0.8,2.2 l-1.3,2.9l0.9,5.4v2.2l-0.8,3.2l-0.8,5.9l-0.1,1.9l0.1,1.4l1.9,6.2l0.2,0.5l1.3,2.3l2,2.4l1.6,1.6l0.9,2v1.6l-3.8,28.5l-0.4,1.5 l-0.4,0.6l-1.4,1.2l-1.1,0.3l-3.7-0.1l-2.3,0.2l-1.6,0.3l-2.1,1.4l-1.4,4.8l-0.5,3.7l-0.1,6.3l0.3,3.5l0.4,2.4l0.7,1.5l0.6,0.9 l1.8,1.7l2.9,1.6l1.1,1.6l0.2,0.8l-0.2,1.4l-0.8,2.3l-0.6,2.7l-0.7,5.1l-0.2,5.5l0.2,1.8l0.5,2.3l1.3,2.6l0.7,0.8l1.7,1.4l2,1.1 l9.8,3.1l1.5,1.2l-0.8,3.9l51.6,0.6h0v-1.3l0.5-0.8l1.7-0.8l0.5-0.6l0.1-1l-0.5-1.7l-0.1-1l0.4-1.7l1.2-3.2v-1.7l-0.4-0.8l-0.9-0.5 l-0.2-0.9l0.2-0.2l1.4-2.6l0.5-3l0.2-7l-0.3-2.9l7.5,0.7l1.3-0.2l0.9-0.8l0.8-1l1-0.8l1.1-0.2l3-0.1l1.1,0.2l1.1,0.6l1,0.7l1,0.5 h1.1l6.7-2l2.4-1.9l1.5-3.5l3.2-11.4l2-4.3l0.6-2.3v-7.2l-0.3-1.9l-1.2-3.5l-0.7-3.1l0.4-3.1l1.9-3.4l0.7-0.6l1.6-0.6l0.7-0.7 l5.9-8.8l0.1-0.6l-0.5-1.4l-0.1-0.8l0.8-2.7l1.6-0.5l1.9,0.4l1.7,0.1l3.2-2l0.7-2.9l-0.8-3.4l-1.2-3.4l-0.4-2.2l0.2-2.5l0.9-2.2 l1.6-1.3l7-3.2l3.8-1.1l5.9,0.7l1.7-1.8l2.6-5.3l3.2-4.3l1-2.2l0.6-9.5l0.6-1.8l1.5-1.6l1.4-0.8l1.2-1l0.9-2.4l0.4-2.6l-0.3-1.7 l-0.9-1.4l-6.7-7.7l-1.4-2.6l-0.1-2.1l2-5l2.4-4.3l0.4-1.3l0.1-2.2l0.9-1.7l1.9-2.1l1.9-0.7l2.1,0.4l6.2,3.7l1.5-0.2l1.5-2.1l0.7-2 l0.1-5.7l0.9-2.9l2.5-5.6l0.7-3L300,195.2z"); 
BEBOR.attr({ id: 'BE.BOR', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEBOR', 'name': '' });

var BEALI = rsr.path("M122.2,106.4l0.5,0.6l19,38.2l4.8,7.7l0.9,0.1l1.2,0.2l3.7,2l3.2,3.5l-5.8,5.4l-1.9,2.5l-1,1.9 l-0.4,1.4l-0.2,1.8l0.6,35.3l-1.1,0.7h4.7l5.1-1.4l4.9-0.4l5-1l15.3,1.3l15.6-2.4l5.3,0.2l14.3,3.3l23.5-2.2l23.5-5.3l36.9-4.6v-2.7 l-0.5-3.2l-0.9-2.1l-1.3-0.8l-1.4-0.3l-1.2-0.5l-0.9-1.2l-0.9-3.6l-0.5-1.2l-0.8-0.9l-1.7-1.7l-0.5-1.3l0.1-1.9l2.1-5.9l0.1-3.2 l-3-11.8l-0.8-2l-0.4-2.2v-2.4l1-4.3l-0.8-0.9L286,141l-0.8-0.2l-2.4-2.5l-17.6-27.6l-1.4-3l-0.2-2.6l1.9-6l0.6-1.7l1.1-5l6.7-12.9 l2.1-2.5l-0.7-0.6l-0.9-1.8l-0.8-0.5l-0.5-1.8l-0.4-0.9l-0.5-1.7l-0.4-0.9l-1.7-1.5l-3.3-5.2l-0.8-0.8l-1.1-0.8l-3.5-1.4l-4.4-3 l-1.1-0.4l-1.1-0.7l-1.1-0.2l-1.4,0.9l-1.3,0.7l-1.4-0.4l-1.2-0.9l-0.8-0.9l-1.4-1.8l-2.2-4.2l-0.7-2l-0.5-2.5l-0.2-2.4l-0.3-0.6 l-1.3-1.1l-0.3-0.6l-16.8-17.1l-4-6.5l-1-2l-0.4-0.6l-0.8-0.3l-3.2-0.4l-1.1-0.5l-1.1-0.6l-0.8-0.9l-0.6-2.5l-0.8-1.4l-1-1.2l-2-1.2 L202.7-1l-1.2,1.7l-2.3,0.1l-1,0.2l-2-0.1l-1,0.2L194.3,2l-1.6,2.1l-0.9,0.8l-1,0.3l-1-0.8l-1.1,0.5l-0.5,0.6L187.4,8l-1.4,2.4 l-0.9,0.6l-3.5-1l-0.7,0.2l-1.2,1l-0.6,0.3l-0.5-0.1l-1.2-0.6l-3.5,1.1l-1.3,1.3l-0.5,0.4l-0.8,0.1l-0.7-1.4l-2-0.2l-0.7,0.3 l-0.5,1.4l-0.6,1.1l-0.5-0.2l-0.5-0.6l-0.8-0.2l-0.5,0.4l-1.1,1.5l-1.2,0.2l-2.3-0.1l-1.3,0.2l-2.4,1.2l-0.8,2l0.1,2.5l1,6.2 l3.3,10.4l0.5,1.1l0.7,0.9l1,0.9l1.1,0.5l0.9,0.2l0.6,0.5l0.2,1.4l-0.1,1.9l-0.7,0.2l-1-0.4l-1,0.1l-0.7,0.8l-0.8,1.6l-0.7,0.8 l-0.8,0.3l-0.9-0.2l-0.8,0.2l-0.5,1.4l0.1,1.2l1.1,1.9l0.2,1.1l-3.5,10.7l-1.4,2.9l-3.8,4.7l-1,3.1l-0.1,2l0.1,1.2l-0.4,1.1 l-1.4,1.4l-5.2,3.3l-7.1,6.5L122.2,106.4z"); 
BEALI.attr({ id: 'BE.ALI', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEALI', 'name': '' });

var BECOL = rsr.path("M140.2,400.8l-0.7,3.5l0.9,1.3l0.7,1.5l1.6,9.9l-1.3,9.5l0.7,2.7l0.6,0.6l-0.8,1.3l-3.4,2.4 l-1.7,0.5l-2.3,0.1l-1.2-0.2l-2.7-1.1l-1.2-0.2h-2.4l-1-0.3l-1.5-1.3l-2.9-1l-1.8-1.2l-0.7-0.8l-1.4-2.1l-1.2-0.9l-0.6-0.1h-3 l-1.1-0.3l-1.4-0.8l-2.6-3.2l-1.6-1.3l-1.7-0.7l-1.2,0.1l-1.6,0.3l-8.5,2.6l-3.5,0.3l-5.3-0.2l-1.8-0.2l0.1,3.3l0.1,1.3l0.5,1.3 l2.5,3.6l0.4,1.1l-0.4,2l-3.2,6l-0.2,0.9v1.9l-0.5,2.7l0.9,0.7l0.5,1l1.1,9.5l-0.4,30.4l0.2,39.6v2l1.9,0.2l19.7-1.3l4.4,1.1 l5.3,2.5l3.7,3.7l3.7,2.9l4.6,0.9l5.2-0.2l5.7,0.6l6.9,2.5l17.5,9l-0.7-2.8l-0.3-2.6l1.1-2.4l3.1-4.9l1-0.7l1.4-0.5l0.2-1.2 l-0.7-2.9l0.2-3.2l1.5-4.6l1.3-0.1l20.2,0.2l0.9-14.9l-0.3-1.6l-0.9-1.6l-2.4-2.9l-1.1-3.2l-0.8-1.4l0.1-1.8l1-2.1l0.4-1l0.4-7 l1.2-7l0.2-6.6l0.3-2l0.8-1.9l1-1.8l0.8-2l0.1-2.4l-0.7-2.4l-1.9-4.6l-0.8-2.5l-0.4-2.6l0.1-2.1l0.7-4.6v-1.1l-0.2-2v-1l0.5-1.4 l2-2.5l0.8-1.3l0.8-3.8l-0.2-3.2l-2-27h0L140.2,400.8z"); 
BECOL.attr({ id: 'BE.COL', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BECOL', 'name': '' });

var BEATL = rsr.path("M168.7,660.7l0.4-2.7l-0.4-5l-1.2-0.9l-1.5-0.7l-1.1-2.2l-0.7-10.1l-0.5-15.2l-0.3-6.4l-1-4.5 l-3.4-6.2l-29.4,0.2l0.9,2.7l-0.5,1.7l-0.6,1.3l-1.5,4.4l-0.5,1l-0.8,1.1l-1.4,2.8l-0.3,1.1l-0.2,0.9l0.2,1.4l0.1,2.2l-1.3,3 l-0.5,2.9l0.1,2l-0.4,2l-2.1,3l-0.3,0.9l-0.1,1.1l0.1,3l0.3,6.3l-0.1,2.3l-0.3,1.3l-2.7,7.8l-0.5,2.3l0.3,3.5l1.5,2.5l0.8,2.9l0.3,2 v1l23.4-3l7.8-2l5.2-0.5l0.9-2.7l1.2-1.3l1.7-1.3l2.1-0.7l4.6-0.6L168.7,660.7z"); 
BEATL.attr({ id: 'BE.ATL', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEATL', 'name': '' }); 

var BELIT = rsr.path("M167.2,664.9l-4.6,0.6l-2.1,0.7l-1.7,1.3l-1.2,1.3l-0.9,2.7l12.1-1.3l-0.2-1.9l-1-0.4l-0.8-0.7 L167.2,664.9z"); 
BELIT.attr({ id: 'BE.LIT', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEATA', 'name': '' }); 

var BEKOU = rsr.path("M128.9,606.2l-1.6,1l-1,0.5l-0.6-0.1l-0.9-0.4l-3.3-2.8l-0.8-1.1l-0.5-2l-1.3-2.3l-1.6-0.9 l-1.6-2.5l-2-3.5l-1.6-1.4l-1.2-0.8l-1.2-2.3l-0.9-4.8l-1.3-5.2l-1.5-2.9l-1.2-0.9l-0.8-1.9l-3.8-5.5l-1.5-1.3l-0.8-1.1l-0.4-0.9 l-0.2-2.1l-0.2-0.8l-0.9-1.8l-0.6-2.9l-5.1-12.3l-0.8-1.4l-2.1-2.9l-3.2-0.7l0.1,10.9l0.2,48.9l-1.8,0.6l-7.4-0.1l1.9,7.9l2.7,3.2 l0.9,1.2l0.2,1.5l-0.8,4.7l0.1,1.9l0.4,1.9l0.8,2.3l0.6,2.7l-0.4,1.7l-0.8,1.2L87,632l1.7,0.2h2.1l9.2-2.4l6.2-2.6l5.3-1.3l3.3,0.2 l3,1l6,3.4l1.3-3l-0.1-2.2l-0.2-1.4l0.2-0.9l0.3-1.1l1.4-2.8l0.8-1.1l0.5-1l1.5-4.4l0.6-1.3l0.5-1.7l-0.9-2.7L128.9,606.2z"); 
BEKOU.attr({ id: 'BE.KOU', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEKOU', 'name': '' });

var BEOUE = rsr.path("M166.1,598.6l-2.7,0.3l-1.6,0.9l-1.6,2.4l-1.1,2.2l-0.2,2.3l3.4,6.2l1,4.5l0.3,6.4l0.5,15.2 l0.7,10.1l1.1,2.2l1.5,0.7l1.2,0.9l0.4,5l-0.4,2.7l-1.5,4.3l-0.3,2.3l0.8,0.7l1,0.4l0.2,1.9l21.5-2.3h0v-6.8l1.1-7.2l0.3-1.1 l-3.8-7.3l-1.5-1.8l-4.7-4.5l-1.9-3.5l-2-13l-4.7-12.8l-1-5.6l0.2-5.6L166.1,598.6z");
BEOUE.attr({ id: 'BE.OUE', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEOUE', 'name': '' });

var BEZOU = rsr.path("M145.6,541.6l-6.9-2.5l-5.7-0.6l-5.2,0.2l-4.6-0.9l-3.7-2.9l-3.7-3.7l-5.3-2.5l-4.4-1.1l-19.7,1.3 l-1.9-0.2v9.5l3.2,0.7l2.1,2.9l0.8,1.4l5.1,12.3l0.6,2.9l0.9,1.8l0.2,0.8l0.2,2.1l0.4,0.9l0.8,1.1l1.5,1.3l3.8,5.5l0.8,1.9l1.2,0.9 l1.5,2.9l1.3,5.2l0.9,4.8l1.2,2.3l1.2,0.8l1.6,1.4l2,3.5l1.6,2.5l1.6,0.9l1.3,2.3l0.5,2l0.8,1.1l3.3,2.8l0.9,0.4l0.6,0.1l1-0.5 l1.6-1l0.7,0.7l29.4-0.2l0.2-2.3l1.1-2.2l1.6-2.4l1.6-0.9l2.7-0.3l6.1,0.1l1.9,0.2l1.7-0.4l0.3-0.6l-0.5-5l-2.2-12.3l0.1-2.5 l-0.6-0.7l-4.6-3.6l-1.5-3.7l-1.9-7.9v-1.7l-0.5-1.1l-0.5-0.8l-0.4-1v-5l-0.5-2.1L145.6,541.6z"); 
BEZOU.attr({ id: 'BE.ZOU', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEZOU', 'name': '' });

var BEPLA = rsr.path("M163.1,550.7l0.5,2.1v5l0.4,1l0.5,0.8l0.5,1.1v1.7l1.9,7.9l1.5,3.7l4.6,3.6l0.6,0.7l-0.1,2.5 l2.2,12.3l0.5,5l-0.3,0.6l-1.7,0.4l-1.9-0.2l-0.2,5.6l1,5.6l4.7,12.8l2,13l1.9,3.5l4.7,4.5l1.5,1.8l3.8,7.3l1.8-6l0.2-2.3l-0.8-4.7 v-2.3l1.1-2.4l1.8-1.8l1.2-0.9l0.5-1.3l-0.3-5.1l-0.2-1.1l-0.6-0.5l-1.2-0.1l-1-0.3l-0.8-0.7l-0.8-1.1l-0.5-2.2l0.2-2.4l1.1-4.7 l-0.5-4.7l-1.3-4.3l-0.3-4l2.5-4l1.1-0.6l1.3-0.4l1-0.6l0.4-1.2l-0.6-1.1l-2.6-2.4l-0.8-1.2l-0.4-1.4l0.1-0.8l0.4-0.7l0.9-2.1 l0.8-1.1l0.3-1.1l0.1-1.5l-2.1-27.3l0.2-1.2l0.8-0.5h1l2.1,0.5l0.6-1.8l0.3-4.7l-2.2-4.1l-2.9-3.9l-2-4.1l-0.5-4.4l0.2-3.6 l-20.2-0.2l-1.3,0.1l-1.5,4.6l-0.2,3.2l0.7,2.9l-0.2,1.2l-1.4,0.5l-1,0.7l-3.1,4.9l-1.1,2.4l0.3,2.6L163.1,550.7z");
BEPLA.attr({ id: 'BE.PLA', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEPLA', 'name': '' });

var BEMON = rsr.path("M120.3,677.1v-1l-0.3-2l-0.8-2.9l-1.5-2.5l-0.3-3.5l0.5-2.3l2.7-7.8l0.3-1.3l0.1-2.3l-0.3-6.3 l-0.1-3l0.1-1.1l0.3-0.9l2.1-3l0.4-2l-0.1-2l0.5-2.9l-6-3.4l-3-1l-3.3-0.2l-5.3,1.3l-6.2,2.6l-9.2,2.4h-2.1l-1.7-0.2l-5.7-3.1 l-1.4,2.2l-0.8,2.5l0.6,1.3l1.3,1.1l1.1,2.2l-0.2,2.8l0.3,1.1l0.6,0.9l2.4,2.1l0.9,0.1l1-0.1l0.7,0.3l0.2,1.3l0.2,0.8l1.6,1.5 l0.6,0.9l0.1,1.1l-0.2,2.4l0.2,1l0.7,0.6l2.1,1.2l0.8,0.7l2.5,4.6l3.8,16.5l-2,0.1l-12.6,3.4l-2,1.2l0.7,2.3l25.9-6.8L120.3,677.1z");
BEMON.attr({ id: 'BE.MON', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEMON', 'name': '' });

var BEATA = rsr.path("M121.8,106.9l-2.7,1.4l-3.5-0.3l-4.1-1.8l-2.5-1.4l-1.2-0.2l-0.9,0.7l-1.7-0.6l-1.9,0.4l-3.8,1.7 l-1.8,0.2l-4.3-0.4l-1.5,0.5l-1.9,1l-4.5,1.1l-1.7,1l-1.9,0.8l-2-4.3l-1.7,0.1l0.6-3l-9.2-0.8l-1.9-0.4l-1.6-1l-0.6,1.6l-2.2,1.1 l-1.3,1.1l-0.8,1.3l-0.1,0.9l0.9,2.4l-1.6,1.1l-2.2,1.1l-2,1.4l-0.8,2.1l0.6,1.9l0.9,1.5l0.2,1.4l-1.7,1.6l-0.7-0.9l-0.7-0.3 l-0.7,0.3l-0.7,0.9l-0.6-1.2l-1.1-1.4l-1.1-0.6l-0.5,1.4l0.2,0.9l1,1.1l0.2,1.1l-0.2,0.8l-1.2,2.6l-3.2-1.7l-1.6-0.5l-1.8-0.1 l-0.8,0.2l-1,0.6h-0.8l0.1-0.6l-0.8-1.3l-0.9-0.8l-1,1.7l-1,1.1l-0.5,1.4l1.8,3.4l0.4,3.8l0.5,1.9l-1-0.4l-2-1.1h-1.1l-0.4,0.6 l-0.7,2l-0.6,0.5l-3.2,0.8l-0.5,0.2l0.1,1.7l1-0.8l0.9,0.2l0.1,0.5l-0.1,1.9l1.4,0.7L33,144l0.2,2.5l0.6,1.2l1.1,1.3l-0.1,1.8 l-0.3,0.5l-0.7-0.8l-1-1.7l-1-0.4l-3-0.4l-1.4,0.7h-0.6l-0.7-1.3l-2-1.5l-2.1-0.4h-0.9l-0.6,1l-0.6,1.3l-0.8,1.4l-0.3,0.3l-0.1,1.1 l0.1,1.2l0.3,1l0.8,0.4l0.6,0.6l0.1,1.3l-0.2,1.3l-0.4,0.6H18l-1.3-0.2l-3-1.9l-2.5,6.8l-0.3,2.2l0.2,1.2l0.8,2.3l0.2,1.2l-1.5,3.3 l-0.2,1.2l-0.2,2.5l-0.3,1.1l-1.3,2l-5.3,5.7l-1.4,3.7l0.8,10l-0.1,4.3l-1.4,6.2L0,220.2l0.1,2.6l0.8,1.7l7.4,5.6l47.5,35.6l1.3,3.8 v0.8l1.2-0.5l5.5-1.2l4.1,0.2l4.7,0.6l4.2,1.1l6.2,0.8l4.9-1.3l4.1-2.3l3.2-2.9l3.4-2.2l3.7-1.5l27.7,1l-0.5-2.1l0.5-1.9l0.8-1.1 l2-1.4l1-0.3l5.3-0.2l1.6-0.4l3.9-1.6l0.9-0.5l1.7-2l0.2-1.4l0.1-2.2l-0.8-7.9l-1.4-5.1l-0.3-1.7l-1.5-4.3l-1.1-1.7l-2.5-2.6 l-0.6-0.9l-0.5-1.7l-0.1-1.7l0.2-1.6l0.6-1.8l1.2-2.4l2.4-3.6l0.6-0.6l2.1-1.4l1.1-0.7l-0.6-35.3l0.2-1.8l0.4-1.4l1-1.9l1.9-2.5 l5.8-5.4l-3.2-3.5l-3.7-2l-1.2-0.2l-0.9-0.1l-4.8-7.7l-19-38.2l-0.5-0.6L121.8,106.9z");
BEATA.attr({ id: 'BE.ATA', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEATA', 'name': '' });

var BEDON = rsr.path("M102.3,260.7l-3.7,1.5l-3.4,2.2l-3.2,2.9l-4.1,2.3l-4.9,1.3l-6.2-0.8l-4.2-1.1l-4.7-0.6l-4.1-0.2 l-5.5,1.2l-1.2,0.5l0.1,8.2l0.3,20.7l0.8,5.2l-0.4,2.5v2.2l-0.1,1.1l-0.6,1.4l-1.7,3l-0.4,1.4l0.3,2.3l1,2.7l1.4,1.7l1.7-0.9 l1.1,3.2l0.7,11.2l1.4,4.4l2.3,4.1l13.9,16.4l2,4l0.8,2.7l0.5,3l0.5,36.3l0.2,14.9l1.8,0.2l5.3,0.2l3.5-0.3l8.5-2.6l1.6-0.3l1.2-0.1 l1.7,0.7l1.6,1.3l2.6,3.2l1.4,0.8l1.1,0.3h3l0.6,0.1l1.2,0.9l1.4,2.1l0.7,0.8l1.8,1.2l2.9,1l1.5,1.3l1,0.3h2.4l1.2,0.2l2.7,1.1 l1.2,0.2l2.3-0.1l1.7-0.5l3.4-2.4l0.8-1.3l-0.6-0.6l-0.7-2.7l1.3-9.5l-1.6-9.9l-0.7-1.5l-0.9-1.3l0.7-3.5l0.8-3.9l-1.5-1.2l-9.8-3.1 l-2-1.1l-1.7-1.4l-0.7-0.8l-1.3-2.6l-0.5-2.3l-0.2-1.8l0.2-5.5l0.7-5.1l0.6-2.7l0.8-2.3l0.2-1.4l-0.2-0.8l-1.1-1.6l-2.9-1.6 l-1.8-1.7l-0.6-0.9l-0.7-1.5l-0.4-2.4l-0.3-3.5l0.1-6.3l0.5-3.7l1.4-4.8l2.1-1.4l1.6-0.3l2.3-0.2l3.7,0.1l1.1-0.3l1.4-1.2l0.4-0.6 l0.4-1.5l3.8-28.5v-1.6l-0.9-2l-1.6-1.6l-2-2.4l-1.3-2.3l-0.2-0.5l-1.9-6.2l-0.1-1.4l0.1-1.9l0.8-5.9l0.8-3.2v-2.2l-0.9-5.4l1.3-2.9 l-0.8-2.2L102.3,260.7z");
BEDON.attr({ id: 'BE.DON', class: 'st0', 'stroke-width': '0', 'stroke-opacity': '1', 'fill': '#000000' }).data({ 'id': 'BEDON', 'name': '' });

var beninDepartments = [BEALI, BEATA, BEATL, BEBOR, BECOL, BEDON, BEKOU, BELIT, BEMON, BEOUE, BEPLA, BEZOU];

export default beninDepartments;
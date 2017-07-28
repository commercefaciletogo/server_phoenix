import BeninRegions from './maps/benin_fill';
import Map from './maps/map';
import TogoRegions from './maps/togo_blue';

const onHover = (e, { name, id }) => console.log(`hovering on ${name} -> ID: ${id}`);

const onClick = (e, { name, id }) => console.log(`clicking on ${name} -> ID: ${id}`);

let togo = new Map(TogoRegions, onHover, onClick);
togo.create();
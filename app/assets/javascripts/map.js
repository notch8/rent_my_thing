$(document).on ('page:change', function() {

  // Addresses:
  // Red pin: Rental item locations
  // -------------------------------------------
  // 4625 Texas St., San Diego, CA. 92116     || coords: -117.138475,32.761480
  // 2267 Boundary St., San Diego, CA. 92104  || coords: -117.116083,32.729552
  // 4711 Kansas St., San Diego, CA. 92116    || coords: -117.131207,32.763225
  // 3200 6th Ave., San Diego, CA. 92103      || coords: -117.159727,32.739113
  // 1642 7th Ave., San Diego, CA. 92104      || coords: -117.159063,32.722439

  // Green pin: Renter's location
  //-------------------------------------------
  // 3803 Ray Street, San Diego, CA. 92104    || coords: -117.129137,32.747502

  mapAttributes = {'/images/red-pin.png': [[-117.138475,32.761480], [-117.116083,32.729552],[-117.131207,32.763225],[-117.159727,32.739113], [-117.159063,32.722439]],
    '/images/green-pin.png': [[-117.129137,32.747502]]}

  var map_div = $('#map')
  drawMap(mapAttributes);

  function drawMap (mapAttributes) {
    var iconLocations = [];
    var vectorSource = new ol.source.Vector({
     //create empty vector -- not sure if this is needed??????
    });

    // Object.keys(mapAttributes).forEach(function(pinType) {console.log(pinType);
    // mapAttributes[pinType].forEach(function(coords){console.log('show pin at ' + coords[0] + ',' + coords[1])})})

    // Outer Loop to retrieve each pin type
    Object.keys(mapAttributes).forEach(function(pinType) {


      // Loop to retrieve all coordinates associated with each pin type
      mapAttributes[pinType].forEach(function(coords) {

        var iconLocation = ol.proj.transform([coords[0], coords[1]], 'EPSG:4326', 'EPSG:3857')
        iconLocations.push(iconLocation)

        var iconFeature = new ol.Feature({
          geometry: new ol.geom.Point(iconLocation),
        })

        // Create Pin styling
        iconFeature.setStyle(
          new ol.style.Style({
            image: new ol.style.Icon({
              anchor: [0.5, 46],
              anchorXUnits: 'fraction',
              anchorYUnits: 'pixels',
              opacity: 0.75,
              src: pinType  // Set pin type
            })
          })
        )
        vectorSource.addFeature(iconFeature);
      }) // End of inner loop - coords
    }); // End of outer loop - pinType

    // *************Create Vector Layer with Markers and Build Map ***************************
    var vectorLayer = new ol.layer.Vector({
      source: vectorSource
//      style: iconStyle
    });

    map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({
          title: "Rental Proximity Map",
          source: new ol.source.MapQuest({layer: 'osm'})
        }), vectorLayer],
      view: new ol.View({
       center: iconLocations[0],          // ??? Do i need a centering point at this point.
        zoom: 12
      }),
      controls: ol.control.defaults({
        attributionOptions: {
          collapsible: false
        }}).extend([
          new ol.control.ScaleLine()
        ])
    });

    // Bound the map
    var view = map.getView()
    var extent = ol.extent.boundingExtent(iconLocations)
    var size = map.getSize()
    view.fitExtent(extent, size)
    Window.map = map;
  } // End of drawmap function
});

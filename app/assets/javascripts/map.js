$(document).on ('page:change', function() {
  function get_coords(addr, callback) {
    $.ajax({
      url: 'http://nominatim.openstreetmap.org/search',
      data: {q: addr, format: 'json'}})
      .done(function(data) {
        if (data.length === 1) {callback(Number(data[0].lat), Number(data[0].lon))}})
  }
  // Java script to display map http://openlayers.org/en/v3.2.1/doc/quickstart.html
  var map_div = $('#map')
  var vectorSource = new ol.source.Vector({
   //create empty vector
  });
  if (map_div) {
    // addr = map_div.data('address')
      window.RentMyThing.addresses.forEach(function(addr) {
        get_coords(addr, function(lat, lon) {
          var pt = ol.proj.transform([lon, lat], 'EPSG:4326', 'EPSG:3857')
          var rental_loc_icon = new ol.Feature({
            geometry: new ol.geom.Point(pt),
            name: 'Rental Location'
          })

          var pt2 = ol.proj.transform([-117.18, 32.92], 'EPSG:4326', 'EPSG:3857')
          var renter_loc_icon = new ol.Feature({
              geometry: new ol.geom.Point(pt2),
              name: 'Renters Location'
          });

          vectorSource.addFeature(rental_loc_icon);
          vectorSource.addFeature(renter_loc_icon);


          renter_loc_icon.setStyle(
            new ol.style.Style({
              image: new ol.style.Icon({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                opacity: 0.75,
                src: '/images/green-pin.png'
              })
            })
          )

          rental_loc_icon.setStyle(
            new ol.style.Style({
              image: new ol.style.Icon({
                anchor: [0.5, 46],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                opacity: 0.75,
                src: '/images/red-pin.png'
              })
            })
          )
          var vectorLayer = new ol.layer.Vector({
            source: vectorSource,
            // style: iconStyle
          });
          var map = new ol.Map({
            target: 'map',
            layers: [
              new ol.layer.Tile({
                title: "Rental Proximity Map",
                source: new ol.source.MapQuest({layer: 'osm'})
              }), vectorLayer],
            view: new ol.View({
             center: pt,
              zoom: 12
            }),
            controls: ol.control.defaults({
              attributionOptions: {
                collapsible: false
              }}).extend([
                new ol.control.ScaleLine()
              ])
          });
          Window.map = map;
      })
    })
  }
})

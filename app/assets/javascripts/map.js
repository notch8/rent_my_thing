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
    var populabel = "";
    var iconLocations = [];
    var vectorSource = new ol.source.Vector({
     //create empty vector -- not sure if this is needed??????
    });

    // Outer Loop to retrieve each pin type
    Object.keys(mapAttributes).forEach(function(pinType) {


      // Inner Loop to retrieve all coordinates associated with each pin type
      mapAttributes[pinType].forEach(function(coords) {

        var iconLocation = ol.proj.transform([coords[0], coords[1]], 'EPSG:4326', 'EPSG:3857')
        iconLocations.push(iconLocation)
        popupLabel=''
        if (pinType == '/images/red-pin.png') {
          popupLabel = 'Rental Location'
        } else {
          popupLabel = 'Renter Location'
        }
        var iconFeature = new ol.Feature({
          geometry: new ol.geom.Point(iconLocation),
          // Added line for popup
          name: popupLabel
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
          }),
          // for code below http://stackoverflow.com/questions/26519613/openlayers-3-add-movable-marker-with-icon-and-text
          new ol.style.Style({
            text: new ol.style.Text({
              text: "Wow such a label",
              offsetY: -25,
              fill: new ol.style.Fill({
                color: '#fff'
              })
            })
          })
        )
        iconFeature.on('mouseover', function() {alert('hover')})
        vectorSource.addFeature(iconFeature);
      }) // End of inner loop - coords
    }); // End of outer loop - pinType

    // *************Create Vector Layer with Markers and Build Map ***************************
    var vectorLayer = new ol.layer.Vector({
      source: vectorSource
//      style: iconStyle
    });

    var map = new ol.Map({
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
    // ***********************************************
    //  Popup logic
    // http://openlayers.org/en/v3.0.0/examples/icon.js
    // ***********************************************
    var element = $('.popup').first();

    var popup = new ol.Overlay({
      element: element,
      positioning: 'bottom-center',
      stopEvent: false
    });
    map.addOverlay(popup);
    var showing;
    // display popup on click
    map.on('pointermove', function(evt) {
      var feature = map.forEachFeatureAtPixel(evt.pixel,
          function(feature, layer) {
            return feature;
          });
      if (feature) {
        if (! showing) {
          showing = true;
          var name = feature.get('name')
          console.log(" Name = " + name );
          var geometry = feature.getGeometry();
          var coord = geometry.getCoordinates();
          popup.setPosition(coord);

          $(element).attr('data-content', name)
          $(element).popover({
            'placement': 'top',
            'html': true,
            'content': name
          });
          $(element).popover('show');
        }
      } else {
        showing = false;
        $(element).popover('destroy');
      }
    });
    // change mouse cursor when over marker
    // $(map.getViewport()).on('mousemove', function(e) {
    //   var pixel = map.getEventPixel(e.originalEvent);
    //   var hit = map.forEachFeatureAtPixel(pixel, function(feature, layer) {
    //     return true;
    //   });
    //   // With map.getTarget().style.cursor you get an error using the line below corrects this error
    //   // https://groups.google.com/forum/#!topic/geoadmin-api/BKM3ADBQJ1s
    //   var target = document.getElementById(map.getTarget());
    //   target.style.cursor = hit ? 'pointer' : '';
    //   // if (hit) {
    //   //   map.getTarget().style.cursor = 'pointer';
    //   // } else {
    //   //   map.getTarget().style.cursor = '';
    //   // }
    // });

    // change mouse cursor when over marker (option #2)
    map.on('pointermove', function(e) {
      if (e.dragging) {
        $(element).popover('destroy');
        return;
      }
      var pixel = map.getEventPixel(e.originalEvent);
      var hit = map.hasFeatureAtPixel(pixel);
      var target = document.getElementById(map.getTarget());
      target.style.cursor = hit ? 'pointer' : '';
//      map.getTarget().style.cursor = hit ? 'pointer' : '';
    });
  // change mouse cursor when over marker (option #3)
  // var cursorHoverStyle = "pointer";
  // var target = map.getTarget();
  //
  // //target returned might be the DOM element or the ID of this element dependeing on how the map was initialized
  // //either way get a jQuery object for it
  // var jTarget = typeof target === "string" ? $("#"+target) : $(target);
  //
  // map.on("pointermove", function (event) {
  //     var mouseCoordInMapPixels = [event.originalEvent.offsetX, event.originalEvent.offsetY];
  //
  //     //detect feature at mouse coords
  //     var hit = map.forEachFeatureAtPixel(mouseCoordInMapPixels, function (feature, layer) {
  //         return true;
  //     });
  //
  //     if (hit) {
  //         jTarget.css("cursor", cursorHoverStyle);
  //     } else {
  //         jTarget.css("cursor", "");
  //     }
  // });

  } // End of drawmap function
});

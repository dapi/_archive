      var map, geoResult;

      window.onload = function () {
         map = new YMaps.Map(document.getElementById("YMapsID"));
        map.setCenter(new YMaps.GeoPoint(47.24, 56.14), 12);
//				map.addControl(new YMaps.TypeControl(),
//			new YMaps.ControlPosition(YMaps.ControlPosition.TOP_LEFT));
				map.addControl(new YMaps.Zoom());
        map.enableScrollZoom()=true;
      }
      function showAddress (value) {
            map.removeOverlay(geoResult);
            var geocoder = new YMaps.Geocoder("Чебоксары, " + value, {results: 1, boundedBy: map.getBounds()});

            YMaps.Events.observe(geocoder, geocoder.Events.Load, function () {
                if (this.length()) {
                    geoResult = this.get(0);
                    map.addOverlay(geoResult);
                    map.setBounds(geoResult.getBounds());
                }else {
                    alert("Ничего не найдено")
                }
            });
        }
      function showCompanyAddress (value) {
            map.removeOverlay(geoResult);
            var geocoder = new YMaps.Geocoder(value, {results: 1, boundedBy: map.getBounds()});

            YMaps.Events.observe(geocoder, geocoder.Events.Load, function () {
                if (this.length()) {
                    geoResult = this.get(0);
                    map.addOverlay(geoResult);
                    map.setBounds(geoResult.getBounds());
                }
            });
        }
        
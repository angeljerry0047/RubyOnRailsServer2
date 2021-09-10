var map;
	
function initialize() {
  var latitude = '36.333698';
  var longitude = '-94.12917099999999'; 
  var googlemap = document.getElementById("map_to_pop_up");
  if (googlemap != null) {	
  
	  var myLatlng = new google.maps.LatLng(latitude,longitude);
	  
	  var mapOptions = {
	    zoom: 8,
	    center: new google.maps.LatLng(latitude, longitude),
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	  };
	  
	  map = new google.maps.Map(googlemap,
	      mapOptions);
	      
	  var input = /** @type {HTMLInputElement} */(document.getElementById('opportunities__facility_address'));
	  var autocomplete = new google.maps.places.Autocomplete(input);
	
	  autocomplete.bindTo('bounds', map);
	
	  var infowindow = new google.maps.InfoWindow();
	  var marker = new google.maps.Marker({
	    position: myLatlng,
	    map: map
	  });
  
	  var initLocation = $('#opportunities__facility_map_location').val(); 
	  if(initLocation!=""){
	  	var location = initLocation.split(","); 
	  	var lat = location[0];
        var lon = location[1];
        
        codeAddress(lat.replace('(',''),lon.replace(')',''));
	  }
	
	  google.maps.event.addListener(autocomplete, 'place_changed', function() {
	    infowindow.close();
	    marker.setVisible(false);
	    var place = autocomplete.getPlace();
	    if (!place.geometry) {
	      // Inform the user that the place was not found and return.
	      input.className = 'notfound';
	      return;
	    }
	
	    // If the place has a geometry, then present it on a map.
	    if (place.geometry.viewport) {
	      map.fitBounds(place.geometry.viewport);
	    } else {
	      map.setCenter(place.geometry.location);
	      map.setZoom(17);  // Why 17? Because it looks good.
	    }
	    marker.setIcon(/** @type {google.maps.Icon} */({
	      url: place.icon,
	      size: new google.maps.Size(71, 71),
	      origin: new google.maps.Point(0, 0),
	      anchor: new google.maps.Point(17, 34),
	      scaledSize: new google.maps.Size(35, 35)
	    }));
	    marker.setPosition(place.geometry.location);
	    marker.setVisible(true);
		document.getElementById("opportunities__facility_map_location").value = place.geometry.location;
	    var address = '';
	    if (place.address_components) {
	      address = [
	        (place.address_components[0] && place.address_components[0].short_name || ''),
	        (place.address_components[1] && place.address_components[1].short_name || ''),
	        (place.address_components[2] && place.address_components[2].short_name || '')
	      ].join(' ');
	    }
	
	    infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
	    infowindow.open(map, marker);
	    $('#opportunities__facility_name').val(place.name);
	    
	    var arrAddress = place.address_components;
		// iterate through address_component array
		$.each(arrAddress, function (i, address_component) {
		    if (address_component.types[i] == "locality") // locality type
		        $('#opportunities__city').val(address_component.long_name);
		});
	    
	  });
	  
  }

}
	
google.maps.event.addDomListener(window, 'load', initialize);

function codeAddress(latitude,longitude) {
  var facilityName = $('#facility_name_dropdown option:selected').text();
  var infowindow = new google.maps.InfoWindow();
  var googlemap = document.getElementById("map_to_pop_up");
  if (googlemap != null) 
  {		  
	
    var geocoder = new google.maps.Geocoder();

    var latlng = new google.maps.LatLng(latitude,longitude);
    geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          map.setZoom(17);
          marker = new google.maps.Marker({
              position: latlng,
              map: map
          });
		  var service = new google.maps.places.PlacesService(map);
		  var icon;
		  service.search({'location':latlng, 'radius':1}, function(results2, status2) {
		 	if (status2 == google.maps.places.PlacesServiceStatus.OK) {
				
				for (var i = 0; i < results2.length; i++) {
					if(results2[i].name == facilityName) {
						marker.setIcon(/** @type {google.maps.Icon} */({
					      url: results2[i].icon,
					      size: new google.maps.Size(71, 71),
					      origin: new google.maps.Point(0, 0),
					      anchor: new google.maps.Point(17, 34),
					      scaledSize: new google.maps.Size(35, 35)
					    }));
					}	
				}
			} 	
		  });	
          var address = '';
	      if (results[0].address_components) {
		      address = [
		        (results[0].address_components[0] && results[0].address_components[0].short_name || ''),
		        (results[0].address_components[1] && results[0].address_components[1].short_name || ''),
		        (results[0].address_components[2] && results[0].address_components[2].short_name || '')
		      ].join(' ');
	      }
	
	      infowindow.setContent('<div><strong>' + facilityName + '</strong><br>' + address);
          infowindow.open(map, marker);
        }
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
  }
}
(function($, app) {

  UberLocations._Models.Locations = Backbone.Model.extend({

    nameAttribute: 'location-detail',

    /**
     * url
     *
     * Returns the relative URL where the model's resource
     * would be located on the server.
     *
     * @return {string}
     */
    url: function() {
      return UberLocations._Data.API.GET_LOCATIONS;
    },


    /**
     * removeLocation
     * Will send a request and remove a location from the
     * database.
     *
     * @param {string} id
     *
     */
    removeLocation: function(id) {
      var self = this;
      $.ajax({
        type: 'DELETE',
        url: UberLocations._Data.API.REMOVE_LOCATION + id
      }).done(function(response) {
        UberLocations._Views.locationView.removeLocationElement(id);
        if (response.msg === 0) {
          self.trigger('UberLocations:Locations:collectionEmpty');
        }
      });
    },

    
    /**
     * editLocation
     * Will edit a location with new properties by running an 
     * jQuery ajax post with new data from the values retrieved
     * in the edit lcoation form.
     *
     * @param {string} locationId
     * @param {object} data
     */
    editLocation: function(locationId, data) {
      $.ajax({
        type: 'POST',
        url: UberLocations._Data.API.EDIT_LOCATION + locationId,
        data: data
      }).done(function(response) {
        var locationObject = {
          'data' : data,
          'id' : locationId
        };

        UberLocations._Views.editLocationView.dispose();
        UberLocations._Views.locationView.updateLocationItem(locationObject);
        UberLocations._Views.locationView.renderMap(locationObject);
        UberLocations._Views.locationView.cleanupElements();
      });
    },


    /**
     * addLocation
     *
     * @param {object} data
     */
    addLocation: function(data) {
      $.ajax({
        type: 'POST',
        url: UberLocations._Data.API.ADD_LOCATION,
        data: data
      }).done(function(response) {
        data._id = response.msg.addedLocation.id;

        var locationObject = {
          'locationCollection': response.msg.locationCollection,
          'data' : [data]
        };

        UberLocations._Views.locationView.renderNewLocation(locationObject);
      });  

    }
        
  });

})(jQuery, UberLocations);

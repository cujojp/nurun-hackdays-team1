(function($, app) {

  UberLocations._Models.LocationDetail = Backbone.Model.extend({

    nameAttribute: 'location',


    /**
     * initialize
     * Initializes the location detail model.
     *
     * @param {object} options
     */
    initialize: function(options) {

      /**
       * Any additional options being passed into the model.
       * @type {object}
       * @private
       */
      this._options = options;

      /**
       * Our URL query for getting data from the API.
       * @type {string}
       * @return
       */
      this._urlQuery = null;

    },

    /**
     * url
     *
     * Returns the relative URL where the model's resource
     * would be located on the server.
     *
     * @return {string}
     */
    url: function() {
      var locationId = this._options.location;

      this._urlQuery = UberLocations._Data.API.GET_LOCATIONS_DETAIL.replace(
          ':id',
          locationId);

      return this._urlQuery;
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
      $.ajax({
        type: 'DELETE',
        url: '/api/remove-location/' + id
      }).done(function(response) {
        console.log('removed location from location detail page');
      });
    },


    /**
     * editLocation
     * Will edit a location with new properties by running an 
     * jQuery ajax post with new data from the values retrieved
     * in the edit lcoation form.
     *
     * @param {object} data
     */
    editLocation: function(data) {


    }

  });

})(jQuery, UberLocations);

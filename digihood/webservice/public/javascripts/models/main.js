(function($, app) {

  UberLocations._Models.Main = Backbone.Model.extend({

    nameAttribute: 'location',

    /**
     * url
     *
     * Returns the relative URL where the model's resource
     * would be located on the server.
     *
     * @return {string}
     */
    url: function() {
      return UberLocations._Data.URL.LOCATION;
    },

    name: function() {
      this.get('title');
    }
  });

})(jQuery, UberLocations);

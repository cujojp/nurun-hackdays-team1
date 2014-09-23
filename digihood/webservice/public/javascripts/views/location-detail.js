(function($, app) {

  UberLocations._Views.LocationDetail = Backbone.View.extend ({

    /**
     * Initializes the location detail view.
     *
     * @param {object} options
     */
    initialize: function(options) {
      var self = this;

      /**
       * Any additional options being passed into the view.
       * @type {object}
       * @private
       */
      self._options = options;

      /**
       * Will be our base template. We will run an
       * ajax request to retrieve the template.
       * @type {jQuery|element}
       * @private
       */
      self._template = null;


      /**
       * Our base detail container.
       * 
       * @type {jQuery|element}
       * @private
       */
      self._detailContainer = null;

      $.get(self._options.template, function(template){
        self._template = $(template);
        self.el = self._template;
      });
    },


    /**
     * Grabbing our base element.
     */
    el: UberLocations.LocationsApp.element,


    /**
     * Backbone event binding to the view.
     */
    events: {
      'click .remove-location': 'removeLocation'
    },


    /**
     * removeLocation
     *
     * Will remove a location based on a click handler.
     *
     * @param {object} event
     */
    removeLocation: function(e) {
      e.preventDefault();
      var targetElement = $(e.target);
      var targetId = targetElement.data('location-id');

      this.model.removeLocation(targetId);
    },


    /**
     * removeLocationElement
     * Will remove the location element from the list.
     *
     * @param {number} id
     */
    removeLocationElement: function(id) {
      var listingEl = UberLocations.LocationsApp.element.find(
          '.location-'+id);

      // TODO (kaleb)
      // we should add some UI transisions so the user knows
      // they wanted to remove the element. Not simply
      // have it vanish and be removed.
      listingEl.remove();
    },


    /**
     * createMapElement
     * Will return a map element. based on coordinates recieved
     *
     * @param {object} coordinates
     * @return {element}
     */
    createMapElement: function(coordinates) {
      var map = UberLocations.LocationsApp.gmaps.staticMapURL({
        size: [510, 250],
        zoom: 13,
        lat: coordinates.lat,
        lng: coordinates.lng,
        markers: [
          {lat: coordinates.lat, lng: coordinates.lng}
        ]
      });  

      return map;  
    },


    /**
     * renderMap
     * Renders the map by grabbing the location detail lat/lng 
     * within a data attribute.
     *
     */
    renderMap: function() {
      var mapContainer = this._detailContainer.find(
          UberLocations._Data.CLASSNAME.DETAIL_MAP_WRAP);
      var locationCords = mapContainer.data('map-cords');
      var map = this.createMapElement(locationCords);
      var mapElement = $('<img/>').attr({
          'src': map,
          'class': 'location-listing-map'});  

      mapContainer.append(mapElement);       

    },  


    /**
     * render
     * Will render the template with the appropriate response.
     *
     * TODO (kaleb) - we should probably make a template manager
     * so we can cache templates. Underscore can get super
     * sluggish when loading templates since they're not cached.
     * But for now and the sake of time we can just use $.get()
     * to download our template.
     *
     * @param {object} response
     * @return
     */
    render: function(response) {
      var template = _.template(this._template.html(),
          {location: response});

      this._options.applicationElement.html(template);

      this._detailContainer = this.$el.find(
          UberLocations._Data.CLASSNAME.DETAIL_CONTAINER);

      this.delegateEvents();
      this.renderMap();
      return this;
    }

  });

})(jQuery, UberLocations);

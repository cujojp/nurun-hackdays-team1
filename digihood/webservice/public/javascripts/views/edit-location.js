(function($, app) {

  UberLocations._Views.EditLocation = Backbone.View.extend ({
    /**
     * Will initialize the view object and initialize any new
     * models needed and run any fetches if need be. Will also
     * use options which will be passed in from the controller
     * (router).
     *
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
       * @type {jQuery|object}
       * @private
       */
      self._template = null;

      /**
       * A cached version of our template.
       * @type {jQuery|object}
       * @private
       */
      self._cachedTemplate = null; 

      $.get(self._options.template, function(template){
        self._template = $(template);
        self.el = self._template;
      });

      UberLocations.Router.bind('route:locationDetail', self.dispose, self);
    },


    /**
     * Grabbing our base element.
     */
    el: UberLocations.LocationsApp.element,
    

    /**
     * Backbone event binding to the view.
     */
    events: {
      'click .edit-location-submit': 'editLocation',
      'click .edit-location-cancel': 'cancelEdit'
    },
          

    /**
     * render
     * Will render the template with the appropriate response.
     *
     * @param {object} response
     */
    render: function(response) {
      var template = _.template(this._template.html(),
          {location: response.location, states: UberLocations._Data.STATES});
      this._cachedTemplate = $(template);

      UberLocations.LocationsApp.element.trigger(
          'UberLocations:EditLocation:rendered', this._cachedTemplate);
    },

    
    /**
     * cancelEdit
     * Will just dispose the location edit field.
     *
     * @param {object} event
     */
    cancelEdit: function(event) {
      event.preventDefault();

      var editElement = $(event.target).closest(
          UberLocations._Data.CLASSNAME.EDIT_CONTAINER);
      editElement.remove();
      UberLocations._Views.locationView.cleanupElements();
    },


    /**
     * editLocation
     * A click event was fired on the submit location and 
     * need to call the location model to post new data 
     * from the form.
     *
     */
    editLocation: function(event) {
      event.preventDefault();

      var locationWrapper = this._cachedTemplate.closest(
          UberLocations._Data.CLASSNAME.LISTING_WRAPPER);
      var locationId = locationWrapper.data('location-id');

      var locationData = this.getLocationData();
          
      var formData = {
        'name': locationData.name,
        'address': locationData.address,
        'city': locationData.city,
        'state': locationData.state,
        'postal': locationData.postal,
        'string': locationData.address + ' ' + 
            locationData.city + ' ' + 
            locationData.state + ' ' + 
            locationData.postal
      };

      UberLocations.LocationsApp.geolocate.geocode({ 
            'address' : formData.string
          }, function(results) { 
            // append our new lat lng to the data
            formData.lat = results[0].geometry.location.k;
            formData.lng = results[0].geometry.location.A;

            UberLocations._Models.locationModel.editLocation(
                locationId, 
                formData);
          });
    },


    /**
     * getLocationData
     * Will get the location data and return it back as an object.
     *
     * @return {object}
     */
    getLocationData: function() {
      var editFields = this._cachedTemplate.find(
          UberLocations._Data.CLASSNAME.EDIT_FIELD);
      var i = 0;
      var locationDataObject = {};
      
      for(; i < editFields.length; i++) {
        var currField = editFields.eq(i);
        var fieldName = currField.attr('name');
        var currVal = currField.val();

        locationDataObject[fieldName] = currVal;
      }

      return locationDataObject;
    },

    /**
     * dispose
     *
     */
    dispose: function() {
      // if theirs no more cached template return out.
      if (!this._cachedTemplate) return;
      this._cachedTemplate.remove();
    },

  });

})(jQuery, UberLocations);

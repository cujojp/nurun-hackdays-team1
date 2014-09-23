(function($, app) {

  UberLocations._Views.Locations = Backbone.View.extend ({
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
       * Our current active listing that the user is editing.
       * @type {jQuery|object}
       * @private
       */
      self._currentActiveListing = null;

      /**
       * The current listing template post render. 
       * @type {jQuery|object}
       * @private
       */
      self._locationListEl = null;

      // listen for when a render event has fired from the
      // edit location view.
      UberLocations.LocationsApp.element.on(
          'UberLocations:EditLocation:rendered', 
          $.proxy(self.onRender, self));

      this.model.on(
          'UberLocations:Locations:collectionEmpty',
          $.proxy(self.renderNoResults, self));
    },


    /**
     * Grabbing our base element.
     */
    el: UberLocations.LocationsApp.element,


    /**
     * Backbone event binding to the view.
     */
    events: {
      'click .remove-location': 'removeLocation',
      'click .edit-location': 'editLocation',
      'click .add-location': 'addLocation'
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
      var targetWrapper = targetElement.closest(
          UberLocations._Data.CLASSNAME.LISTING_WRAPPER);
      var targetId = targetWrapper.data('location-id');

      if (this._currentActiveListing) {
        UberLocations._Views.editLocationView.dispose();
        this._currentActiveListing = null;
        return;
      }   

      this.model.removeLocation(targetId);
    },


    /**
     * editLocation
     * Will fire the model to edit the location 
     * Will also need to dispose any other edit panels if they
     * are ope
     *
     * @param {object} event
     */
    editLocation: function(event) {
      event.preventDefault();
      var targetElement = $(event.target);
      var targetWrapper = targetElement.closest(
          UberLocations._Data.CLASSNAME.LISTING_WRAPPER);
      var targetId = targetWrapper.data('location-id');

      var activeListingExist = this.checkActiveListing(targetWrapper);

      if (activeListingExist) return;

      // destroy any other elements on the page.
      if (self._currentActiveListing) {
        UberLocations._Views.editLocationView.dispose();
      }

      self._currentActiveListing = targetWrapper;

      // we need to call and get the location detail using
      // our location detail model.
      var locationDetailModel = new UberLocations._Models.LocationDetail({
        location: targetId
      });

      locationDetailModel.fetch({
        success: function(model, response) { 
          // we can render our edit detail view.
          UberLocations._Views.editLocationView.render(response);
        } 
      });
    },

    
    /**
     * addLocation
     * Will display the add location view as a modal.
     *
     * @param {object} event // optional
     * @return
     */
    addLocation: function(event) {
      if (event) {
        event.preventDefault();
      }

      UberLocations._Views.addLocationView =
          new UberLocations._Views.AddLocation({
        el: UberLocations.LocationsApp.appElement,
        model: UberLocations._Models.locationModel,
        template: UberLocations._Data.TEMPLATES.ADD_LOCATION,
        applicationElement: UberLocations.LocationsApp.element
      });    

      UberLocations._Views.addLocationView.render(
        UberLocations._Data.STATES);
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
     * render
     * Will render the template with the appropriate response.
     *
     * @param {object} response
     */
    render: function(response) {
      this.getTemplate(response, $.proxy(this.renderTemplate, this));

      return this;
    },
     

    /**
     * _getTemplate
     *
     * @param {object} response
     * @param {object} opt_cb
     */
    getTemplate: function(response, opt_cb) {
      //var hasLocations = (response.locations) ? true : false;
      var self = this;
      var templateUrl = 
          (self.arrayExistsWithLength(response, 'locations')) ?
          UberLocations._Data.TEMPLATES.LOCATION_LIST :
          UberLocations._Data.TEMPLATES.NO_LOCATIONS;

      // if there are any locations our template changes.
      //(!response.locations)
      // get the templates and assign our element.
      $.get(templateUrl, function(template){
        self._template = $(template);
        self.el = self._template;

        if (opt_cb && typeof(opt_cb) === 'function') {
          opt_cb(response);
        }
      });                                  
    },


    /**
     * renderTemplate
     * Will render the appropriate template with data.
     *
     * @param {object} response
     */
    renderTemplate: function(response) { 
      var template = _.template(this._template.html(),
          {locations: response.locations});

      this._options.applicationElement.html(template);
      this.delegateEvents();
      this._locationListEl = UberLocations.LocationsApp.element.find(
          UberLocations._Data.CLASSNAME.LOCATION_LIST);  

      this.renderMapList();
    },

    /**
     * renderMapList
     * Will render the maps with the list of locations.
     *
     */
    renderMapList: function() {
      var locationElements = this._locationListEl.find(
          UberLocations._Data.CLASSNAME.LISTING_WRAPPER);
      var i = 0;
      var len = locationElements.length;

      // loop through our elements to append the map.
      for (; i < len; i++) {
        var currentLocation = locationElements.eq(i);
        var mapWrapper = currentLocation.find(
            UberLocations._Data.CLASSNAME.LIST_MAP_WRAP);
        var locationCords = currentLocation.data('map-cords');
        var map = this.createMapElement(locationCords);
        
        var mapElement = $('<img/>').attr({
            'src': map,
            'class': 'location-listing-map'});

        mapWrapper.append(mapElement);       
      }
    },


    /**
     * renderMap
     * Will render a specific elements map.
     *
     * @param {object} locationObject
     */
    renderMap: function(locationObject) {
      var locationElement = this.getLocationById(locationObject.id);
      var mapCords = locationElement.data('map-cords');
      var locationMap = locationElement.find(
          UberLocations._Data.CLASSNAME.LISTING_MAP);
      var newLocationMap = this.createMapElement({
          'lat':locationObject.data.lat,
          'lng':locationObject.data.lng});

      locationMap.attr('src', newLocationMap);
    },


    /**
     * createMapElement
     * Will create a gmaps instance of a map.
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
     * renderNoResults
     * Will fire when theres no results and burn the view to the ground.
     * It's a bit messy since it needs to re-render both views.
     * What would be ideal is we separate the containers and burn
     * only the location list container and keep the add location 
     * view.
     *
     */
    renderNoResults: function() {
      this.getTemplate({'locations' : []}, $.proxy(this.renderTemplate, this));
      this.addLocation();
    },


    /**
     * renderNewLocation
     * Will render a new item in the container.
     *
     * @param {object} response // data of new location from the db
     */
    renderNewLocation: function(response) {

      this.getTemplate(
          {'locations' : response.locationCollection}, 
          $.proxy(this.renderTemplate, this));
    },


    /**
     * onRender
     * Fired off event that an element has been rendered.
     *
     * @param {object} event // event data
     * @param {jQuery|element} template // our template from the render
     */
    onRender: function(event, template) {
      self._currentActiveListing.append(template);

      // find the select fields
      var selectFieldsEls = self._currentActiveListing.find('select');

      // make em pretty.
      selectFieldsEls.uniform({
        selectAutoWidth: false
      });
    },


    /**
     * cleanupEvents
     * Will clean up all event delegation thus events don't bubble.
     */
    cleanupEvents: function() {
      this.undelegateEvents();
    },


    /**
     * updateLocationItem
     * Updates an individual listing. Usually called from after data
     * has been updated per the item.
     *
     * @param {object} locationData
     */
    updateLocationItem: function(locationData) {
      var locationListingEl = this.getLocationById(
          locationData.id);
      var locationTitle = locationListingEl.find('.name');
      var locationAddress = locationListingEl.find('.address');
      var locationCity = locationListingEl.find('.city');
      var locationState = locationListingEl.find('.state');
      locationListingEl.attr(
          'data-map-cords', "{'lat':" + 
          null + ", 'lng':" + 
          null + "}");

      // update our text to reflect the updated changes.
      locationTitle.text(locationData.data.name);
      locationAddress.text(locationData.data.address);
      locationCity.text(locationData.data.city);
      locationState.text(locationData.data.state);
    },


    /**
     * getLocationById
     * Will get a location element by it's unique id.
     *
     * @param id {string}
     * @return {jQuery|object}
     */
    getLocationById: function(id) {
      var locationListing = UberLocations.LocationsApp.element.find(
          '.location-'+id);        

      return locationListing;
    },

    /**
     * checks if the active listing exists and if the targetWrapper
     * is equal to the active listing, which means it exists.
     *
     * @return {boolean}
     */
    checkActiveListing: function(targetWrapper) {
      // if the currentActiveListing is currently open we need to 
      // toggle it closed. And close out of this method.
      if (self._currentActiveListing && 
          self._currentActiveListing.get(0) === targetWrapper.get(0)) {
        UberLocations._Views.editLocationView.dispose();
        self._currentActiveListing = null;
        return true;
      }
    },


    /**
     * arrayExistsWithLength
     * Checks if an array exists and it has a length
     *
     * @param array
     * @return {boolean}
     */
    arrayExistsWithLength: function(array, key) {
      return (typeof array[key] !== "undefined" && 
          array[key] && 
          array[key].length > 0);
    },

    /**
     * cleanupElements
     * WIll set some elements to null since they're no longer
     * preesent/
     */
    cleanupElements: function() {
      self._currentActiveListing = null;
    }

  });

})(jQuery, UberLocations);

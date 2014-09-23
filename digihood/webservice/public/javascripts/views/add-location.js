(function($, app) {

  UberLocations._Views.AddLocation = Backbone.View.extend ({

    /**
     * initialize
     *
     * @param {object} options
     * @return
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
       * A cached version of our template.
       * @type {jQuery|object}
       * @private
       */
      self._cachedTemplate = null; 

      /**
       * Instance of validate.ja form validation.
       * @type {object}
       * @private
       */
      self._addLocationValidate = null;

      /**
       * Object with our location data from the form.
       * @type {object}
       * @private
       */
      self._locationData = {};
    },
    

    /**
     * Backbone event binding to the view.
     */
    events: {
      'click .add-location-cancel': 'dispose',
      'click .modal-overlay': 'dispose'
    }, 


    /**
     * getLocationData
     * Will loop through the form elements and get values
     * for the form to submit.
     *
     * @return {object}
     */
    getLocationData: function() {
      var formFields = this.addLocationContainer.find(
          UberLocations._Data.CLASSNAME.ADD_LOCATION_FIELD);
      var i = 0;
      var locationDataObject = {};

      for(; i < formFields.length; i++) {
        var currField = formFields.eq(i);
        var fieldName = currField.attr('name');
        var currVal = currField.val();

        locationDataObject[fieldName] = currVal;
      }

      return locationDataObject;
    },


    /**
     * render
     *
     * @return
     */
    render: function() {
      this.getTemplate($.proxy(this.renderTemplate, this));
      
      return this;
    },


    /**
     * _getTemplate
     *
     * @param {object} opt_cb
     * @return
     */
    getTemplate: function(opt_cb) {
      var self = this;

      // if there are any locations our template changes.
      //(!response.locations)
      // get the templates and assign our element.
      $.get(self._options.template, function(template){
        self._template = $(template);
        self.el = self._template;

        if (opt_cb && typeof(opt_cb) === 'function') {
          opt_cb();
        }
      });                                  
 
    },                                


    /**
     * renderTemplate
     * Will render the appropriate template with data.
     *
     * @return
     */
    renderTemplate: function() { 
      var template = _.template(this._template.html(),
          {states: UberLocations._Data.STATES});
      this.addLocationContainer = this._options.applicationElement.closest(
           UberLocations._Data.CLASSNAME.APP);

      this.addLocationContainer.append(template);
      this._cachedTemplate = this.addLocationContainer.find(
          UberLocations._Data.CLASSNAME.MODAL_VIEW);

      this.setElement(this._cachedTemplate);

      // find the select fields
      var selectFieldsEls = this.addLocationContainer.find('.add-location-state');

      // make em pretty.
      selectFieldsEls.uniform({
        selectAutoWidth: false
      });

      UberLocations.LocationsApp.window.on(
          'keyup.locationkey', 
          $.proxy(this.handleKeyPress, this));

      this.fadeModal('in');

      this.delegateEvents();
      this.setupFormValidation();
      UberLocations.LocationsApp.centerModal(this._cachedTemplate);
    },


    /**
     * fadeModal
     *
     * @param {string} direction
     * @return
     */
    fadeModal: function(direction) {
      var modal = this._cachedTemplate.find(
          UberLocations._Data.CLASSNAME.ADD_LOCATION_MODAL);
      var modalOverlayEl = this._cachedTemplate.find(
          UberLocations._Data.CLASSNAME.MODAL_OVERLAY);
      

      if (direction === 'in') {
        modal.addClass(
            UberLocations._Data.CLASSNAME.IN);
        modalOverlayEl.addClass(
            UberLocations._Data.CLASSNAME.IN);
      } else {
        modal.removeClass(
            UberLocations._Data.CLASSNAME.IN);
        modalOverlayEl.removeClass(
            UberLocations._Data.CLASSNAME.IN);
      }

    },


    /**
     * setupFormValidation
     * Will setup form validation for the add location form.
     *
     * @return
     */
    setupFormValidation: function() {
      var self = this;

      self._addLocationValidate = new FormValidator('add-location', [
        {
          name: 'name',
          display: 'required',    
          rules: 'required'      
        },
        {
          name: 'address',
          display: 'required',    
          rules: 'required'      
        },
        {
          name: 'city',
          display: 'required',    
          rules: 'required'      
        },
        {
          name: 'state',
          display: 'required',    
          rules: 'required'      
        },
        {
          name: 'postal',
          display: 'required',    
          rules: 'required'      
        }
      ], $.proxy(this.handleFormValidation, this));
    },


    /**
     * handleFormValidation
     * handleValidationErrors is a utility to manage custom 
     * error messaging
     *
     * @param {object} errors
     * @param {object} event
     * @return
     */
    handleFormValidation: function(errors, event) {
      event.preventDefault();
      var i = 0;
      var len = errors.length;

      // remove the fields errors.
      $('.add-field.error').removeClass(
          UberLocations._Data.CLASSNAME.ERROR);

      if (len > 0) {
        for (; i <= len; i++) {
          var currFieldEl = $('[name="' + errors[i].name + '"]');
          currFieldEl.addClass(UberLocations._Data.CLASSNAME.ERROR);
        }
      } else {
        this.submitForm();
      }
    },


    /**
     * handleKeyPress
     * Will handle the keycode.
     *
     * @param {object} event
     * @return
     */
    handleKeyPress: function(event) {
      var keyCode = event.keyCode;

      if (keyCode === 27) {
        this.dispose();
      }
    },


    /**
     * dispose
     * Disposes the view.
     *
     * @return
     */
    dispose: function() {
      var self = this;

      self.fadeModal('out');
      
      // instead of a setTimeout we could listen for when
      // transitions have ended.
      setTimeout(function() {
        self.remove();
        self.stopListening();
        UberLocations.LocationsApp.window.off(
            'keypress.locationkey');  

      }, 300);
    },


    /**
     * submitForm
     * Will submit the form with the data from the form.
     *
     * @return
     */
    submitForm: function() {
      var self = this;
      self._locationData = self.getLocationData();
      
      var formData = {
        'name': self._locationData.name, 
        'address': self._locationData.address,
        'city': self._locationData.city,
        'state': self._locationData.state,
        'postal': self._locationData.postal,
        'string': self._locationData.address + ' ' + 
            self._locationData.city + ' ' + 
            self._locationData.state + ' ' + 
            self._locationData.postal
      };   

      UberLocations.LocationsApp.geolocate.geocode({ 
            'address' : formData.string
          }, function(results) { 
            // append our new lat lng to the data
            formData.lat = results[0].geometry.location.k;
            formData.lng = results[0].geometry.location.A;

            UberLocations._Models.locationModel.addLocation(
                formData);
            //$.proxy(self.dispose, self);
            self.dispose();
          });

    },

  });

})(jQuery, UberLocations);    

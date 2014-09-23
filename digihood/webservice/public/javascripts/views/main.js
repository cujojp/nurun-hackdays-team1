(function($, app) {

  UberLocations._Views.Main = Backbone.View.extend ({

    /**
     * Will initialize the view object and initialize any new
     * models needed and run any fetches if need be. Will also
     * use options which will be passed in from the controller
     * (router).
     *
     */
    initialize: function(options) {
      /**
       * Any additional options being passed into the view.
       * @type {object}
       * @private
       */
      this._options = options;
    },

    /**
     * render
     * Will render the template with the appropriate response.

     * @param {object} response
     * @return
     */
    render: function(response) {
      var self = this;

      $.get(self._options.template, function(template){
        var html = $(template).tmpl();
        self._options.applicationElement.html(html);
      });
      return this;
    }

  });

})(jQuery, UberLocations);


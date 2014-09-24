(function($, app) {

  /**
   * The BaseRenderer method is a base that will render any template
   * regardless of data. It accepts some parameters which will be given
   * options of template UR which to render, which element to render into,
   * and if it is to simply append the template versus emptying the element.
   *
   *
   * @return
   */
  UberLocations._Views.BaseRenderer = Backbone.View.extend ({

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
       *
       * template: {string} // URL of the template to load
       * applicationElement: {jQuery|object} // elemet to append element to.
       *
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


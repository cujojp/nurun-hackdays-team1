
/**
 * @fileoverview
 * @author Kaleb White (cujojp)
 *
 * Extends the Backbone router so we can call elements within the
 * controller and access models and vies.
 */

(function($, app) {

  /**
   * ROuter Constructor
   * @constructor
   */
  app.Router = Backbone.Router.extend ({

    /**
     * The routes hash maps URLs with parameters to
     * functions on the router
     */
    routes: {
      "" : "root",
      "location/*name": "locationDetail",
    },


    /**
     * Root lanidng page.
     *
     */
    root: function() {
      var self = this;

      console.log("-- On Root Page -- ");
      UberLocations._Models.locationModel =
          new UberLocations._Models.Locations();

      // add our location list view.
      UberLocations._Views.locationView =
          new UberLocations._Views.Locations({
        model: UberLocations._Models.locationModel,
        applicationElement: UberLocations.LocationsApp.element
      });

      // add our edit location view.
      UberLocations._Views.editLocationView = 
          new UberLocations._Views.EditLocation({
        template: UberLocations._Data.TEMPLATES.EDIT_LOCATION,
      });

      UberLocations._Models.locationModel.fetch({
        success: function(model, response) {
          var template = UberLocations._Views.locationView.render(response);
          // add our add location view.
        }
      });

    },


    /**
     * locationDetail
     *
     * Will user Backbones router and get arguments passed
     * from the query string of the location. The model
     * will return data back for the view to parse.
     *
     * @param {string} args // url query
     *
     */
    locationDetail: function(args) {
      console.log("-- On Location Page -- ");
      if (!args) {
        console.warn('No location specified.');
        return this.root();
      }

      var params = args.split('/');
      var locatonName = params[0];

      this.initializeLocationView(locatonName);

      UberLocations._Models.locationDetailModel.fetch({
        success: function(model, response) {
          var data = response.location || null;
          // if we dont have any data, we cannot render this template.
          if (!data) {
            console.warn('throw a 404 here');
            return;
          }
          var template = UberLocations._Views.LocationDetailView
              .render(data);
        }
      });

      if (UberLocations._Views.locationView) { 
        UberLocations._Views.locationView.cleanupEvents();
        // destroy our edit panel if its open.
        UberLocations._Views.editLocationView.dispose();
      }

    },


    /**
     * initializeLocationView
     * Will get our singletons for our location detail page.
     *
     * @param {string} locatonName
     */
    initializeLocationView: function(locatonName) {

      UberLocations._Models.locationDetailModel =
        new UberLocations._Models.LocationDetail({
        location: locatonName
      });

      UberLocations._Views.LocationDetailView =
        new UberLocations._Views.LocationDetail({
        model: UberLocations._Models.locationDetailModel,
        template: UberLocations._Data.TEMPLATES.LOCATION_DETAIL,
        applicationElement: UberLocations.LocationsApp.element
      });  
    }

  });

})(jQuery, UberLocations);

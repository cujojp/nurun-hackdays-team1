//= include core.js
//= include ../libs/jQuery-2.1.0.min.js
//= include ../libs/jquery.tmpl.min.js
//= include app.js
//= include ../views/main.js
//= include_tree ../models/
//= include_tree ../components/

/**
 * @fileoverview
 * @author Kaleb White (cujojp)
 *
 * Application Notes:
 * - - - - - -
 * We will be attaching many module classes to the
 * window.UberLocations namespace.
 * All modules will exist adjacent to the Core module
 * that exists on all site pages.
 */

;(function( $, app ) {

  /** @override */
  app.GoogleMaps = null;

  /**
   * Initialize main Header component
   * @override
   */
  app._Header = new app._Modules.Header();

  /**
   * Initialize our router for the application.
   * @override
   */
  app._Router = new app.Router();

  Backbone.history.start({ pushState: false });

})(jQuery, UberLocations);

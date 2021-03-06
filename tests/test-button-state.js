/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

const {Cc, Ci, Cm, Cu, components} = require("chrome");

let tmp = {};
Cu.import("resource://gre/modules/Services.jsm", tmp);
Cu.import("resource://gre/modules/PlacesUtils.jsm", tmp);
let {Services, PlacesUtils} = tmp;

let {createSharePanel, getTestUrl, createTab, removeCurrentTab, finalize} = require("./test_utils");

exports.testButtonState = function(test) {
  test.waitUntilDone();
  let pageUrl = getTestUrl("page.html");

  finalize(test, function(finish) {
    removeCurrentTab(function() {
      finish();
    });
  });

  createTab(pageUrl, function(tab) {
    let sharePanel = createSharePanel();
    //sharePanel.show();
    // the panel callback doesn't seem to happen immediately...
    test.waitUntil(function() {return sharePanel.anchor.getAttribute("checked");}
    ).then(function() {
      sharePanel.panel.hide(); // XX - not currently exposed on sharePanel
      test.waitUntil(function() {return !sharePanel.anchor.getAttribute("checked")}
      ).then(function() {
        test.done();
      });
    });
  });
}

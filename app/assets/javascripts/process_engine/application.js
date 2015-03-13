// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


function loadBMPNViewer(bpmnXMLUrl, highlightedNodes, BpmnViewer, $) {

  // create viewer
  var bpmnViewer = new BpmnViewer({
    container: '#bpmn_canvas'
  });


  // import function
  function importXML(xml) {

    // import diagram
    bpmnViewer.importXML(xml, function(err) {

      if (err) {
        return console.error('could not import BPMN 2.0 diagram', err);
      }

      var canvas = bpmnViewer.get('canvas'),
          overlays = bpmnViewer.get('overlays');


      // zoom to fit full viewport
      canvas.zoom('fit-viewport');

      // attach an overlay to a node
      // overlays.add('decision', 'note', {
      //   position: {
      //     bottom: 0,
      //     right: 0
      //   },
      //   html: '<div class="diagram-note">Mixed up the labels?</div>'
      // });

      // add marker
      // canvas.addMarker('decision', 'bpmn-highlight-node');
      // canvas.addMarker('UserTask_1', 'bpmn-highlight-node');
      for(var i in highlightedNodes) {
        canvas.addMarker(highlightedNodes[i], 'bpmn-highlight-node');
      }
    });
  }


  // load external diagram file via AJAX and import it
  $.get(bpmnXMLUrl, importXML, 'text');
}

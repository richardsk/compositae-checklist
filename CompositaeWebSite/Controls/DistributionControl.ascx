<%@ Control Language="VB" AutoEventWireup="false" CodeFile="DistributionControl.ascx.vb" Inherits="Controls_DistributionControl" %>
<script type="text/javascript" src="TDWGGeo/OpenLayers.js"></script>
<script type="text/javascript">
 var map;
 
 var layerOptions = {
     maxExtent: new OpenLayers.Bounds(-180, -90, 180, 90),
     isBaseLayer: false,
     displayInLayerSwitcher: false
  };
 
 var tdwg_1 = new OpenLayers.Layer.WMS.Untiled( 
    "tdwg level 1", 
    "http://edit.csic.es/geoserver/wms",
    {layers:"topp:tdwg_level_1",transparent:"true", format:"image/png"},
    layerOptions
  );
  
 var tdwg_2 = new OpenLayers.Layer.WMS.Untiled( 
    "tdwg level 2", 
    "http://edit.csic.es/geoserver/wms",
    {layers:"topp:tdwg_level_2",transparent:"true", format:"image/png"},
    layerOptions
  );
  
 var tdwg_3 = new OpenLayers.Layer.WMS.Untiled( 
    "tdwg level 3", 
    "http://edit.csic.es/geoserver/wms",
    {layers:"topp:tdwg_level_3", transparent:"true", format:"image/png"},
    layerOptions
  );
  
  var tdwg_4 = new OpenLayers.Layer.WMS.Untiled( 
    "tdwg level 4", 
    "http://edit.csic.es/geoserver/wms",
    {layers:"topp:tdwg_level_4",transparent:"true", format:"image/png"},
    layerOptions
  );
  
 // make baselayer
 layerOptions['isBaseLayer'] = true; 
 
 var ol_wms = new OpenLayers.Layer.WMS( 
    "OpenLayers WMS",
    "http://labs.metacarta.com/wms/vmap0",
    {layers: 'basic'}, 
    layerOptions
  );
  
  
  // ------------------------------
  
  
 function init() {
alert('here'); 
   var mapOptions={
     controls: 
       [ 
         new OpenLayers.Control.PanZoom(),
         new OpenLayers.Control.Navigation({zoomWheelEnabled: false, handleRightClicks:true, zoomBoxKeyMask: OpenLayers.Handler.MOD_CTRL})
       ],
       maxExtent: new OpenLayers.Bounds(-180, -90, 180, 90),
       maxResolution: 0.72,
       restrictedExtent: new OpenLayers.Bounds(-180, -90, 180, 90),
       projection: new OpenLayers.Projection("EPSG:4326")
    };
   
   map = new OpenLayers.Map('openlayers_map', mapOptions);
   map.addLayers([ol_wms]);
   
   
   
          tdwg_3.params.SLD = 'http://edit.csic.es/v1/sld/tdwg3_b3a821b10f08b9674e649ad2dce9f94d.sld';
          map.addLayers([tdwg_3]);
   
   map.zoomToExtent(new OpenLayers.Bounds(-119.59723138809,-41.0486145019531,-16.923888683319,23.2041664123535), false);
 }
 
 init();
</script>

<div id="openlayers_map" class="smallmap" style="width: 500px; height:250px"></div>

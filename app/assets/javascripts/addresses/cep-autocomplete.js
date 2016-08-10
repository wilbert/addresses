"use strict";

jQuery(document).ready(function(){
  "use strict";

  var cep_input = jQuery('input[cep-autocomplete=true]');
  var cep_loader = (cep_input.attr('loader')!==undefined) ? jQuery(cep_input.attr('loader')) : jQuery([]);
  cep_loader.hide();
  cep_input.bind("input", function(){
    var e = jQuery(this);
    var value = e.val().replace('-', '');
    if (value.length===8){

      cep_loader.show();
      $.getJSON( "/addresses/cep", {id:value, cep_csrf_token:cep_csrf_token} )
        .done(function( json ) {
          console.log(json);
          var update_elements = false;
          if (e.attr('data-update-elements')) {
            update_elements = jQuery.parseJSON(jQuery(e).attr("data-update-elements"));
          }
          for (var key in update_elements) {
            var value = (json[key]===undefined) ? '' : json[key];
            jQuery(update_elements[key]).val(value);
          }

          cep_loader.hide();
        })
        .fail(function(jqxhr, textStatus, error){
          cep_loader.hide();
        });
    }
  });

});

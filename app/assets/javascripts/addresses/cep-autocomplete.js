"use strict";

jQuery(document).ready(function(){
  "use strict";

  // jQuery('#city').bind('railsAutocomplete.select', function(event, data){
  //   console.log(a=data.item);
  // });
  
  var cep_input = jQuery('input[cep-autocomplete=true]');
  var cep_loader = (cep_input.attr('loader')!==undefined) ? jQuery(cep_input.attr('loader')) : jQuery([]);
  cep_loader.hide();
  cep_input.keyup(function(){
    var e = jQuery(this);
    var value = e.val().replace('-', '');
    if (value.length===8){
      // var div = jQuery(".wrapper-cep_autocomplete");
      // jQuery(element).appendTo(".wrapper-cep_autocomplete");
      // var button = '<button id="cep_button" type="button">Pesquisar cep</button>';
      // div.append(button);

      // jQuery(button).click(function(){

        cep_loader.show();
        $.getJSON( "/addresses/cep", {id:value} )
          .done(function( json ) {
            console.log( json );

            if (json.resultado==='0')
              alert('Não encontrado.');

            var update_elements = false;
            if (e.attr('data-update-elements')) {
              update_elements = jQuery.parseJSON(jQuery(e).attr("data-update-elements"));
            }
            for (var key in update_elements) {
              jQuery(update_elements[key]).val(json[key]);
            }

            cep_loader.hide();
          })
          .fail(function( jqxhr, textStatus, error ) {
            alert('Não encontrado.');
            var err = textStatus + ", " + error;
            console.log( err );
            cep_loader.hide();
        });
      // });
    }
  });

});

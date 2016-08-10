module SimpleForm
  module Inputs
    module Autocomplete
      #
      # Method used to rename the autocomplete key to a more standard
      # data-autocomplete key
      #
      def rewrite_autocomplete_option
        new_options = {}
        new_options["cep-autocomplete"] = true
        new_options["data-update-elements"] = JSON.generate(options.delete :update_elements) if options[:update_elements]
        new_options["data-id-element"] = options.delete :id_element if options[:id_element]
        input_html_options.merge new_options
      end
    end

    class CepAutocompleteInput < Base
      include Autocomplete

      def input(wrapper_options)
        @builder.cep_autocomplete_field(
          attribute_name,
          rewrite_autocomplete_option
        )
      end

      protected
      def limit
        column && column.limit
      end

      def has_placeholder?
        placeholder_present?
      end
    end
  end

  class FormBuilder
    map_type :cep_autocomplete, :to => SimpleForm::Inputs::CepAutocompleteInput
  end

end
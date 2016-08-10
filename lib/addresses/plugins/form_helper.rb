module ActionView
  module Helpers
    module FormHelper
      # Returns an input tag of the "text" type tailored for accessing a specified attribute (identified by +method+) and
      # that is populated with jQuery's autocomplete plugin.
      #
      # ==== Examples
      #   cep_autocomplete_field(:post, :title, :size => 20)
      #   # => <input type="text" id="post_title" name="post[title]" size="20" value="#{@post.title}"  cep-autocomplete="true"/>
      #
      def cep_autocomplete_field(object_name, method, options ={})
        text_field(object_name, method, rewrite_autocomplete_option(options))
      end
    end

    module FormTagHelper
      # Creates a standard text field that can be populated with jQuery's autocomplete plugin
      #
      # ==== Examples
      #   cep_autocomplete_field_tag 'address', '', :size => 75
      #   # => <input id="address" name="address" size="75" type="text" value="" cep-autocomplete="true"/>
      #
      def cep_autocomplete_field_tag(name, value, options ={})
        text_field_tag(name, value, rewrite_autocomplete_option(options))
      end
    end

    #
    # Method used to rename the autocomplete key to a more standard
    # data-autocomplete key
    #
    private
    def rewrite_autocomplete_option(options)
      options["cep-autocomplete"] = true
      options["data-update-elements"] = JSON.generate(options.delete :update_elements) if options[:update_elements]
      options["data-id-element"] = options.delete :id_element if options[:id_element]
      options
    end
  end
end

class ActionView::Helpers::FormBuilder #:nodoc:
  def cep_autocomplete_field(method, options = {})
    @template.cep_autocomplete_field(@object_name, method, objectify_options(options))
  end
end
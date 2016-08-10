module Addresses
  module ApplicationHelper
    def cep_crsf_token_tag
      session[:cep_csrf_token]=SecureRandom.uuid
      %Q{
        <script>
          var cep_csrf_token = '#{session[:cep_csrf_token]}';
        </script>
      }.html_safe
    end
  end
end

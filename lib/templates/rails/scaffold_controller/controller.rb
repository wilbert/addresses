class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :xml

  def index
    @search = <%= human_name %>.search(params[:q])

    @<%= plural_table_name %> = @search.result.paginate(page: params[:page])

    respond_with @<%= plural_table_name %>
  end

  def show
    respond_with @<%= singular_table_name %>
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_with @<%= singular_table_name %>
  end

  def edit
    respond_with @<%= singular_table_name %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    flash[:notice] = I18n.t(:created, model: I18n.t(:<%= singular_table_name %>, scope: "activerecord.models")) if @<%= orm_instance.save %>

    respond_with @<%= singular_table_name %>
  end

  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    flash[:notice] = I18n.t(:updated, model: I18n.t(:<%= singular_table_name %>, scope: "activerecord.models")) if @<%= orm_instance.update("#{singular_table_name}_params") %>
    
    respond_with @<%= singular_table_name %>
  end

  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    
    flash[:alert] = I18n.t(:deleted, model: I18n.t(:<%= singular_table_name %>, scope: "activerecord.models")) if @<%= orm_instance.destroy %>

    respond_with @<%= singular_table_name %>, :location => <%= index_helper %>_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # Only allow a trusted parameter "white list" through.
  def <%= "#{singular_table_name}_params" %>
  <%- if attributes_names.empty? -%>
    params[:<%= singular_table_name %>]
  <%- else -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
  <%- end -%>
  end
end

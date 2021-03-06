#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ApplicationController < ActionController::Base

  #pundit
  include Pundit
  after_filter :verify_authorized_with_exceptions, :except => [:index,:autocomplete]

  protect_from_forgery

  def build_login
    @login = render_to_string(:partial => "devise/login_popover" , :layout => false )
  end

  helper :all
  helper_method :tinycms_admin?

  # Customize the Devise after_sign_in_path_for() for redirect to previous page after login
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User) && resource_or_scope.banned?
      sign_out resource_or_scope
      flash.discard
      "/banned"
    else
      stored_location_for(resource_or_scope) || user_path(resource_or_scope)
    end
  end

  def tinycms_admin?
    current_user && current_user.admin?
  end

  ## programmatically get controller's filters
  # def self.filters(kind = nil)
  #   all_filters = _process_action_callbacks
  #   all_filters = all_filters.select{|f| f.kind == kind} if kind
  #   all_filters.map { :filter }
  # end

  protected

  def render_users_hero
    render_hero :controller => "users"
  end

  def render_hero options
    options[:action] ||= "default"
    options[:controller] ||= params[:controller]
    @rendered_hero = options
  end

  # Pundit checker

  def verify_authorized_with_exceptions
    verify_authorized unless pundit_unverified_controller
  end

  def pundit_unverified_controller
    (pundit_unverified_modules.include? self.class.name.split("::").first) || (pundit_unverified_classes.include? self.class)
  end

  def pundit_unverified_modules
    ["Devise","RailsAdmin"]
  end

  def pundit_unverified_classes
    [RegistrationsController]
  end

end

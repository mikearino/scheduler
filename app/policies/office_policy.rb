# frozen_string_literal: true

class OfficePolicy < ApplicationPolicy
  def reports?
    index?
  end

  def permitted_attributes
    [:name, :region, { address_attributes: %i[street street2 city state postal_code] }]
  end
end

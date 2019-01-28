# frozen_string_literal: true

class ShiftsController < ApplicationController
  def index
    authorize Shift
    @shifts = policy_scope(Shift)
                .includes(need: :office)
                .order(:start_at)
                .where('shifts.start_at >= ?', Time.zone.now)
  end

  def new
    authorize Shift
  end

  def create
    authorize Shift
  end

  def update
    @shift = policy_scope(Shift).find(params[:id])
    @need = policy_scope(Need).find(params[:need_id])
    authorize @shift
    @shift.assign_attributes(permitted_attributes(@shift))
    if @shift.save
      Services::SendShiftStatusNotifications.call(@shift)
      flash[:notice] = 'Shift Claimed!'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to @need
  end

  def destroy
    authorize Shift
  end
end

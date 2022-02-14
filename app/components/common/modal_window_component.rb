class Common::ModalWindowComponent < BaseComponent
  include Turbo::FramesHelper

  option :force_open, optional: true, default: false

  renders_one :header
  renders_one :actions

  private

  def turbo_frame_request?
    force_open || request.headers.include?('Turbo-Frame')
  end
end

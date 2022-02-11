class ModalWindowComponent < BaseComponent
  include Turbo::FramesHelper

  option :close_link, optional: true

  renders_one :header
  renders_one :actions

  private

  def turbo_frame_request?
    request.headers.include?('Turbo-Frame')
  end
end

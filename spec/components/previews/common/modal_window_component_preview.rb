# @label Modal window
# -------------------
#
# @display max_width 500px
class Common::ModalWindowComponentPreview < ViewComponent::Preview
  # @label Default
  # --------------
  #
  def default
    render Common::ModalWindowComponent.new(force_open: true) do
      'Modal window content'
    end
  end

  # @label With header and actions
  # -------------------------------
  #
  def with_header_and_actions
    render Common::ModalWindowComponent.new(force_open: true) do |c|
      c.header do
        'Window header'
      end

      c.actions do
        '<a href="#" class="button button--primary">Button</a>'
      end

      'Modal window content'
    end
  end
end

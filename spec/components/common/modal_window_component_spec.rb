require 'rails_helper'

RSpec.describe Common::ModalWindowComponent, type: :component do
  let(:content) { ->(_c) { 'Example' } }
  let(:turbo_frame_request) { false }

  def set_up_request_context(turbo_frame_request)
    mock_headers = stub
    mock_request = stub(headers: mock_headers)
    described_class.any_instance.stubs(:request).returns(mock_request)

    mock_headers.stubs(:include?).with('Turbo-Frame').returns(turbo_frame_request)
  end

  before(:each) do
    set_up_request_context(turbo_frame_request)
    render_inline(described_class.new, &content).to_html
  end

  it 'renders the modal window' do
    expect(rendered_component).to have_css('.common__modal-window')
    expect(rendered_component).to have_css('.common__modal-window__content', text: 'Example')
  end

  describe 'actions' do
    context 'with actions' do
      let(:content) do
        lambda do |c|
          c.actions do
            'A list of actions'
          end
        end
      end

      context 'for a turbo frame request' do
        let(:turbo_frame_request) { true }

        it 'renders the actions' do
          expect(rendered_component).to have_css('.common__modal-window__actions', text: 'A list of actions')
        end
      end

      context 'for a regular request' do
        let(:turbo_frame_request) { false }

        it 'does not render the actions' do
          expect(rendered_component).to_not have_css('.common__modal-window__actions')
        end
      end
    end

    context 'without actions' do
      context 'for a turbo frame request' do
        let(:turbo_frame_request) { true }

        it 'does not render the actions' do
          expect(rendered_component).to_not have_css('.common__modal-window__actions')
        end
      end
    end
  end

  describe 'close link' do
    context 'for a turbo frame request' do
      let(:turbo_frame_request) { true }

      it 'renders the close link' do
        expect(rendered_component).to have_link('Close', href: '#')
      end
    end

    context 'for a regular request' do
      let(:turbo_frame_request) { false }

      it 'does not render the close link' do
        expect(rendered_component).to_not have_link('Close')
      end
    end
  end

  describe 'header' do
    context 'when present' do
      let(:content) do
        lambda do |c|
          c.header do
            'Header content'
          end
        end
      end

      it 'renders the header' do
        expect(rendered_component).to have_css('.common__modal-window__header', text: 'Header content')
      end
    end

    context 'when empty' do
      let(:content) do
        lambda do |_c|
          'Other content'
        end
      end

      it 'does not render the header' do
        expect(rendered_component).to_not have_css('.common__modal-window__header')
      end
    end
  end
end

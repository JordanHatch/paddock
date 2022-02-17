require 'rails_helper'

RSpec.describe Common::ButtonComponent, type: :component do
  let(:label) { 'Button label' }

  context 'a standard button' do
    subject! do
      render_inline(described_class.new) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css('button.button', text: label)
    end
  end

  context 'as an anchor tag' do
    let(:href) { '/example' }

    subject! do
      render_inline(described_class.new(tag: :a, href: href)) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css("a.button[href='#{href}']", text: label)
    end
  end

  context 'with a scheme' do
    let(:scheme) { :warning }

    subject! do
      render_inline(described_class.new(scheme: scheme)) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css("button.button.button--#{scheme}", text: label)
    end
  end

  context 'with a style' do
    let(:style) { :inverted }
    let(:scheme) { :primary }

    subject! do
      render_inline(described_class.new(scheme: scheme, style: style)) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css("button.button.button--inverted-#{scheme}", text: label)
    end
  end

  context 'with a size' do
    let(:size) { :sm }

    subject! do
      render_inline(described_class.new(size: size)) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css("button.button.button--#{size}", text: label)
    end
  end

  context 'with a button type' do
    let(:type) { :submit }

    subject! do
      render_inline(described_class.new(type: type)) { label }
    end

    it 'renders the button' do
      expect(rendered_component).to have_css("button[type=#{type}]", text: label)
    end
  end

  context 'with extra classes' do
    let(:extra_classes) { 'classname' }

    subject! do
      render_inline(described_class.new(classes: extra_classes)) { label }
    end

    it 'appends the extra classes' do
      expect(rendered_component).to have_css("button.button.#{extra_classes}", text: label)
    end
  end

  context 'with the "id" attribute' do
    let(:id) { 'foo' }

    subject! do
      render_inline(described_class.new(id: id)) { label }
    end

    it 'passes through the attribute' do
      expect(rendered_component).to have_css("button\##{id}", text: label)
    end
  end

  context 'with the "title" attribute' do
    let(:title) { 'Title' }

    subject! do
      render_inline(described_class.new(title: title)) { label }
    end

    it 'passes through the attribute' do
      expect(rendered_component).to have_css("button[title='#{title}']", text: label)
    end
  end

  context 'with the "data" attribute' do
    let(:data) { { disable: true } }

    subject! do
      render_inline(described_class.new(data: data)) { label }
    end

    it 'passes through the attribute' do
      expect(rendered_component).to have_css('button[data-disable=true]', text: label)
    end
  end
end

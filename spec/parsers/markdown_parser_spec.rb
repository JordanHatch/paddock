require 'rails_helper'

RSpec.describe MarkdownParser do

  describe '#render' do
    it 'renders markdown' do
      input = <<~MD
        Example text.

        - Item 1
        - Item 2
        - Item 3
      MD

      expected = <<~HTML
        <p>Example text.</p>

        <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
        </ul>
      HTML

      output = MarkdownParser.render(input)
      expect(output).to eq(expected)
    end

    it 'inserts line breaks for new lines' do
      input = <<~MD
        #### Heading
        Example text.
        And another new line
        - List item
      MD

      expected = <<~HTML
        <h4>Heading</h4>

        <p>Example text.<br>
        And another new line</p>

        <ul>
        <li>List item</li>
        </ul>
      HTML

      output = MarkdownParser.render(input)
      expect(output).to eq(expected)
    end

    it 'escapes HTML tags' do
      input = <<~MD
        Some preamble

        <script>alert()</script>
      MD

      expected = <<~HTML
        <p>Some preamble</p>

        <p>&lt;script&gt;alert()&lt;/script&gt;</p>
      HTML

      output = MarkdownParser.render(input)
      expect(output).to eq(expected)
    end

    it 'offsets headings level <= 3 by 3' do
      input = <<~MD
        # Heading 1
        ## Heading 2
        ### Heading 3
      MD

      expected = <<~HTML
        <h4>Heading 1</h4>

        <h5>Heading 2</h5>

        <h6>Heading 3</h6>
      HTML

      output = MarkdownParser.render(input)
      expect(output).to eq(expected)
    end

    it 'leaves headings >= level 4 alone' do
      input = <<~MD
        #### Heading 4
        ##### Heading 5
        ###### Heading 6
      MD

      expected = <<~HTML
        <h4>Heading 4</h4>

        <h5>Heading 5</h5>

        <h6>Heading 6</h6>
      HTML

      output = MarkdownParser.render(input)
      expect(output).to eq(expected)
    end
  end

end

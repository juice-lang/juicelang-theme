# frozen_string_literal: true

require 'jekyll'
require 'kramdown'

class Kramdown::Converter::ToC < Kramdown::Converter::Html
    def convert(el, indent = -@indent)
        result = super
        return result unless el.type == :root

        @toc
    end
end

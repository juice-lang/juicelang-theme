# frozen_string_literal: true

require 'jekyll'
require 'kramdown'
require 'liquid'

require_relative 'markdown_toc'


class ToCTag < Liquid::Tag
    def initialize(tag_name, input, tokens)
        super
    end

    def render(context)
        toc = Kramdown::Document.new(context.registers[:page]['content'], {
            input: "GFM"
        }).to_ToC
        build_list(toc.select { |item| item[0] == 2 }, toc.first[1])
    end

    private

    def build_list(toc, topLink)
        result = '<li class="uk-active"><a href="#' + topLink + '">Top</a></li>' + "\n"

        for i in 0...toc.count
            item = toc[i]
            result += '<li><a href="#' + item[1] + '">' + item[2][0].value + "</a></li>\n"
        end

        result
    end
end

Liquid::Template.register_tag('toc', ToCTag)

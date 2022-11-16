# frozen_string_literal: true

require 'jekyll'
require 'kramdown'
require 'liquid'


class ToCTag < Liquid::Tag
    def initialize(tag_name, input, tokens)
        super
    end

    def render(context)
        toc = Kramdown::Document.new(context.registers[:page]['content'], {
            input: "GFM"
        }).to_Toc
        build_list(toc, context)
    end

    private

    def build_list(toc, context)
        top = toc.children.first.value
        result = '<li class="uk-active"><a href="#' + top.attr['id'] + '"><div class="uk-text-bold">' + elementToHTML(top, context) + '</div></a></li>' + "\n"

        for item in toc.children.first.children.map { |e| e.value }
            result += '<li><a href="#' + item.attr['id'] + '"><div>' + elementToHTML(item, context) + "</div></a></li>\n"
        end

        result
    end

    def elementToHTML(el, context)
        root = Kramdown::Element.new(:root, nil, nil, encoding: context.registers[:page]['content'].encoding)
        root.children = el.children
        Kramdown::Converter::CustomHtml.convert(root).first
    end
end

Liquid::Template.register_tag('toc', ToCTag)

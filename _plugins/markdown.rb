class Kramdown::Converter::CustomHtml < Kramdown::Converter::Html
    def convert_em(el, indent)
        "<span#{html_attributes(add_class(el.attr, "uk-text-italic"))}>#{inner(el, indent)}</span>"
    end

    def convert_strong(el, indent)
        "<span#{html_attributes(add_class(el.attr, "uk-text-bold"))}>#{inner(el, indent)}</span>"
    end


    def convert_table(el, indent)
        format_as_indented_block_html(el.type, add_class(el.attr, "uk-table uk-table-divider"), inner(el, indent), indent)
    end

    def convert_thead(el, indent)
        format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
    end
    
    def convert_tbody(el, indent)
        format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
    end
    
    def convert_tfoot(el, indent)
        format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
    end
    
    def convert_tr(el, indent)
        format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
    end
    

    def add_class(attr, class_name)
        if attr.has_key?("class")
            attr[:class] = attr[:class] + " " + class_name
        else
            attr[:class] = class_name
        end
        attr
    end
end
  
class Jekyll::Converters::Markdown::CustomMarkdown < Jekyll::Converters::Markdown
    def initialize(config)
        require 'kramdown'
        @config = config
    rescue LoadError
        STDERR.puts 'You are missing a library required for Markdown. Please run:'
        STDERR.puts '  $ [sudo] gem install kramdown'
        raise FatalException.new("Missing dependency: kramdown")
    end
  
    def convert(content)
        Kramdown::Document.new(content, {
            input: "GFM",
            syntax_highlighter: "rouge"
        }).to_CustomHtml
    end
end

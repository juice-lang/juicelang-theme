# frozen_string_literal: true

require 'jekyll'
require 'liquid'

module Jekyll
    module CustomFilters
        def is_active?(pageHash, children = nil)
            page = pageFromHash(pageHash)
            return true if page.equal? currentPage

            isActiveRecursion? children
        end

        def find(input, property, targetValue = nil)
            standardFilters = Class.new.extend(Liquid::StandardFilters)
            standardFilters.first(standardFilters.where(input, property, targetValue))
        end


        private

        def currentPage
            pageFromHash(@context.registers[:page])
        end

        def site
            @context.registers[:site]
        end

        def pageFromHash(hash)
            site.pages.find { |page|
                page.path == hash['path']
            }
        end

        def isActiveRecursion?(children)
            children && children.any? { |item|
                pageFromHash(item).equal?(currentPage) || isActiveRecursion?(item['children'])
            }
        end
    end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)
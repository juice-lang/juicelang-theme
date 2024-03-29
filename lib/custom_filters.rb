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
            first(where(input, property, targetValue))
        end

        def previous_and_next(pageHash, nav)
            result = {'previous' => nil, 'next' => nil}
            page = pageFromHash(pageHash)

            indexPage = pageFromHash(nav, 'index_path')

            if page.equal? indexPage
                result['next'] = pageFromHash(nav['menu'].first)
                return result
            end

            flattenedMenu = flattenMenu(nav['menu'])

            for i in 0...flattenedMenu.count
                pageI = flattenedMenu[i]

                if page.equal? pageI
                    result['previous'] = i == 0 ? indexPage : flattenedMenu[i - 1]
                    result['next'] = flattenedMenu[i + 1] unless i == flattenedMenu.count - 1
                    return result
                end
            end

            result
        end

        def url_without_ext(pageHash)
            page = pageFromHash(pageHash)
            url = absolute_url(page.url)

            return url.sub /\.x?html?$/, ''
        end


        def prefix(input, prefix)
            prefix.to_s + input.to_s if input
        end

        def suffix(input, suffix)
            input.to_s + suffix.to_s if input
        end


        def chunked(input, size)
            size = Liquid::Utils.to_integer(size)
            if input.is_a? Array
                input.each_slice(size).to_a
            else
                input.to_s.scan(/.{1,#{size}}/m)
            end
        end


        def strip_empty_html(input)
            input.gsub(/<([^\/>][^>]*)><\/\1>/, '')
        end


        private

        include Liquid::StandardFilters
        include Jekyll::Filters::URLFilters

        def currentPage
            pageFromHash(@context.registers[:page])
        end

        def site
            @context.registers[:site]
        end

        def pageFromHash(hash, pathKey = 'path')
            site.pages.find { |page|
                page.path == hash[pathKey]
            } unless hash.nil?
        end

        def isActiveRecursion?(children)
            children && children.any? { |item|
                pageFromHash(item).equal?(currentPage) || isActiveRecursion?(item['children'])
            }
        end

        def flattenMenu(menu)
            result = []

            for item in menu
                result.push(pageFromHash(item))
                if item['children']
                    result.concat(flattenMenu(item['children']))
                end
            end

            result
        end
    end
end

Liquid::Template.register_filter(Jekyll::CustomFilters)

# juicelang-theme

This is the theme of the website of the *juice* programming language ([juicelang.org](https://juicelang.org)).


## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "juicelang-theme", "~> 0.4", group: :jekyll_plugins
```

And add the following lines to your Jekyll site's `_config.yml`:

```yaml
theme: juicelang-theme
plugins:
  - juicelang-theme
```

Then execute:

```bash
$ bundle install
```

Or install the gem yourself using:

```bash
$ gem install juicelang-theme
```

## Development

To set up your environment to develop this theme, run `bundle install`.

To test this theme, run `bundle exec jekyll serve --watch` and open your browser at `http://localhost:4000`. This starts a Jekyll server using your theme. Add pages, documents, data, etc. like normal to test this theme's contents. As you make modifications to this theme and to your content, your site will regenerate and you should see the changes in the browser after a refresh, just like normal.

## License

The theme is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


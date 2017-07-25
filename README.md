<a href="https://github.com/TrestleAdmin/trestle">
    <img src="https://avatars3.githubusercontent.com/u/29348992?v=3&s=200" alt="Trestle Logo" width="60" align="right" />
</a>

# Trestle

[![Travis](https://img.shields.io/travis/TrestleAdmin/trestle.svg?style=flat-square)](https://travis-ci.org/TrestleAdmin/trestle)
[![Code Climate](https://img.shields.io/codeclimate/github/TrestleAdmin/trestle.svg?style=flat-square)](https://codeclimate.com/github/TrestleAdmin/trestle)
[![Coveralls](https://img.shields.io/coveralls/TrestleAdmin/trestle.svg?style=flat-square)](https://coveralls.io/github/TrestleAdmin/trestle)

> A modern, responsive admin framework for Ruby on Rails

<img src="https://trestle.io/images/Trestle-Screenshot-1.png" width="50%" /><img src="https://trestle.io/images/Trestle-Screenshot-2.png" width="50%" />

## Getting Started

To start using Trestle, first add it to your application's Gemfile:

```ruby
gem 'trestle'
```

Run `bundle install`, and then run the install generator to create the initial configuration file and customization hooks:

    $ rails generate trestle:install

Then create your first admin resource:

    $ rails generate trestle:resource Article

After restarting your Rails server, visit http://localhost:3000/admin to view your newly created admin. You will find the admin definition in `app/admin/articles_admin.rb` ready to customize.


## Example

```ruby
Trestle.resource(:posts) do
  # Add a link to this admin in the main navigation
  menu :posts, icon: "fa fa-file-text-o", group: :blog_management

  # Define custom scopes for the index view
  scope :all, default: true
  scope :published
  scope :drafts, -> { Post.unpublished }

  # Define the index view table listing
  table do
    column :title, link: true
    column :author, ->(post) { post.author.name }
    column :published, align: :center do |post|
      status_tag(icon("fa fa-check"), :success) if post.published?
    end
    column :updated_at, header: "Last Updated", align: :center
    actions
  end

  # Define the form structure for the new & edit actions
  form do
    # Organize fields into tabs and sidebars
    tab :post do
      text_field :title

      # Define custom form fields for easy re-use
      editor :body
    end

    tab :metadata do
      # Layout fields based on a 12-column grid
      row do
        col(sm: 6) { select :author, User.all }
        col(sm: 6) { tag_select :tags }
      end
    end

    sidebar do
      # Render a custom partial: app/views/admin/posts/_sidebar.html.erb
      render "sidebar"
    end
  end
end
```


## License

The gem is available as open source under the terms of the [LGPLv3 License](https://opensource.org/licenses/LGPL-3.0).

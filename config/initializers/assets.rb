# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# NOTE: (cmhobbs) these lines are mostly to resolve Rails 4.2 test
#      failures because sprockets got an upgrade.  condense them to a
#      single precompile += statement and move bits to
#      config/environments/ if necessary.
# Rails.application.config.assets.precompile += [
#   "application/home.css",
#   "application/recommendations.css",
#   "application/list-post.css",
#   "application/navbar.css",
#   "application/navbar.js",
#   "application/menu.css",
#   "application/organizations.css",
#   "application/dallas.css",
#   "application/tabs.css",
#   "application/tabs.js",
#   "application/input-dropdown.css",
#   "application/input-dropdown.js",
#   "application/footer.css",
#   "application/signup.css",
#   "application/comments.css",
#   "application/pages.css",
#   "application/best_practice.css",
#   "application/landing.css",
#   "assessment_new.js",
#   "users.css",
#   "cer"
#   "application/badge-table.css",
#   "application/fast_content.css",
#   "application/certifications.css"
# ]

# Add stylesheets.

Rails.application.config.assets.precompile += Dir
                                              .glob('app/**/*.scss')
                                              .map do |x|
  x
    .gsub('app/assets/stylesheets/', '')
    .gsub('.css.scss', '.css')
    .gsub('.scss', '.css')
end

# Add javascript.

Rails.application.config.assets.precompile += Dir
                                              .glob('app/**/*.js')
                                              .map { |x| x.gsub('app/assets/javascripts/', '') }

Rails.application.config.assets.precompile += %w[manifest.js]

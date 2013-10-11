# Giffare

I hacked this app together in a weekend. Adding to GitHub because there are people who want to contribute.


# Running locally

    git clone
    bundle
    rake db:create db:migrate db:seed
    GIFLIST_ADMIN_PASSWORD='choose_your_own_password' rails server

To access admin panel go to /gifs/unpublished

# Running tests

    GIFLIST_ADMIN_PASSWORD='secret' bundle exec rspec
